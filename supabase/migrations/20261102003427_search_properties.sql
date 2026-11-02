-- Explorer search: one query (no N+1), translated with fallback to the default locale.
-- SECURITY INVOKER: anon only ever sees published rows and never the exact `location` column.

create function public.search_properties(
  p_locale text,
  p_bbox double precision[] default null,          -- [west, south, east, north] in WGS84
  p_types public.property_type[] default null,
  p_min_price numeric default null,
  p_max_price numeric default null,
  p_currency char(3) default 'USD',                 -- shortcut: price filters only match rows in this currency; convert once multi-currency pricing exists
  p_min_bedrooms smallint default null,
  p_min_bathrooms smallint default null,
  p_min_area numeric default null,
  p_max_area numeric default null,
  p_zone_ids uuid[] default null,
  p_amenity_keys text[] default null,               -- property must have ALL of them
  p_has_tour boolean default null,
  p_residency boolean default null,
  p_sort text default 'relevance',                  -- relevance | price_asc | price_desc | newest | area_desc
  p_limit integer default 24,
  p_offset integer default 0
)
returns table (
  id uuid,
  reference integer,
  type public.property_type,
  availability public.availability_status,
  price numeric,
  currency char(3),
  bedrooms smallint,
  bathrooms smallint,
  area_m2 numeric,
  is_featured boolean,
  residency_eligible boolean,
  has_virtual_tour boolean,
  title text,
  slug text,
  short_description text,
  locale text,
  is_fallback boolean,
  zone_id uuid,
  zone_name text,
  lng double precision,
  lat double precision,
  cover_path text,
  total_count bigint
)
language sql
stable
security invoker
set search_path = public, extensions -- PostGIS operators live in `extensions`
as $$
  with def as (select code from public.locales where is_default limit 1),
  wanted_amenities as (select distinct unnest(p_amenity_keys) as key)
  select
    p.id,
    p.reference,
    p.type,
    p.availability,
    p.price,
    p.currency,
    p.bedrooms,
    p.bathrooms,
    p.area_m2,
    p.is_featured,
    p.residency_eligible,
    p.virtual_tour_url is not null,
    coalesce(t.title, d.title),
    coalesce(t.slug, d.slug),
    coalesce(t.short_description, d.short_description),
    case when t.property_id is not null then p_locale else (select code from def) end,
    t.property_id is null,
    p.zone_id,
    coalesce(zt.name, zd.name),
    st_x(p.display_location::geometry),
    st_y(p.display_location::geometry),
    cover.storage_path,
    count(*) over ()
  from public.properties p
  left join public.property_translations t on t.property_id = p.id and t.locale = p_locale
  left join public.property_translations d on d.property_id = p.id and d.locale = (select code from def)
  left join public.zone_translations zt on zt.zone_id = p.zone_id and zt.locale = p_locale
  left join public.zone_translations zd on zd.zone_id = p.zone_id and zd.locale = (select code from def)
  left join lateral (
    select m.storage_path
      from public.property_media m
     where m.property_id = p.id
     order by m.is_cover desc, m.position
     limit 1
  ) cover on true
  where p.publication_status = 'published'
    and (p_bbox is null
         or p.display_location && st_makeenvelope(p_bbox[1], p_bbox[2], p_bbox[3], p_bbox[4], 4326)::geography)
    and (p_types is null or cardinality(p_types) = 0 or p.type = any (p_types))
    and (p_min_price is null or (p.currency = p_currency and p.price >= p_min_price))
    and (p_max_price is null or (p.currency = p_currency and p.price <= p_max_price))
    and (p_min_bedrooms is null or p.bedrooms >= p_min_bedrooms)
    and (p_min_bathrooms is null or p.bathrooms >= p_min_bathrooms)
    and (p_min_area is null or p.area_m2 >= p_min_area)
    and (p_max_area is null or p.area_m2 <= p_max_area)
    and (p_zone_ids is null or cardinality(p_zone_ids) = 0 or p.zone_id = any (p_zone_ids))
    and (p_amenity_keys is null or cardinality(p_amenity_keys) = 0 or (
      select count(*)
        from public.property_amenities pa
        join public.amenities a on a.id = pa.amenity_id
       where pa.property_id = p.id and a.key in (select key from wanted_amenities)
    ) = (select count(*) from wanted_amenities))
    and (p_has_tour is not true or p.virtual_tour_url is not null)
    and (p_residency is not true or p.residency_eligible)
  order by
    case when p_sort = 'price_asc' then p.price end asc,
    case when p_sort = 'price_desc' then p.price end desc,
    case when p_sort = 'area_desc' then p.area_m2 end desc nulls last,
    case when p_sort = 'newest' then p.published_at end desc,
    p.is_featured desc,
    p.published_at desc,
    p.reference desc
  limit least(greatest(coalesce(p_limit, 24), 1), 48)
  offset greatest(coalesce(p_offset, 0), 0)
$$;

revoke execute on function public.search_properties from public;
grant execute on function public.search_properties to anon, authenticated, service_role;
