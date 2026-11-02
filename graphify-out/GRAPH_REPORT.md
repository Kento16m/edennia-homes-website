# Graph Report - edennia.homes  (2026-11-01)

## Corpus Check
- Corpus is ~21,601 words - fits in a single context window. You may not need a graph.

## Summary
- 638 nodes · 902 edges · 44 communities (36 shown, 8 thin omitted)
- Extraction: 88% EXTRACTED · 12% INFERRED · 0% AMBIGUOUS · INFERRED: 104 edges (avg confidence: 0.84)
- Token cost: 151,310 input · 0 output

## Community Hubs (Navigation)
- Sistema de diseño y primitivas UI
- Reglas de proyecto y del plan
- Arquitectura y backend (MASTERPLAN)
- Styleguide
- Dependencias admin
- Dependencias web
- Dependencias ui
- ESLint compartido
- Shape Home
- Layouts y next.config
- Workspace raíz
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
- Shape Login
- tsconfig admin
- tsconfig web
- Ref 07 login
- Análisis de referencias
- Logo color
- Logo blanco
- Ref 05 EstateEdge
- Paquete db
- tsconfig ui
- pnpm workspace
- tsconfig i18n
- Voz y logo existente
- Iconografía

## God Nodes (most connected - your core abstractions)
1. `Design System: Edennia Homes (DESIGN.md)` - 23 edges
2. `cn()` - 21 edges
3. `Edennia Homes Implementation Plan (Phases 2-13)` - 18 edges
4. `Shape · Explorador /propiedades` - 15 edges
5. `Análisis de referencias` - 14 edges
6. `Shape · Ficha /propiedades/[slug]` - 13 edges
7. `Shape · Home /[locale]` - 13 edges
8. `compilerOptions` - 12 edges
9. `Forest and Sand Color Palette` - 12 edges
10. `Task 3: packages/ui tokens, fonts, primitives, logo` - 12 edges

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

## Communities (44 total, 8 thin omitted)

### Community 0 - "Sistema de diseño y primitivas UI"
Cohesion: 0.06
Nodes (43): Admin Panel Layout (264px sidebar, medium density), Badge Component (available/reserved/sold/neutral), Brand Logo Assets (docs/brand, logo-color.png), Browser Surfaces (selection, caret, accent-color), Button Component (primary/secondary/ghost), Card and Container Components, Chip Component (static / toggle), Clash Display (display font) (+35 more)

### Community 1 - "Reglas de proyecto y del plan"
Cohesion: 0.06
Nodes (37): Next.js agent rules (apps/admin): read bundled next docs, breaking changes, Next.js agent rules (apps/web): read bundled next docs, breaking changes, pnpm + Turborepo monorepo (apps/web, apps/admin, packages/db,ui,i18n,config), Edennia Homes project rules (CLAUDE.md), Custom access token hook (user_role in JWT), Fase 2: Monorepo, tokens y libreria base, Fase 3: Supabase schema, i18n, RLS, storage, Fase 4: Web layout, i18n, navigation (+29 more)

### Community 2 - "Arquitectura y backend (MASTERPLAN)"
Cohesion: 0.06
Nodes (44): Admin metrics dashboard (KPIs, funnel, inventory health), Admin login split screen (no public signup), AI translation draft (Edge Function translate via Claude API), CLAUDE.md project rules, Cloudflare Turnstile anti-spam, Custom access token hook (role in JWT), Proposed palette and design principles (Masterplan section 3), Edennia Homes Masterplan (+36 more)

### Community 3 - "Styleguide"
Cohesion: 0.13
Nodes (25): colors, metadata, Section(), Styleguide(), swatchBg, type, Task 3: packages/ui tokens, fonts, primitives, logo, badge (+17 more)

### Community 4 - "Dependencias admin"
Cohesion: 0.07
Nodes (37): dependencies, @edennia/ui@workspace:*, next@16.4.3, react@19.3.0, react-dom@19.3.0, devDependencies, @edennia/config@workspace:*, eslint@^9 (+29 more)

### Community 5 - "Dependencias web"
Cohesion: 0.07
Nodes (37): dependencies, @edennia/ui@workspace:*, next@16.4.3, react@19.3.0, react-dom@19.3.0, devDependencies, @edennia/config@workspace:*, eslint@^9 (+29 more)

### Community 6 - "Dependencias ui"
Cohesion: 0.07
Nodes (35): dependencies, class-variance-authority@^0.7.1, clsx@^2.1.1, tailwind-merge@^3.7.0, devDependencies, @edennia/config@workspace:*, eslint@^9, next@16.4.3 (+27 more)

### Community 7 - "ESLint compartido"
Cohesion: 0.09
Nodes (17): dependencies, eslint-config-next@16.4.3, eslint-config-prettier@^10, exports, ./eslint, ./prettier, ./tsconfig.base.json, ./tsconfig.nextjs.json (+9 more)

### Community 8 - "Shape Home"
Cohesion: 0.15
Nodes (14): Buscador flotante, Cómo comprar desde Europa (5 pasos), Datos que importan (sin contadores inventados), Destacadas (acordeón, is_featured), Explora por zona, Hero en capas con wordmark gigante (22vw), Propiedad del hero configurable en site_settings (abierto), Shape · Home /[locale] (+6 more)

### Community 9 - "Layouts y next.config"
Cohesion: 0.14
Nodes (8): nextConfig, metadata, nextConfig, metadata, clashDisplay, fontVariables, generalSans, instrumentSerif

### Community 10 - "Workspace raíz"
Cohesion: 0.13
Nodes (17): devDependencies, @edennia/config@workspace:*, prettier@^3.9.10, turbo@^2.11.10, @edennia/config, name, packageManager, private (+9 more)

### Community 11 - "Ref 03 filtros Reall"
Cohesion: 0.15
Nodes (14): REALL Rental Listing with Filters (UI Reference), Additional Conveniences Filter (Parking slot / Pet allowed / Furnished), Bedroom / Bathroom Steppers, Filters Sidebar, Map Pin Preview Popover (thumbnail, price, address), Interactive Map with Property Pins, Price Range Slider with Min/Max Inputs, Property Area Range Slider (sqft) (+6 more)

### Community 12 - "Paquete i18n"
Cohesion: 0.15
Nodes (15): devDependencies, @edennia/config@workspace:*, typescript@^5, vitest@^5.0.5, exports, @edennia/config, typescript, vitest (+7 more)

### Community 13 - "Shape Ficha y leads"
Cohesion: 0.17
Nodes (13): Salud del inventario, Calculadora de cuotas (colapsada), Variante condominio en preventa (unidades + avance de obra), Edge Function submit-lead (Turnstile, zod, rate-limit), Estados Reservada / Vendida (lead property_sold), Shape · Ficha /propiedades/[slug], Formulario Me interesa (lead calificado), Galería bento + lightbox (GSAP Flip) (+5 more)

### Community 14 - "Shape Explorador"
Cohesion: 0.18
Nodes (13): Buscar en esta zona (bbox), /comparar (hasta 3), Shape · Explorador /propiedades, /favoritos (localStorage), Filtro Incluye gestión de residencia, Filtros en vivo (debounce 300ms), Mapa con pines de precio, clusters y mini-card, Proveedor de tiles MapTiler vs Mapbox (abierto) (+5 more)

### Community 15 - "tsconfig base"
Cohesion: 0.14
Nodes (13): compilerOptions, esModuleInterop, isolatedModules, lib, module, moduleResolution, noEmit, noUncheckedIndexedAccess (+5 more)

### Community 16 - "Ref 02 detalle"
Cohesion: 0.20
Nodes (11): Property Detail Page Reference (02-detalle-propiedad), Hotel Features Amenities Row (Wifi, King Bed, Bathtub, Breakfast, Size), App Shell: Top Nav (Home, Support, Rent, Contact, search) + Left Icon Rail, Booking Sidebar Card (price/night, discount badge, check-in/out, guests), Content Tabs (Description, Feature, Virtual, Reviews), Extra Services Selectors (Room Clean, Breakfast), Property Photo Gallery Grid (1 large + 3 small), Embedded Location Map (+3 more)

### Community 17 - "Turborepo"
Cohesion: 0.17
Nodes (11): dependsOn, outputs, cache, persistent, $schema, tasks, build, dev (+3 more)

### Community 18 - "Ref 01 Humee"
Cohesion: 0.22
Nodes (11): Humee Listing + Map Reference Screenshot, Address Search Bar, Contact Property CTA + Phone, Favorite (Heart) Toggle, Filter Dropdowns (Property Type, Max Price, Beds, More Filters), Listing Status Tags (For Rent, Pet Friendly), Map Pin Markers (property dots), Horizontal Property Listing Card (+3 more)

### Community 19 - "Shape Dashboard"
Cohesion: 0.28
Nodes (9): Bloque Hoy (leads sin responder con SLA), Shape · Dashboard admin, Embudo de leads (Lead→Contactado→Visita→Negociación→Cerrado), Mapa de demanda (zonas: leads vs inventario), Origen de leads por país de residencia, Supabase Realtime (leads en vivo), Tarjeta KPI con variación vs período anterior, Umbral SLA de primera respuesta (abierto) (+1 more)

### Community 20 - "Producto puente Europa-Paraguay"
Cohesion: 0.22
Nodes (6): Approximate EUR price beside USD, GDPR compliance for EU residents, Content pages: Invertir en Paraguay, Residencia, Como comprar desde Europa, Primary user: European investor/family looking at Paraguay, Real funnel: discover, understand Paraguay, explore, contact remotely, Paraguayan residency management (free with selected properties)

### Community 21 - "Ref 04 hero nuffo"
Cohesion: 0.28
Nodes (8): Nuffo Landing Page Reference (Screenshot), Eco Modern Architecture Real Estate Brand, Glassmorphism Room Info Card, Looks Dark Gallery Band, Pill-Style Top Navigation, Trusted By Logo Strip, Who We Are About Section, Why Choose Us Staggered Card Row

### Community 22 - "Ref 06 dashboard"
Cohesion: 0.31
Nodes (9): Real Estate Admin Dashboard Reference (06-dashboard.png), KPI Stat Cards (Total Revenue, Maintenance Cost), Personalized Greeting Header, Promotional Hero Banner (house-in-hand, Explore Now CTA), Property List Cards (photo, offers badge, address, price), Total Revenue Line Chart (Income vs Expense, 2018-2022), Sales by Region Map, Sales Report Table (Sales by, Email, Sales Type, Price, Status) (+1 more)

### Community 23 - "tsconfig Next"
Cohesion: 0.22
Nodes (8): compilerOptions, allowJs, incremental, jsx, plugins, extends, $schema, ./tsconfig.base.json

### Community 24 - "Shape Login"
Cohesion: 0.25
Nodes (6): Variantes por rol (admin/asesor/editor, RLS), Shape · Login admin /login, Split screen foto | formulario, Auth Supabase SSR (cookies, middleware, roles JWT), Segundo paso TOTP para admin (opcional), Ref 07 · Realnest (login)

### Community 25 - "tsconfig admin"
Cohesion: 0.29
Nodes (6): compilerOptions, paths, exclude, extends, include, @edennia/config/tsconfig.nextjs.json

### Community 26 - "tsconfig web"
Cohesion: 0.29
Nodes (6): compilerOptions, paths, exclude, extends, include, @edennia/config/tsconfig.nextjs.json

### Community 27 - "Ref 07 login"
Cohesion: 0.38
Nodes (5): Realnest Login Screen Reference, Email/Password Login Form, Hero Image Carousel with Tagline 'Find your sweet home', Register Link for New Accounts, Social Login (Google, Facebook) 'Instant Login'

### Community 28 - "Análisis de referencias"
Cohesion: 0.33
Nodes (3): WhatsApp con mensaje prellenado y código, Ref 06 · Dashboard inmobiliario, Análisis de referencias

### Community 29 - "Logo color"
Cohesion: 0.53
Nodes (6): Edennia Homes Color Logo, Edennia Script Wordmark, Green Monochrome Brand Palette, HOMES Sans-serif Descriptor, House Roof Icon, Leaf and Vine Motif

### Community 30 - "Logo blanco"
Cohesion: 0.47
Nodes (5): Edennia Homes Logo (White Variant), Edennia Script Wordmark, HOMES Spaced-Caps Subtitle, House Roof and Window Motif, Leaf Motif (Eden / Nature)

### Community 31 - "Ref 05 EstateEdge"
Cohesion: 0.40
Nodes (5): EstateEdge Landing Page Reference, Featured Deals Carousel (Expanding Cards), Hero: Secure Your Share of Elite Property, Transparent Navbar with Phone CTA Pill, Who We Are Section with Image Carousel

### Community 32 - "Paquete db"
Cohesion: 0.33
Nodes (5): exports, name, private, type, version

### Community 33 - "tsconfig ui"
Cohesion: 0.33
Nodes (5): compilerOptions, jsx, extends, include, @edennia/config/tsconfig.base.json

### Community 34 - "pnpm workspace"
Cohesion: 0.40
Nodes (4): allowBuilds, sharp, unrs-resolver, packages

### Community 35 - "tsconfig i18n"
Cohesion: 0.50
Nodes (3): extends, include, @edennia/config/tsconfig.base.json

## Knowledge Gaps
- **72 isolated node(s):** `@edennia/config/tsconfig.nextjs.json`, `@edennia/config/tsconfig.nextjs.json`, `./tsconfig.base.json`, `@edennia/config/tsconfig.base.json`, `@edennia/config/tsconfig.base.json` (+67 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 218 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Design System: Edennia Homes (DESIGN.md)` connect `Sistema de diseño y primitivas UI` to `Reglas de proyecto y del plan`, `Arquitectura y backend (MASTERPLAN)`, `Styleguide`, `Análisis de referencias`?**
  _High betweenness centrality (0.195) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Shape · Explorador /propiedades` (e.g. with `Precio USD con EUR aproximado` and `Buscador flotante`) actually correct?**
  _`Shape · Explorador /propiedades` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `@edennia/config/tsconfig.nextjs.json`, `@edennia/config/tsconfig.nextjs.json`, `./tsconfig.base.json` to the rest of the system?**
  _72 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Sistema de diseño y primitivas UI` be split into smaller, more focused modules?**
  _Cohesion score 0.06298701298701298 - nodes in this community are weakly interconnected._
- **Why does `Task 3: packages/ui tokens, fonts, primitives, logo` connect `Styleguide` to `Sistema de diseño y primitivas UI`, `Reglas de proyecto y del plan`?**
  _High betweenness centrality (0.109) - this node is a cross-community bridge._
- **Should `Reglas de proyecto y del plan` be split into smaller, more focused modules?**
  _Cohesion score 0.06289308176100629 - nodes in this community are weakly interconnected._
- **Why does `Análisis de referencias` connect `Análisis de referencias` to `Sistema de diseño y primitivas UI`, `Shape Home`, `Shape Ficha y leads`, `Shape Explorador`, `Shape Login`?**
  _High betweenness centrality (0.097) - this node is a cross-community bridge._