-- Trigger functions. Everything lives in `private` (not exposed); SECURITY DEFINER only where a
-- trigger must write rows the caller cannot (profiles on signup, lead_events, audit_log).

-- ── updated_at ───────────────────────────────────────────────────────────────
create function private.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

do $$
declare t text;
begin
  foreach t in array array[
    'profiles', 'zones', 'testimonials', 'investment_facts', 'properties', 'property_translations',
    'property_units', 'leads', 'site_settings', 'site_settings_translations', 'exchange_rates'
  ] loop
    execute format(
      'create trigger set_updated_at before update on public.%I for each row execute function private.set_updated_at()', t);
  end loop;
end;
$$;

-- ── Staff accounts (invite-only) ─────────────────────────────────────────────
create function private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  new_role public.app_role := (new.raw_app_meta_data ->> 'role')::public.app_role;
begin
  if new_role is null then
    raise exception 'Staff users must be invited with app_metadata.role (admin, agent or editor)'
      using errcode = '22023';
  end if;
  insert into public.profiles (id, role, full_name, email)
  values (new.id, new_role, coalesce(new.raw_user_meta_data ->> 'full_name', ''), new.email);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function private.handle_new_user();

-- Logged-in users may edit their own profile, but only admins change role or is_active.
create function private.guard_profile()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if current_user = 'authenticated'
     and not private.has_role('admin')
     and (new.role is distinct from old.role or new.is_active is distinct from old.is_active) then
    raise exception 'Only admins can change role or is_active' using errcode = '42501';
  end if;
  return new;
end;
$$;

create trigger guard_profile before update on public.profiles
  for each row execute function private.guard_profile();

-- ── Properties ───────────────────────────────────────────────────────────────
-- Public coordinates: exact, or snapped to a ~500 m grid when the exact address is hidden.
create function private.sync_display_location()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.display_location := case
    when new.location is null then null
    when new.hide_exact_address then
      extensions.st_snaptogrid(new.location::extensions.geometry, 0.005)::extensions.geography
    else new.location
  end;
  return new;
end;
$$;

create trigger sync_display_location before insert or update of location, hide_exact_address on public.properties
  for each row execute function private.sync_display_location();

-- A property can only be published with a title and description in every enabled, required locale.
create function private.enforce_publication()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  missing text;
begin
  if new.publication_status = 'published'
     and (tg_op = 'INSERT' or old.publication_status is distinct from 'published') then
    select string_agg(l.code, ', ' order by l.sort_order, l.code)
      into missing
      from public.locales l
     where l.is_enabled
       and l.is_required
       and not exists (
         select 1
           from public.property_translations t
          where t.property_id = new.id
            and t.locale = l.code
            and length(trim(coalesce(t.description, ''))) > 0
       );
    if missing is not null then
      raise exception 'missing_translations: %', missing
        using errcode = 'P0001',
              hint = 'Add a title and description in every required language before publishing.';
    end if;
    new.published_at := coalesce(new.published_at, now());
  end if;

  if new.availability = 'sold' and (tg_op = 'INSERT' or old.availability is distinct from 'sold') then
    new.sold_at := coalesce(new.sold_at, now());
  end if;
  return new;
end;
$$;

create trigger enforce_publication before insert or update on public.properties
  for each row execute function private.enforce_publication();

create function private.guard_required_translation()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if exists (
    select 1
      from public.properties p
      join public.locales l on l.code = old.locale
     where p.id = old.property_id
       and p.publication_status = 'published'
       and l.is_enabled
       and l.is_required
  ) then
    raise exception 'cannot_delete_required_translation: %', old.locale
      using errcode = 'P0001', hint = 'Unpublish the property first.';
  end if;
  return old;
end;
$$;

create trigger guard_required_translation before delete on public.property_translations
  for each row execute function private.guard_required_translation();

-- ── Leads ────────────────────────────────────────────────────────────────────
create function private.lead_before_update()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.stage is distinct from old.stage then
    if old.stage = 'new' then
      new.first_response_at := coalesce(new.first_response_at, now());
    end if;
    new.closed_at := case when new.stage in ('won', 'lost') then coalesce(new.closed_at, now()) end;
  end if;
  return new;
end;
$$;

create trigger lead_before_update before update on public.leads
  for each row execute function private.lead_before_update();

create function private.log_lead_event()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if tg_op = 'INSERT' then
    insert into public.lead_events (lead_id, type, to_stage, actor_id)
    values (new.id, 'created', new.stage, auth.uid());
  else
    if new.stage is distinct from old.stage then
      insert into public.lead_events (lead_id, type, from_stage, to_stage, actor_id)
      values (new.id, 'stage_changed', old.stage, new.stage, auth.uid());
    end if;
    if new.assigned_to is distinct from old.assigned_to then
      insert into public.lead_events (lead_id, type, note, actor_id)
      values (new.id, 'assigned', new.assigned_to::text, auth.uid());
    end if;
  end if;
  return null;
end;
$$;

create trigger log_lead_event after insert or update of stage, assigned_to on public.leads
  for each row execute function private.log_lead_event();

-- A logged call/email/WhatsApp counts as the first response even without a stage change.
create function private.mark_first_response()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.type in ('call', 'email', 'whatsapp') then
    update public.leads
       set first_response_at = new.created_at
     where id = new.lead_id
       and first_response_at is null;
  end if;
  return null;
end;
$$;

create trigger mark_first_response after insert on public.lead_events
  for each row execute function private.mark_first_response();

-- ── Audit trail ──────────────────────────────────────────────────────────────
create function private.audit()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  row_data jsonb := to_jsonb(case when tg_op = 'DELETE' then old else new end);
begin
  insert into public.audit_log (table_name, record_id, action, actor_id, old_data, new_data)
  values (
    tg_table_name,
    coalesce(
      row_data ->> 'id',
      (row_data ->> 'property_id') || ':' || (row_data ->> 'locale'),
      (row_data ->> 'base') || '/' || (row_data ->> 'quote')
    ),
    tg_op,
    auth.uid(),
    case when tg_op <> 'INSERT' then to_jsonb(old) end,
    case when tg_op <> 'DELETE' then to_jsonb(new) end
  );
  return null;
end;
$$;

do $$
declare t text;
begin
  foreach t in array array[
    'properties', 'property_translations', 'leads', 'profiles', 'site_settings', 'exchange_rates', 'investment_facts'
  ] loop
    execute format(
      'create trigger audit after insert or update or delete on public.%I for each row execute function private.audit()', t);
  end loop;
end;
$$;

revoke execute on all functions in schema private from public;
grant execute on function private.has_role(public.app_role[]) to anon, authenticated, service_role;
