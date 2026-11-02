-- Core tables. Translatable content lives in *_translations keyed by locale (MASTERPLAN §2.3):
-- adding a language is an INSERT into public.locales, never a migration.

-- ── i18n ─────────────────────────────────────────────────────────────────────
create table public.locales (
  code text primary key check (code ~ '^[a-z]{2}(-[A-Z]{2})?$'),
  name text not null,
  native_name text not null,
  is_default boolean not null default false,
  is_enabled boolean not null default true,
  is_required boolean not null default false,
  sort_order smallint not null default 0,
  check (not is_default or (is_enabled and is_required))
);
create unique index locales_single_default on public.locales (is_default) where is_default;

-- ── People ───────────────────────────────────────────────────────────────────
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  role public.app_role not null,
  full_name text not null default '',
  email text,
  phone text,
  whatsapp text,
  avatar_path text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ── Translatable catalogs ────────────────────────────────────────────────────
create table public.zones (
  id uuid primary key default gen_random_uuid(),
  center extensions.geography(Point, 4326),
  sort_order smallint not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.zone_translations (
  zone_id uuid not null references public.zones (id) on delete cascade,
  locale text not null references public.locales (code) on update cascade,
  name text not null check (length(trim(name)) > 0),
  slug text not null check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  description text,
  primary key (zone_id, locale),
  unique (locale, slug)
);

create table public.amenities (
  id uuid primary key default gen_random_uuid(),
  key text not null unique check (key ~ '^[a-z0-9_]+$'),
  icon text,
  sort_order smallint not null default 0
);

create table public.amenity_translations (
  amenity_id uuid not null references public.amenities (id) on delete cascade,
  locale text not null references public.locales (code) on update cascade,
  name text not null check (length(trim(name)) > 0),
  primary key (amenity_id, locale)
);
create index amenity_translations_locale_idx on public.amenity_translations (locale);

create table public.testimonials (
  id uuid primary key default gen_random_uuid(),
  author_name text not null,
  author_country char(2) check (author_country ~ '^[A-Z]{2}$'),
  property_id uuid, -- FK added after public.properties exists
  is_published boolean not null default false,
  sort_order smallint not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.testimonial_translations (
  testimonial_id uuid not null references public.testimonials (id) on delete cascade,
  locale text not null references public.locales (code) on update cascade,
  quote text not null check (length(trim(quote)) > 0),
  primary key (testimonial_id, locale)
);
create index testimonial_translations_locale_idx on public.testimonial_translations (locale);

-- Fiscal/migration facts shown on the "Invertir" pages: never published without a source and a date.
create table public.investment_facts (
  id uuid primary key default gen_random_uuid(),
  key text not null unique check (key ~ '^[a-z0-9_]+$'),
  value text not null,
  source_url text not null check (source_url ~ '^https://'),
  as_of date not null,
  sort_order smallint not null default 0,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.investment_fact_translations (
  fact_id uuid not null references public.investment_facts (id) on delete cascade,
  locale text not null references public.locales (code) on update cascade,
  label text not null check (length(trim(label)) > 0),
  body text,
  primary key (fact_id, locale)
);
create index investment_fact_translations_locale_idx on public.investment_fact_translations (locale);

-- ── Inventory ────────────────────────────────────────────────────────────────
create table public.properties (
  id uuid primary key default gen_random_uuid(),
  reference integer generated always as identity unique, -- shown as ED-0001 (WhatsApp, admin)
  type public.property_type not null,
  operation public.operation_type not null default 'sale',
  publication_status public.publication_status not null default 'draft',
  availability public.availability_status not null default 'available',
  price numeric(14, 2) not null check (price > 0),
  currency char(3) not null default 'USD' check (currency ~ '^[A-Z]{3}$'),
  bedrooms smallint check (bedrooms >= 0),
  bathrooms smallint check (bathrooms >= 0),
  area_m2 numeric(10, 2) check (area_m2 > 0),
  lot_m2 numeric(10, 2) check (lot_m2 > 0),
  parking smallint check (parking >= 0),
  year_built smallint check (year_built between 1850 and 2100),
  location extensions.geography(Point, 4326),          -- exact: staff only (column grants)
  display_location extensions.geography(Point, 4326),  -- public: exact or ~500 m grid (trigger)
  address_line text,                                    -- exact: staff only (column grants)
  hide_exact_address boolean not null default true,
  zone_id uuid references public.zones (id) on delete set null,
  agent_id uuid references public.profiles (id) on delete set null,
  is_featured boolean not null default false,
  residency_eligible boolean not null default false,
  virtual_tour_url text check (virtual_tour_url ~ '^https://'),
  video_url text check (video_url ~ '^https://'),
  floor_plan_path text,
  construction_progress smallint check (construction_progress between 0 and 100),
  delivery_date date,
  published_at timestamptz,
  sold_at timestamptz,
  created_by uuid references public.profiles (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index properties_display_location_idx on public.properties using gist (display_location);
create index properties_status_idx on public.properties (publication_status, availability);
create index properties_zone_idx on public.properties (zone_id);
create index properties_agent_idx on public.properties (agent_id);
create index properties_created_by_idx on public.properties (created_by);
create index properties_featured_idx on public.properties (published_at desc) where is_featured;

alter table public.testimonials
  add constraint testimonials_property_id_fkey foreign key (property_id) references public.properties (id) on delete set null;
create index testimonials_property_idx on public.testimonials (property_id);

create table public.property_translations (
  property_id uuid not null references public.properties (id) on delete cascade,
  locale text not null references public.locales (code) on update cascade,
  title text not null check (length(trim(title)) > 0),
  slug text not null check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  short_description text,
  description text,
  seo_title text,
  seo_description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (property_id, locale),
  unique (locale, slug)
);

create table public.property_media (
  id uuid primary key default gen_random_uuid(),
  property_id uuid not null references public.properties (id) on delete cascade,
  storage_path text not null unique,
  position smallint not null default 0,
  is_cover boolean not null default false,
  width integer check (width > 0),
  height integer check (height > 0),
  created_at timestamptz not null default now()
);
create unique index property_media_one_cover on public.property_media (property_id) where is_cover;
create index property_media_property_position_idx on public.property_media (property_id, position);

create table public.property_media_translations (
  media_id uuid not null references public.property_media (id) on delete cascade,
  locale text not null references public.locales (code) on update cascade,
  alt_text text not null check (length(trim(alt_text)) > 0),
  primary key (media_id, locale)
);
create index property_media_translations_locale_idx on public.property_media_translations (locale);

create table public.property_amenities (
  property_id uuid not null references public.properties (id) on delete cascade,
  amenity_id uuid not null references public.amenities (id) on delete cascade,
  primary key (property_id, amenity_id)
);
create index property_amenities_amenity_idx on public.property_amenities (amenity_id);

-- Units of a condominium sold off-plan; the condominium itself is the parent property.
create table public.property_units (
  id uuid primary key default gen_random_uuid(),
  property_id uuid not null references public.properties (id) on delete cascade,
  label text not null,
  bedrooms smallint check (bedrooms >= 0),
  bathrooms smallint check (bathrooms >= 0),
  area_m2 numeric(10, 2) check (area_m2 > 0),
  floor smallint,
  price numeric(14, 2) check (price > 0),
  currency char(3) not null default 'USD' check (currency ~ '^[A-Z]{3}$'),
  status public.unit_status not null default 'available',
  sort_order smallint not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (property_id, label)
);

-- ── Leads & analytics ────────────────────────────────────────────────────────
create table public.leads (
  id uuid primary key default gen_random_uuid(),
  full_name text not null check (length(trim(full_name)) between 1 and 200),
  email text not null check (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  phone text not null check (length(phone) between 5 and 40),
  country char(2) check (country ~ '^[A-Z]{2}$'),
  locale text not null references public.locales (code) on update cascade,
  source public.lead_source not null,
  property_id uuid references public.properties (id) on delete set null,
  goal public.lead_goal,
  residency_interest boolean not null default false,
  preferred_channel public.contact_channel,
  interest public.lead_interest,
  preferred_date date,
  preferred_slot text,
  timezone text,
  message text check (length(message) <= 5000),
  consent_privacy_at timestamptz not null,
  consent_marketing boolean not null default false,
  stage public.lead_stage not null default 'new',
  assigned_to uuid references public.profiles (id) on delete set null,
  first_response_at timestamptz,
  closed_at timestamptz,
  closed_price numeric(14, 2) check (closed_price > 0),
  closed_currency char(3) check (closed_currency ~ '^[A-Z]{3}$'),
  lost_reason text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index leads_assigned_idx on public.leads (assigned_to);
create index leads_property_idx on public.leads (property_id);
create index leads_stage_created_idx on public.leads (stage, created_at);
create index leads_created_idx on public.leads (created_at);
create index leads_email_idx on public.leads (lower(email));
create index leads_locale_idx on public.leads (locale);

create table public.lead_events (
  id bigint generated always as identity primary key,
  lead_id uuid not null references public.leads (id) on delete cascade,
  type public.lead_event_type not null,
  from_stage public.lead_stage,
  to_stage public.lead_stage,
  note text check (length(note) <= 5000),
  remind_at timestamptz,
  actor_id uuid references public.profiles (id) on delete set null,
  created_at timestamptz not null default now()
);
create index lead_events_lead_created_idx on public.lead_events (lead_id, created_at);
create index lead_events_actor_idx on public.lead_events (actor_id);

-- No personal data: property + locale + timestamp only.
create table public.property_views (
  id bigint generated always as identity primary key,
  property_id uuid not null references public.properties (id) on delete cascade,
  locale text references public.locales (code) on update cascade,
  viewed_at timestamptz not null default now()
);
create index property_views_property_viewed_idx on public.property_views (property_id, viewed_at);
create index property_views_viewed_idx on public.property_views (viewed_at);
create index property_views_locale_idx on public.property_views (locale);

-- ── Settings & system ────────────────────────────────────────────────────────
create table public.site_settings (
  id boolean primary key default true check (id), -- single row
  phone text,
  whatsapp text,
  email text,
  address_line text,
  social jsonb not null default '{}'::jsonb,
  lead_notification_emails text[] not null default '{}',
  hero_property_id uuid references public.properties (id) on delete set null,
  hero_image_path text,
  lead_sla_minutes integer not null default 120 check (lead_sla_minutes > 0),
  updated_at timestamptz not null default now()
);
create index site_settings_hero_property_idx on public.site_settings (hero_property_id);

create table public.site_settings_translations (
  locale text primary key references public.locales (code) on update cascade,
  hero_tagline text,
  hero_microcopy text[] not null default '{}',
  updated_at timestamptz not null default now()
);

create table public.exchange_rates (
  base char(3) not null check (base ~ '^[A-Z]{3}$'),
  quote char(3) not null check (quote ~ '^[A-Z]{3}$'),
  rate numeric(18, 8) not null check (rate > 0),
  updated_at timestamptz not null default now(),
  updated_by uuid references public.profiles (id) on delete set null,
  primary key (base, quote),
  check (base <> quote)
);
create index exchange_rates_updated_by_idx on public.exchange_rates (updated_by);

create table public.audit_log (
  id bigint generated always as identity primary key,
  table_name text not null,
  record_id text,
  action text not null check (action in ('INSERT', 'UPDATE', 'DELETE')),
  actor_id uuid, -- no FK: the trail must survive the profile
  old_data jsonb,
  new_data jsonb,
  created_at timestamptz not null default now()
);
create index audit_log_record_idx on public.audit_log (table_name, record_id);
create index audit_log_created_idx on public.audit_log (created_at);
