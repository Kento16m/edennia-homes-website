-- RLS on every table + explicit grants (new tables are not exposed to the Data API automatically).
-- Roles come from the JWT claim `user_role`; policies wrap helpers in (select …) so they run once per query.

-- ── Helpers that depend on tables ────────────────────────────────────────────
create function private.can_edit_property(pid uuid)
returns boolean
language sql
stable
set search_path = ''
as $$
  select private.has_role('admin', 'editor')
      or (private.has_role('agent')
          and exists (select 1 from public.properties p where p.id = pid and p.agent_id = auth.uid()))
$$;
revoke execute on function private.can_edit_property(uuid) from public;
grant execute on function private.can_edit_property(uuid) to authenticated, service_role;

-- ── Enable RLS everywhere ────────────────────────────────────────────────────
do $$
declare t text;
begin
  for t in select tablename from pg_tables where schemaname = 'public' loop
    execute format('alter table public.%I enable row level security', t);
  end loop;
end;
$$;

-- ── Grants ───────────────────────────────────────────────────────────────────
-- Supabase's default ACLs give anon/authenticated ALL (incl. TRUNCATE) on every new public table:
-- that would make the column grants below meaningless. Start from nothing, now and for future objects.
revoke all on all tables in schema public from anon, authenticated;
revoke all on all sequences in schema public from anon, authenticated;
alter default privileges for role postgres in schema public revoke all on tables from anon, authenticated;
alter default privileges for role postgres in schema public revoke all on sequences from anon, authenticated;
alter default privileges for role postgres in schema public revoke execute on functions from public, anon, authenticated;

grant usage on schema public to anon, authenticated, service_role;
grant all on all tables in schema public to service_role;
grant usage, select on all sequences in schema public to anon, authenticated, service_role;

-- Staff: full DML, rows restricted by RLS below.
grant select, insert, update, delete on all tables in schema public to authenticated;
revoke insert, update, delete on public.audit_log from authenticated;
revoke update, delete on public.property_views from authenticated;

-- Public visitors: read-only catalog, column-limited where data is private.
grant select on
  public.locales, public.zones, public.zone_translations, public.amenities, public.amenity_translations,
  public.testimonials, public.testimonial_translations, public.investment_facts, public.investment_fact_translations,
  public.property_translations, public.property_media, public.property_media_translations,
  public.property_amenities, public.property_units, public.site_settings_translations, public.exchange_rates
to anon;

grant select (
  id, reference, type, operation, publication_status, availability, price, currency, bedrooms, bathrooms,
  area_m2, lot_m2, parking, year_built, display_location, hide_exact_address, zone_id, agent_id, is_featured,
  residency_eligible, virtual_tour_url, video_url, floor_plan_path, construction_progress, delivery_date,
  published_at, sold_at, created_at, updated_at
) on public.properties to anon; -- never: location, address_line, created_by

grant select (id, full_name, avatar_path, role, is_active) on public.profiles to anon; -- advisor card only

grant select (
  id, phone, whatsapp, email, address_line, social, hero_property_id, hero_image_path, updated_at
) on public.site_settings to anon; -- never: lead_notification_emails, lead_sla_minutes

grant insert (property_id, locale) on public.property_views to anon, authenticated;
-- public.leads and public.lead_events: no anon grant at all. Public leads arrive via the submit-lead Edge Function.

-- ── locales ──────────────────────────────────────────────────────────────────
create policy "locales: read enabled" on public.locales for select to anon, authenticated
  using (is_enabled or (select private.has_role('admin', 'agent', 'editor')));

-- ── zones, amenities (+ translations) ────────────────────────────────────────
create policy "zones: read active" on public.zones for select to anon, authenticated
  using (is_active or (select private.has_role('admin', 'agent', 'editor')));

create policy "zone_translations: read" on public.zone_translations for select to anon, authenticated
  using (exists (select 1 from public.zones z where z.id = zone_id));

create policy "amenities: read" on public.amenities for select to anon, authenticated using (true);

create policy "amenity_translations: read" on public.amenity_translations for select to anon, authenticated using (true);

-- ── testimonials, investment_facts (+ translations) ──────────────────────────
create policy "testimonials: read published" on public.testimonials for select to anon, authenticated
  using (is_published or (select private.has_role('admin', 'agent', 'editor')));

create policy "testimonial_translations: read" on public.testimonial_translations for select to anon, authenticated
  using (exists (select 1 from public.testimonials t where t.id = testimonial_id));

create policy "investment_facts: read published" on public.investment_facts for select to anon, authenticated
  using (is_published or (select private.has_role('admin', 'agent', 'editor')));

create policy "investment_fact_translations: read" on public.investment_fact_translations for select to anon, authenticated
  using (exists (select 1 from public.investment_facts f where f.id = fact_id));

-- ── profiles ─────────────────────────────────────────────────────────────────
create policy "profiles: public advisor card" on public.profiles for select to anon
  using (is_active and role in ('admin', 'agent'));
create policy "profiles: staff read" on public.profiles for select to authenticated
  using (id = (select auth.uid()) or (select private.has_role('admin', 'agent', 'editor')));
create policy "profiles: update own or admin" on public.profiles for update to authenticated
  using (id = (select auth.uid()) or (select private.has_role('admin')))
  with check (id = (select auth.uid()) or (select private.has_role('admin')));
create policy "profiles: admin inserts" on public.profiles for insert to authenticated
  with check ((select private.has_role('admin')));
create policy "profiles: admin deletes" on public.profiles for delete to authenticated
  using ((select private.has_role('admin')));

-- ── properties ───────────────────────────────────────────────────────────────
create policy "properties: public reads published" on public.properties for select to anon
  using (publication_status = 'published');
create policy "properties: staff read all" on public.properties for select to authenticated
  using ((select private.has_role('admin', 'agent', 'editor')));
create policy "properties: insert" on public.properties for insert to authenticated
  with check (
    (select private.has_role('admin', 'editor'))
    or ((select private.has_role('agent')) and agent_id = (select auth.uid()))
  );
create policy "properties: update" on public.properties for update to authenticated
  using (
    (select private.has_role('admin', 'editor'))
    or ((select private.has_role('agent')) and agent_id = (select auth.uid()))
  )
  with check (
    (select private.has_role('admin', 'editor'))
    or ((select private.has_role('agent')) and agent_id = (select auth.uid()))
  );
create policy "properties: admin deletes" on public.properties for delete to authenticated
  using ((select private.has_role('admin')));

-- Children of a property: public when the property is published; writable by whoever may edit it.
do $$
declare t text;
begin
  foreach t in array array['property_translations', 'property_media', 'property_amenities', 'property_units'] loop
    execute format($f$
      create policy "%1$s: public reads published" on public.%1$I for select to anon
        using (exists (select 1 from public.properties p where p.id = property_id and p.publication_status = 'published'));
      create policy "%1$s: staff read" on public.%1$I for select to authenticated
        using ((select private.has_role('admin', 'agent', 'editor')));
      create policy "%1$s: insert" on public.%1$I for insert to authenticated
        with check (private.can_edit_property(property_id));
      create policy "%1$s: update" on public.%1$I for update to authenticated
        using (private.can_edit_property(property_id)) with check (private.can_edit_property(property_id));
      create policy "%1$s: delete" on public.%1$I for delete to authenticated
        using (private.can_edit_property(property_id));
    $f$, t);
  end loop;
end;
$$;

create policy "property_media_translations: public reads published" on public.property_media_translations
  for select to anon
  using (exists (
    select 1 from public.property_media m join public.properties p on p.id = m.property_id
     where m.id = media_id and p.publication_status = 'published'));
create policy "property_media_translations: staff read" on public.property_media_translations
  for select to authenticated using ((select private.has_role('admin', 'agent', 'editor')));

-- ── leads (anon has no grant: permission denied) ─────────────────────────────
create policy "leads: read admin or assigned agent" on public.leads for select to authenticated
  using (
    (select private.has_role('admin'))
    or ((select private.has_role('agent')) and assigned_to = (select auth.uid()))
  );
create policy "leads: insert admin or self-assigned agent" on public.leads for insert to authenticated
  with check (
    (select private.has_role('admin'))
    or ((select private.has_role('agent')) and assigned_to = (select auth.uid()))
  );
create policy "leads: update admin or assigned agent" on public.leads for update to authenticated
  using (
    (select private.has_role('admin'))
    or ((select private.has_role('agent')) and assigned_to = (select auth.uid()))
  )
  with check ( -- an agent cannot hand the lead to someone else
    (select private.has_role('admin'))
    or ((select private.has_role('agent')) and assigned_to = (select auth.uid()))
  );
create policy "leads: admin deletes" on public.leads for delete to authenticated
  using ((select private.has_role('admin')));

-- lead_events follow lead visibility (the leads policies apply inside the subquery).
create policy "lead_events: read visible leads" on public.lead_events for select to authenticated
  using (exists (select 1 from public.leads l where l.id = lead_id));
create policy "lead_events: log activity on visible leads" on public.lead_events for insert to authenticated
  with check (
    actor_id = (select auth.uid())
    and type in ('note', 'call', 'email', 'whatsapp', 'reminder')
    and exists (select 1 from public.leads l where l.id = lead_id)
  );
create policy "lead_events: author edits own note" on public.lead_events for update to authenticated
  using (actor_id = (select auth.uid()) and type in ('note', 'reminder'))
  with check (actor_id = (select auth.uid()) and type in ('note', 'reminder'));
create policy "lead_events: admin deletes" on public.lead_events for delete to authenticated
  using ((select private.has_role('admin')));

-- ── property_views (anonymous analytics) ─────────────────────────────────────
create policy "property_views: record view of published property" on public.property_views
  for insert to anon, authenticated
  with check (exists (select 1 from public.properties p where p.id = property_id and p.publication_status = 'published'));
create policy "property_views: staff read" on public.property_views for select to authenticated
  using ((select private.has_role('admin', 'agent', 'editor')));

-- ── settings ─────────────────────────────────────────────────────────────────
create policy "site_settings: read" on public.site_settings for select to anon, authenticated using (true);

create policy "site_settings_translations: read" on public.site_settings_translations
  for select to anon, authenticated using (true);

create policy "exchange_rates: read" on public.exchange_rates for select to anon, authenticated using (true);

-- ── Write policies for catalogs and settings (insert/update/delete only, so reads keep a single policy) ──
do $$
declare r record;
begin
  for r in select * from (values
    ('locales', $p$(select private.has_role('admin'))$p$),
    ('site_settings', $p$(select private.has_role('admin'))$p$),
    ('exchange_rates', $p$(select private.has_role('admin'))$p$),
    ('zones', $p$(select private.has_role('admin', 'editor'))$p$),
    ('zone_translations', $p$(select private.has_role('admin', 'editor'))$p$),
    ('amenities', $p$(select private.has_role('admin', 'editor'))$p$),
    ('amenity_translations', $p$(select private.has_role('admin', 'editor'))$p$),
    ('testimonials', $p$(select private.has_role('admin', 'editor'))$p$),
    ('testimonial_translations', $p$(select private.has_role('admin', 'editor'))$p$),
    ('investment_facts', $p$(select private.has_role('admin', 'editor'))$p$),
    ('investment_fact_translations', $p$(select private.has_role('admin', 'editor'))$p$),
    ('site_settings_translations', $p$(select private.has_role('admin', 'editor'))$p$),
    ('property_media_translations',
     $p$private.can_edit_property((select m.property_id from public.property_media m where m.id = media_id))$p$)
  ) as t(tbl, pred) loop
    execute format('create policy "%1$s: insert" on public.%1$I for insert to authenticated with check (%2$s)', r.tbl, r.pred);
    execute format('create policy "%1$s: update" on public.%1$I for update to authenticated using (%2$s) with check (%2$s)', r.tbl, r.pred);
    execute format('create policy "%1$s: delete" on public.%1$I for delete to authenticated using (%2$s)', r.tbl, r.pred);
  end loop;
end;
$$;

-- ── audit_log ────────────────────────────────────────────────────────────────
create policy "audit_log: admin reads" on public.audit_log for select to authenticated
  using ((select private.has_role('admin')));
