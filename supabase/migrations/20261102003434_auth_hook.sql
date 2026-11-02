-- Custom access token hook: puts the staff role in the JWT as `user_role` (read by private.has_role).
-- Enabled in supabase/config.toml → [auth.hook.custom_access_token]. Inactive users get no role claim.
-- Claims are refreshed with the token (jwt_expiry = 1 h): deactivating a user also requires signing them out.

create function public.custom_access_token_hook(event jsonb)
returns jsonb
language plpgsql
stable
set search_path = ''
as $$
declare
  claims jsonb := event -> 'claims';
  staff_role public.app_role;
begin
  select p.role into staff_role
    from public.profiles p
   where p.id = (event ->> 'user_id')::uuid
     and p.is_active;

  if staff_role is null then
    claims := claims - 'user_role';
  else
    claims := jsonb_set(claims, '{user_role}', to_jsonb(staff_role));
  end if;

  return jsonb_set(event, '{claims}', claims);
end;
$$;

grant usage on schema public to supabase_auth_admin;
grant execute on function public.custom_access_token_hook(jsonb) to supabase_auth_admin;
revoke execute on function public.custom_access_token_hook(jsonb) from authenticated, anon, public;

grant select on table public.profiles to supabase_auth_admin;
create policy "profiles: auth server reads roles" on public.profiles
  as permissive for select to supabase_auth_admin using (true);
