# Graph Report - docs  (2026-11-01)

## Corpus Check
- Corpus is ~15,399 words - fits in a single context window. You may not need a graph.

## Summary
- 239 nodes · 318 edges · 21 communities (18 shown, 3 thin omitted)
- Extraction: 78% EXTRACTED · 22% INFERRED · 0% AMBIGUOUS · INFERRED: 69 edges (avg confidence: 0.84)
- Token cost: 571,769 input · 0 output

## Community Hubs (Navigation)
- Sistema visual y pantallas clave
- Referencias en la Home
- Tokens de diseño y reglas
- Ficha y captura de leads
- Dashboard y CRM
- Ref 03 · filtros Reall
- Explorador con mapa
- Modelo multilenguaje e i18n
- Ref 02 · detalle propiedad
- Ref 01 · listado Humee
- Producto: puente Europa-Paraguay
- Ref 04 · hero nuffo
- Ref 06 · dashboard
- Proceso, fases y accesibilidad
- Ref 07 · login Realnest
- Logo color
- Logo blanco
- Ref 05 · EstateEdge
- Formas y radios

## God Nodes (most connected - your core abstractions)
1. `Shape · Explorador /propiedades` - 15 edges
2. `Shape · Ficha /propiedades/[slug]` - 13 edges
3. `Shape · Home /[locale]` - 13 edges
4. `Análisis de referencias` - 12 edges
5. `Shape · Dashboard admin` - 11 edges
6. `Panel admin (apps/admin)` - 8 edges
7. `Tech stack (Next.js, Tailwind v4, shadcn/ui, Recharts, Sentry, Vitest, Playwright, Vercel)` - 8 edges
8. `Property Detail Page Reference (02-detalle-propiedad)` - 8 edges
9. `Filters Sidebar` - 8 edges
10. `Nuffo Landing Page Reference (Screenshot)` - 8 edges

## Surprising Connections (you probably didn't know these)
- `Shape · Explorador /propiedades` --references--> `Precio USD con EUR aproximado`  [INFERRED]
  design/shape/explorador.md → design/shape/ficha.md
- `Buscador flotante` --references--> `Shape · Explorador /propiedades`  [INFERRED]
  design/shape/home.md → design/shape/explorador.md
- `Principle: Nothing invented (no fake testimonials, counters, urgency)` --conceptually_related_to--> `Web publica (apps/web)`  [INFERRED]
  PRODUCT.md → MASTERPLAN.md
- `Internal Edennia team (2 advisors, roles admin/agent/editor)` --references--> `Panel admin (apps/admin)`  [INFERRED]
  PRODUCT.md → MASTERPLAN.md
- `Principle: Scale without rebuilding (grow as data, not code)` --semantically_similar_to--> `Multilingual model with translation tables`  [INFERRED] [semantically similar]
  PRODUCT.md → MASTERPLAN.md

## Hyperedges (group relationships)
- **Lead capture flow (form, Turnstile, submit-lead, Resend, CRM)** — masterplan_lead_form, masterplan_cloudflare_turnstile, masterplan_submit_lead_edge_function, masterplan_resend_email, masterplan_leads_crm [EXTRACTED 1.00]
- **Multilingual data model (locales, translations, publication rule, AI drafts)** — masterplan_translation_tables_model, masterplan_locales_table, masterplan_property_translations, masterplan_publication_rule, masterplan_ai_translation_draft, masterplan_packages_i18n [EXTRACTED 1.00]
- **DESIGN.md named rules** — design_one_leaf_rule, design_photo_leads_rule, design_one_italic_rule, design_expansion_rule, design_flat_by_default_rule, design_glass_once_rule [EXTRACTED 1.00]
- **Lead capture to response flow** — design_shape_ficha_formulario_me_interesa, design_shape_ficha_edge_function_submit_lead, design_shape_dashboard_bloque_hoy, design_shape_dashboard_supabase_realtime, design_shape_dashboard_umbral_sla [INFERRED 0.85]
- **Dribbble references mapped to Edennia screens** — design_reference_analysis_ref_01_humee, design_reference_analysis_ref_02_detalle_propiedad, design_reference_analysis_ref_03_reall, design_reference_analysis_ref_04_nuffo, design_reference_analysis_ref_05_estateedge, design_reference_analysis_ref_06_dashboard, design_reference_analysis_ref_07_realnest, design_shape_explorador_explorador, design_shape_ficha_ficha, design_shape_home_home, design_shape_dashboard_dashboard_admin, design_shape_login_login_admin [EXTRACTED 1.00]
- **No invented content applied across Home** — design_reference_analysis_nada_inventado, design_shape_home_datos_que_importan, design_shape_home_testimonios_condicional, design_shape_home_destacadas_acordeon [INFERRED 0.85]
- **Nature-meets-home brand identity** — brand_logo_color_edennia_script_wordmark, brand_logo_color_leaf_vine_motif, brand_logo_color_house_roof_icon, brand_logo_color_green_palette [INFERRED 0.85]
- **Edennia Homes logo composition: nature (Eden) + home** — brand_logo_white_edennia_wordmark, brand_logo_white_leaf_motif, brand_logo_white_house_roof_motif, brand_logo_white_homes_subtitle [INFERRED 0.85]
- **Property search flow: search, filter, sort, browse on map and list** — references_01_listado_mapa_humee_address_search_bar, references_01_listado_mapa_humee_filter_dropdowns, references_01_listado_mapa_humee_results_count_sort, references_01_listado_mapa_humee_map_pin_markers, references_01_listado_mapa_humee_property_listing_card [INFERRED 0.85]
- **Single-card booking-to-checkout flow** — references_02_detalle_propiedad_booking_card, references_02_detalle_propiedad_extra_services, references_02_detalle_propiedad_price_breakdown, references_02_detalle_propiedad_payment_form [INFERRED 0.85]
- **Left-column property information sections** — references_02_detalle_propiedad_image_gallery_grid, references_02_detalle_propiedad_property_header, references_02_detalle_propiedad_amenities_row, references_02_detalle_propiedad_content_tabs, references_02_detalle_propiedad_location_map [INFERRED 0.85]
- **Rental listing filter controls** — references_03_listado_flitros_reall_property_type_filter, references_03_listado_flitros_reall_rental_period_filter, references_03_listado_flitros_reall_price_range_filter, references_03_listado_flitros_reall_bedroom_bathroom_stepper, references_03_listado_flitros_reall_property_area_filter, references_03_listado_flitros_reall_additional_conveniences_filter [EXTRACTED 1.00]
- **Filter -> list -> map synchronized browsing flow** — references_03_listado_flitros_reall_filters_sidebar, references_03_listado_flitros_reall_search_results_list, references_03_listado_flitros_reall_map_view [INFERRED 0.85]
- **Nuffo Hero Composition** — references_04_landing_hero_nuffo_giant_wordmark_hero, references_04_landing_hero_nuffo_pill_navigation, references_04_landing_hero_nuffo_glass_info_card [INFERRED 0.85]
- **EstateEdge landing page section flow** — references_05_landing_estateedge_hero_section, references_05_landing_estateedge_who_we_are, references_05_landing_estateedge_featured_deals_carousel [EXTRACTED 1.00]
- **Sales/Revenue Analytics Widgets** — references_06_dashboard_kpi_cards, references_06_dashboard_revenue_line_chart, references_06_dashboard_sales_report_table, references_06_dashboard_sales_by_region_map [INFERRED 0.85]
- **Realnest Authentication Entry Options** — references_07_login_realnest_email_password_form, references_07_login_realnest_social_login, references_07_login_realnest_register_link [INFERRED 0.85]

## Communities (21 total, 3 thin omitted)

### Community 0 - "Sistema visual y pantallas clave"
Cohesion: 0.09
Nodes (27): Layout: container, grid, explorer/ficha/panel layouts, touch targets, Logo usage: flat SVG vs 3D, emblem-only nav during hero, Lucide iconography, Admin metrics dashboard (KPIs, funnel, inventory health), Admin login split screen (no public signup), Cloudflare Turnstile anti-spam, Custom access token hook (role in JWT), Edennia Homes Masterplan (+19 more)

### Community 1 - "Referencias en la Home"
Cohesion: 0.13
Nodes (16): Ref 04 · nuffo (landing hero), Ref 05 · EstateEdge (landing), Ref 06 · Dashboard inmobiliario, Análisis de referencias, Buscador flotante, Cómo comprar desde Europa (5 pasos), Datos que importan (sin contadores inventados), Destacadas (acordeón, is_featured) (+8 more)

### Community 2 - "Tokens de diseño y reglas"
Cohesion: 0.14
Nodes (15): Buttons (primary forest-900, secondary, WhatsApp without WhatsApp green), Forest and sand color palette tokens, Design System: Edennia Homes (DESIGN.md), Map pins (forest-900 pill price, leaf-400 selected, clusters), Typography pair A: Clash Display + General Sans + Instrument Serif Italic, Typography pair B: Cabinet Grotesk + Switzer + Zodiak Italic, CLAUDE.md project rules, Proposed palette and design principles (Masterplan section 3) (+7 more)

### Community 3 - "Ficha y captura de leads"
Cohesion: 0.15
Nodes (14): Ref 02 · Detalle de propiedad, Salud del inventario, Calculadora de cuotas (colapsada), Variante condominio en preventa (unidades + avance de obra), Edge Function submit-lead (Turnstile, zod, rate-limit), Estados Reservada / Vendida (lead property_sold), Shape · Ficha /propiedades/[slug], Formulario Me interesa (lead calificado) (+6 more)

### Community 4 - "Dashboard y CRM"
Cohesion: 0.13
Nodes (15): Ref 07 · Realnest (login), Bloque Hoy (leads sin responder con SLA), Shape · Dashboard admin, Embudo de leads (Lead→Contactado→Visita→Negociación→Cerrado), Mapa de demanda (zonas: leads vs inventario), Origen de leads por país de residencia, Supabase Realtime (leads en vivo), Tarjeta KPI con variación vs período anterior (+7 more)

### Community 5 - "Ref 03 · filtros Reall"
Cohesion: 0.15
Nodes (14): REALL Rental Listing with Filters (UI Reference), Additional Conveniences Filter (Parking slot / Pet allowed / Furnished), Bedroom / Bathroom Steppers, Filters Sidebar, Map Pin Preview Popover (thumbnail, price, address), Interactive Map with Property Pins, Price Range Slider with Min/Max Inputs, Property Area Range Slider (sqft) (+6 more)

### Community 6 - "Explorador con mapa"
Cohesion: 0.18
Nodes (13): Ref 01 · Humee (listado con mapa), Ref 03 · Reall (listado con filtros), Buscar en esta zona (bbox), /comparar (hasta 3), Shape · Explorador /propiedades, /favoritos (localStorage), Filtro Incluye gestión de residencia, Filtros en vivo (debounce 300ms) (+5 more)

### Community 7 - "Modelo multilenguaje e i18n"
Cohesion: 0.20
Nodes (9): AI translation draft (Edge Function translate via Claude API), Extra ideas (WhatsApp button, search alerts, condo projects, dual currency, auto lead assignment, SLA), locales table, next-intl localized routes and slugs (hreflang), packages/i18n (locales, translation fallback), properties table (geography Point location), property_translations table, RPC search_properties(bbox, filters, locale) (+1 more)

### Community 8 - "Ref 02 · detalle propiedad"
Cohesion: 0.20
Nodes (11): Property Detail Page Reference (02-detalle-propiedad), Hotel Features Amenities Row (Wifi, King Bed, Bathtub, Breakfast, Size), App Shell: Top Nav (Home, Support, Rent, Contact, search) + Left Icon Rail, Booking Sidebar Card (price/night, discount badge, check-in/out, guests), Content Tabs (Description, Feature, Virtual, Reviews), Extra Services Selectors (Room Clean, Breakfast), Property Photo Gallery Grid (1 large + 3 small), Embedded Location Map (+3 more)

### Community 9 - "Ref 01 · listado Humee"
Cohesion: 0.22
Nodes (11): Humee Listing + Map Reference Screenshot, Address Search Bar, Contact Property CTA + Phone, Favorite (Heart) Toggle, Filter Dropdowns (Property Type, Max Price, Beds, More Filters), Listing Status Tags (For Rent, Pet Friendly), Map Pin Markers (property dots), Horizontal Property Listing Card (+3 more)

### Community 10 - "Producto: puente Europa-Paraguay"
Cohesion: 0.22
Nodes (6): Approximate EUR price beside USD, GDPR compliance for EU residents, Content pages: Invertir en Paraguay, Residencia, Como comprar desde Europa, Primary user: European investor/family looking at Paraguay, Real funnel: discover, understand Paraguay, explore, contact remotely, Paraguayan residency management (free with selected properties)

### Community 11 - "Ref 04 · hero nuffo"
Cohesion: 0.28
Nodes (8): Nuffo Landing Page Reference (Screenshot), Eco Modern Architecture Real Estate Brand, Glassmorphism Room Info Card, Looks Dark Gallery Band, Pill-Style Top Navigation, Trusted By Logo Strip, Who We Are About Section, Why Choose Us Staggered Card Row

### Community 12 - "Ref 06 · dashboard"
Cohesion: 0.31
Nodes (9): Real Estate Admin Dashboard Reference (06-dashboard.png), KPI Stat Cards (Total Revenue, Maintenance Cost), Personalized Greeting Header, Promotional Hero Banner (house-in-hand, Explore Now CTA), Property List Cards (photo, offers badge, address, price), Total Revenue Line Chart (Income vs Expense, 2018-2022), Sales by Region Map, Sales Report Table (Sales by, Email, Sales Type, Price, Status) (+1 more)

### Community 13 - "Proceso, fases y accesibilidad"
Cohesion: 0.33
Nodes (5): Reduced motion via gsap.matchMedia, Graphify checkpoints G0-G5, Phase-by-phase plan (Fase 0-13), Skills toolkit (Superpowers, Claude-Mem, Impeccable, Ponytail, Find Skills, Graphify), WCAG 2.2 AA accessibility and i18n text expansion

### Community 14 - "Ref 07 · login Realnest"
Cohesion: 0.38
Nodes (5): Realnest Login Screen Reference, Email/Password Login Form, Hero Image Carousel with Tagline 'Find your sweet home', Register Link for New Accounts, Social Login (Google, Facebook) 'Instant Login'

### Community 15 - "Logo color"
Cohesion: 0.53
Nodes (6): Edennia Homes Color Logo, Edennia Script Wordmark, Green Monochrome Brand Palette, HOMES Sans-serif Descriptor, House Roof Icon, Leaf and Vine Motif

### Community 16 - "Logo blanco"
Cohesion: 0.47
Nodes (5): Edennia Homes Logo (White Variant), Edennia Script Wordmark, HOMES Spaced-Caps Subtitle, House Roof and Window Motif, Leaf Motif (Eden / Nature)

### Community 17 - "Ref 05 · EstateEdge"
Cohesion: 0.40
Nodes (5): EstateEdge Landing Page Reference, Featured Deals Carousel (Expanding Cards), Hero: Secure Your Share of Elite Property, Transparent Navbar with Phone CTA Pill, Who We Are Section with Image Carousel

## Knowledge Gaps
- **57 isolated node(s):** `Custom access token hook (role in JWT)`, `Real funnel: discover, understand Paraguay, explore, contact remotely`, `GDPR compliance for EU residents`, `Approximate EUR price beside USD`, `Typography pair B: Cabinet Grotesk + Switzer + Zodiak Italic` (+52 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 73 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Análisis de referencias` connect `Referencias en la Home` to `Ficha y captura de leads`, `Dashboard y CRM`, `Explorador con mapa`?**
  _High betweenness centrality (0.046) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Shape · Explorador /propiedades` (e.g. with `Precio USD con EUR aproximado` and `Buscador flotante`) actually correct?**
  _`Shape · Explorador /propiedades` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Custom access token hook (role in JWT)`, `Real funnel: discover, understand Paraguay, explore, contact remotely`, `GDPR compliance for EU residents` to the rest of the system?**
  _57 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Sistema visual y pantallas clave` be split into smaller, more focused modules?**
  _Cohesion score 0.0946969696969697 - nodes in this community are weakly interconnected._
- **Why does `Shape · Explorador /propiedades` connect `Explorador con mapa` to `Referencias en la Home`, `Ficha y captura de leads`?**
  _High betweenness centrality (0.026) - this node is a cross-community bridge._
- **Should `Referencias en la Home` be split into smaller, more focused modules?**
  _Cohesion score 0.13043478260869565 - nodes in this community are weakly interconnected._
- **Why does `Shape · Ficha /propiedades/[slug]` connect `Ficha y captura de leads` to `Explorador con mapa`?**
  _High betweenness centrality (0.023) - this node is a cross-community bridge._