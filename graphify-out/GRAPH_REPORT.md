# Graph Report - edennia.homes  (2026-11-02)

## Corpus Check
- Corpus is ~38,483 words - fits in a single context window. You may not need a graph.

## Summary
- 822 nodes · 1201 edges · 57 communities (44 shown, 13 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 110 edges (avg confidence: 0.84)
- Token cost: 52,324 input · 0 output

## Community Hubs (Navigation)
- Sistema de diseño y primitivas UI
- Reglas de proyecto y del plan
- Arquitectura y backend (MASTERPLAN)
- Styleguide
- Dependencias admin
- Dependencias web
- Tipos generados de BD
- Dependencias ui
- Esquema: tablas núcleo
- Guía Supabase local
- ESLint compartido
- Workspace raíz
- Paquete db
- Shape Home
- Layouts y next.config
- Métricas y leads (SQL)
- Triggers y auth.users
- Catálogos i18n (SQL)
- Ref 03 filtros Reall
- Paquete i18n
- Shape Ficha y leads
- Shape Explorador
- tsconfig base
- Ref 02 detalle
- Turborepo
- Ref 01 Humee
- Shape Dashboard
- Producto puente Europa-Paraguay
- Ref 04 hero nuffo
- Ref 06 dashboard
- tsconfig Next
- Perfiles, eventos y tasas (SQL)
- Shape Login
- tsconfig admin
- tsconfig web
- Ref 07 login
- Análisis de referencias
- Logo color
- Logo blanco
- Ref 05 EstateEdge
- tsconfig ui
- pnpm workspace
- tsconfig db
- tsconfig i18n
- Voz y logo existente
- Iconografía

## God Nodes (most connected - your core abstractions)
1. `public.properties` - 28 edges
2. `Design System: Edennia Homes (DESIGN.md)` - 23 edges
3. `cn()` - 21 edges
4. `public.leads` - 21 edges
5. `Edennia Homes Implementation Plan (Phases 2-13)` - 18 edges
6. `public.locales` - 17 edges
7. `Shape · Explorador /propiedades` - 15 edges
8. `Análisis de referencias` - 14 edges
9. `Shape · Ficha /propiedades/[slug]` - 13 edges
10. `Shape · Home /[locale]` - 13 edges

## Surprising Connections (you probably didn't know these)
- `Global Constraints` --semantically_similar_to--> `Definition of done (build+typecheck+lint+tests, 1440/390 screenshots)`  [INFERRED] [semantically similar]
  docs/plan/implementation-plan.md → CLAUDE.md
- `Task 4: packages/i18n and packages/db` --references--> `isLocale()`  [INFERRED]
  docs/plan/implementation-plan.md → packages/i18n/src/index.ts
- `Translatable content in *_translations tables; locales from locales table` --conceptually_related_to--> `getTranslation()`  [INFERRED]
  CLAUDE.md → packages/i18n/src/index.ts
- `Task 4: packages/i18n and packages/db` --references--> `getTranslation()`  [INFERRED]
  docs/plan/implementation-plan.md → packages/i18n/src/index.ts
- `Translation fallback to default locale` --references--> `getTranslation()`  [INFERRED]
  docs/plan/implementation-plan.md → packages/i18n/src/index.ts

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Named Restraint Rules of the Edennia Design System** — docs_design_one_leaf_rule, docs_design_photo_leads_rule, docs_design_one_italic_rule, docs_design_expansion_rule, docs_design_flat_by_default_rule, docs_design_glass_once_rule [EXTRACTED 1.00]
- **Dribbble references mapped to Edennia screens** — docs_design_reference_analysis_ref_01_humee, docs_design_reference_analysis_ref_02_detalle_propiedad, docs_design_reference_analysis_ref_03_reall, docs_design_reference_analysis_ref_04_nuffo, docs_design_reference_analysis_ref_05_estateedge, docs_design_reference_analysis_ref_06_dashboard, docs_design_reference_analysis_ref_07_realnest, design_shape_explorador_explorador, design_shape_ficha_ficha, design_shape_home_home, design_shape_dashboard_dashboard_admin, design_shape_login_login_admin [EXTRACTED 1.00]
- **Lead capture flow (form, Turnstile, submit-lead, Resend, CRM)** — docs_masterplan_lead_form, docs_masterplan_cloudflare_turnstile, docs_masterplan_submit_lead_edge_function, docs_masterplan_resend_email, docs_masterplan_leads_crm [EXTRACTED 1.00]
- **Multilingual data model (locales, translations, publication rule, AI drafts)** — docs_masterplan_translation_tables_model, docs_masterplan_locales_table, docs_masterplan_property_translations, docs_masterplan_publication_rule, docs_masterplan_ai_translation_draft, docs_masterplan_packages_i18n [EXTRACTED 1.00]
- **Rental listing filter controls** — docs_references_03_listado_flitros_reall_property_type_filter, docs_references_03_listado_flitros_reall_rental_period_filter, docs_references_03_listado_flitros_reall_price_range_filter, docs_references_03_listado_flitros_reall_bedroom_bathroom_stepper, docs_references_03_listado_flitros_reall_property_area_filter, docs_references_03_listado_flitros_reall_additional_conveniences_filter [EXTRACTED 1.00]
- **EstateEdge landing page section flow** — docs_references_05_landing_estateedge_hero_section, docs_references_05_landing_estateedge_who_we_are, docs_references_05_landing_estateedge_featured_deals_carousel [EXTRACTED 1.00]
- **Add a language without a migration** — supabase_readme_locales_table, supabase_readme_messages_json, supabase_readme_translations_tables [EXTRACTED 1.00]
- **Staff role to JWT claim flow** — supabase_readme_invite_only_signup, supabase_readme_app_metadata_role, supabase_readme_custom_access_token_hook, supabase_readme_user_role_claim [EXTRACTED 1.00]
- **Nature-meets-home brand identity** — docs_brand_logo_color_edennia_script_wordmark, docs_brand_logo_color_leaf_vine_motif, docs_brand_logo_color_house_roof_icon, docs_brand_logo_color_green_palette [INFERRED 0.85]
- **Edennia Homes logo composition: nature (Eden) + home** — docs_brand_logo_white_edennia_wordmark, docs_brand_logo_white_leaf_motif, docs_brand_logo_white_house_roof_motif, docs_brand_logo_white_homes_subtitle [INFERRED 0.85]
- **Multilingual content model** — claude_translations_tables, claude_zero_hardcoded_text, docs_plan_implementation_plan_translation_fallback, packages_i18n_src_index_gettranslation, docs_plan_implementation_plan_publication_validation [INFERRED 0.85]
- **Hero composition: wordmark, house photo, emblem nav and intro motion** — docs_design_wordmark, docs_design_hero_animation, docs_design_hero_logo_decision_b, docs_design_clash_display, docs_design_glass_once_rule [INFERRED 0.85]
- **Bridge between calligraphic logo and geometric UI** — docs_design_brand_tension, docs_design_instrument_serif, docs_design_label_small_caps, docs_design_logo_component [INFERRED 0.85]
- **No invented content applied across Home** — docs_design_reference_analysis_nada_inventado, design_shape_home_datos_que_importan, design_shape_home_testimonios_condicional, design_shape_home_destacadas_acordeon [INFERRED 0.85]
- **Lead capture to response flow** — design_shape_ficha_formulario_me_interesa, design_shape_ficha_edge_function_submit_lead, design_shape_dashboard_bloque_hoy, design_shape_dashboard_supabase_realtime, design_shape_dashboard_umbral_sla [INFERRED 0.85]
- **Lead capture to CRM pipeline** — docs_plan_implementation_plan_leads_table, docs_plan_implementation_plan_submit_lead_edge_function, docs_plan_implementation_plan_fase_07, docs_plan_implementation_plan_fase_10, claude_rls_everywhere [INFERRED 0.85]
- **@edennia/ui primitives planned in Task 3** — packages_ui_src_button_button, packages_ui_src_input_input, packages_ui_src_badge_badge, packages_ui_src_card_card, packages_ui_src_chip_chip, packages_ui_src_container_container, packages_ui_src_logo_logo, packages_ui_src_cn_cn [INFERRED 0.85]
- **Property search flow: search, filter, sort, browse on map and list** — docs_references_01_listado_mapa_humee_address_search_bar, docs_references_01_listado_mapa_humee_filter_dropdowns, docs_references_01_listado_mapa_humee_results_count_sort, docs_references_01_listado_mapa_humee_map_pin_markers, docs_references_01_listado_mapa_humee_property_listing_card [INFERRED 0.85]
- **Single-card booking-to-checkout flow** — docs_references_02_detalle_propiedad_booking_card, docs_references_02_detalle_propiedad_extra_services, docs_references_02_detalle_propiedad_price_breakdown, docs_references_02_detalle_propiedad_payment_form [INFERRED 0.85]
- **Left-column property information sections** — docs_references_02_detalle_propiedad_image_gallery_grid, docs_references_02_detalle_propiedad_property_header, docs_references_02_detalle_propiedad_amenities_row, docs_references_02_detalle_propiedad_content_tabs, docs_references_02_detalle_propiedad_location_map [INFERRED 0.85]
- **Filter -> list -> map synchronized browsing flow** — docs_references_03_listado_flitros_reall_filters_sidebar, docs_references_03_listado_flitros_reall_search_results_list, docs_references_03_listado_flitros_reall_map_view [INFERRED 0.85]
- **Nuffo Hero Composition** — docs_references_04_landing_hero_nuffo_giant_wordmark_hero, docs_references_04_landing_hero_nuffo_pill_navigation, docs_references_04_landing_hero_nuffo_glass_info_card [INFERRED 0.85]
- **Sales/Revenue Analytics Widgets** — docs_references_06_dashboard_kpi_cards, docs_references_06_dashboard_revenue_line_chart, docs_references_06_dashboard_sales_report_table, docs_references_06_dashboard_sales_by_region_map [INFERRED 0.85]
- **Realnest Authentication Entry Options** — docs_references_07_login_realnest_email_password_form, docs_references_07_login_realnest_social_login, docs_references_07_login_realnest_register_link [INFERRED 0.85]
- **Anonymous access controls (properties and leads)** — supabase_readme_anon_column_grants, supabase_readme_display_location, supabase_readme_leads, supabase_readme_submit_lead_edge_function, supabase_readme_service_role [INFERRED 0.85]

## Communities (57 total, 13 thin omitted)

### Community 0 - "Sistema de diseño y primitivas UI"
Cohesion: 0.05
Nodes (50): Admin Panel Layout (264px sidebar, medium density), Badge Component (available/reserved/sold/neutral), Brand Logo Assets (docs/brand, logo-color.png), Browser Surfaces (selection, caret, accent-color), Button Component (primary/secondary/ghost), Card and Container Components, Chip Component (static / toggle), Clash Display (display font) (+42 more)

### Community 1 - "Reglas de proyecto y del plan"
Cohesion: 0.06
Nodes (37): Next.js agent rules (apps/admin): read bundled next docs, breaking changes, Next.js agent rules (apps/web): read bundled next docs, breaking changes, pnpm + Turborepo monorepo (apps/web, apps/admin, packages/db,ui,i18n,config), Edennia Homes project rules (CLAUDE.md), Custom access token hook (user_role in JWT), Fase 2: Monorepo, tokens y libreria base, Fase 3: Supabase schema, i18n, RLS, storage, Fase 4: Web layout, i18n, navigation (+29 more)

### Community 2 - "Arquitectura y backend (MASTERPLAN)"
Cohesion: 0.07
Nodes (37): Admin metrics dashboard (KPIs, funnel, inventory health), Admin login split screen (no public signup), AI translation draft (Edge Function translate via Claude API), Cloudflare Turnstile anti-spam, Custom access token hook (role in JWT), Proposed palette and design principles (Masterplan section 3), Extra ideas (WhatsApp button, search alerts, condo projects, dual currency, auto lead assignment, SLA), Floating search under hero (+29 more)

### Community 3 - "Styleguide"
Cohesion: 0.14
Nodes (24): colors, metadata, Section(), Styleguide(), swatchBg, type, Task 3: packages/ui tokens, fonts, primitives, logo, badge (+16 more)

### Community 4 - "Dependencias admin"
Cohesion: 0.07
Nodes (37): dependencies, @edennia/ui@workspace:*, next@16.4.3, react@19.3.0, react-dom@19.3.0, devDependencies, @edennia/config@workspace:*, eslint@^9 (+29 more)

### Community 5 - "Dependencias web"
Cohesion: 0.07
Nodes (37): dependencies, @edennia/ui@workspace:*, next@16.4.3, react@19.3.0, react-dom@19.3.0, devDependencies, @edennia/config@workspace:*, eslint@^9 (+29 more)

### Community 6 - "Tipos generados de BD"
Cohesion: 0.06
Nodes (30): CompositeTypes, Constants, Database, DatabaseWithoutInternals, DefaultSchema, Enums, Json, Tables (+22 more)

### Community 7 - "Dependencias ui"
Cohesion: 0.07
Nodes (36): dependencies, class-variance-authority@^0.7.1, clsx@^2.1.1, tailwind-merge@^3.7.0, devDependencies, @edennia/config@workspace:*, eslint@^9, next@16.4.3 (+28 more)

### Community 8 - "Esquema: tablas núcleo"
Cohesion: 0.12
Nodes (28): audit_log_created_idx, audit_log_record_idx, investment_fact_translations_locale_idx, properties_agent_idx, properties_created_by_idx, properties_display_location_idx, properties_featured_idx, properties_status_idx (+20 more)

### Community 9 - "Guía Supabase local"
Cohesion: 0.08
Nodes (25): Supabase (local) README, app_metadata.role, public.custom_access_token_hook, supabase db advisors (security/performance), supabase db reset (rebuild from migrations + seed), display_location (snapped ~500 m), Docker Desktop, @edennia/db package (+17 more)

### Community 10 - "ESLint compartido"
Cohesion: 0.09
Nodes (17): dependencies, eslint-config-next@16.4.3, eslint-config-prettier@^10, exports, ./eslint, ./prettier, ./tsconfig.base.json, ./tsconfig.nextjs.json (+9 more)

### Community 11 - "Workspace raíz"
Cohesion: 0.12
Nodes (19): devDependencies, @edennia/config@workspace:*, prettier@^3.9.10, supabase@^2.122.0, turbo@^2.11.10, @edennia/config, name, packageManager (+11 more)

### Community 12 - "Paquete db"
Cohesion: 0.12
Nodes (19): dependencies, zod@^4.6.7, devDependencies, @edennia/config@workspace:*, typescript@^5, vitest@^5.0.5, exports, @edennia/config (+11 more)

### Community 13 - "Shape Home"
Cohesion: 0.15
Nodes (14): Buscador flotante, Cómo comprar desde Europa (5 pasos), Datos que importan (sin contadores inventados), Destacadas (acordeón, is_featured), Explora por zona, Hero en capas con wordmark gigante (22vw), Propiedad del hero configurable en site_settings (abierto), Shape · Home /[locale] (+6 more)

### Community 14 - "Layouts y next.config"
Cohesion: 0.14
Nodes (8): nextConfig, metadata, nextConfig, metadata, clashDisplay, fontVariables, generalSans, instrumentSerif

### Community 15 - "Métricas y leads (SQL)"
Cohesion: 0.14
Nodes (14): leads_assigned_idx, leads_created_idx, leads_email_idx, leads_locale_idx, leads_property_idx, leads_stage_created_idx, public.leads, public.site_settings (+6 more)

### Community 16 - "Triggers y auth.users"
Cohesion: 0.15
Nodes (14): enforce_publication, guard_profile, lead_before_update, log_lead_event, mark_first_response, on_auth_user_created, private.enforce_publication(), private.guard_profile() (+6 more)

### Community 17 - "Catálogos i18n (SQL)"
Cohesion: 0.17
Nodes (16): amenity_translations_locale_idx, locales_single_default, property_amenities_amenity_idx, public.amenities, public.amenity_translations, public.locales, public.property_amenities, public.property_translations (+8 more)

### Community 18 - "Ref 03 filtros Reall"
Cohesion: 0.15
Nodes (14): REALL Rental Listing with Filters (UI Reference), Additional Conveniences Filter (Parking slot / Pet allowed / Furnished), Bedroom / Bathroom Steppers, Filters Sidebar, Map Pin Preview Popover (thumbnail, price, address), Interactive Map with Property Pins, Price Range Slider with Min/Max Inputs, Property Area Range Slider (sqft) (+6 more)

### Community 19 - "Paquete i18n"
Cohesion: 0.15
Nodes (15): devDependencies, @edennia/config@workspace:*, typescript@^5, vitest@^5.0.5, exports, @edennia/config, typescript, vitest (+7 more)

### Community 20 - "Shape Ficha y leads"
Cohesion: 0.17
Nodes (13): Salud del inventario, Calculadora de cuotas (colapsada), Variante condominio en preventa (unidades + avance de obra), Edge Function submit-lead (Turnstile, zod, rate-limit), Estados Reservada / Vendida (lead property_sold), Shape · Ficha /propiedades/[slug], Formulario Me interesa (lead calificado), Galería bento + lightbox (GSAP Flip) (+5 more)

### Community 21 - "Shape Explorador"
Cohesion: 0.18
Nodes (13): Buscar en esta zona (bbox), /comparar (hasta 3), Shape · Explorador /propiedades, /favoritos (localStorage), Filtro Incluye gestión de residencia, Filtros en vivo (debounce 300ms), Mapa con pines de precio, clusters y mini-card, Proveedor de tiles MapTiler vs Mapbox (abierto) (+5 more)

### Community 22 - "tsconfig base"
Cohesion: 0.14
Nodes (13): compilerOptions, esModuleInterop, isolatedModules, lib, module, moduleResolution, noEmit, noUncheckedIndexedAccess (+5 more)

### Community 23 - "Ref 02 detalle"
Cohesion: 0.20
Nodes (11): Property Detail Page Reference (02-detalle-propiedad), Hotel Features Amenities Row (Wifi, King Bed, Bathtub, Breakfast, Size), App Shell: Top Nav (Home, Support, Rent, Contact, search) + Left Icon Rail, Booking Sidebar Card (price/night, discount badge, check-in/out, guests), Content Tabs (Description, Feature, Virtual, Reviews), Extra Services Selectors (Room Clean, Breakfast), Property Photo Gallery Grid (1 large + 3 small), Embedded Location Map (+3 more)

### Community 24 - "Turborepo"
Cohesion: 0.17
Nodes (11): dependsOn, outputs, cache, persistent, $schema, tasks, build, dev (+3 more)

### Community 25 - "Ref 01 Humee"
Cohesion: 0.22
Nodes (11): Humee Listing + Map Reference Screenshot, Address Search Bar, Contact Property CTA + Phone, Favorite (Heart) Toggle, Filter Dropdowns (Property Type, Max Price, Beds, More Filters), Listing Status Tags (For Rent, Pet Friendly), Map Pin Markers (property dots), Horizontal Property Listing Card (+3 more)

### Community 26 - "Shape Dashboard"
Cohesion: 0.28
Nodes (9): Bloque Hoy (leads sin responder con SLA), Shape · Dashboard admin, Embudo de leads (Lead→Contactado→Visita→Negociación→Cerrado), Mapa de demanda (zonas: leads vs inventario), Origen de leads por país de residencia, Supabase Realtime (leads en vivo), Tarjeta KPI con variación vs período anterior, Umbral SLA de primera respuesta (abierto) (+1 more)

### Community 27 - "Producto puente Europa-Paraguay"
Cohesion: 0.22
Nodes (6): Approximate EUR price beside USD, GDPR compliance for EU residents, Content pages: Invertir en Paraguay, Residencia, Como comprar desde Europa, Primary user: European investor/family looking at Paraguay, Real funnel: discover, understand Paraguay, explore, contact remotely, Paraguayan residency management (free with selected properties)

### Community 28 - "Ref 04 hero nuffo"
Cohesion: 0.28
Nodes (8): Nuffo Landing Page Reference (Screenshot), Eco Modern Architecture Real Estate Brand, Glassmorphism Room Info Card, Looks Dark Gallery Band, Pill-Style Top Navigation, Trusted By Logo Strip, Who We Are About Section, Why Choose Us Staggered Card Row

### Community 29 - "Ref 06 dashboard"
Cohesion: 0.31
Nodes (9): Real Estate Admin Dashboard Reference (06-dashboard.png), KPI Stat Cards (Total Revenue, Maintenance Cost), Personalized Greeting Header, Promotional Hero Banner (house-in-hand, Explore Now CTA), Property List Cards (photo, offers badge, address, price), Total Revenue Line Chart (Income vs Expense, 2018-2022), Sales by Region Map, Sales Report Table (Sales by, Email, Sales Type, Price, Status) (+1 more)

### Community 30 - "tsconfig Next"
Cohesion: 0.22
Nodes (8): compilerOptions, allowJs, incremental, jsx, plugins, extends, $schema, ./tsconfig.base.json

### Community 31 - "Perfiles, eventos y tasas (SQL)"
Cohesion: 0.22
Nodes (8): exchange_rates_updated_by_idx, lead_events_actor_idx, lead_events_lead_created_idx, public.exchange_rates, public.lead_events, public.profiles, public.agent_ranking(), public.custom_access_token_hook()

### Community 32 - "Shape Login"
Cohesion: 0.25
Nodes (6): Variantes por rol (admin/asesor/editor, RLS), Shape · Login admin /login, Split screen foto | formulario, Auth Supabase SSR (cookies, middleware, roles JWT), Segundo paso TOTP para admin (opcional), Ref 07 · Realnest (login)

### Community 33 - "tsconfig admin"
Cohesion: 0.29
Nodes (6): compilerOptions, paths, exclude, extends, include, @edennia/config/tsconfig.nextjs.json

### Community 34 - "tsconfig web"
Cohesion: 0.29
Nodes (6): compilerOptions, paths, exclude, extends, include, @edennia/config/tsconfig.nextjs.json

### Community 35 - "Ref 07 login"
Cohesion: 0.38
Nodes (5): Realnest Login Screen Reference, Email/Password Login Form, Hero Image Carousel with Tagline 'Find your sweet home', Register Link for New Accounts, Social Login (Google, Facebook) 'Instant Login'

### Community 36 - "Análisis de referencias"
Cohesion: 0.33
Nodes (3): WhatsApp con mensaje prellenado y código, Ref 06 · Dashboard inmobiliario, Análisis de referencias

### Community 37 - "Logo color"
Cohesion: 0.53
Nodes (6): Edennia Homes Color Logo, Edennia Script Wordmark, Green Monochrome Brand Palette, HOMES Sans-serif Descriptor, House Roof Icon, Leaf and Vine Motif

### Community 38 - "Logo blanco"
Cohesion: 0.47
Nodes (5): Edennia Homes Logo (White Variant), Edennia Script Wordmark, HOMES Spaced-Caps Subtitle, House Roof and Window Motif, Leaf Motif (Eden / Nature)

### Community 39 - "Ref 05 EstateEdge"
Cohesion: 0.40
Nodes (5): EstateEdge Landing Page Reference, Featured Deals Carousel (Expanding Cards), Hero: Secure Your Share of Elite Property, Transparent Navbar with Phone CTA Pill, Who We Are Section with Image Carousel

### Community 40 - "tsconfig ui"
Cohesion: 0.33
Nodes (5): compilerOptions, jsx, extends, include, @edennia/config/tsconfig.base.json

### Community 41 - "pnpm workspace"
Cohesion: 0.40
Nodes (4): allowBuilds, sharp, unrs-resolver, packages

### Community 42 - "tsconfig db"
Cohesion: 0.50
Nodes (3): extends, include, @edennia/config/tsconfig.base.json

### Community 43 - "tsconfig i18n"
Cohesion: 0.50
Nodes (3): extends, include, @edennia/config/tsconfig.base.json

## Knowledge Gaps
- **81 isolated node(s):** `@edennia/config/tsconfig.nextjs.json`, `@edennia/config/tsconfig.nextjs.json`, `./tsconfig.base.json`, `@edennia/config/tsconfig.base.json`, `@edennia/config/tsconfig.base.json` (+76 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 274 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **13 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Design System: Edennia Homes (DESIGN.md)` connect `Sistema de diseño y primitivas UI` to `Reglas de proyecto y del plan`, `Styleguide`, `Análisis de referencias`?**
  _High betweenness centrality (0.148) - this node is a cross-community bridge._
- **What connects `@edennia/config/tsconfig.nextjs.json`, `@edennia/config/tsconfig.nextjs.json`, `./tsconfig.base.json` to the rest of the system?**
  _81 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Sistema de diseño y primitivas UI` be split into smaller, more focused modules?**
  _Cohesion score 0.054563492063492064 - nodes in this community are weakly interconnected._
- **Why does `Task 3: packages/ui tokens, fonts, primitives, logo` connect `Styleguide` to `Sistema de diseño y primitivas UI`, `Reglas de proyecto y del plan`?**
  _High betweenness centrality (0.097) - this node is a cross-community bridge._
- **Should `Reglas de proyecto y del plan` be split into smaller, more focused modules?**
  _Cohesion score 0.06458635703918723 - nodes in this community are weakly interconnected._
- **Why does `Análisis de referencias` connect `Análisis de referencias` to `Sistema de diseño y primitivas UI`, `Shape Login`, `Shape Home`, `Shape Ficha y leads`, `Shape Explorador`?**
  _High betweenness centrality (0.070) - this node is a cross-community bridge._
- **Should `Arquitectura y backend (MASTERPLAN)` be split into smaller, more focused modules?**
  _Cohesion score 0.06868686868686869 - nodes in this community are weakly interconnected._