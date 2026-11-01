# EDENNIA HOMES — Plan maestro para Claude Code

> Documento director del proyecto. Guárdalo en la raíz del repo como `docs/MASTERPLAN.md`.
> Todos los prompts de abajo lo referencian, así Claude Code siempre trabaja con el mismo contexto.

---

## 0. Cómo usar este documento

1. Crea la carpeta del proyecto y copia dentro:
   - `docs/MASTERPLAN.md` (este archivo)
   - `docs/references/` con tus imágenes renombradas:
     - `01-listado-mapa-humee.png` (imagen 1)
     - `02-detalle-propiedad.png` (imagen 2)
     - `03-listado-filtros-reall.png` (imagen 3)
     - `04-landing-hero-nuffo.png` (imagen 4)
     - `05-landing-estateedge.png` (imagen 5)
     - `06-dashboard.png` (imagen 6)
     - `07-login-realnest.png` (imagen 7)
   - `docs/brand/logo-color.png` y `docs/brand/logo-white.png`
2. Ejecuta las fases **en orden**. Cada fase = **una sesión nueva** de Claude Code (`/clear` entre fases).
3. Antes de cada fase, ajusta **modelo** (`/model`) y **esfuerzo** (`/effort`) según la tabla de la sección 6.
4. Al cerrar cada fase marcada con 🧭, haz el **checkpoint de Graphify** (sección 7).
5. Haz `git commit` + tag al final de cada fase (`git tag fase-03`). Es tu botón de "deshacer".

> **Nota sobre las referencias:** son diseños de Dribbble de otros autores. Úsalas como dirección (layout, ritmo, jerarquía), no como copia pixel a pixel: la identidad final debe ser de Edennia (verde, naturaleza, calma). Eso además da un resultado más memorable.

---

## 1. Visión del producto

**Edennia Homes** vende casas, apartamentos y condominios. El sitio tiene dos productos que comparten una sola base de datos Supabase:

| Producto | Público | Acceso | Objetivo |
|---|---|---|---|
| **Web pública** (`edennia.homes`) | Compradores | Libre, sin login | Inspirar → explorar → generar un **lead** de calidad |
| **Panel admin** (`admin.edennia.homes`) | Equipo interno | Login con roles | Publicar inventario bilingüe, gestionar leads, medir el negocio |

**Métrica norte:** leads calificados por semana (y tiempo de primera respuesta).

**Idiomas:** Español (principal) + Inglés (secundario). Arquitectura preparada para añadir más idiomas **sin tocar el esquema** (solo insertar una fila en `locales` + un archivo de mensajes).

---

## 2. Arquitectura (decisión senior)

### 2.1 Monorepo con dos apps, despliegues separados

Pediste el dashboard "en otro proyecto aparte compartiendo la misma base de datos". La mejor forma de lograrlo **sin duplicar tipos, esquema ni tokens de diseño** es un monorepo con dos apps que se despliegan como **dos proyectos independientes** (dos dominios, dos builds, cero código admin en el bundle público):

```
edennia/
├── apps/
│   ├── web/            # Next.js — sitio público (ES/EN), GSAP, mapas
│   └── admin/          # Next.js — dashboard, auth, CRUD, CRM
├── packages/
│   ├── db/             # Tipos generados de Supabase, queries compartidas, zod schemas
│   ├── ui/             # Design tokens (Tailwind theme), primitivas compartidas
│   ├── i18n/           # Config de locales, helpers de traducción y fallback
│   └── config/         # tsconfig, eslint, prettier compartidos
├── supabase/
│   ├── migrations/     # ÚNICA fuente de verdad del esquema
│   ├── functions/      # Edge Functions (submit-lead, notify, translate)
│   └── seed.sql
├── docs/               # MASTERPLAN, PRODUCT.md, DESIGN.md, specs, references/
└── CLAUDE.md
```

Herramientas: **pnpm workspaces + Turborepo**.
Alternativa si de verdad quieres 2 repos: el repo `admin` es dueño de `supabase/migrations` y publica los tipos como paquete; más fricción, no lo recomiendo.

### 2.2 Stack

| Capa | Elección | Por qué |
|---|---|---|
| Framework | Next.js (última estable, App Router, RSC) + TypeScript estricto | SEO, ISR para fichas, i18n por ruta |
| Estilos | Tailwind CSS v4 + tokens en `packages/ui` | Un solo sistema para ambas apps |
| Componentes admin | shadcn/ui + TanStack Table | Velocidad + calidad en tablas/formularios |
| Animación (web) | **GSAP** + ScrollTrigger + Flip + SplitText, **Lenis** (smooth scroll) | Hero tipo imagen 4, reveals, transiciones de galería |
| Mapas | **MapLibre GL** + MapTiler (o Mapbox si ya tienes cuenta) | Pines con precio, clusters, "buscar en esta zona" |
| i18n | **next-intl** con rutas `/es/...` y `/en/...` y slugs localizados | SEO multilenguaje correcto (hreflang) |
| Formularios | react-hook-form + zod (schemas en `packages/db`) | Validación idéntica cliente/servidor |
| Backend | Supabase: Postgres + **PostGIS**, Auth, Storage, RLS, Edge Functions | Una sola BD para ambos proyectos |
| Email | Resend (aviso al equipo + confirmación al cliente) | Respuesta inmediata al lead |
| Anti-spam | Cloudflare Turnstile en el formulario de contacto | Web sin login = imán de bots |
| Gráficos admin | Recharts (o Tremor) | Dashboard tipo imagen 6 |
| Observabilidad | Sentry + Vercel Analytics (+ PostHog opcional) | Errores y embudo de conversión |
| Tests | Vitest (lógica) + Playwright (E2E) | Flujo lead y login blindados |
| Deploy | Vercel (2 proyectos) + Supabase (proyectos `dev` y `prod`) | Previews por PR |

### 2.3 Modelo multilenguaje (clave para escalar idiomas)

**Nunca** columnas `title_es`, `title_en`. Usa tablas de traducción:

```
locales(code PK, name, native_name, is_default, enabled, sort_order)
properties(id, type, operation, status, price, currency, bedrooms, bathrooms,
           area_m2, lot_m2, parking, year_built, location geography(Point),
           zone_id, address_line, is_featured, published_at, ...)
property_translations(property_id, locale FK→locales, title, slug,
           short_description, description, seo_title, seo_description,
           UNIQUE(locale, slug), PK(property_id, locale))
```

- Añadir francés = `INSERT INTO locales ('fr', ...)` + `messages/fr.json`. Cero migraciones.
- **Fallback**: si falta la traducción, se muestra el idioma por defecto con un aviso discreto.
- **Regla de publicación**: una propiedad solo se publica si tiene traducción completa en todos los idiomas `enabled` marcados como obligatorios (validado en BD con función + en el admin con un indicador de completitud).
- **Idea pro**: botón "Generar borrador en inglés" en el admin (Edge Function que llama a la API de Claude) → el editor revisa y aprueba. Ahorra horas por publicación.

---

## 3. Sistema de diseño (derivado del logo)

El logo es verde brillante con relieve 3D. Para un sitio minimalista:
- **Vectoriza una versión plana** (SVG) del logo para header/footer/favicon. El 3D compite con la fotografía; resérvalo para la pantalla de login o el footer grande.
- El blanco del logo se usa sobre el hero (fotos oscuras/atardecer).

**Paleta propuesta** (que Claude ajuste con `/impeccable document`):

| Token | Uso | Valor inicial |
|---|---|---|
| `--forest-900` | Texto de marca, botones primarios | `#0F3D24` |
| `--forest-600` | Hover, acentos | `#1E7A3E` |
| `--leaf-400` | Detalles, pines de mapa, badges | `#5FBF4A` |
| `--sand-100` | Fondos cálidos (como la imagen 2) | `#F3EFE7` |
| `--paper` | Fondo base | `#FAFAF7` |
| `--ink` | Texto | `#121411` |
| `--stone-500` | Texto secundario | `#6B6F68` |

**Tipografía**: una display geométrica grande para el wordmark gigante del hero (estilo "nuffo" de la imagen 4, pero con **"Edennia"**), p. ej. *Clash Display* o *General Sans* (Fontshare, gratuitas) + una serif itálica de acento (*Instrument Serif*) para palabras clave como *hogar*. Evitar el combo genérico Inter-por-todas-partes.

**Principios**: mucho aire, fotografía protagonista, esquinas redondeadas generosas (16–24px), sombras casi invisibles, 1 acento de color por pantalla, movimiento lento y suave (ease `power3.out`, 0.8–1.2s), respetar `prefers-reduced-motion`.

---

## 4. Mapa del sitio y funcionalidades

### 4.1 Web pública

**`/[locale]` — Home (refs 4 + 5)**
1. **Hero**: wordmark gigante "Edennia" detrás de la casa (la casa recortada en PNG/WebP se superpone a las letras = efecto profundidad de la ref 4). Nav en píldoras, dirección y CTA arriba. GSAP: letras entran con SplitText, la casa hace parallax suave al scroll.
2. **Buscador flotante** bajo el hero: pestañas *Casas · Apartamentos · Condominios* + zona + presupuesto → lleva a `/propiedades` con filtros en la URL. *(Este es el "apartado debajo del hero" que pediste.)*
3. **Franja de confianza**: cifras (propiedades vendidas, años, zonas) con contadores animados.
4. **Quiénes somos** con carrusel lateral de imágenes difuminadas (ref 5).
5. **Propiedades destacadas** — carrusel tipo acordeón expandible (ref 5, "Featured Deals").
6. **Explora por zona/barrio**: tarjetas con foto y nº de propiedades.
7. **Por qué Edennia** (3 pilares con imágenes tipo ref 4).
8. **Testimonios reales** (desde la BD, nunca inventados).
9. **CTA final** + footer grande con logo, contacto, WhatsApp, redes, selector de idioma.

**`/[locale]/propiedades` — Explorador (refs 1 + 3)**
- Layout 3 columnas en desktop: **filtros** (ref 3) · **resultados** · **mapa** (refs 1/3). Botón para colapsar filtros.
- Filtros: tipo, operación (venta), rango de precio (slider + inputs), dormitorios/baños (+/-), m², zona, amenidades (piscina, quincho, seguridad 24h, mascotas, amoblado…), solo con tour virtual.
- **Todo el estado en la URL** (compartible y con SEO): `?tipo=casa&min=80000&dorm=3`.
- Sincronía **tarjeta ↔ pin**: hover en tarjeta resalta pin; click en pin muestra mini-card (ref 3).
- Pines con precio, clusters al alejar, botón **"Buscar en esta zona"** al mover el mapa (consulta por bounding box con PostGIS).
- Orden: relevancia, precio ↑↓, más recientes, m².
- Móvil: toggle Lista / Mapa con bottom sheet.
- Favoritos ♡ sin login (localStorage) + página `/favoritos` + **comparador** de hasta 3 propiedades.
- Estados vacíos útiles ("Amplía tu presupuesto" / "Quita el filtro X").

**`/[locale]/propiedades/[slug]` — Ficha (ref 2)**
- Galería bento (1 grande + 3) → lightbox a pantalla completa con transición GSAP Flip.
- Título, dirección, chips (tipo, estilo, amenidades), iconos de características (dorm., baños, m², cochera, año).
- Pestañas: **Descripción · Características · Tour virtual / Video · Ubicación** + plano si existe.
- Mini-mapa con zona aproximada (opción de ocultar dirección exacta).
- **Tarjeta lateral sticky** (reemplaza la pasarela de pago de la ref 2):
  - Precio + moneda (USD / PYG) + badge de estado (Disponible / Reservado / Vendido).
  - **Formulario "Me interesa esta propiedad"**: nombre*, email*, teléfono/WhatsApp*, ¿cómo prefieres que te contactemos? (WhatsApp / llamada / email), interés (visita presencial / videollamada / más info / financiación), fecha preferida (opcional), mensaje prellenado editable, consentimiento de privacidad*, Turnstile.
  - Botón secundario **"Escribir por WhatsApp"** con mensaje prellenado y referencia de la propiedad.
  - Tarjeta del asesor asignado (foto, nombre).
- **Calculadora de cuotas** (precio, entrada %, tasa, años) — muy valorado en inmobiliaria.
- Propiedades similares (mismo tipo/zona/rango).
- Compartir (copiar link, WhatsApp) + JSON-LD `RealEstateListing` para Google.

**Otras páginas**: `/nosotros`, `/contacto` (formulario general), `/favoritos`, `/comparar`, `/privacidad`, 404 bonita.

### 4.2 Panel admin

**`/login` (ref 7)** — split screen: foto arquitectónica a la izquierda con frase de marca y carrusel de 3 imágenes; formulario mínimo a la derecha (email + contraseña, "recordarme", olvidé mi contraseña). **Sin registro público** (los usuarios los invita un admin). Opcional: magic link y 2FA (TOTP de Supabase) para admins.

**Roles**: `admin` (todo), `agent` (sus propiedades y sus leads), `editor` (contenido y traducciones, sin leads).

**Módulos**:
1. **Dashboard** (ref 6, con datos que importan):
   - KPIs: leads nuevos (hoy / 7d / 30d con % vs período anterior), **tiempo medio de primera respuesta**, propiedades activas por tipo, reservadas, vendidas este mes, valor total del inventario, días promedio en el mercado.
   - Gráfico: leads e ingresos/ventas por mes; embudo **Lead → Contactado → Visita → Negociación → Cerrado**.
   - Top 5 propiedades más vistas y más consultadas (ratio vistas/leads = detecta precio mal puesto).
   - **Mapa de demanda** por zona (dónde piden más vs. dónde tienes inventario).
   - Leads por fuente (ficha, WhatsApp, contacto general) y por idioma.
   - **Salud del inventario**: propiedades sin traducción completa, con pocas fotos, sin coordenadas, sin actualizar en 60 días.
   - Ranking de asesores (leads atendidos, cierres).
   - Saludo + accesos rápidos ("Nueva propiedad", "Leads sin responder: 4").
2. **Propiedades**: tabla con filtros, estado, completitud de idiomas; editor con **pestañas por idioma**, subida múltiple de fotos con drag & drop para ordenar y elegir portada, compresión a WebP, selector de ubicación en mapa, borrador/publicado/archivado, duplicar propiedad, vista previa.
3. **Leads (CRM)**: vista Kanban por etapa + vista tabla, ficha del lead con historial (notas, llamadas, cambios de etapa), asignación a asesor, recordatorios, botón de WhatsApp directo, exportar CSV.
4. **Zonas, amenidades y testimonios** (catálogos traducibles).
5. **Idiomas**: activar/desactivar locales, ver % de traducción por idioma.
6. **Usuarios y roles** (invitar, desactivar).
7. **Auditoría**: quién cambió qué y cuándo.
8. **Ajustes**: datos de contacto, WhatsApp, redes, emails que reciben leads.

---

## 5. Base de datos Supabase (esquema base)

Tablas principales: `locales`, `profiles` (rol), `zones` + `zone_translations`, `amenities` + `amenity_translations`, `properties`, `property_translations`, `property_media` (orden, portada, alt por idioma), `property_amenities`, `leads`, `lead_events` (historial), `property_views` (analítica), `testimonials` + traducciones, `site_settings`, `audit_log`.

Reglas no negociables:
- **RLS activado en todas las tablas.**
- `anon`: SELECT solo de propiedades `published` y sus traducciones/medios; **nunca** lee leads.
- Los leads entran por **Edge Function `submit-lead`** (verifica Turnstile, valida con zod, rate-limit por IP, inserta con service role, dispara emails). Sin INSERT directo de `anon` sobre `leads`.
- Vistas por agente: `agent` solo ve leads asignados (`assigned_to = auth.uid()`).
- Rol en `profiles` + **custom access token hook** para tenerlo en el JWT.
- Búsqueda geográfica con RPC `search_properties(bbox, filtros, locale)` usando índices GIST.
- Métricas del dashboard con **vistas/funciones SQL** (no calcular en el cliente).
- Storage: bucket `property-media` lectura pública, escritura solo autenticados con rol.
- Trigger de `audit_log` y de `updated_at`.
- Dos proyectos Supabase: `edennia-dev` y `edennia-prod`. Migraciones versionadas en `supabase/migrations`.

---

## 6. Qué modelo y qué esfuerzo usar (y cuándo cambiar)

**Regla general:** *Opus piensa, Sonnet construye, Haiku hace lo mecánico.*

| Tipo de trabajo | Modelo | Esfuerzo |
|---|---|---|
| Arquitectura, spec, plan, esquema de BD, RLS, auth, seguridad | **Opus 5.5** | `high` → `xhigh` en BD/seguridad |
| Dirección de arte del hero y de pantallas clave | **Opus 5.5** | `high` |
| Implementar componentes, páginas, CRUD, formularios | **Sonnet 5.5** | `medium` (sube a `high` en mapa/filtros) |
| Bugs difíciles (estado del mapa, hidratación, RLS que bloquea) | **Opus 5.5** | `high` |
| Strings de UI, traducciones de seed, renombrados, docs | **Haiku 5.5** | `low` |
| Revisión final de seguridad pre-lanzamiento | **Opus 5.5** (o Fable 5.1 si tu plan lo incluye) | `max` |

**Cuándo cambiar a mitad de fase:**
- Sonnet falla 2 veces en el mismo problema → `/model opus` + `high`, resuelve, vuelve a Sonnet.
- Vas a tocar `supabase/migrations` o políticas RLS → siempre Opus.
- La tarea es "repetir el patrón X en 10 archivos" → baja a Sonnet `low` o Haiku.
- No uses `max` por defecto: es lento y caro; resérvalo para auditorías.

Usa **Plan Mode** (Shift+Tab) en todas las fases marcadas con Opus: primero plan, lo apruebas, luego ejecuta.

---

## 7. Skills: cuál, cuándo y checkpoints de Graphify

### 7.1 Tus skills instaladas

| Skill | Rol en este proyecto | Momentos de uso |
|---|---|---|
| **Superpowers** | Metodología: brainstorming → plan → ejecución con subagentes → TDD → verificación | Inicio de cada fase grande (brainstorming/writing-plans), ejecución (subagent-driven-development), bugs (systematic-debugging), cierre (verification-before-completion, requesting-code-review) |
| **Claude-Mem** | Memoria entre sesiones | Automático. Al iniciar cada fase: "consulta la memoria del proyecto sobre decisiones previas" |
| **Impeccable** | Calidad de diseño | `/impeccable init` y `document` (fase 1), `shape` antes de cada pantalla, `critique` + `audit` al terminar cada pantalla, `animate`/`overdrive` en el hero, `polish` + `harden` + `adapt` + `optimize` en la fase final |
| **Ponytail** | Evitar sobreingeniería, código mínimo y sólido | `/ponytail full` en fases de backend/CRUD, `/ponytail lite` en fases de diseño (para que no recorte el pulido visual), `/ponytail-review` al cerrar cada fase, `/ponytail-audit` antes del lanzamiento, `/ponytail-debt` para ver atajos pendientes |
| **Find Skills** | Descubrir e instalar skills que faltan | Fase 0 y cada vez que aparezca una tecnología nueva |
| **Graphify** | Mapa de conocimiento del repo (menos tokens, mejor contexto) | Checkpoints 🧭 (abajo) |

### 7.2 Skills a autodescubrir (Fase 0)

Verificadas como oficiales:
- **GSAP oficial**: `npx skills add https://github.com/greensock/gsap-skills` (core, timeline, ScrollTrigger, plugins, React, performance).
- **Supabase oficial**: `npx skills add supabase/agent-skills` (Postgres best practices: esquema, índices, RLS).

A buscar con Find Skills (Claude elige la mejor por estrellas/mantenimiento): Next.js App Router, React best practices, Tailwind v4, shadcn/ui, next-intl / i18n, MapLibre/Mapbox, Playwright E2E, SEO técnico, accesibilidad WCAG, dataviz/dashboards, seguridad web.

### 7.3 Checkpoints de Graphify 🧭

Instalación única (fase 0): `pip install graphifyy && graphify install`, y tras el primer build `graphify claude install` (hace que Claude consulte el grafo antes de buscar en archivos).

| Checkpoint | Cuándo | Por qué |
|---|---|---|
| 🧭 **G0** | Fin de Fase 1 (solo `docs/`) | Graphify procesa también imágenes: indexa referencias, PRODUCT.md, DESIGN.md y spec |
| 🧭 **G1** | Fin de Fase 2 (monorepo + tokens) | Fija la estructura base |
| 🧭 **G2** | Fin de Fase 3 (Supabase) | **El más importante**: esquema, RLS y tipos quedan mapeados para ambas apps |
| 🧭 **G3** | Fin de Fase 7 (web pública completa) | Antes de empezar el admin, que reutiliza `packages/` |
| 🧭 **G4** | Fin de Fase 10 (admin completo) | Antes de QA |
| 🧭 **G5** | Antes del deploy | Grafo final = documentación viva del proyecto |

Comando en cada checkpoint: `/graphify .` y después pedir: *"Lee graphify-out/GRAPH_REPORT.md y dime si hay acoplamientos raros, duplicación entre apps o archivos huérfanos."*

---

## 8. Prompts fase por fase

> Formato de cada fase: **Modelo · Esfuerzo · Skills** → prompt para copiar → **Hecho cuando**.
> Empieza cada fase con `/clear`.

---

### FASE 0 — Setup y autodescubrimiento de skills
**Opus 5.5 · high · Find Skills, Superpowers**

```
Eres el tech lead de "Edennia Homes". Lee docs/MASTERPLAN.md completo antes de hacer nada.

Objetivo de esta sesión: preparar el entorno, NO escribir código de producto.

1. Verifica qué skills/plugins tengo instalados (Superpowers, Claude-Mem, Impeccable, Ponytail, Find Skills, Graphify) y reporta si alguno falla.
2. Instala las skills oficiales:
   - npx skills add https://github.com/greensock/gsap-skills
   - npx skills add supabase/agent-skills
3. Usa Find Skills para buscar las mejores skills para: Next.js App Router, React best practices, Tailwind CSS v4, shadcn/ui, next-intl/i18n, MapLibre GL, Playwright, SEO técnico, accesibilidad WCAG, dashboards/dataviz, seguridad web.
   Para cada categoría muéstrame 1–2 candidatas con: repo, estrellas, fecha del último commit y qué aporta. Prioriza oficiales del fabricante. Descarta las abandonadas o con scripts sospechosos (lee su SKILL.md antes de proponerlas).
   Espera mi aprobación antes de instalar.
4. Instala Graphify (pip install graphifyy && graphify install) si no está.
5. Crea CLAUDE.md en la raíz con el contenido de la sección 9 del MASTERPLAN.
6. Inicializa git, .gitignore (node, next, supabase, graphify-out/cache), y haz el primer commit.

Al final, entrégame una tabla: skill → instalada sí/no → en qué fase se usará.
```
**Hecho cuando:** skills instaladas, CLAUDE.md creado, primer commit.

---

### FASE 1 — Descubrimiento, producto y dirección de diseño 🧭 G0
**Opus 5.5 · high · Superpowers (brainstorming, writing-plans), Impeccable (init, document, shape)**

```
Lee docs/MASTERPLAN.md y mira TODAS las imágenes de docs/references/ y docs/brand/.

Usa la skill de brainstorming de Superpowers para cuestionar y completar el plan conmigo. Hazme como máximo 8 preguntas, agrupadas, sobre lo que el MASTERPLAN no resuelve (por ejemplo: moneda principal, si se muestra la dirección exacta, número de asesores, zonas iniciales, si habrá alquileres a futuro).

Con mis respuestas:
1. Ejecuta /impeccable init para generar docs/PRODUCT.md (audiencia, tono de voz bilingüe, objetivos, métricas).
2. Analiza cada imagen de referencia y escribe docs/design/reference-analysis.md: para cada una, qué tomamos (layout, ritmo, jerarquía, interacción) y qué NO tomamos. La identidad visual debe ser propia de Edennia (verde del logo, naturaleza, calma), no un clon.
3. Ejecuta /impeccable document para crear docs/DESIGN.md con: paleta (parte de la sección 3 del MASTERPLAN y valida contraste AA), tipografías (propón 2 pares y justifica), escala tipográfica fluida, espaciado, radios, sombras, iconografía (Lucide o Phosphor), principios de movimiento GSAP (duraciones, easings, reduced-motion) y uso del logo (versión plana SVG vs 3D).
4. Ejecuta /impeccable shape para Home, Explorador, Ficha, Login y Dashboard: un wireframe textual por pantalla con secciones, estados (carga, vacío, error) y comportamiento móvil.
5. Usa writing-plans de Superpowers para generar docs/plan/implementation-plan.md alineado con las fases 2–13 del MASTERPLAN, con tareas pequeñas y verificables.

No escribas código de la aplicación en esta fase.
```
**Hecho cuando:** existen PRODUCT.md, DESIGN.md, reference-analysis.md, plan. → `/graphify ./docs` (G0) → commit.

---

### FASE 2 — Monorepo, tokens y librería base 🧭 G1
**Sonnet 5.5 · medium · Ponytail (full), Superpowers (executing-plans), skills de Next.js/Tailwind**

```
Lee CLAUDE.md, docs/MASTERPLAN.md (sección 2) y docs/DESIGN.md. Consulta la memoria del proyecto.

/ponytail full

Crea el monorepo:
- pnpm workspaces + Turborepo.
- apps/web y apps/admin: Next.js (última estable, App Router, TypeScript strict, src/).
- packages/config (tsconfig, eslint, prettier), packages/ui (tema Tailwind v4 con los tokens de DESIGN.md como CSS variables + primitivas: Button, Input, Badge, Card, Chip, Container), packages/i18n (lista de locales, helper getTranslation con fallback), packages/db (vacío por ahora, se llena en fase 3).
- Fuentes self-hosted con next/font.
- Logo: genera a partir de docs/brand una versión SVG plana monocroma (verde y blanco). Si no puedes vectorizar con calidad, deja un placeholder SVG y anótalo en /ponytail-debt.
- Página /styleguide en apps/web que muestre tokens y primitivas (solo en desarrollo).
- Scripts: dev, build, lint, typecheck a nivel raíz.

Verifica que `pnpm build` y `pnpm typecheck` pasan en ambas apps. Luego /ponytail-review.
```
**Hecho cuando:** ambas apps arrancan, styleguide visible. → `/graphify .` (G1) → commit + tag.

---

### FASE 3 — Supabase: esquema, i18n, RLS, storage 🧭 G2
**Opus 5.5 · xhigh · Supabase postgres best practices, Superpowers (TDD), Plan Mode**

```
Lee CLAUDE.md, MASTERPLAN secciones 2.3 y 5, y PRODUCT.md. Consulta la memoria del proyecto.
Activa Plan Mode: primero preséntame el plan del esquema completo (tablas, columnas, tipos, índices, políticas RLS, funciones y triggers) y espera mi aprobación.

Después de aprobado:
1. Configura Supabase CLI local (supabase init / start). Crea migraciones versionadas en supabase/migrations.
2. Implementa el modelo multilenguaje con tablas de traducción (locales, *_translations). Añadir un idioma nuevo NO debe requerir migración.
3. Activa PostGIS. Columna location geography(Point,4326) + índice GIST. RPC search_properties(bbox, filtros, locale, orden, paginación) que devuelva datos ya traducidos con fallback al idioma por defecto.
4. Roles admin/agent/editor en profiles + custom access token hook para meter el rol en el JWT.
5. RLS en TODAS las tablas según la sección 5 del MASTERPLAN. anon nunca puede leer leads.
6. Función de validación: no se puede publicar una propiedad sin traducciones completas en los locales obligatorios.
7. Vistas/funciones SQL para las métricas del dashboard (sección 4.2).
8. Triggers: updated_at, audit_log, registro de cambios de etapa en lead_events.
9. Storage bucket property-media con políticas.
10. seed.sql: locales es/en, 6 zonas, 15 amenidades, 24 propiedades realistas (casas, apartamentos, condominios) con traducciones ES/EN, coordenadas reales de la ciudad que te indique, y 40 leads de ejemplo en distintas etapas.
11. Genera tipos TypeScript en packages/db y crea los zod schemas compartidos (property, lead, filtros).
12. Escribe tests de RLS con pgTAP o scripts SQL: anon no lee leads, agent solo ve sus leads, editor no ve leads, anon solo ve publicadas.

Aplica las buenas prácticas de la skill de Supabase (índices en FKs, sin N+1, políticas eficientes con (select auth.uid())).
Al terminar ejecuta los tests y muéstrame el resultado.
```
**Hecho cuando:** `supabase db reset` aplica limpio, tests RLS en verde, tipos generados. → `/graphify .` (G2) → commit + tag.

---

### FASE 4 — Web pública: layout, i18n y navegación
**Sonnet 5.5 · medium · Impeccable, skill de next-intl/i18n, Ponytail (lite)**

```
Lee CLAUDE.md, DESIGN.md, PRODUCT.md. Consulta la memoria.
/ponytail lite

En apps/web:
1. next-intl con rutas /es y /en, español por defecto, detección del idioma del navegador en la primera visita, slugs localizados para propiedades, hreflang y canonical en todas las páginas.
2. messages/es.json y messages/en.json con TODOS los textos de UI (nada hardcodeado). Estructura preparada para más idiomas leyendo la lista desde packages/i18n.
3. Header: logo, navegación en píldoras (estilo ref 4), selector de idioma que conserva la página actual (incluido el slug traducido), botón WhatsApp/contacto. Se vuelve compacto y con fondo al hacer scroll.
4. Footer grande con logo, contacto, redes, zonas, idioma.
5. Lenis para smooth scroll integrado con GSAP ScrollTrigger (usa la skill de GSAP; cleanup correcto con useGSAP).
6. Página 404 y loading states con el estilo de marca.

Luego /impeccable critique sobre header y footer y corrige lo que salga con prioridad alta.
```
**Hecho cuando:** cambiar de idioma funciona en todas las rutas, sin textos sueltos.

---

### FASE 5 — Home / Landing (refs 4 y 5)
**Opus 5.5 · high para el hero → Sonnet 5.5 · medium para el resto · GSAP skills, Impeccable (shape, animate, overdrive, critique)**

```
Lee DESIGN.md, reference-analysis.md y mira docs/references/04-*.png y 05-*.png. Consulta la memoria.

Construye la Home según MASTERPLAN 4.1 en este orden. Después de CADA sección haz una captura con Playwright en 1440px y 390px y revísala tú mismo antes de seguir.

1. HERO (lo más importante del sitio):
   - Wordmark gigante "Edennia" ocupando el ancho, con la foto de la casa recortada SUPERPUESTA a las letras (efecto profundidad de la ref 4). Usa capas: fondo cielo → letras → casa recortada → UI.
   - Nav en píldoras, microcopys a los lados (tipo "Excelencia // Vida moderna //"), dirección y CTA.
   - GSAP: entrada de letras con SplitText (stagger), la casa sube con fade, parallax suave de capas con ScrollTrigger. Respeta prefers-reduced-motion.
   - Imágenes de placeholder de Unsplash con licencia libre; deja la estructura lista para cambiarlas por fotos propias.
2. BUSCADOR bajo el hero: pestañas Casas / Apartamentos / Condominios + zona + presupuesto + botón "Explorar" → navega a /propiedades con los filtros en la URL. Debe sentirse como la puerta de entrada al explorador.
3. Franja de confianza con contadores animados.
4. "Quiénes somos" con carrusel de bordes difuminados (ref 5).
5. Destacadas: carrusel acordeón (una tarjeta expandida + las demás estrechas, ref 5), datos reales desde Supabase (is_featured).
6. Explora por zona, Por qué Edennia, Testimonios (desde BD), CTA final.

Para el hero usa /impeccable animate y considera /impeccable overdrive solo si no compromete el rendimiento (LCP < 2.5s en móvil).
Al final: /impeccable critique de la Home completa y aplica las correcciones de prioridad alta.
```
> Cambia a **Sonnet** después de aprobar el hero (sección 1).

**Hecho cuando:** Home completa en ES/EN, Lighthouse móvil ≥ 90 en performance.

---

### FASE 6 — Explorador de propiedades con mapa (refs 1 y 3)
**Opus 5.5 · high (estado y arquitectura) → Sonnet 5.5 · high (UI) · Skill de MapLibre, Impeccable, Superpowers (TDD para filtros)**

```
Lee MASTERPLAN 4.1 (/propiedades), DESIGN.md y mira refs 01 y 03. Consulta la memoria.
Plan Mode primero: propón la arquitectura de estado (URL como fuente de verdad, sincronización lista↔mapa, fetching con la RPC search_properties, cache) y espera aprobación.

Implementa:
1. Layout desktop: filtros (colapsables) | resultados | mapa. Tablet: filtros en drawer. Móvil: toggle Lista/Mapa con bottom sheet.
2. Filtros de la ref 3 adaptados: tipo (tarjetas con icono), rango de precio (slider + inputs), dormitorios/baños (+/-), m², zona, amenidades, solo con tour virtual. Contador de resultados y "Limpiar filtros".
3. Estado 100% en la URL (searchParams), parseado y validado con el zod schema de packages/db. Tests unitarios del parser.
4. Tarjetas de resultado (refs 1/3): foto con carrusel mini, badge de tipo, precio, dirección, dorm/baños/m², corazón de favoritos (localStorage).
5. Mapa MapLibre: pines con precio, clusters, hover tarjeta ↔ pin resaltado, click en pin → mini-card (ref 3), botón "Buscar en esta zona" al mover el mapa (consulta por bbox).
6. Orden, paginación o infinite scroll, skeletons de carga, estados vacíos con sugerencias.
7. /favoritos y /comparar (hasta 3 propiedades lado a lado).

Al terminar: /impeccable critique + /impeccable adapt (responsive) y /ponytail-review.
```
**Hecho cuando:** filtros compartibles por URL, mapa fluido con las 24 propiedades del seed, móvil usable.

---

### FASE 7 — Ficha de propiedad + formulario de lead (ref 2) 🧭 G3
**Sonnet 5.5 · high · GSAP (Flip), Impeccable · Opus 5.5 · high para la Edge Function y su seguridad**

```
Lee MASTERPLAN 4.1 (ficha) y 5, DESIGN.md, mira ref 02. Consulta la memoria.

1. Ficha /[locale]/propiedades/[slug] con ISR y revalidación on-demand (webhook desde Supabase al publicar/editar).
2. Galería bento (1 grande + 3, "+N fotos") → lightbox fullscreen con transición GSAP Flip, swipe en móvil, teclado.
3. Título, dirección, chips, iconos de características, pestañas Descripción / Características / Tour virtual-Video / Ubicación, mini-mapa con opción de ubicación aproximada.
4. Tarjeta lateral sticky que REEMPLAZA la pasarela de pago de la ref 2: precio + moneda + estado, formulario "Me interesa esta propiedad" con los campos de MASTERPLAN 4.1, Turnstile, consentimiento, estados de envío/éxito/error elegantes; botón WhatsApp con mensaje prellenado que incluya el código de la propiedad; tarjeta del asesor.
5. Edge Function supabase/functions/submit-lead: verifica Turnstile, valida con zod, rate-limit por IP/email, guarda lead con locale y fuente, registra lead_event, envía email al equipo (Resend) y confirmación al cliente EN SU IDIOMA.
6. Calculadora de cuotas, propiedades similares, compartir, JSON-LD RealEstateListing, Open Graph con la foto de portada.
7. Registro de vista en property_views (vía RPC, sin datos personales).
8. /contacto con el mismo sistema de leads (fuente = "general").

Tests: Playwright del flujo completo de lead en ES y EN; test de que la función rechaza envíos sin Turnstile y con datos inválidos.
Cierra con /impeccable critique y verification-before-completion de Superpowers.
```
**Hecho cuando:** un lead enviado aparece en la BD y llega el email. → `/graphify .` (G3) → commit + tag `web-v1`.

---

### FASE 8 — Admin: login, auth y layout
**Opus 5.5 · high · Supabase skills, Impeccable (shape, critique)**

```
Lee MASTERPLAN 4.2, DESIGN.md y mira refs 06 y 07. Consulta la memoria.
Plan Mode: propón el flujo de auth (Supabase SSR con cookies, middleware de protección de rutas, roles desde el JWT, invitaciones) y espera aprobación.

En apps/admin:
1. /login estilo ref 7: split screen, foto arquitectónica + frase de marca + indicador de carrusel a la izquierda; formulario minimalista a la derecha (email, contraseña con mostrar/ocultar, recordarme, ¿olvidaste tu contraseña?). SIN registro público. Mensajes de error claros sin revelar si el email existe.
2. Recuperar contraseña y aceptar invitación (crear contraseña).
3. Middleware: todo /(dashboard) exige sesión; permisos por rol (admin/agent/editor) en servidor, no solo ocultando botones.
4. Layout del dashboard estilo ref 6: sidebar con avatar y saludo, navegación con iconos, colapsable; topbar con búsqueda global (cmd+K) y notificaciones de leads nuevos (Supabase Realtime).
5. Idioma del panel: español por defecto, inglés disponible (mismo packages/i18n).
6. Opcional si me lo confirmas: 2FA TOTP para el rol admin.

Tests Playwright: login correcto, incorrecto, acceso sin sesión redirige, agent no entra a /usuarios.
```
**Hecho cuando:** login funcional con los 3 roles del seed.

---

### FASE 9 — Admin: propiedades con editor multilenguaje
**Sonnet 5.5 · high · shadcn/ui skill, Ponytail (full)**

```
Lee MASTERPLAN 2.3 y 4.2. Consulta la memoria. /ponytail full

1. Tabla de propiedades (TanStack Table): búsqueda, filtros por tipo/estado/zona/asesor, columnas de completitud de idiomas (chips ES ✓ EN ✗), acciones (editar, duplicar, archivar, ver en web).
2. Editor por pasos o secciones: Datos generales → Ubicación (selector en mapa + dirección) → Características y amenidades → Contenido por idioma (PESTAÑAS dinámicas generadas desde la tabla locales, no hardcodeadas) → Fotos → SEO → Publicación.
3. Contenido por idioma: título, slug autogenerado y editable, descripción con editor de texto simple, SEO. Indicador de completitud por pestaña. Botón "Generar borrador desde español" (Edge Function translate que llama a la API de Claude; el resultado queda como borrador para revisión humana). Pide la API key por variable de entorno.
4. Fotos: subida múltiple drag & drop, compresión a WebP en el cliente, reordenar arrastrando, elegir portada, alt text por idioma.
5. Bloquear "Publicar" si faltan traducciones obligatorias (mensaje claro de qué falta).
6. Al publicar/editar → revalidar la ficha en apps/web.
7. CRUD simple de zonas, amenidades y testimonios (también traducibles).

/ponytail-review al terminar.
```

---

### FASE 10 — Admin: CRM de leads y dashboard de métricas 🧭 G4
**Sonnet 5.5 · high · skill de dataviz, Impeccable · Opus 5.5 si las queries de métricas se complican**

```
Lee MASTERPLAN 4.2 (Dashboard y Leads). Consulta la memoria.

LEADS:
1. Vista Kanban por etapa (Nuevo → Contactado → Visita agendada → Negociación → Cerrado ganado / Perdido) con drag & drop; vista tabla alternativa.
2. Ficha del lead: datos, propiedad de interés, idioma, fuente, historial (lead_events), notas, asignación a asesor, recordatorio, botón WhatsApp y email directos.
3. Agent solo ve los suyos (ya lo garantiza RLS; verifica).
4. Exportar CSV. Badge en tiempo real de leads sin responder.

DASHBOARD (ref 6, pero con los datos de MASTERPLAN 4.2):
- KPIs con variación vs período anterior, selector de rango (7d/30d/90d/año).
- Gráfico de leads y ventas por mes, embudo de conversión, top propiedades por vistas y por leads (con ratio), mapa de demanda por zona, leads por fuente e idioma, salud del inventario, ranking de asesores, accesos rápidos.
- Todo calculado con las vistas/funciones SQL de la fase 3, no en el cliente.
- Estados vacíos y skeletons. Que se entienda en 5 segundos qué hacer hoy.

Cierra con /impeccable critique y /impeccable audit.
```
**Hecho cuando:** el dashboard muestra los datos del seed correctamente. → `/graphify .` (G4) → commit + tag `admin-v1`.

---

### FASE 11 — Pulido final: SEO, rendimiento, accesibilidad
**Sonnet 5.5 · medium · Impeccable (polish, harden, adapt, optimize, clarify), skills de SEO y a11y**

```
Consulta la memoria. Recorre ambas apps:
1. /impeccable audit en todas las pantallas → corrige crítico y alto.
2. /impeccable harden: textos largos en inglés/español que rompen layouts, overflow, errores de red, idiomas futuros con textos más largos (prueba con pseudo-localización).
3. /impeccable optimize: imágenes (next/image, AVIF/WebP, tamaños), lazy de GSAP y del mapa, fuentes, bundle. Objetivo móvil: LCP < 2.5s, CLS < 0.1, INP < 200ms.
4. /impeccable clarify: revisa los microcopys ES y EN con el tono de PRODUCT.md.
5. SEO: sitemap.xml multilenguaje, robots.txt, hreflang, metadatos por página, JSON-LD (Organization, RealEstateListing, BreadcrumbList), OG images.
6. Accesibilidad WCAG 2.2 AA: foco visible, navegación por teclado en mapa/galería/kanban, contraste, labels, reduced-motion.
7. /impeccable polish como pasada final.
Entrégame un informe antes/después con Lighthouse de Home, Explorador y Ficha.
```

---

### FASE 12 — QA y auditoría de seguridad
**Opus 5.5 · max · Superpowers (systematic-debugging, requesting-code-review), Ponytail (audit)**

```
Actúa como auditor senior de seguridad y QA. Consulta la memoria y el grafo (GRAPH_REPORT.md).

1. /ponytail-audit de todo el repo y /ponytail-debt: resuelve o justifica cada atajo pendiente.
2. Revisa: políticas RLS una por una (intenta romperlas como anon y como agent), Edge Functions (validación, rate-limit, secretos), exposición de service_role key (debe estar SOLO en Edge Functions), headers de seguridad (CSP, HSTS), CORS, inyección en búsquedas, subida de archivos (tipo/tamaño).
3. Suite E2E Playwright completa: explorar → filtrar → ficha → enviar lead (ES y EN); admin: login → crear propiedad bilingüe → publicar → aparece en la web → lead llega al Kanban.
4. Usa requesting-code-review de Superpowers con un subagente que NO haya visto el código, para una revisión independiente.
Entrégame una lista priorizada de hallazgos y corrige los críticos y altos.
```

---

### FASE 13 — Deploy 🧭 G5
**Sonnet 5.5 · medium**

```
1. Crea el proyecto Supabase de producción, aplica migraciones (sin seed de leads de prueba), configura auth (URLs de redirección, plantillas de email en ES/EN con la marca), storage y secrets de las Edge Functions.
2. Dos proyectos en Vercel desde el monorepo: apps/web → edenniahomes.com, apps/admin → admin.edenniahomes.com (con turbo-ignore para no rebuildear lo que no cambió).
3. Variables de entorno por entorno (preview/production) documentadas en docs/ENV.md.
4. Sentry y analítica. Webhook de revalidación configurado.
5. Crea el primer usuario admin por invitación.
6. docs/RUNBOOK.md: cómo añadir un idioma, cómo restaurar un backup, cómo invitar un usuario, cómo rotar claves.
Checklist de lanzamiento verificado punto por punto.
```
→ `/graphify .` (G5) → tag `v1.0.0` 🎉

---

## 9. CLAUDE.md (pégalo en la raíz del repo)

```markdown
# Edennia Homes — Reglas del proyecto

## Contexto
- Plan maestro: docs/MASTERPLAN.md · Producto: docs/PRODUCT.md · Diseño: docs/DESIGN.md
- Si existe graphify-out/GRAPH_REPORT.md, léelo antes de explorar archivos.
- Consulta la memoria del proyecto (Claude-Mem) al empezar cada sesión.

## Arquitectura
- Monorepo pnpm + Turborepo: apps/web (pública), apps/admin (panel), packages/{db,ui,i18n,config}.
- supabase/migrations es la ÚNICA fuente de verdad del esquema. Nunca cambies la BD desde el dashboard de Supabase.
- Tipos de BD solo desde packages/db (generados). Schemas zod compartidos ahí.

## Reglas no negociables
- RLS en todas las tablas. La service_role key solo existe en Edge Functions.
- Cero textos hardcodeados en UI: todo en messages/{locale}.json.
- Contenido traducible siempre en tablas *_translations. Nunca columnas por idioma.
- Los idiomas se leen de la tabla `locales`; nunca asumas solo es/en.
- Tokens de diseño solo desde packages/ui. No inventes colores ni tamaños sueltos.
- Animaciones GSAP con useGSAP y cleanup; siempre respetar prefers-reduced-motion.
- Imágenes con next/image. Nada de layout shift.

## Flujo de trabajo
- Tareas grandes: brainstorming → plan → ejecución (Superpowers). Plan Mode para BD, auth y seguridad.
- Antes de decir "terminado": build + typecheck + lint + tests en verde, y captura de pantalla revisada para cambios de UI (1440px y 390px).
- Commits pequeños con Conventional Commits.
- Si algo falla 2 veces seguidas, para, aplica systematic-debugging y explícame la causa raíz.
```

---

## 10. Ideas extra recomendadas (para inspirarte)

**Conversión y experiencia**
- **Botón flotante de WhatsApp** con mensaje contextual según la página (en Paraguay/LatAm es el canal #1).
- **"Agendar visita"** con selector de franja horaria dentro del formulario de lead.
- **Alertas de búsqueda sin login**: "Avísame cuando haya algo así" (solo email + filtros guardados; double opt-in).
- **Comparador** de hasta 3 propiedades y **favoritos** sin cuenta.
- **Calculadora de cuotas/financiación** en cada ficha.
- **Tour virtual** (embed de Matterport/Kuula) y video por propiedad.
- **Badges** automáticos: "Nuevo", "Precio rebajado", "Últimas unidades" (condominios).
- **Condominios como proyectos**: página de proyecto con sus unidades disponibles (tipología, piso, estado), avance de obra y fecha de entrega.
- **Página por zona/barrio** (SEO local): descripción, colegios, comercios cercanos, propiedades disponibles.
- **Moneda doble**: precio en USD con conversión aproximada a PYG (tasa editable en ajustes).

**Admin y negocio**
- **Asignación automática de leads** por zona o en rotación entre asesores.
- **SLA de respuesta**: alerta si un lead lleva >2 h sin contactar.
- **Plantillas de respuesta** de WhatsApp/email en ES y EN.
- **Traducción asistida por IA** con revisión humana (ya incluida en la fase 9).
- **Ficha PDF** descargable/compartible de cada propiedad para enviar a clientes.
- **Informe semanal automático** por email al dueño con los KPIs.

**Técnico**
- **Entornos dev/prod** separados en Supabase y previews por PR en Vercel.
- **Backups** diarios (Supabase PITR en plan pago) y runbook de restauración.
- **Feature flags** simples en `site_settings` para lanzar secciones sin redeploy.

---

## 11. Riesgos y cómo evitarlos

| Riesgo | Mitigación |
|---|---|
| Hero espectacular pero lento | Presupuesto de rendimiento en fase 5; GSAP carga diferida; imagen del hero optimizada y con `priority` |
| Fotos de stock = sitio genérico | Planifica una sesión de fotos real; el hero necesita una casa recortada en PNG de alta calidad |
| Traducciones incompletas en producción | Bloqueo de publicación en BD + indicador en admin |
| Spam en formularios | Turnstile + rate-limit + validación en Edge Function |
| Fuga de datos de leads | RLS testeado en la fase 3 y atacado en la fase 12 |
| Contexto perdido entre sesiones | CLAUDE.md + Claude-Mem + checkpoints Graphify + una fase por sesión |
| Sobreingeniería | Ponytail en full para backend, revisión al cerrar cada fase |

---

### Orden resumido

```
F0 Setup ─ F1 Diseño 🧭G0 ─ F2 Monorepo 🧭G1 ─ F3 Supabase 🧭G2
   ─ F4 Layout web ─ F5 Home ─ F6 Explorador ─ F7 Ficha+Leads 🧭G3
   ─ F8 Login admin ─ F9 Propiedades ─ F10 CRM+Dashboard 🧭G4
   ─ F11 Pulido ─ F12 QA/Seguridad ─ F13 Deploy 🧭G5
```
