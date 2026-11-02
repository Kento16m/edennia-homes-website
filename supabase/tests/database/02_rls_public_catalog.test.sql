-- What an anonymous visitor can and cannot see.
begin;
create extension if not exists pgtap with schema extensions;
select plan(10);

set local role anon;
select is((select count(*) from public.properties), 20::bigint, 'anon sees only the 20 published properties');
select is(
  (select count(*) from public.properties where publication_status <> 'published'), 0::bigint,
  'anon never sees drafts or archived');
select throws_ok('select location from public.properties limit 1', '42501', null,
  'anon cannot read exact coordinates');
select throws_ok('select address_line from public.properties limit 1', '42501', null,
  'anon cannot read the exact address');
select is(
  (select count(*) from public.property_translations
    where property_id = '10000000-0000-4000-8000-000000000018'), 0::bigint,
  'anon cannot read translations of a draft');
select throws_ok('select email from public.profiles limit 1', '42501', null,
  'anon cannot read staff emails');
select throws_ok('select lead_notification_emails from public.site_settings', '42501', null,
  'anon cannot read internal notification emails');
select lives_ok(
  $$insert into public.property_views (property_id, locale) values ('10000000-0000-4000-8000-000000000001', 'en')$$,
  'anon can record a view of a published property');
select throws_ok(
  $$insert into public.property_views (property_id, locale) values ('10000000-0000-4000-8000-000000000018', 'en')$$,
  '42501', null, 'anon cannot record a view of a draft');
select throws_ok('select count(*) from public.audit_log', '42501', null, 'anon cannot read the audit log');
reset role;

select * from finish();
rollback;
