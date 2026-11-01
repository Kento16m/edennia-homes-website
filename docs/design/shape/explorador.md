# Shape · Explorador `/[locale]/propiedades`

**Modo:** Operate (dentro de la web pública) · **Refs:** 03 (estructura), 01 (tarjeta, barra de resultados) · **Fase:** 6

## Job y audiencia
El visitante ya quiere ver casas: filtra por tipo, presupuesto, zona y características, y compara en el mapa dónde está cada una. El europeo no conoce los barrios → el **mapa y las zonas con nombre** le dan contexto; el local filtra rápido.

## Resultado
- Acción primaria: abrir una **ficha**. Secundarias: guardar favorito, compartir la búsqueda (URL), "Buscar en esta zona".
- Éxito: tiempo hasta primera ficha abierta; búsquedas compartidas; cero callejones sin salida.

## Dirección
Estructura de la ref. 03 (filtros | resultados | mapa), tarjeta y barra de la ref. 01, piel Edennia. **La URL es la única fuente de verdad** del estado (`?tipo=casa&min=80000&max=250000&dorm=3&zona=villa-morra&amen=piscina,quincho&orden=precio-asc&bbox=…`).

## Wireframe (desktop ≥1280)

```
┌ header compacto (lockup plano) ─────────────────────────────────────────┐
├───────────────┬──────────────────────────────┬──────────────────────────┤
│ FILTROS  [«]  │ 37 propiedades   Orden: ▾    │                          │
│               │ [chips filtros activos ×]    │        MAPA              │
│ Tipo          │ ┌──────┬───────────────────┐ │   (USD 185k) (USD 240k)  │
│ [■Casa][Apto] │ │ foto │ Casa · Villa Morra│ │        (3)  ← cluster    │
│ [Condominio]  │ │ ‹ › ♡│ USD 185.000 ≈€171k│ │   (USD 95k)              │
│ Precio (USD)  │ │      │ 3 dorm 2 baños 180m²│ │  ┌──────────────┐       │
│ ●━━━━━━━●     │ └──────┴───────────────────┘ │  │foto USD 240k │ ←mini │
│ [80.000][250k]│ ┌──────┬───────────────────┐ │  │Carmelitas  → │  card │
│ Dorm. [−][3][+]│ │ …    │ …                 │ │  └──────────────┘       │
│ Baños [−][2][+]│ └──────┴───────────────────┘ │                          │
│ Superficie m² │  …                            │ [Buscar en esta zona]   │
│ Zona ▾        │  [Cargar más]                 │  aparece al mover mapa  │
│ Amenidades ☐… │                               │                          │
│ ☐ Tour virtual│                               │                          │
│ ☐ Residencia  │                               │                          │
│ [Limpiar]     │                               │                          │
└───────────────┴──────────────────────────────┴──────────────────────────┘
```

- Filtros aplican en vivo (debounce 300ms) y reemplazan la URL (`router.replace`, sin llenar el historial con cada tecla).
- **Nuevo filtro (propuesta):** "Incluye gestión de residencia" (propiedades marcadas en admin).
- Hover/foco en tarjeta → pin resaltado (`leaf-400`); click en pin → mini-card y scroll a la tarjeta.
- Tarjeta entera es el enlace a la ficha; ♡ y flechas del mini-carrusel son botones independientes.
- Precio con moneda explícita y EUR aprox. en `stone-500` si hay tasa.

## Estados
- **Carga inicial:** SSR con los primeros resultados (SEO); al cambiar filtros, skeletons de tarjeta (misma altura → sin CLS) y el mapa mantiene los pines anteriores atenuados.
- **Vacío:** "No hay propiedades con estos filtros" + sugerencias accionables calculadas: "Amplía el presupuesto a USD 300.000 (4 resultados)", "Quita *Piscina* (6 resultados)", [Limpiar filtros]. Nunca solo un texto.
- **Vacío en el área del mapa:** "Nada en esta zona del mapa" + [Ver todas las de Asunción].
- **Error de red/RPC:** banner inline "No pudimos cargar resultados" + [Reintentar]; filtros conservan su estado.
- **Mapa no carga (tiles/WebGL):** la lista funciona sola, el panel del mapa muestra aviso discreto. El mapa se carga diferido (no bloquea LCP).
- **Filtros inválidos en la URL:** se ignoran los inválidos (validación zod), se conserva el resto.
- **Muchos resultados:** clusters al alejar; paginación "Cargar más" (24 por página) con URL `&p=2`.

## Tablet (768–1279)
Resultados | mapa; filtros en drawer lateral con contador en el botón "Filtros (3)".

## Móvil (390)
- Barra superior sticky: [Filtros (3)] [Orden] y toggle **Lista / Mapa**.
- Filtros en sheet a pantalla completa con botón fijo "Ver 37 propiedades".
- Vista mapa: pines + bottom sheet con la tarjeta del pin seleccionado; arrastrar el sheet hacia arriba muestra la lista.
- Tarjeta en vertical (foto arriba).

## Favoritos y comparar
- `/favoritos`: grilla de tarjetas desde `localStorage`; vacío → "Guarda propiedades con ♡ para verlas aquí" + [Explorar].
- `/comparar`: hasta 3 columnas (precio, EUR aprox., m², dorm., baños, zona, amenidades, año, residencia); en móvil, scroll horizontal con primera columna fija.

## Restricciones y decisiones abiertas
- Consulta por bbox con la RPC `search_properties` (PostGIS) → Fase 3.
- Navegación por teclado: filtros, lista y pines accesibles (los pines tienen equivalente en la lista; el mapa no es el único camino).
- **Abierto:** proveedor de tiles (MapTiler vs Mapbox) y estilo del mapa base en tonos `paper`/`sand`.
