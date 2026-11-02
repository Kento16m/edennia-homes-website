# Supabase (local)

`supabase/migrations` is the only source of truth for the schema. Never change the database from the dashboard.

## Requirements
- Docker Desktop running (on Windows it needs WSL 2: `wsl --install` as administrator, then restart).
- The CLI is a dev dependency: use `pnpm exec supabase …` from the repo root.

## Commands
| What | Command |
|---|---|
| Start the local stack | `pnpm exec supabase start` |
| Rebuild DB from migrations + seed | `pnpm exec supabase db reset` |
| Run pgTAP tests (`supabase/tests/database`) | `pnpm exec supabase test db` |
| Security/performance advisors | `pnpm exec supabase db advisors` |
| Regenerate TS types | `pnpm --filter @edennia/db gen:types` |
| New migration | `pnpm exec supabase migration new <name>` |

## Seed users (local only)
Password for all: `edennia-local-2026`

| Email | Role |
|---|---|
| admin@edennia.test | admin |
| asesor1@edennia.test | agent (20 leads) |
| asesor2@edennia.test | agent (20 leads) |
| editor@edennia.test | editor (no leads) |

Staff accounts are invite-only (`enable_signup = false`). An invitation **must** set `app_metadata.role`
(`admin`, `agent` or `editor`); the role reaches the JWT as the `user_role` claim through
`public.custom_access_token_hook`.

## Model in one paragraph
Translatable content lives in `*_translations` tables keyed by `locales.code`: adding a language is an
`insert into locales` plus a `messages/xx.json`, no migration. A property can only be published with a
description in every enabled + required locale. Anonymous visitors read published properties through
column grants that hide `location`, `address_line` and `created_by` (they get `display_location`, snapped
to ~500 m when `hide_exact_address`). Leads have no anon grant at all: public leads arrive through the
`submit-lead` Edge Function (Phase 7) with the service role.
