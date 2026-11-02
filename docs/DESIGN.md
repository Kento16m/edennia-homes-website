---
name: Edennia Homes
description: Inmobiliaria premium que acompaña a europeos a invertir y vivir en Paraguay.
colors:
  forest-900: "#0F3D24"
  forest-600: "#1E7A3E"
  leaf-400: "#5FBF4A"
  sand-100: "#F3EFE7"
  paper: "#FAFAF7"
  white: "#FFFFFF"
  ink: "#121411"
  stone-500: "#656962"
  line: "#E4E1D9"
  line-strong: "#868A82"
  status-available-bg: "#E3F2DD"
  status-reserved-bg: "#FBEFD5"
  status-reserved-text: "#7A5200"
  status-sold-bg: "#E9E7E1"
  danger: "#B42318"
  danger-bg: "#FDECEA"
typography:
  wordmark:
    fontFamily: "Clash Display, General Sans, system-ui, sans-serif"
    fontSize: "clamp(5.5rem, 22vw, 21rem)"
    fontWeight: 600
    lineHeight: 0.85
    letterSpacing: "-0.04em"
  display:
    fontFamily: "Clash Display, General Sans, system-ui, sans-serif"
    fontSize: "clamp(2.75rem, 1.6rem + 4.6vw, 5.5rem)"
    fontWeight: 500
    lineHeight: 1
    letterSpacing: "-0.03em"
  headline:
    fontFamily: "Clash Display, General Sans, system-ui, sans-serif"
    fontSize: "clamp(2rem, 1.4rem + 2.6vw, 3.5rem)"
    fontWeight: 500
    lineHeight: 1.05
    letterSpacing: "-0.02em"
  title-lg:
    fontFamily: "General Sans, system-ui, sans-serif"
    fontSize: "clamp(1.5rem, 1.2rem + 1.2vw, 2.25rem)"
    fontWeight: 500
    lineHeight: 1.15
    letterSpacing: "-0.01em"
  title:
    fontFamily: "General Sans, system-ui, sans-serif"
    fontSize: "1.25rem"
    fontWeight: 500
    lineHeight: 1.3
  body-lg:
    fontFamily: "General Sans, system-ui, sans-serif"
    fontSize: "clamp(1.0625rem, 1rem + 0.25vw, 1.25rem)"
    fontWeight: 400
    lineHeight: 1.6
  body:
    fontFamily: "General Sans, system-ui, sans-serif"
    fontSize: "1rem"
    fontWeight: 400
    lineHeight: 1.6
  small:
    fontFamily: "General Sans, system-ui, sans-serif"
    fontSize: "0.875rem"
    fontWeight: 400
    lineHeight: 1.5
  label:
    fontFamily: "General Sans, system-ui, sans-serif"
    fontSize: "0.75rem"
    fontWeight: 500
    lineHeight: 1.4
    letterSpacing: "0.12em"
  accent:
    fontFamily: "Instrument Serif, Georgia, serif"
    fontWeight: 400
    lineHeight: 1
rounded:
  sm: "8px"
  md: "12px"
  lg: "16px"
  xl: "24px"
  pill: "999px"
spacing:
  "1": "4px"
  "2": "8px"
  "3": "12px"
  "4": "16px"
  "6": "24px"
  "8": "32px"
  "12": "48px"
  "16": "64px"
  "24": "96px"
  "32": "128px"
  section: "clamp(5rem, 3rem + 8vw, 10rem)"
  gutter: "clamp(1rem, 4vw, 3rem)"
components:
  button-primary:
    backgroundColor: "{colors.forest-900}"
    textColor: "{colors.white}"
    rounded: "{rounded.md}"
    height: "48px"
    padding: "0 24px"
  button-primary-hover:
    backgroundColor: "{colors.forest-600}"
  button-secondary:
    textColor: "{colors.ink}"
    rounded: "{rounded.md}"
    height: "48px"
    padding: "0 24px"
  button-secondary-hover:
    backgroundColor: "{colors.sand-100}"
  input:
    backgroundColor: "{colors.white}"
    textColor: "{colors.ink}"
    rounded: "{rounded.md}"
    height: "48px"
    padding: "0 16px"
  chip-selected:
    backgroundColor: "{colors.forest-900}"
    textColor: "{colors.white}"
    rounded: "{rounded.pill}"
    padding: "8px 16px"
  badge-available:
    backgroundColor: "{colors.status-available-bg}"
    textColor: "{colors.forest-900}"
    rounded: "{rounded.pill}"
    padding: "4px 12px"
  card:
    backgroundColor: "{colors.white}"
    rounded: "{rounded.lg}"
    padding: "24px"
---

# Design System: Edennia Homes

> Fuente: MASTERPLAN §3 (paleta y principios fijados por el cliente), `docs/PRODUCT.md`, `docs/design/reference-analysis.md` y el logo en `docs/brand/`. Los tokens son normativos; la prosa explica cómo usarlos. Valores de color validados con WCAG 2.x (ratios en cada token).

## Overview

**Creative North Star: "El Edén habitado"**

Edennia vende la idea de llegar a un lugar verde y tranquilo y quedarse a vivir en él. El sistema traduce eso en **aire, fotografía protagonista y un verde que se gana cada aparición**. La casa —siempre una propiedad real— es la heroína; la interfaz se aparta. Densidad baja en la web pública (Persuade/Read), densidad media y precisa en el panel (Operate), con el mismo ADN de color, tipo y forma.

La marca vive en una tensión deliberada: un **logo caligráfico, orgánico y ornamental** frente a una **interfaz geométrica, sobria y europea**. El puente entre ambos es mínimo y preciso: la serif itálica de acento (que hace eco de las curvas del logo) y las versalitas espaciadas de las etiquetas (que hacen eco de "HOMES"). Nada más del ornamento del logo se traslada a la UI.

Escena física: un europeo que mira propiedades de noche en el sofá con el móvil, o de día en el portátil; y un asesor en una oficina luminosa de Villa Morra. Ambos con buena luz ambiente → **tema claro**. No hay tema oscuro en v1; las secciones oscuras (`forest-900`) son momentos de ritmo, no un modo.

Rechazos confirmados: no clonar las referencias de Dribbble; no prueba social inventada; no paleta marrón/púrpura/naranja de las referencias.

**Key Characteristics:**
- Fotografía grande, real y sin filtros de color; la UI flota sobre ella con contención.
- Un solo acento verde por pantalla; el resto, neutros cálidos.
- Wordmark gigante "Edennia" en el hero, en capas con la casa recortada.
- Esquinas generosas (16–24px) en medios y tarjetas; píldoras en navegación y chips.
- Sombras casi invisibles: lo plano es la norma, la sombra indica "flota".
- Movimiento lento y suave (0.8–1.2s, `power3.out`), siempre opcional.

## Colors

Paleta de bosque y arena: verdes profundos de la familia del logo sobre neutros cálidos, con un verde hoja brillante reservado para detalles.

> **Nota sobre el logo:** el verde del logo es un verde puro (tono ≈120°) que va de `#003000` en las sombras a `#00A800` en los brillos (medido sobre `docs/brand/logo-color.png`). Los verdes de la UI son los del MASTERPLAN (tono 141–147°, algo más fríos y profundos): conviven como "la sombra" del verde del logo. El logo nunca se recolorea con ellos salvo en su versión plana (ver Components › Logo).

### Primary
- **Verde Bosque** (`forest-900`): color de marca en la UI. Botones primarios, texto de marca, tipo seleccionado en filtros, pines del mapa, fondos de secciones de ritmo. Blanco sobre él 12.3:1; sobre `paper` 11.7:1. **AA en todo uso.**
- **Verde Follaje** (`forest-600`): hover de primarios, enlaces, iconos activos, estado "Disponible", éxito. Blanco sobre él 5.4:1; sobre `paper` 5.1:1; sobre `sand-100` 4.7:1. **AA para texto normal.**

### Secondary
- **Verde Hoja** (`leaf-400`): el brillo del logo trasladado a la UI. **Solo** detalles: punto activo de un carrusel, subrayado de foco decorativo, pin seleccionado (con texto `ink`), acento sobre fondos `forest-900` (5.3:1). **Nunca texto sobre claro (2.2:1) ni texto blanco sobre él (2.3:1).** `ink` sobre él 8.0:1.

### Neutral
- **Papel** (`paper`): fondo base de ambas apps.
- **Arena** (`sand-100`): fondos cálidos de zonas de calma (bloque de identidad de la ficha, secciones alternas de la Home, panel lateral del login). `ink` sobre ella 16.2:1.
- **Blanco** (`white`): superficies que flotan (tarjetas, buscador, tarjeta sticky, popups).
- **Tinta** (`ink`): texto principal. 17.7:1 sobre `paper`.
- **Piedra** (`stone-500`): texto secundario (direcciones, metadatos, ayudas). **Ajustado** desde `#6B6F68` (MASTERPLAN) porque fallaba AA sobre `sand-100` (4.47:1); ahora 4.9:1 sobre `sand-100`, 5.4:1 sobre `paper`.
- **Línea** (`line`): divisores y bordes decorativos de tarjetas. No se usa para delimitar controles.
- **Línea fuerte** (`line-strong`): borde de inputs, checkboxes y steppers. ≥3:1 sobre `paper`, `white` y `sand-100` (WCAG 1.4.11).

### Estados
- **Disponible:** texto `forest-900` sobre `status-available-bg` (10.5:1).
- **Reservado:** texto `status-reserved-text` sobre `status-reserved-bg` (6.1:1).
- **Vendido:** texto `ink` sobre `status-sold-bg` (15.0:1).
- **Error:** `danger` sobre `paper` 6.3:1 / sobre `danger-bg` 5.8:1; blanco sobre `danger` 6.6:1.
- El color nunca es la única señal: todo estado lleva texto o icono.

### Named Rules
**The One Leaf Rule.** Una pantalla tiene un solo acento de color protagonista. Si el botón primario es `forest-900`, nada más compite en verde saturado en ese viewport.

**The Photo Leads Rule.** Ningún fondo de color, gradiente o patrón se coloca donde debería ir una foto real. Si falta la foto, se muestra un placeholder neutro `sand-100` con el emblema, nunca un gradiente.

## Typography

**Par recomendado (A):**
- **Display Font:** Clash Display (Indian Type Foundry · Fontshare, licencia ITF Free Font: uso comercial gratuito, autoalojable) — wordmark del hero, titulares grandes.
- **Body Font:** General Sans (misma fundición y licencia) — interfaz y lectura en ambas apps.
- **Accent Font:** Instrument Serif Italic (Google Fonts, OFL) — **una palabra clave por titular** como máximo (*hogar*, *Paraguay*, *home*).

**Character:** geometría europea y serena con una sola voz cálida. Clash Display da al wordmark "Edennia" un cuerpo moderno y alto que se lee aun parcialmente tapado por la casa; General Sans comparte su ADN pero se suaviza a tamaños de texto; la itálica serif es la única concesión al trazo caligráfico del logo.

**Par A confirmado por el cliente (2026-11-01).** Descartado: Cabinet Grotesk + Switzer + Zodiak (más sobrio, pero el wordmark perdía personalidad).

**Archivos (verificado en Fase 2):** fuentes variables autoalojadas en `packages/ui/src/fonts/` (Clash Display y General Sans, 200–700) e Instrument Serif vía `next/font/google` sin precarga. Cobertura comprobada para ñ, á–ú, ü, ß, ç, œ, €. **No incluyen** el signo ₲ ni cifras tabulares (`tnum`, dígitos proporcionales):
- Guaraníes se escriben "Gs." o "PYG" (lo que da `Intl.NumberFormat`), nunca ₲.
- Cifras que deben alinearse (columnas de tablas, KPIs del panel) usan `font-numeric tabular-nums` (pila del sistema). Precios sueltos en la web pública siguen en General Sans.

### Hierarchy
- **Wordmark** (600, `clamp(5.5rem, 22vw, 21rem)`, 0.85): solo "Edennia" en el hero. Uno por sitio.
- **Display** (500, `clamp(2.75rem → 5.5rem)`, 1.0): titular de sección principal en la Home, titular de páginas *Invertir*/*Residencia*.
- **Headline** (500, `clamp(2rem → 3.5rem)`, 1.05): títulos de sección; título de la ficha de propiedad.
- **Title-lg** (500, `clamp(1.5rem → 2.25rem)`, 1.15): precios destacados, títulos de tarjeta grande, KPIs del dashboard.
- **Title** (500, 1.25rem, 1.3): títulos de tarjeta, encabezados de formulario y de módulos del panel.
- **Body-lg** (400, `clamp(1.0625rem → 1.25rem)`, 1.6): entradillas y descripciones de propiedad. Máx. 65ch.
- **Body** (400, 1rem, 1.6): texto general y formularios. Nunca menor de 16px en inputs (evita zoom en iOS).
- **Small** (400, 0.875rem, 1.5): metadatos, ayudas, celdas de tabla del panel.
- **Label** (500, 0.75rem, tracking 0.12em, MAYÚSCULAS): etiquetas de sección, kicker, microcopys del hero. Eco de "HOMES".

### Named Rules
**The One Italic Rule.** La serif itálica aparece como máximo una vez por titular y nunca en párrafos, botones ni en el panel admin.

**The Expansion Rule.** Todo texto de UI se diseña para +35 % de longitud (inglés→alemán). Ningún botón ni chip tiene ancho fijo.

## Layout

- **Contenedor:** ancho máx. 1440px, márgenes laterales `gutter` (16→48px). Bloques de lectura a 65ch.
- **Ritmo vertical:** escala de 4px; separación entre secciones de la Home `section` (80→160px). Más espacio sobre un título que debajo.
- **Rejilla:** 12 columnas en desktop, 4 en móvil. Las secciones rompen la rejilla con medios a sangre cuando la foto lo merece.
- **Breakpoints:** sm 640 · md 768 · lg 1024 · xl 1280 · 2xl 1536 (los de Tailwind).
- **Explorador:** desktop ≥1280 filtros (280px, colapsable) | resultados (fluido) | mapa (≈45 %); tablet: filtros en drawer, resultados | mapa; móvil: lista o mapa con bottom sheet.
- **Ficha:** contenido (≈8 col.) + tarjeta sticky (≈4 col.) en desktop; en móvil la tarjeta se convierte en barra inferior fija con precio + "Me interesa".
- **Panel:** sidebar 264px (colapsable a 72px) + contenido fluido; densidad media, cifras alineadas a la derecha.
- **Objetivo táctil** ≥44×44px en web pública y ≥40×40px en el panel.

## Elevation & Depth

Sistema **plano por defecto**. La profundidad la dan la fotografía, las capas del hero y el contraste `paper`/`white`/`sand-100`. La sombra solo significa "esto flota sobre otra cosa": buscador sobre el hero, tarjeta sticky, mini-card del mapa, menús, modales.

### Shadow Vocabulary
- **xs** (`0 1px 2px rgb(18 20 17 / 0.04)`): separación mínima de tarjetas sobre `paper`.
- **sm** (`0 2px 8px -2px rgb(18 20 17 / 0.06), 0 1px 2px rgb(18 20 17 / 0.04)`): hover de tarjetas.
- **md** (`0 12px 32px -12px rgb(15 61 36 / 0.18), 0 2px 6px rgb(18 20 17 / 0.05)`): elementos flotantes (buscador, tarjeta sticky, mini-card del mapa, dropdowns).
- **lg** (`0 24px 64px -24px rgb(15 61 36 / 0.28)`): modales, lightbox, bottom sheet.

### Named Rules
**The Flat-By-Default Rule.** Nada tiene sombra en reposo salvo lo que flota. Ninguna sombra con color que no sea `ink` o `forest-900`.

**The Glass Once Rule.** El vidrio translúcido (`backdrop-filter`) se usa solo en la nav en píldoras y la etiqueta de la casa del hero, nunca en tarjetas.

## Shapes

- **Medios y tarjetas grandes:** 24px (`xl`): galería, carrusel de destacadas, imagen del hero.
- **Tarjetas y paneles:** 16px (`lg`): tarjetas de resultado, tarjeta sticky, KPIs.
- **Controles:** 12px (`md`) para inputs, selects y botones de formulario; 8px (`sm`) en celdas, tooltips y elementos del panel.
- **Píldoras** (`pill`): nav del hero, chips, filtros rápidos, badges de estado, pines del mapa.
- Bordes de 1px; nunca dobles. Las imágenes dentro de tarjetas heredan el radio del contenedor menos el padding.

## Components

> Implementados en `packages/ui/src/` (Fase 2) y visibles en `/styleguide` (solo desarrollo). Clases combinadas con `cn()` (clsx + tailwind-merge configurado con la escala tipográfica y `rounded-pill` propias). Ningún componente tiene ancho fijo (The Expansion Rule).

### Buttons
Firme y sobrio: el verde bosque es la única voz de acción.
- **Shape:** esquinas suaves (`md`, 12px); `whitespace-nowrap`, crece con el texto.
- **Primary:** fondo `forest-900`, texto blanco; hover `forest-600` (200ms, `ease-soft`).
- **Secondary:** borde 1px `line-strong`, texto `ink`; hover fondo `sand-100`.
- **Ghost:** sin borde, texto `ink`; hover fondo `sand-100`.
- **Tamaños:** `lg` 48px / texto `body` (web, por defecto) · `md` 40px / texto `small` (panel).
- **Disabled:** 50 % de opacidad y sin eventos. **Foco:** anillo global 2px `forest-600` con 2px de separación.
- **WhatsApp:** variante secondary con icono; el verde de WhatsApp **no** se usa (choca con la marca).

### Chips
- **Estático** (sin `selected`): `<span>` píldora con borde `line`, texto `small` — características de una propiedad.
- **Toggle** (`selected` booleano): `<button aria-pressed>`; seleccionado = `forest-900` sólido con texto blanco; no seleccionado = borde `line-strong`, hover `sand-100` — filtros y pestañas de tipo.

### Badges
- Píldora `label` en mayúsculas. Tonos: `available` (`forest-900` sobre `status-available-bg`), `reserved` (`status-reserved-text` sobre `status-reserved-bg`), `sold` (`ink` sobre `status-sold-bg`), `neutral` (`ink` sobre `sand-100`, p. ej. "Residencia incluida").

### Cards / Containers
- **Card:** `lg` (16px), fondo `white`, `shadow-xs`, padding 24px. Nunca tarjetas anidadas.
- **Container:** ancho máx. `site` (1440px), centrado, márgenes `gutter` (16→48px).

### Inputs / Fields
- **Style:** 48px de alto, `md`, fondo `white`, borde 1px `line-strong` (≥3:1), texto `body` (16px: sin zoom en iOS), placeholder `stone-500`.
- **Error:** prop `invalid` → `aria-invalid` + borde `danger`; el mensaje va en un elemento enlazado con `aria-describedby`, en `danger`.
- **Disabled:** 50 % de opacidad.

### Logo
- **Inventario:** PNG 3D originales en `docs/brand/` + **SVG planos** en `packages/ui/src/logo/`: `lockup` (completo) y `emblem` (techo + ventana + hoja, recortado del propio logo), cada uno en `forest` (`#0F3D24`) y `white`. Vectorizados con potrace sobre el alfa de `logo-color.png` y optimizados con svgo; se pierden solo las venas internas de la hoja.
- **Componente:** `<Logo variant="lockup|emblem" tone="forest|white" />` sirve el SVG como archivo estático (`next/image`, sin entrar al bundle JS); altura por defecto 40px, `preload` para el header.
- **Dónde va cada versión:**
  - *Plana* → header compacto, footer, favicon (solo emblema), emails, Open Graph, panel admin.
  - *3D* → solo en el panel de foto del login y en el footer grande, a ≥240px de ancho, nunca sobre foto sin velo.
  - *Hero (decisión B)* → mientras el wordmark gigante está en pantalla, la nav muestra **solo el emblema**; al pasar el hero, el header compacto muestra el lockup plano. Nunca dos "Edennia" simultáneos en el viewport.
- **Tamaño mínimo:** lockup 120px de ancho; emblema 24px. **Área de respeto:** la altura de la "H" de HOMES por cada lado.
- **Prohibido:** recolorear la versión 3D, estirar, añadir sombras, rotar, poner sobre `leaf-400`.

### Superficies del navegador
- Selección de texto `leaf-400` con texto `ink` (8.0:1); cursor de texto `forest-600`; `accent-color` `forest-900` en checkboxes/radios nativos.

### Iconografía (se instala con el primer uso, Fase 4)
- **Lucide** en ambas apps (ya es la de shadcn/ui → una sola dependencia), trazo 1.5px, 20px en web / 18px en panel, color heredado del texto.
- Iconos de características: `BedDouble`, `Bath`, `Ruler`/`Maximize`, `Car`, `CalendarDays`; amenidades con el glifo más cercano y, si falta (p. ej. quincho), un SVG propio con el mismo trazo.
- Ningún icono sin etiqueta visible o `aria-label`.

### Pines del mapa (se construyen en la Fase 6)
- Píldora `forest-900` con precio abreviado en blanco (p. ej. "USD 185k"); seleccionado/hover: `leaf-400` con texto `ink` y escala 1.08; clusters: círculo `white` con borde `forest-900` y número.

## Motion

Principio: **lento, suave y prescindible**. El contenido es visible sin JavaScript y sin animación; GSAP solo añade.

- **Easing base:** `power3.out` (CSS: `cubic-bezier(0.215, 0.61, 0.355, 1)`); transiciones bidireccionales `power3.inOut`. Nada de rebotes ni `elastic`.
- **Duraciones:** micro (hover, foco) 150–200ms en CSS · UI (menús, drawers, tabs) 300ms · reveals al scroll 0.8–1.2s · Flip de galería→lightbox 0.6s.
- **Hero:** letras del wordmark con SplitText (stagger 0.04–0.06s por carácter, desde `y: 40%` + opacidad), la casa sube con fade (1.2s, 0.3s después), microcopys al final. Intro total ≤1.8s. Parallax con ScrollTrigger `scrub`: wordmark 0→−4 %, casa 0→−10 %. La imagen LCP **no** espera a la animación.
- **Scroll:** Lenis (lerp 0.1) sincronizado con ScrollTrigger; desactivado en el panel admin.
- **Contadores:** solo para cifras reales de la BD; 1.2s, una vez.
- **Reduced motion (`gsap.matchMedia`):** sin SplitText, sin parallax, sin Lenis (scroll nativo), sin Flip; reveals reemplazados por fundido de 0.2s o nada. Carruseles sin autoplay.
- **Panel admin:** solo transiciones de UI (≤300ms). Sin reveals al scroll.
- **Cleanup:** toda animación en React via `useGSAP` con scope; nada de animaciones huérfanas entre rutas.

## Do's and Don'ts

### Do:
- **Do** usar fotografía real del inventario (subida desde el admin) en hero, tarjetas y ficha; placeholder `sand-100` + emblema si falta.
- **Do** mantener un solo acento verde dominante por viewport (The One Leaf Rule).
- **Do** usar `forest-900` para todo lo accionable principal y `stone-500` (no un gris arbitrario) para lo secundario.
- **Do** reservar `leaf-400` para detalles no textuales o texto sobre `forest-900`.
- **Do** dejar respirar: `section` entre bloques de la Home; 65ch máx. en textos.
- **Do** mostrar precio con moneda explícita ("USD 185.000") y, si existe tasa, el aproximado en EUR en `stone-500`.

### Don't:
- **Don't** mostrar el logo caligráfico y el wordmark gigante a la vez en el mismo viewport.
- **Don't** usar `leaf-400` como color de texto sobre fondos claros ni texto blanco sobre él.
- **Don't** inventar logos de "confían en nosotros", testimonios, contadores ni badges de descuento/urgencia.
- **Don't** usar gradientes, glassmorphism en tarjetas, ni sombras de color que no sean `ink`/`forest-900`.
- **Don't** usar Inter ni la tipografía del sistema como display en la web pública.
- **Don't** usar el verde de WhatsApp, el púrpura de la ref. 01, el marrón de la ref. 02 ni el naranja de la ref. 03.
