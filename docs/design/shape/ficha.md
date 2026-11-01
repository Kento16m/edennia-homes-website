# Shape · Ficha `/[locale]/propiedades/[slug]`

**Modo:** Persuade (con bloques de lectura) · **Ref:** 02 · **Fase:** 7

## Job y audiencia
El visitante evalúa una propiedad concreta y decide si pedir información. El europeo necesita además: precio en algo que entienda (EUR aprox.), si la compra incluye **residencia**, y un contacto que funcione a distancia.

## Resultado
- Acción primaria: **enviar el formulario "Me interesa"**. Secundaria: **WhatsApp** con mensaje prellenado y código de la propiedad.
- Éxito: lead calificado (país, objetivo, canal) con `source = property` y `property_id`.

## Wireframe (desktop 1440)

```
┌ header compacto ────────────────────────────────────────────────────────┐
│ Propiedades / Villa Morra / Casa con jardín…            [♡] [Compartir] │ breadcrumb
├─────────────────────────────────────────────┬───────────────────────────┤
│ ┌────────────────────┐┌─────────┐           │                           │
│ │                    ││         │  BENTO    │ ┌ TARJETA STICKY ───────┐ │
│ │  foto principal    │├────┬────┤  (xl)     │ │ USD 185.000           │ │
│ │                    ││    │ +18│           │ │ ≈ €171.000 aprox.     │ │
│ └────────────────────┘└────┴────┘           │ │ [Disponible] [Residencia│ │
├─────────────────────────────────────────────┤ │  incluida]            │ │
│ (sand-100)                                  │ │ ─────────────────────  │ │
│ Casa con jardín en Villa Morra   (headline) │ │ Me interesa esta      │ │
│ Zona Villa Morra, Asunción  (o exacta)      │ │ propiedad             │ │
│ (Casa)(Moderna)(Piscina)(Quincho)  chips    │ │ Nombre*               │ │
│ 🛏3  🛁2  ⤢180 m²  🚗2  📅2019               │ │ Email*                │ │
├─────────────────────────────────────────────┤ │ WhatsApp/teléfono*    │ │
│ [Descripción][Características][Tour][Ubic.] │ │ País de residencia* ▾ │ │
│ ┌───────────────────────┐ ┌──────────────┐  │ │ Objetivo: ○Invertir   │ │
│ │ texto descripción     │ │  mini-mapa   │  │ │  ○Vivir ○Ambos        │ │
│ │ (body-lg, 65ch)       │ │ (zona aprox. │  │ │ Contacto: WhatsApp ▾  │ │
│ │                       │ │  = círculo)  │  │ │ Interés: Videollamada▾│ │
│ └───────────────────────┘ └──────────────┘  │ │ Franja horaria ▾      │ │
├─────────────────────────────────────────────┤ │ ☐ Me interesa la      │ │
│ PLANO (si existe)                           │ │   residencia          │ │
│ CALCULADORA DE CUOTAS (colapsada)           │ │ Mensaje (prellenado)  │ │
│ [CONDOMINIO: tabla de unidades + avance]    │ │ ☐ Acepto privacidad*  │ │
├─────────────────────────────────────────────┤ │ [Turnstile]           │ │
│ PROPIEDADES SIMILARES  [card][card][card]   │ │ [ Enviar ]            │ │
└─────────────────────────────────────────────┤ │ [Escribir por WhatsApp│ │
                                              │ │ (foto) Ana · Asesora  │ │
                                              │ └───────────────────────┘ │
                                              └───────────────────────────┘
```

- **Galería:** click → lightbox fullscreen (GSAP Flip desde la miniatura), teclado ←/→/Esc, swipe en móvil, contador "4 / 22".
- **Ubicación:** si la propiedad oculta la dirección → círculo de ~500m desplazado, texto "Zona aproximada"; si no, pin exacto.
- **Condominio en preventa (variante):** bloque de proyecto con tabla de unidades (tipología, piso, m², precio, estado), barra de avance de obra (%) y fecha de entrega.
- **Formulario:** campos del MASTERPLAN §4.1 + (propuesta) país de residencia, objetivo, interés en residencia, franja horaria. Mensaje prellenado con el título y código.
- JSON-LD `RealEstateListing`, OG con foto de portada, hreflang al slug traducido.

## Estados
- **Envío:** botón con spinner y deshabilitado; **éxito** reemplaza el formulario por confirmación ("Te escribimos en menos de X h por WhatsApp" + resumen + [Escribir ahora por WhatsApp]); **error de validación** inline por campo + resumen con foco al primer error; **error de red/Turnstile** mensaje arriba del botón, datos conservados.
- **Reservada:** badge ámbar; formulario sigue activo con texto "Avísame si vuelve a estar disponible / ver similares".
- **Vendida:** badge "Vendida"; formulario se convierte en "Busco algo similar" (lead con fuente `property_sold`). Se mantiene publicada por SEO solo si el admin lo decide.
- **Traducción ausente:** contenido en idioma por defecto + aviso discreto "Esta descripción aún no está disponible en inglés".
- **Pocas fotos (1–3):** bento se reduce a 1 grande + las que haya; 0 fotos → placeholder con emblema (y aviso en el panel de salud del inventario).
- **Sin asesor asignado:** tarjeta del equipo genérica "Equipo Edennia".

## Móvil (390)
- Galería como carrusel a sangre con contador; título y precio debajo.
- Tarjeta sticky → **barra inferior fija**: precio + [Me interesa] (abre el formulario en sheet) + icono WhatsApp.
- Pestañas como acordeones apilados.

## Restricciones y decisiones abiertas
- ISR + revalidación on-demand al editar en el admin.
- Envío solo vía Edge Function `submit-lead` (Turnstile, zod, rate-limit). Consentimiento RGPD explícito, no premarcado.
- `property_views` sin datos personales.
- **Abierto:** compromiso de tiempo de respuesta que se muestra tras enviar (depende del equipo); relevancia de la calculadora de cuotas para compradores extranjeros (la mayoría paga al contado) → se deja colapsada.
