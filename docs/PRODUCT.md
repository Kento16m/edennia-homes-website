# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Stack

Definido en `docs/MASTERPLAN.md` §2.2: monorepo pnpm + Turborepo, dos apps Next.js (App Router, TypeScript strict) — `apps/web` (pública) y `apps/admin` (panel) — sobre una sola base Supabase (Postgres + PostGIS, Auth, Storage, RLS, Edge Functions). Tailwind v4, GSAP + Lenis, MapLibre GL, next-intl, shadcn/ui en el admin. Deploy en Vercel (2 proyectos).

Dominios: `edennia.homes` (web) y `admin.edennia.homes` (panel). *(El MASTERPLAN §8 Fase 13 menciona `edenniahomes.com`; el dominio real confirmado por el email de contacto es `edennia.homes`.)*

## Users

**Primario — el europeo que mira Paraguay desde lejos.** Inversores y familias de España (y en segundo lugar del resto de Europa) que evalúan **invertir** en inmuebles en Paraguay, **mudarse** a vivir allí, o ambas cosas. Están en otro continente, a 5–6 h de diferencia horaria, sin conocer el mercado, las zonas, los costos ni el proceso legal. Su trabajo: decidir si confían lo bastante como para dar el siguiente paso (una videollamada o una visita) y entender qué implica comprar y obtener la residencia.

**Secundario — comprador local o residente en Paraguay** que busca casa, apartamento o condominio en Asunción.

**Interno — el equipo de Edennia** (hoy 2 asesores en la misma oficina; se contratarán más) que publica inventario bilingüe, atiende leads y mide el negocio desde el panel. Roles: `admin`, `agent`, `editor`.

## Product Purpose

Edennia Homes es una inmobiliaria premium de origen español instalada en Asunción (Villa Morra). El sitio existe para que un europeo pase de "¿Paraguay?" a "quiero hablar con ellos": inspirar, explicar el país y el proceso, mostrar inventario real y convertir esa confianza en un **lead calificado**.

Misión (de la empresa): ayudar a personas y familias a encontrar oportunidades inmobiliarias con acompañamiento cercano, transparente y profesional, sumando orientación y gestión de la residencia en Paraguay.

Visión: ser la inmobiliaria de referencia para europeos que buscan invertir o residir en Paraguay.

**Éxito:** leads calificados por semana y tiempo de primera respuesta (métrica norte del MASTERPLAN). Calificado = sabemos su país, su objetivo (invertir / vivir / ambos), su presupuesto o propiedad de interés y su canal preferido.

## Positioning

No es "otra inmobiliaria de Asunción": es **el puente España/Europa → Paraguay**, con un servicio integral antes, durante y después de la compra que incluye la **gestión de la residencia paraguaya** (gratuita con la compra de propiedades seleccionadas). Un portal local puede listar las mismas casas; no puede ofrecer el acompañamiento de un equipo español que conoce las preguntas de quien llega desde Europa.

## Operating Context

- **Embudo real:** descubrir (búsqueda/redes) → entender Paraguay y el proceso → explorar propiedades → contactar. El contacto inicial casi siempre es **remoto**: WhatsApp (funciona igual en España), email o **videollamada**; la visita presencial llega después.
- **Servicios:** compra y venta; búsqueda personalizada según objetivos; asesoramiento de inversión; acompañamiento completo del proceso (pasos, tiempos, costos, documentación); gestión de la residencia.
- **Argumentos de inversión que la empresa comunica:** 0 % de impuestos sobre rentas de origen extranjero; residencia gratuita con propiedades seleccionadas; estabilidad y crecimiento económico (proyecciones del Banco Mundial); sistema tributario competitivo (IRE 10 %, IVA 5–10 %); igualdad de trato al inversor extranjero; ubicación estratégica.
- **Contacto oficial:** WhatsApp/teléfono +595 975 500 150 · info@edennia.homes · Teniente Malutín 516, Villa Morra, Asunción, Paraguay.
- **Panel interno:** los asesores trabajan desde la oficina; los leads llegan con desfase horario, por lo que el tiempo de primera respuesta se mide y se alerta.

## Capabilities and Constraints

**Confirmado**
- **Operación v1:** solo **venta**. Tipos: casas, apartamentos, condominios. **Condominios en preventa / en pozo como proyectos** (unidades por tipología y piso, estado, avance de obra, fecha de entrega) entran en v1. **Alquileres: no por ahora** (el esquema conserva el campo `operation` para no cerrarse la puerta).
- **Moneda:** precios en **USD**. Habrá más monedas (PYG y otras) → la moneda vive en el dato, nunca asumida en la UI.
- **Ubicación:** se decide **por propiedad** si se muestra la dirección exacta o solo una zona aproximada.
- **Fotos:** existen fotos reales; se suben **desde el admin a Supabase Storage**. Esto incluye la imagen del hero (casa recortada con transparencia), que es contenido editable, no un asset del repo.
- **Idiomas:** español (principal) + inglés. Añadir idiomas sin migraciones (tabla `locales`).
- **Mercado inicial:** Asunción (y zonas a definir en el seed de la Fase 3).

**Adoptado por propuesta (sin objeción del cliente)**
- **RGPD:** al captar datos de residentes en la UE, aplica el RGPD además de la ley paraguaya: consentimiento explícito y granular, política de privacidad, banner de cookies si hay analítica no esencial, derecho de acceso/borrado.
- **Precio en EUR aproximado** junto al USD (tasa editable en el admin, con aviso "aprox."), porque el usuario primario piensa en euros.
- **Contenido nuevo** fuera del MASTERPLAN original: páginas *Invertir en Paraguay*, *Residencia en Paraguay* y *Cómo comprar desde Europa* (pasos, tiempos, costos, documentos). Los datos fiscales se gestionan desde el admin, con fecha de actualización y aviso de "información orientativa, no asesoramiento fiscal ni legal".
- **Lead calificado:** el formulario suma país de residencia, objetivo (invertir / vivir / ambos), interés en la residencia y zona horaria / franja preferida para videollamada.

**Sin decidir**
- Zonas/barrios iniciales concretos de Asunción y alrededores.
- Qué propiedades califican para "residencia gratuita" (marca por propiedad en el admin).
- Volumen de inventario al lanzamiento.
- Tercer idioma futuro (candidatos naturales: alemán, portugués, francés).
- Proveedor del mapa base (MapTiler vs. Mapbox).

## Brand Commitments

- **Nombre:** Edennia Homes. **Logo existente:** lettering caligráfico verde con hoja, techo de casa y "HOMES" en versales espaciadas; versión color y blanca, ambas con relieve 3D, solo en PNG (`docs/brand/logo-color.png`, `docs/brand/logo-white.png`). **No existe versión vectorial.**
- **Hero (decisión del cliente):** wordmark gigante "Edennia" con la casa recortada superpuesta (concepto de la ref. 04), como dice el MASTERPLAN §4.1.
- **Voz:** cercana, experta, transparente y sin humo. Español peninsular con **tú** (es como habla el público objetivo); inglés claro y cálido para el resto de Europa. Nunca jerga inmobiliaria de portal ("¡oportunidad única!"), nunca promesas fiscales absolutas.
- **Identidad propia:** verde del logo, naturaleza, calma. Las referencias de Dribbble son dirección, no copia (MASTERPLAN §0).

## Evidence on Hand

- Logos: `docs/brand/`. Referencias de diseño: `docs/references/01–07`.
- Fotos reales de propiedades: existen, fuera del repo; se cargarán vía admin.
- Datos de contacto, misión, visión, servicios y argumentos de inversión: este documento.
- **Ausencias que no se deben fabricar:** la empresa recién se instala en Paraguay, así que **no hay** todavía propiedades vendidas, años de trayectoria local, testimonios de clientes, logos de clientes/prensa ni cifras de equipo más allá de 2 asesores. Ningún contador, testimonio o sello puede inventarse; las secciones que dependen de ellos se muestran solo cuando haya datos reales en la BD.
- Las cifras fiscales y macroeconómicas requieren fuente y fecha antes de publicarse.

## Product Principles

1. **Confianza antes que catálogo.** Para alguien a 10.000 km, entender el país, el proceso y quién está detrás pesa más que ver 100 casas. Cada pantalla responde una duda antes de pedir algo.
2. **Nada inventado.** Ni testimonios, ni contadores, ni urgencias falsas. Si un dato no existe, la sección no aparece. La transparencia es el producto.
3. **Remoto primero.** WhatsApp, videollamada y email son la puerta principal; todo flujo de contacto funciona desde Europa, con su idioma y su horario.
4. **Calificar sin fricción.** Pedir solo lo que el asesor necesita para responder bien en la primera interacción.
5. **Escalar sin rehacer.** Idiomas, monedas, asesores y tipos de operación crecen como datos, no como código.

## Accessibility & Inclusion

WCAG 2.2 AA en ambas apps (MASTERPLAN Fase 11). Respetar `prefers-reduced-motion` en todo el movimiento GSAP. Público internacional: textos que aguanten la expansión de otros idiomas (EN, DE) y formatos de número/moneda/fecha por locale.
