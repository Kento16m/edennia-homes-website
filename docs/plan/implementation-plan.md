# Edennia Homes — Plan de implementación (Fases 2–13)

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Construir la web pública (`edennia.homes`) y el panel admin (`admin.edennia.homes`) sobre una sola base Supabase, según MASTERPLAN, PRODUCT y DESIGN.

**Architecture:** Monorepo pnpm + Turborepo con `apps/web`, `apps/admin` y `packages/{config,ui,i18n,db}`. Supabase (Postgres + PostGIS, RLS, Edge Functions) es la única fuente de datos; `supabase/migrations` es la única fuente del esquema.

**Tech Stack (versiones estables al 2026-11-01):** Next.js 16.4 · React 19.3 · TypeScript (la que instale `create-next-app`) · Tailwind CSS 4.3 · Turborepo 2.11 · pnpm 12 · next-intl 4.14 · GSAP 3.15 + @gsap/react 2.1 · Lenis 1.3 · MapLibre GL 6.16 · Supabase JS 2.118 + @supabase/ssr 0.12 · Zod 4.6 · react-hook-form 7.91 · Vitest 5 · Playwright 1.64 · lucide-react · shadcn/ui · Recharts 3 · TanStack Table 9.

**Spec:** `docs/MASTERPLAN.md` (§2, §4, §5, §8) · `docs/PRODUCT.md` · `docs/DESIGN.md` · `docs/design/shape/*.md` · `docs/design/reference-analysis.md`

**Granularidad:** la Fase 2 está detallada a nivel de paso porque se ejecuta ahora. Las fases 3–13 están en tareas pequeñas y verificables; **cada una se detalla en Plan Mode al empezar su sesión** (MASTERPLAN §6), con este documento como índice. Así el plan no envejece antes de que exista el código que describe.

## Global Constraints

- Reglas no negociables de `CLAUDE.md` (RLS en todas las tablas; service_role solo en Edge Functions; cero textos hardcodeados; contenido traducible en `*_translations`; idiomas desde la tabla `locales`; tokens solo desde `packages/ui`; GSAP con `useGSAP` + `prefers-reduced-motion`; `next/image` sin layout shift).
- Tokens exactos de `docs/DESIGN.md` (frontmatter normativo). `stone-500 = #656962`. `leaf-400` nunca como texto sobre claro.
- Tipografía: Clash Display (display/wordmark) + General Sans (UI/texto) + Instrument Serif Italic (acento, ≤1 palabra por titular, nunca en admin). Autoalojadas.
- Iconos: `lucide-react`, trazo 1.5.
- Moneda en el dato (precios en USD hoy; EUR aproximado si hay tasa). Nunca asumir moneda en la UI.
- "Nada inventado": ningún testimonio, contador, logo de cliente o badge de urgencia sin dato real en BD.
- RGPD: consentimiento explícito no premarcado; banner de cookies si hay analítica no esencial.
- Antes de "terminado": `pnpm build`, `pnpm typecheck`, `pnpm lint` y tests en verde; capturas 1440px y 390px revisadas en cambios de UI.
- Conventional Commits; `git tag fase-NN` al cerrar cada fase.

## Review Focus

1. **Textos largos en otros idiomas** (EN y futuro DE, +35 %): ningún botón/chip con ancho fijo → Fase 2 Task 3 (styleguide incluye variante de texto largo) y Fase 11 (pseudo-localización).
2. **Traducción faltante de una propiedad**: debe caer al idioma por defecto con aviso, nunca a una página rota → Fase 2 Task 4 (test de `getTranslation` con fallback) y Fase 7.
3. **URL del explorador manipulada o vieja** (`?min=abc&dorm=-2`): se ignoran los parámetros inválidos y se conserva el resto → Fase 6 (tests del parser zod).
4. **Envío de lead duplicado, sin Turnstile o desde bot**: rechazo limpio y sin datos perdidos del usuario legítimo → Fase 7 (tests de la Edge Function).
5. **Asesor intentando ver leads ajenos o usuario anónimo leyendo `leads`**: bloqueado por RLS, no solo por la UI → Fase 3 (tests RLS) y Fase 12 (ataque manual).

---

## FASE 2 — Monorepo, tokens y librería base 🧭 G1

**Estructura de archivos**

```
package.json                 # scripts raíz: dev, build, lint, typecheck, test (turbo)
pnpm-workspace.yaml          # apps/*, packages/*
turbo.json
packages/config/             # @edennia/config
  package.json
  tsconfig.base.json         # strict
  tsconfig.nextjs.json       # extiende base, para apps Next
  eslint.config.mjs          # flat config compartida (next + prettier)
  prettier.config.mjs
packages/ui/                 # @edennia/ui
  package.json               # exports: ./styles.css, ./fonts, ./*
  src/styles.css             # @theme con tokens de DESIGN.md + base
  src/fonts.ts               # next/font: Clash Display, General Sans (local), Instrument Serif (google)
  src/fonts/*.woff2          # Fontshare (licencia ITF Free Font)
  src/cn.ts                  # clsx + tailwind-merge
  src/button.tsx  input.tsx  badge.tsx  card.tsx  chip.tsx  container.tsx
  src/logo.tsx               # <Logo variant="lockup|emblem" tone="forest|white" />
  src/logo/*.svg
packages/i18n/               # @edennia/i18n
  src/index.ts               # locales, defaultLocale, getTranslation
  src/index.test.ts
packages/db/                 # @edennia/db (vacío hasta Fase 3)
  src/index.ts
apps/web/                    # Next.js (create-next-app), src/app/styleguide/page.tsx
apps/admin/                  # Next.js (create-next-app)
```

### Task 1: Workspace raíz + `packages/config`

**Files:** Create `package.json`, `pnpm-workspace.yaml`, `turbo.json`, `packages/config/*`

**Interfaces:**
- Produces: paquete `@edennia/config` con `tsconfig.base.json`, `tsconfig.nextjs.json`, `eslint.config.mjs`, `prettier.config.mjs`. Scripts raíz `dev | build | lint | typecheck | test` → `turbo run <task>`.

- [ ] **Step 1:** Instalar pnpm 12 si falta (`npm i -g pnpm`). Verificar: `pnpm -v` → `12.x`.
- [ ] **Step 2:** Crear `pnpm-workspace.yaml` (`apps/*`, `packages/*`), `package.json` raíz privado con los 5 scripts y `turbo` como devDependency, `turbo.json` con tareas `build` (outputs `.next/**`, `!.next/cache/**`), `dev` (persistent, sin cache), `lint`, `typecheck`, `test`.
- [ ] **Step 3:** `packages/config`: `tsconfig.base.json` con `strict: true`, `noUncheckedIndexedAccess: true`; `tsconfig.nextjs.json` con las opciones que genera Next (plugin `next`, `jsx: preserve`, `moduleResolution: bundler`).
- [ ] **Step 4:** `pnpm install`. Esperado: sin errores.
- [ ] **Step 5:** Commit `chore: workspace pnpm + turborepo + config compartida`.

### Task 2: `apps/web` y `apps/admin`

**Files:** Create `apps/web/**`, `apps/admin/**` con `create-next-app`; Modify sus `tsconfig.json` y `eslint.config.mjs` para extender `@edennia/config`.

**Interfaces:**
- Consumes: `@edennia/config` (Task 1).
- Produces: dos apps con `src/app`, alias `@/*`, scripts `dev` (web :3000, admin :3001), `build`, `lint`, `typecheck` (`tsc --noEmit`).

- [ ] **Step 1:** `pnpm create next-app@latest apps/web --ts --tailwind --eslint --app --src-dir --import-alias "@/*" --use-pnpm --skip-install` (idem `apps/admin`). Renombrar paquetes a `@edennia/web` y `@edennia/admin`.
- [ ] **Step 2:** Borrar el boilerplate de la página de inicio (SVGs de demo, estilos de ejemplo); cada `page.tsx` queda con un `<main>` mínimo.
- [ ] **Step 3:** `tsconfig.json` de cada app extiende `@edennia/config/tsconfig.nextjs.json`; añadir script `typecheck`.
- [ ] **Step 4:** `pnpm install && pnpm build && pnpm typecheck`. Esperado: ambas apps compilan.
- [ ] **Step 5:** Commit `feat: apps web y admin con Next.js`.

### Task 3: `packages/ui` — tokens, fuentes, primitivas y logo

**Files:** Create `packages/ui/**`; Modify `apps/*/src/app/globals.css` (importa `@edennia/ui/styles.css`), `apps/*/src/app/layout.tsx` (variables de fuente), `apps/*/next.config.ts` (`transpilePackages: ['@edennia/ui']`).

**Interfaces:**
- Produces:
  - CSS: utilidades Tailwind derivadas de `@theme` con los nombres del frontmatter de DESIGN.md: `bg-forest-900`, `text-stone-500`, `border-line-strong`, `rounded-xl`, `font-display`, `font-sans`, `font-accent`, `shadow-md`, etc.
  - `fontVariables: string` (clases `--font-display`, `--font-sans`, `--font-accent`) exportado desde `@edennia/ui/fonts`.
  - `cn(...inputs: ClassValue[]): string`
  - `Button` props: `variant?: 'primary' | 'secondary' | 'ghost'`, `size?: 'md' | 'lg'`, `asChild?` no (YAGNI) + props nativas de `<button>`.
  - `Input` (props nativas de `<input>` + `invalid?: boolean` → `aria-invalid`), `Badge` (`tone: 'available' | 'reserved' | 'sold' | 'neutral'`), `Card` (`<div>` con `lg` + `white` + `shadow-xs`), `Chip` (`selected?: boolean` → `aria-pressed` cuando es botón), `Container` (`max-w-[1440px]` + `px-gutter`).
  - `Logo` props: `variant: 'lockup' | 'emblem'`, `tone: 'forest' | 'white'`, `className?`; SVG inline con `role="img"` y `aria-label="Edennia Homes"`.

- [ ] **Step 1:** `src/styles.css`: `@import "tailwindcss";` + `@theme { … }` con TODOS los colores, radios, sombras (DESIGN.md › Elevation), espaciados `section`/`gutter`, fuentes y escala tipográfica del frontmatter; `@source "./"` para que las apps detecten clases del paquete. Base: `body { background: var(--color-paper); color: var(--color-ink); }`, foco visible global (anillo 2px `forest-600` + offset 2px).
- [ ] **Step 2:** Fuentes: descargar de Fontshare los `.woff2` de Clash Display (500, 600) y General Sans (400, 500) a `src/fonts/`; `src/fonts.ts` con `next/font/local` para ambas y `next/font/google` para Instrument Serif (italic 400), cada una con `variable` y `display: 'swap'`.
- [ ] **Step 3:** Primitivas con `class-variance-authority` donde haya variantes (Button, Badge). Ninguna con ancho fijo. Valores de DESIGN.md › Components (Button 48px web, `md` radius, hover `forest-600`).
- [ ] **Step 4:** Logo: intentar vectorizar `docs/brand/logo-white.png` (umbral sobre alfa/luminancia → trazado con potrace) a `src/logo/lockup.svg` y extraer el emblema (hoja + techo) a `src/logo/emblem.svg`, ambos monocromos con `fill="currentColor"`. Revisar el resultado renderizado en la styleguide. **Si el trazo caligráfico no es limpio:** placeholder SVG (wordmark "Edennia" en Clash Display + "HOMES" en label) con comentario `shortcut: placeholder hasta tener vector profesional del logo, reemplazar cuando el diseñador entregue el SVG`.
- [ ] **Step 5:** Ambas apps importan `@edennia/ui/styles.css` y aplican `fontVariables` en `<html>`. `pnpm build && pnpm typecheck`. Esperado: verde.
- [ ] **Step 6:** Commit `feat(ui): tokens de diseño, fuentes, primitivas y logo`.

### Task 4: `packages/i18n` y `packages/db`

**Files:** Create `packages/i18n/src/index.ts`, `packages/i18n/src/index.test.ts`, `packages/i18n/package.json` (vitest), `packages/db/src/index.ts`, `packages/db/package.json`.

**Interfaces:**
- Produces:
  - `locales: readonly ['es', 'en']` — `shortcut: lista estática para el routing de next-intl; la fuente de verdad de idiomas habilitados será la tabla locales (Fase 3)`.
  - `type Locale = (typeof locales)[number]`, `defaultLocale: Locale = 'es'`, `isLocale(value: string): value is Locale`.
  - `getTranslation<T>(translations: Partial<Record<string, T>>, locale: string, fallback?: string): { value: T; locale: string; isFallback: boolean } | null`

- [ ] **Step 1: Test que falla** (`index.test.ts`):
  - `getTranslation({ es: 'Hola', en: 'Hi' }, 'en')` → `{ value: 'Hi', locale: 'en', isFallback: false }`
  - `getTranslation({ es: 'Hola' }, 'en')` → `{ value: 'Hola', locale: 'es', isFallback: true }`
  - `getTranslation({ es: 'Hola' }, 'de')` → `{ value: 'Hola', locale: 'es', isFallback: true }` (idioma futuro sin traducción)
  - `getTranslation({}, 'es')` → `null`
  - `isLocale('fr')` → `false`; `isLocale('es')` → `true`
- [ ] **Step 2:** `pnpm --filter @edennia/i18n test` → FAIL.
- [ ] **Step 3:** Implementar en `src/index.ts` (fallback por defecto = `defaultLocale`).
- [ ] **Step 4:** `pnpm --filter @edennia/i18n test` → PASS.
- [ ] **Step 5:** `packages/db`: `package.json` + `src/index.ts` con `export {}` y comentario `// Tipos y schemas se generan en la Fase 3`.
- [ ] **Step 6:** Commit `feat(i18n): locales y getTranslation con fallback`.

### Task 5: `/styleguide` (solo desarrollo)

**Files:** Create `apps/web/src/app/styleguide/page.tsx`.

**Interfaces:**
- Consumes: todo `@edennia/ui` (Task 3).

- [ ] **Step 1:** Página server component; `if (process.env.NODE_ENV === 'production') notFound()`.
- [ ] **Step 2:** Secciones: paleta (swatch + nombre + hex + ratio de contraste documentado), escala tipográfica (wordmark, display… label, acento itálico), radios, sombras, botones (3 variantes, hover/foco/disabled), input (normal/invalid/disabled), badges (4 tonos), chips (seleccionado/no), card, container, logo (lockup y emblema, forest y white sobre `forest-900`). Incluir una fila con texto largo en alemán para comprobar que nada desborda. *Única excepción a "cero textos hardcodeados": es una página interna de desarrollo.*
- [ ] **Step 3:** `pnpm --filter @edennia/web dev` y capturas con Playwright a 1440px y 390px en `/styleguide`; revisarlas.
- [ ] **Step 4:** `pnpm build` (confirma que `/styleguide` da 404 en producción) y `pnpm typecheck`, `pnpm lint`.
- [ ] **Step 5:** Commit `feat(web): styleguide de desarrollo`.

### Cierre de Fase 2
- [ ] `/ponytail-review` y corregir lo que salga.
- [ ] `/impeccable document` en modo scan (reemplaza el seed de DESIGN.md con los tokens reales).
- [ ] 🧭 G1: `/graphify .` → revisar GRAPH_REPORT.md.
- [ ] `git tag fase-02`.

---

## FASE 3 — Supabase: esquema, i18n, RLS, storage 🧭 G2
*Opus · xhigh · Plan Mode obligatorio · skills `supabase`, `supabase-postgres-best-practices`*

- [ ] 3.1 `supabase init` + `supabase start` local; proyectos `edennia-dev` / `edennia-prod` creados por el cliente. **Hecho:** `supabase status` OK.
- [ ] 3.2 Migración base: `locales`, `profiles` (rol), `zones`(+tr), `amenities`(+tr), `properties`, `property_translations`, `property_media`, `property_amenities`, `testimonials`(+tr), `site_settings`, `audit_log`. **Nuevas por PRODUCT.md:** `properties.residency_eligible bool`, `properties.hide_exact_address bool`, `properties.currency` (USD por defecto), `exchange_rates(base, quote, rate, updated_at)`, `projects` + `project_units` (condominios en preventa: tipología, piso, m², precio, estado, avance %, fecha de entrega), `investment_facts` + `investment_fact_translations` (valor, `source_url`, `as_of` obligatorios). **Hecho:** `supabase db reset` limpio.
- [ ] 3.3 PostGIS: `location geography(Point,4326)` + GIST; RPC `search_properties(bbox, filtros, locale, orden, paginación)` con fallback de idioma. **Hecho:** test SQL devuelve resultados traducidos y con fallback.
- [ ] 3.4 Leads: `leads` (+ `country`, `goal: invest|live|both`, `residency_interest bool`, `preferred_slot`, `locale`, `source`, `property_id`), `lead_events`, `property_views`. **Hecho:** migración aplica.
- [ ] 3.5 Roles + custom access token hook (rol en el JWT). **Hecho:** JWT de prueba contiene `user_role`.
- [ ] 3.6 RLS en todas las tablas (MASTERPLAN §5). **Hecho:** tests pgTAP: anon no lee `leads`; agent solo los suyos; editor no ve `leads`; anon solo propiedades `published`.
- [ ] 3.7 Función de validación de publicación (traducciones obligatorias). **Hecho:** test: publicar sin EN falla con mensaje claro.
- [ ] 3.8 Vistas/funciones de métricas del dashboard, incluido **leads por país** y **tiempo de primera respuesta**. **Hecho:** consultas sobre el seed devuelven cifras esperadas.
- [ ] 3.9 Triggers `updated_at`, `audit_log`, cambios de etapa → `lead_events`. **Hecho:** test de trigger.
- [ ] 3.10 Bucket `property-media` + políticas (incluye imagen de hero con transparencia). **Hecho:** anon lee, solo roles escriben.
- [ ] 3.11 `seed.sql`: es/en, 6 zonas de Asunción y alrededores, 15 amenidades, 24 propiedades (incl. 1 proyecto de condominio con unidades), tasa USD→EUR, 40 leads con países europeos. **Hecho:** `db reset` + conteos.
- [ ] 3.12 Tipos TS en `packages/db` + schemas zod (property, lead, filtros). **Hecho:** `pnpm typecheck` verde.
- 🧭 G2 · `git tag fase-03`

## FASE 4 — Web pública: layout, i18n y navegación
- [ ] 4.1 next-intl con `/es` y `/en`, detección de idioma inicial, slugs localizados, hreflang + canonical. **Hecho:** test Playwright de cambio de idioma conservando la página.
- [ ] 4.2 `messages/es.json` y `messages/en.json` con toda la UI. **Hecho:** grep sin literales en JSX.
- [ ] 4.3 Header (emblema durante el hero → lockup plano compacto al hacer scroll; nav en píldoras; selector de idioma; WhatsApp). **Hecho:** capturas 1440/390.
- [ ] 4.4 Footer grande (logo, contacto real, zonas, redes, idioma, legal).
- [ ] 4.5 Lenis + ScrollTrigger con `useGSAP`, desactivado con reduced-motion.
- [ ] 4.6 404 y loading con estilo de marca. `/impeccable critique` header/footer.

## FASE 5 — Home (`docs/design/shape/home.md`)
- [ ] 5.1 Hero en capas (wordmark gigante + casa recortada desde `site_settings`), fallback sin recorte. **Hecho:** LCP < 2.5s móvil.
- [ ] 5.2 Buscador flotante → `/propiedades?…`.
- [ ] 5.3 "Datos que importan" (de `investment_facts` + conteo real de propiedades).
- [ ] 5.4 Quiénes somos (carrusel difuminado) · 5.5 Por qué Paraguay · 5.6 Destacadas acordeón · 5.7 Zonas · 5.8 Cómo comprar desde Europa · 5.9 Por qué Edennia · 5.10 Testimonios condicionales · 5.11 CTA + footer.
- **Hecho:** Lighthouse móvil ≥ 90; capturas por sección; `/impeccable critique`.

## FASE 6 — Explorador (`docs/design/shape/explorador.md`)
- [ ] 6.1 Parser de filtros URL ↔ zod **con tests** (incl. Review Focus #3).
- [ ] 6.2 Layout 3 columnas / drawer / toggle móvil.
- [ ] 6.3 Filtros (incl. "Incluye residencia") · 6.4 Tarjetas · 6.5 Mapa MapLibre (pines con precio, clusters, bbox) · 6.6 Orden, paginación, skeletons, vacíos con sugerencias · 6.7 `/favoritos` y `/comparar`.
- **Hecho:** URL compartible reproduce la búsqueda; 24 propiedades del seed en el mapa; `/impeccable adapt`; `/ponytail-review`.

## FASE 7 — Ficha + leads + páginas de contenido (`docs/design/shape/ficha.md`) 🧭 G3
- [ ] 7.1 Ficha ISR + revalidación on-demand · 7.2 Galería bento + lightbox Flip · 7.3 Identidad, pestañas, mini-mapa exacto/aproximado · 7.4 Variante condominio (unidades + avance).
- [ ] 7.5 Tarjeta sticky + formulario calificado (país, objetivo, residencia, franja) + Turnstile + consentimiento RGPD + WhatsApp + asesor.
- [ ] 7.6 Edge Function `submit-lead` (Turnstile, zod, rate-limit, `lead_events`, emails Resend en el idioma del cliente) **con tests** (Review Focus #4).
- [ ] 7.7 Calculadora (colapsada), similares, compartir, JSON-LD, OG · 7.8 `property_views` vía RPC · 7.9 `/contacto`.
- [ ] 7.10 **Nuevas:** `/invertir-en-paraguay`, `/residencia`, `/como-comprar` (datos de `investment_facts` con fuente/fecha y aviso legal) · `/privacidad` y banner de cookies RGPD.
- **Hecho:** Playwright del flujo de lead ES/EN; lead en BD + email recibido. `web-v1`.

## FASE 8 — Admin: login, auth y layout (`docs/design/shape/login.md`)
- [ ] 8.1 Supabase SSR + middleware + permisos por rol en servidor · 8.2 `/login`, recuperar contraseña, aceptar invitación · 8.3 Layout (sidebar, ⌘K, notificaciones Realtime) · 8.4 i18n del panel.
- **Hecho:** Playwright: login ok/ko, sin sesión → redirect, agent no entra a `/usuarios`.

## FASE 9 — Admin: propiedades y contenido
- [ ] 9.1 Tabla (TanStack) con completitud de idiomas · 9.2 Editor por secciones con pestañas dinámicas desde `locales` · 9.3 Borrador IA "desde español" (Edge Function `translate`, API de Claude por env) · 9.4 Fotos (drag & drop, WebP, portada, alt por idioma, imagen de hero) · 9.5 Bloqueo de publicación · 9.6 Revalidación de la web.
- [ ] 9.7 CRUD zonas, amenidades, testimonios · **9.8 Nuevos:** proyectos/unidades, `investment_facts`, tasa de cambio, marca `residency_eligible`.

## FASE 10 — Admin: CRM y dashboard (`docs/design/shape/dashboard.md`) 🧭 G4
- [ ] 10.1 Kanban + tabla de leads · 10.2 Ficha del lead · 10.3 CSV · 10.4 Badge en tiempo real.
- [ ] 10.5 Dashboard: bloque "Hoy" con SLA, KPIs con variación, leads/ventas por mes, embudo, **origen por país/fuente/idioma**, top propiedades, mapa de demanda, salud del inventario, asesores (≥2). Skill `dataviz`.
- **Hecho:** datos del seed correctos; `/impeccable critique` + `audit`. `admin-v1`.

## FASE 11 — Pulido: SEO, rendimiento, accesibilidad
- [ ] 11.1 `/impeccable audit` · 11.2 `harden` + pseudo-localización (Review Focus #1) · 11.3 `optimize` (LCP < 2.5s, CLS < 0.1, INP < 200ms) · 11.4 `clarify` ES/EN · 11.5 sitemap multilenguaje, robots, JSON-LD · 11.6 WCAG 2.2 AA · 11.7 `polish`.
- **Hecho:** informe Lighthouse antes/después (Home, Explorador, Ficha).

## FASE 12 — QA y seguridad
- [ ] 12.1 `/ponytail-audit` + `/ponytail-debt` (resolver o justificar cada `shortcut:`) · 12.2 Ataque a RLS como anon/agent (Review Focus #5), Edge Functions, secretos, CSP/HSTS, uploads · 12.3 Suite E2E completa · 12.4 Revisión independiente (requesting-code-review).

## FASE 13 — Deploy 🧭 G5
- [ ] 13.1 Supabase prod (sin seed de leads), auth, plantillas de email ES/EN · 13.2 Dos proyectos Vercel: `edennia.homes` y `admin.edennia.homes` · 13.3 `docs/ENV.md` · 13.4 Sentry, analítica (con consentimiento RGPD), webhook de revalidación · 13.5 Primer admin por invitación · 13.6 `docs/RUNBOOK.md`.
- `v1.0.0`
