-- Business rules (publication, lead history), search RPC and the access token hook.
begin;
create extension if not exists pgtap with schema extensions;
select plan(16);

-- ── Publication rule ─────────────────────────────────────────────────────────
select throws_ok(
  $$update public.properties set publication_status = 'published' where reference = 18$$,
  'P0001', 'missing_translations: en', 'a property without English cannot be published');
select lives_ok(
  $$update public.properties set publication_status = 'published' where reference = 10$$,
  'a property with every required translation can be published');
select isnt((select published_at from public.properties where reference = 10), null, 'publishing sets published_at');
select throws_ok(
  $$delete from public.property_translations
     where property_id = '10000000-0000-4000-8000-000000000001' and locale = 'en'$$,
  'P0001', 'cannot_delete_required_translation: en', 'a required translation of a published property cannot be deleted');

-- ── Hidden address → public coordinates on a ~500 m grid ─────────────────────
select ok(
  (select not extensions.st_equals(location::extensions.geometry, display_location::extensions.geometry)
     from public.properties where reference = 1),
  'hidden address: public point differs from the exact one');
select ok(
  (select extensions.st_equals(location::extensions.geometry, display_location::extensions.geometry)
     from public.properties where reference = 19),
  'public address: public point is the exact one');

-- ── Lead stage change as the assigned agent ──────────────────────────────────
select set_config('request.jwt.claims',
  '{"sub":"00000000-0000-4000-8000-000000000002","role":"authenticated","user_role":"agent"}', true);
set local role authenticated;
update public.leads set stage = 'contacted'
 where email = 'lead1@example.com'; -- lead 1 is new and assigned to asesor1
reset role;
select is(
  (select count(*) from public.lead_events e join public.leads l on l.id = e.lead_id
    where l.email = 'lead1@example.com' and e.type = 'stage_changed'
      and e.actor_id = '00000000-0000-4000-8000-000000000002'),
  1::bigint, 'a stage change is logged with the acting agent');
select isnt((select first_response_at from public.leads where email = 'lead1@example.com'), null,
  'leaving "new" sets first_response_at');

-- ── search_properties as an anonymous visitor ────────────────────────────────
set local role anon;
select is((select max(total_count) from public.search_properties('es')), 21::bigint,
  'search returns every published property (20 seeded + the one published above)');
select is((select count(*) from public.search_properties('de') where not is_fallback), 0::bigint,
  'an unsupported locale falls back to the default language');
select is((select min(title) from public.search_properties('de')) is not null, true,
  'fallback rows still carry a title');
select is(
  (select max(total_count) from public.search_properties('es', p_bbox => array[-57.52, -25.30, -57.45, -25.24])),
  3::bigint, 'bbox around Luque returns its 3 published properties');
select is(
  (select max(total_count) from public.search_properties('en', p_types => array['apartment']::public.property_type[],
                                                          p_amenity_keys => array['pool', 'gym'])),
  2::bigint, 'type + all-of amenities filter (apartments with pool and gym)');
reset role;

-- ── Catalog writes: editors yes, agents no (an RLS-filtered UPDATE touches 0 rows) ──
select set_config('request.jwt.claims',
  '{"sub":"00000000-0000-4000-8000-000000000002","role":"authenticated","user_role":"agent"}', true);
set local role authenticated;
with changed as (
  update public.zone_translations set description = 'agent edit' where locale = 'es' returning 1
)
select is((select count(*) from changed), 0::bigint, 'an agent cannot edit zones');
reset role;
select set_config('request.jwt.claims',
  '{"sub":"00000000-0000-4000-8000-000000000004","role":"authenticated","user_role":"editor"}', true);
set local role authenticated;
with changed as (
  update public.zone_translations set description = 'editor edit' where locale = 'es' returning 1
)
select is((select count(*) from changed), 6::bigint, 'an editor can edit zone translations');
reset role;

-- ── Access token hook ────────────────────────────────────────────────────────
select is(
  public.custom_access_token_hook(jsonb_build_object(
    'user_id', '00000000-0000-4000-8000-000000000003',
    'claims', jsonb_build_object('sub', '00000000-0000-4000-8000-000000000003', 'role', 'authenticated')))
  -> 'claims' ->> 'user_role',
  'agent', 'hook adds user_role from profiles');

select * from finish();
rollback;
