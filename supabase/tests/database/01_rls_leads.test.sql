-- Leads are the most sensitive data: anon never reads them, agents only their own, editors none.
begin;
create extension if not exists pgtap with schema extensions;
select plan(12);

-- ── Privileges (RLS limits rows, not columns or TRUNCATE) ────────────────────
select is(
  (select count(*) from pg_class c
    where c.relnamespace = 'public'::regnamespace and c.relkind in ('r', 'p')
      and (has_table_privilege('anon', c.oid, 'TRUNCATE') or has_table_privilege('authenticated', c.oid, 'TRUNCATE'))),
  0::bigint, 'only the service role can TRUNCATE (TRUNCATE ignores RLS)');
select is(has_table_privilege('anon', 'public.leads', 'SELECT'), false, 'anon has no privilege at all on leads');

-- ── anon ─────────────────────────────────────────────────────────────────────
set local role anon;
select throws_ok('select count(*) from public.leads', '42501', null, 'anon cannot read leads');
select throws_ok(
  $$insert into public.leads (full_name, email, phone, locale, source, consent_privacy_at)
    values ('Bot', 'bot@example.com', '+34 600 000 000', 'es', 'contact_form', now())$$,
  '42501', null, 'anon cannot insert leads directly (only via the submit-lead Edge Function)');
select throws_ok('select count(*) from public.lead_events', '42501', null, 'anon cannot read lead history');
reset role;

-- ── agent (asesor1) ──────────────────────────────────────────────────────────
select set_config('request.jwt.claims',
  '{"sub":"00000000-0000-4000-8000-000000000002","role":"authenticated","user_role":"agent"}', true);
set local role authenticated;
select is((select count(*) from public.leads), 20::bigint, 'agent sees exactly their 20 leads');
select is((select count(*) from public.leads where assigned_to <> '00000000-0000-4000-8000-000000000002'), 0::bigint,
  'agent sees no lead assigned to someone else');
select throws_ok(
  $$update public.leads set assigned_to = '00000000-0000-4000-8000-000000000003'
     where id = (select id from public.leads limit 1)$$,
  '42501', null, 'agent cannot hand a lead to another agent');
select is(
  (select count(*) from public.lead_events e join public.leads l on l.id = e.lead_id
    where l.assigned_to <> '00000000-0000-4000-8000-000000000002'),
  0::bigint, 'agent sees no history of other agents'' leads');
reset role;

-- ── editor ───────────────────────────────────────────────────────────────────
select set_config('request.jwt.claims',
  '{"sub":"00000000-0000-4000-8000-000000000004","role":"authenticated","user_role":"editor"}', true);
set local role authenticated;
select is((select count(*) from public.leads), 0::bigint, 'editor sees no leads');
reset role;

-- ── admin ────────────────────────────────────────────────────────────────────
select set_config('request.jwt.claims',
  '{"sub":"00000000-0000-4000-8000-000000000001","role":"authenticated","user_role":"admin"}', true);
set local role authenticated;
select is((select count(*) from public.leads), 40::bigint, 'admin sees all 40 leads');
reset role;

-- ── authenticated without a role (deactivated user) ──────────────────────────
select set_config('request.jwt.claims',
  '{"sub":"00000000-0000-4000-8000-000000000003","role":"authenticated"}', true);
set local role authenticated;
select is((select count(*) from public.leads), 0::bigint, 'a user without user_role claim sees no leads');
reset role;

select * from finish();
rollback;
