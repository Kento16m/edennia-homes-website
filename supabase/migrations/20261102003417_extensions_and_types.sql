-- Extensions, enums and the private helper schema.

create extension if not exists postgis with schema extensions;

-- Not exposed through the Data API: helpers, trigger functions, security definer code.
create schema if not exists private;
grant usage on schema private to anon, authenticated, service_role;

create type public.app_role as enum ('admin', 'agent', 'editor');
create type public.property_type as enum ('house', 'apartment', 'condominium');
create type public.operation_type as enum ('sale');
create type public.publication_status as enum ('draft', 'published', 'archived');
create type public.availability_status as enum ('available', 'reserved', 'sold');
create type public.unit_status as enum ('available', 'reserved', 'sold');
create type public.lead_stage as enum ('new', 'contacted', 'visit_scheduled', 'negotiation', 'won', 'lost');
create type public.lead_source as enum ('property_form', 'contact_form', 'whatsapp', 'phone', 'other');
create type public.lead_goal as enum ('invest', 'live', 'both');
create type public.contact_channel as enum ('whatsapp', 'phone', 'email', 'video_call');
create type public.lead_interest as enum ('visit', 'video_call', 'info', 'financing');
create type public.lead_event_type as enum ('created', 'stage_changed', 'assigned', 'note', 'call', 'email', 'whatsapp', 'reminder');

-- Role comes from the `user_role` JWT claim set by public.custom_access_token_hook (never from user_metadata).
create function private.has_role(variadic roles public.app_role[])
returns boolean
language sql
stable
set search_path = ''
as $$
  select coalesce((auth.jwt() ->> 'user_role')::public.app_role = any (roles), false)
$$;

revoke execute on function private.has_role(public.app_role[]) from public;
grant execute on function private.has_role(public.app_role[]) to anon, authenticated, service_role;
