# Shape · Home `/[locale]`

**Modo:** Persuade · **Refs:** 04 (hero, "por qué"), 05 (quiénes somos, destacadas) · **Fase:** 5

## Job y audiencia
Un europeo (sobre todo de España) llega sin saber casi nada de Paraguay ni de Edennia. En segundos debe entender: *quiénes son, qué hacen por mí, por qué Paraguay, y cómo hablo con ellos*. Visitante secundario: comprador local que va directo al buscador.

## Resultado
- Acción primaria: **explorar propiedades** (buscador) o **agendar videollamada / escribir por WhatsApp**.
- Éxito: el visitante abre el explorador con filtros, o inicia contacto. Métrica: CTR del buscador y leads con fuente "home".

## Dirección
Hero en capas (decisión B) como momento memorable; después, la página alterna **inspiración (fotos)** y **explicación (país, proceso)**, porque para este público la confianza viene de entender. El orden del MASTERPLAN §4.1 se ajusta (propuesta) para meter *Por qué Paraguay* y *Cómo comprar desde Europa*, y la franja de cifras se rehace sin datos inventados.

## Wireframe (desktop 1440)

```
┌──────────────────────────────────────────────────────────────────────┐
│ [emblema]  (Inicio)(Propiedades)(Invertir)(Residencia)(Nosotros)      │  nav en píldoras (glass)
│                                         ES|EN   [WhatsApp] [Contactar]│
│ ASUNCIÓN //                                      Teniente Malutín 516 │  label + dirección real
│ RESIDENCIA //                                    Villa Morra, Asunción│
│ INVERSIÓN //                                                          │
│ ███████ E D E N N I A ████████  ← wordmark gigante (22vw)             │
│ ████████▓▓▓▓▓[ casa recortada ]▓▓▓▓▓█████  ← casa tapa la franja baja │
│                 ┌──────────────┐                                      │
│                 │ Villa Morra ↗│ ← etiqueta glass → ficha de la casa  │
│                 └──────────────┘          Tu *hogar* en Paraguay,     │
│                                           acompañado desde España. →  │
├──────────────────────────────────────────────────────────────────────┤
│   ┌ BUSCADOR flotante (white, shadow md, xl) ──────────────────────┐  │  solapa el borde del hero
│   │ [Casas] [Apartamentos] [Condominios]                           │  │
│   │ Zona ▾        Presupuesto (USD) ▾           [ Explorar → ]     │  │
│   └────────────────────────────────────────────────────────────────┘  │
├──────────────────────────────────────────────────────────────────────┤
│ DATOS QUE IMPORTAN  (sin contadores inventados)                       │
│  0 %  impuesto a rentas   │ Residencia  gestionada   │ 37 propiedades │
│  del exterior*            │ con tu compra*           │ disponibles ←BD│
│  * fuente + fecha, enlace a /invertir                                 │
├──────────────────────────────────────────────────────────────────────┤
│ QUIÉNES SOMOS                     ┌────┐┌──────────┐┌────┐            │  ref 05: carrusel
│ Un equipo español en Asunción…    │blur││  foto    ││blur│  ← →       │  bordes difuminados
│ [Conócenos →]                     └────┘└──────────┘└────┘            │
├──────────────────────────────────────────────────────────────────────┤
│ POR QUÉ PARAGUAY   (sección forest-900, texto blanco, acento leaf)    │
│  Fiscalidad │ Residencia │ Estabilidad │ Ubicación     [Ver guía →]   │
├──────────────────────────────────────────────────────────────────────┤
│ DESTACADAS  (acordeón ref 05, is_featured)                            │
│ ┌───────────────────────────┐┌──┐┌──┐┌──┐                             │
│ │ foto expandida            ││  ││  ││  │  ← columnas estrechas       │
│ │ Zona · USD 185.000 ≈ €…   ││  ││  ││  │    se expanden hover/foco   │
│ └───────────────────────────┘└──┘└──┘└──┘                             │
├──────────────────────────────────────────────────────────────────────┤
│ EXPLORA POR ZONA   [Villa Morra 12] [Carmelitas 5] [Luque 8] …        │  tarjetas foto + nº (BD)
├──────────────────────────────────────────────────────────────────────┤
│ CÓMO COMPRAR DESDE EUROPA   01 Videollamada → 02 Selección → 03 Visita│
│                             → 04 Compra y escritura → 05 Residencia   │
├──────────────────────────────────────────────────────────────────────┤
│ POR QUÉ EDENNIA  (trío escalonado ref 04: \01 \02 \03)                │
├──────────────────────────────────────────────────────────────────────┤
│ TESTIMONIOS  ← SOLO si hay ≥1 testimonio publicado en BD; si no, no existe
├──────────────────────────────────────────────────────────────────────┤
│ CTA FINAL  "Hablemos por videollamada"  [Agendar] [WhatsApp]          │
│ FOOTER grande: logo 3D/plano, contacto, zonas, redes, idioma, legal   │
└──────────────────────────────────────────────────────────────────────┘
```

## Estados
- **Carga:** el HTML llega renderizado (RSC); la imagen del hero es LCP con `priority`. Destacadas y zonas con skeleton solo si se hidratan en cliente.
- **Sin destacadas:** la sección se oculta (no se rellena con "próximamente").
- **Sin imagen de hero recortada en BD:** fallback a foto completa de la propiedad con velo y wordmark encima (sin efecto de profundidad), nunca un gradiente.
- **Sin testimonios:** sección ausente.
- **Datos fiscales sin fuente/fecha:** el bloque no se publica (validación en admin).
- **Error de BD:** página estática cacheada (ISR) sigue sirviendo; secciones dinámicas fallan en silencio, nunca con trazas.

## Móvil (390)
- Wordmark a 22vw ocupa el ancho; la casa debajo, cubriendo solo la base de las letras. Microcopys y dirección pasan bajo el hero.
- Nav → emblema + botón menú (sheet a pantalla completa) + WhatsApp siempre visible.
- Buscador: pestañas en scroll horizontal, campos apilados, botón a ancho completo.
- Carrusel quiénes somos y destacadas: swipe; el acordeón se convierte en carrusel de tarjetas con peek.
- Proceso de 5 pasos en lista vertical con línea conectora.

## Restricciones y decisiones abiertas
- Parallax y SplitText desactivados con reduced-motion; LCP < 2.5s en móvil.
- Todos los textos en `messages/{locale}.json`; microcopys del hero traducibles y editables.
- **Abierto:** qué propiedad protagoniza el hero (configurable en `site_settings` desde el admin) y texto final de los microcopys.
