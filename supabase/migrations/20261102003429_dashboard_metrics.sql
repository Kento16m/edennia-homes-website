-- Dashboard metrics (MASTERPLAN §4.2), computed in SQL, never in the client.
-- All SECURITY INVOKER: RLS scopes them automatically (an agent only counts their own leads).
-- Months are bucketed in Asunción time.

create function public.dashboard_kpis(p_from timestamptz, p_to timestamptz)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  with bounds as (select p_from - (p_to - p_from) as prev_from, p_from as prev_to),
  cur as (select * from public.leads where created_at >= p_from and created_at < p_to),
  prev as (select l.* from public.leads l, bounds b where l.created_at >= b.prev_from and l.created_at < b.prev_to)
  select jsonb_build_object(
    'leads_new', (select count(*) from cur),
    'leads_new_prev', (select count(*) from prev),
    'first_response_minutes',
      (select round(avg(extract(epoch from first_response_at - created_at)) / 60) from cur where first_response_at is not null),
    'first_response_minutes_prev',
      (select round(avg(extract(epoch from first_response_at - created_at)) / 60) from prev where first_response_at is not null),
    'unanswered', (select count(*) from public.leads where stage = 'new'),
    'unanswered_over_sla', (
      select count(*)
        from public.leads l
        cross join (select coalesce(max(lead_sla_minutes), 120) as sla from public.site_settings) s
       where l.stage = 'new' and l.created_at < now() - make_interval(mins => s.sla)),
    'active_by_type', coalesce((
      select jsonb_object_agg(type, n)
        from (select type, count(*) as n from public.properties
               where publication_status = 'published' and availability = 'available' group by type) x), '{}'::jsonb),
    'reserved', (select count(*) from public.properties where publication_status = 'published' and availability = 'reserved'),
    'sold_in_period', (select count(*) from public.properties where sold_at >= p_from and sold_at < p_to),
    'sold_in_period_prev', (select count(*) from public.properties p, bounds b where p.sold_at >= b.prev_from and p.sold_at < b.prev_to),
    'inventory_value', coalesce((
      select jsonb_object_agg(currency, total)
        from (select currency, sum(price) as total from public.properties
               where publication_status = 'published' and availability <> 'sold' group by currency) x), '{}'::jsonb),
    'avg_days_on_market', (
      select round(avg(extract(epoch from sold_at - published_at) / 86400))
        from public.properties where sold_at >= p_from and sold_at < p_to and published_at is not null)
  )
$$;

create function public.leads_by_month(p_months integer default 12)
returns table (month date, leads bigint, won bigint, won_value_usd numeric)
language sql
stable
security invoker
set search_path = ''
as $$
  with months as (
    select generate_series(
      date_trunc('month', (now() at time zone 'America/Asuncion')) - make_interval(months => greatest(p_months, 1) - 1),
      date_trunc('month', (now() at time zone 'America/Asuncion')),
      interval '1 month')::date as month
  )
  select
    m.month,
    count(l.id),
    count(l.id) filter (where l.stage = 'won'),
    coalesce(sum(l.closed_price) filter (where l.stage = 'won' and l.closed_currency = 'USD'), 0)
  from months m
  left join public.leads l on date_trunc('month', l.created_at at time zone 'America/Asuncion')::date = m.month
  group by m.month
  order by m.month
$$;

-- Funnel: how many leads created in the period reached at least each stage (history-aware); lost listed apart.
create function public.lead_funnel(p_from timestamptz, p_to timestamptz)
returns table (stage public.lead_stage, reached bigint)
language sql
stable
security invoker
set search_path = ''
as $$
  with ranks(stage, r) as (
    values ('new'::public.lead_stage, 1), ('contacted', 2), ('visit_scheduled', 3), ('negotiation', 4), ('won', 5)
  ),
  scoped as (select id, stage from public.leads where created_at >= p_from and created_at < p_to),
  reached as (
    select s.id, max(r.r) as r
      from scoped s
      cross join lateral (
        select s.stage as st
        union all
        select e.to_stage from public.lead_events e where e.lead_id = s.id and e.to_stage is not null
      ) h
      join ranks r on r.stage = h.st
     group by s.id
  )
  select stage, reached from (
    select r.stage, count(x.id) as reached, r.r as ord
      from ranks r left join reached x on x.r >= r.r
     group by r.stage, r.r
    union all
    select 'lost'::public.lead_stage, (select count(*) from scoped where stage = 'lost'), 6
  ) f
  order by ord
$$;

create function public.leads_breakdown(p_dimension text, p_from timestamptz, p_to timestamptz)
returns table (key text, leads bigint)
language sql
stable
security invoker
set search_path = ''
as $$
  select
    case p_dimension
      when 'country' then coalesce(country::text, '??')
      when 'source' then source::text
      when 'locale' then locale
    end as key,
    count(*)
  from public.leads
  where p_dimension in ('country', 'source', 'locale')
    and created_at >= p_from and created_at < p_to
  group by 1
  order by 2 desc, 1
$$;

-- views_per_lead: many views and few leads usually means the price or the photos are off.
create function public.top_properties(
  p_from timestamptz, p_to timestamptz, p_order text default 'views', p_limit integer default 5
)
returns table (property_id uuid, reference integer, title text, views bigint, leads bigint, views_per_lead numeric)
language sql
stable
security invoker
set search_path = ''
as $$
  with def as (select code from public.locales where is_default limit 1),
  v as (select property_id, count(*) as n from public.property_views
         where viewed_at >= p_from and viewed_at < p_to group by property_id),
  ld as (select property_id, count(*) as n from public.leads
          where created_at >= p_from and created_at < p_to and property_id is not null group by property_id)
  select
    p.id, p.reference, t.title,
    coalesce(v.n, 0), coalesce(ld.n, 0),
    case when coalesce(ld.n, 0) > 0 then round(coalesce(v.n, 0)::numeric / ld.n, 1) end
  from public.properties p
  left join v on v.property_id = p.id
  left join ld on ld.property_id = p.id
  left join public.property_translations t on t.property_id = p.id and t.locale = (select code from def)
  where coalesce(v.n, 0) + coalesce(ld.n, 0) > 0
  order by
    case when p_order = 'leads' then coalesce(ld.n, 0) else coalesce(v.n, 0) end desc,
    p.reference
  limit least(greatest(coalesce(p_limit, 5), 1), 50)
$$;

create function public.demand_by_zone(p_from timestamptz, p_to timestamptz)
returns table (zone_id uuid, name text, lng double precision, lat double precision, leads bigint, active_properties bigint)
language sql
stable
security invoker
set search_path = ''
as $$
  with def as (select code from public.locales where is_default limit 1)
  select
    z.id,
    zt.name,
    extensions.st_x(z.center::extensions.geometry),
    extensions.st_y(z.center::extensions.geometry),
    (select count(*) from public.leads l join public.properties p on p.id = l.property_id
      where p.zone_id = z.id and l.created_at >= p_from and l.created_at < p_to),
    (select count(*) from public.properties p
      where p.zone_id = z.id and p.publication_status = 'published' and p.availability = 'available')
  from public.zones z
  left join public.zone_translations zt on zt.zone_id = z.id and zt.locale = (select code from def)
  where z.is_active
  order by 5 desc, 2
$$;

-- Inventory health: incomplete translations, few photos, no coordinates, untouched for 60 days.
create function public.inventory_health()
returns table (property_id uuid, reference integer, title text, issues text[])
language sql
stable
security invoker
set search_path = ''
as $$
  with def as (select code from public.locales where is_default limit 1),
  checks as (
    select
      p.id, p.reference,
      array_remove(array[
        case when exists (
          select 1 from public.locales l
           where l.is_enabled and l.is_required
             and not exists (select 1 from public.property_translations t
                              where t.property_id = p.id and t.locale = l.code
                                and length(trim(coalesce(t.description, ''))) > 0)
        ) then 'missing_translations' end,
        case when (select count(*) from public.property_media m where m.property_id = p.id) < 5 then 'few_photos' end,
        case when p.location is null then 'no_location' end,
        case when p.updated_at < now() - interval '60 days' then 'stale' end
      ], null) as issues
    from public.properties p
    where p.publication_status <> 'archived'
  )
  select c.id, c.reference, t.title, c.issues
    from checks c
    left join public.property_translations t on t.property_id = c.id and t.locale = (select code from def)
   where cardinality(c.issues) > 0
   order by cardinality(c.issues) desc, c.reference
$$;

create function public.agent_ranking(p_from timestamptz, p_to timestamptz)
returns table (agent_id uuid, full_name text, leads_assigned bigint, won bigint, avg_first_response_minutes numeric)
language sql
stable
security invoker
set search_path = ''
as $$
  select
    pr.id,
    pr.full_name,
    count(l.id),
    count(l.id) filter (where l.stage = 'won'),
    round(avg(extract(epoch from l.first_response_at - l.created_at)) / 60)
  from public.profiles pr
  left join public.leads l on l.assigned_to = pr.id and l.created_at >= p_from and l.created_at < p_to
  where pr.role = 'agent' and pr.is_active and (select private.has_role('admin'))
  group by pr.id, pr.full_name
  order by 4 desc, 3 desc, 2
$$;

do $$
declare f text;
begin
  foreach f in array array[
    'dashboard_kpis', 'leads_by_month', 'lead_funnel', 'leads_breakdown',
    'top_properties', 'demand_by_zone', 'inventory_health', 'agent_ranking'
  ] loop
    execute format('revoke execute on function public.%I from public, anon', f);
    execute format('grant execute on function public.%I to authenticated, service_role', f);
  end loop;
end;
$$;
