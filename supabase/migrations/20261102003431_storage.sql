-- Public bucket for property photos, floor plans and the hero cut-out.
-- Paths: properties/{property_id}/… (per property) and site/… (hero, brand assets).
-- Public reads go through the public URL; listing and writes need the policies below.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('property-media', 'property-media', true, 10485760,
        array['image/jpeg', 'image/png', 'image/webp', 'image/avif'])
on conflict (id) do nothing;

create function private.can_write_media(object_name text)
returns boolean
language sql
stable
set search_path = ''
as $$
  select private.has_role('admin', 'editor')
      or (private.has_role('agent')
          and (storage.foldername(object_name))[1] = 'properties'
          and (storage.foldername(object_name))[2] ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
          and private.can_edit_property(((storage.foldername(object_name))[2])::uuid))
$$;
revoke execute on function private.can_write_media(text) from public;
grant execute on function private.can_write_media(text) to authenticated, service_role;

-- Upsert needs INSERT + SELECT + UPDATE.
create policy "property-media: staff list" on storage.objects for select to authenticated
  using (bucket_id = 'property-media' and (select private.has_role('admin', 'agent', 'editor')));
create policy "property-media: upload" on storage.objects for insert to authenticated
  with check (bucket_id = 'property-media' and private.can_write_media(name));
create policy "property-media: replace" on storage.objects for update to authenticated
  using (bucket_id = 'property-media' and private.can_write_media(name))
  with check (bucket_id = 'property-media' and private.can_write_media(name));
create policy "property-media: delete" on storage.objects for delete to authenticated
  using (bucket_id = 'property-media' and private.can_write_media(name));
