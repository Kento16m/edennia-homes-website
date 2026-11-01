# Análisis de referencias

> Las 7 referencias son shots de Dribbble de otros autores. Son **dirección** (estructura, ritmo, jerarquía, interacción), nunca piel. La piel es de Edennia: verde del logo, naturaleza, calma (ver `docs/DESIGN.md`).
> Regla transversal derivada de `docs/PRODUCT.md`: **nada inventado**. Cualquier elemento de una referencia que dependa de prueba social, cifras o urgencia que Edennia aún no tiene, no se toma.

Archivos: `docs/references/01…07`. (El 03 se llama `03-listado-flitros-reall.png` — errata respecto al MASTERPLAN; no afecta.)

---

## 01 · Listado con mapa — "Humee" → Explorador

**Qué es:** app de alquileres. Mapa a la izquierda (≈40 %), resultados a la derecha; fila de filtros en dropdowns; barra con contador + orden; tarjetas horizontales (foto izq., datos der.).

**Tomamos**
- **Barra contador + orden** sobre los resultados ("980 Properties · Sort by"): orienta sin ocupar espacio.
- **Tarjeta horizontal densa**: precio como dato principal → dirección → fila de specs con iconos (dorm · baños · m²). Buena jerarquía para escanear.
- **Corazón de favorito sobre la foto**, esquina superior.
- Mapa como **columna completa de altura de viewport**, siempre visible mientras se scrollea la lista.

**No tomamos**
- Púrpura/azul eléctrico y pines-punto azules sin información → nuestros pines llevan **precio** y color de marca.
- Botón "Contact Property" + teléfono **en cada tarjeta**: ruido repetido; la tarjeta entera es el enlace y el contacto vive en la ficha.
- Rangos de precio de alquiler ("$3,098 – $9,786/mo"): Edennia vende, precio único.
- El marco de "app flotante" con borde redondeado alrededor de toda la UI (es presentación de Dribbble, no producto).

---

## 02 · Detalle de propiedad → Ficha

**Qué es:** ficha de hotel/alquiler vacacional con checkout. Galería bento, título, dirección, chips, iconos de features, pestañas, mini-mapa, tarjeta lateral de reserva y pago.

**Tomamos**
- **Galería bento**: 1 imagen grande + composición de 3 → lightbox. Da peso a la fotografía desde el primer viewport.
- **Bloque de identidad**: título grande → dirección en gris → **chips** de estilo/amenidad.
- **Fila de características con icono + etiqueta** (aquí: dorm., baños, m², cochera, año).
- **Pestañas** Descripción / Características / Tour virtual / Ubicación (sin "Reviews").
- **Mini-mapa junto a la descripción**, no relegado al final.
- **Tarjeta lateral sticky** con jerarquía precio → estado → acción. Es el patrón correcto; cambiamos su contenido.

**No tomamos**
- Todo el **checkout/pago** (check-in, extras, tarjeta, "Pay Now"): Edennia no cobra online; la tarjeta lateral es el **formulario de interés + WhatsApp + asesor**.
- Pestaña **Reviews**: no hay reseñas reales que mostrar.
- Badge de **descuento "10% Off"** y desglose de tarifas: urgencia/comercio que no aplica.
- Paleta **marrón/beige** como acento. Conservamos solo la idea de un fondo cálido (`sand`) en zonas de calma; el acento es verde.
- La barra lateral de iconos de la izquierda (es navegación de app de reservas).

---

## 03 · Listado con filtros — "Reall" → Explorador (estructura principal)

**Qué es:** buscador con **3 columnas**: filtros | resultados | mapa, con mini-card emergente sobre el mapa.

**Tomamos** (es la referencia estructural más cercana a lo que necesitamos)
- **Layout filtros | resultados | mapa** en desktop.
- **Tipo de propiedad como tarjetas con icono** (Casa / Apartamento / Condominio); el estado **seleccionado en verde oscuro sólido** encaja de forma natural con `forest-900`.
- **Rango de precio**: slider doble + dos inputs numéricos.
- **Steppers − n +** para dormitorios y baños.
- Rango de superficie y **checkboxes de amenidades** ("Additional conveniences" → piscina, quincho, seguridad 24 h, mascotas, amoblado).
- **Contador "Search results 547" + orden** en la cabecera de resultados.
- **Mini-card sobre el mapa** al hacer click en un pin: foto + precio + dirección.
- Tarjeta de resultado con **marcador/favorito** a la derecha del título.

**No tomamos**
- **Botones "Ok"** para aplicar precio/área: el filtro aplica en vivo (con debounce) y escribe la URL. Menos pasos.
- Filtro **"Rental period"** y la navegación Buy / Rent / Sell / Rent out: v1 es solo venta.
- **Puntos naranjas** en el mapa: sustituidos por pines con precio en verde de marca y clusters.
- Precio "/month".

---

## 04 · Landing hero — "nuffo" → Home: hero y "Por qué Edennia"

**Qué es:** hero con **wordmark gigante detrás de una casa recortada**, nav en píldoras, microcopys laterales, dirección arriba a la derecha; debajo, logos "Trusted by", "Why choose us" con imágenes escalonadas, "Who we are", galería oscura "Looks".

**Tomamos**
- **El efecto de profundidad por capas** (decisión del cliente, hero B): cielo/fondo → **"Edennia" gigante** → casa recortada superpuesta → UI. Es el momento memorable del sitio.
- **Nav en píldoras** sobre la imagen.
- **Microcopys a un lado** en tres líneas cortas (estilo "Excelencia // Vida moderna //") → en Edennia, con contenido propio (p. ej. *Asunción // Residencia // Inversión*), traducibles.
- **Dirección física arriba a la derecha**: Edennia tiene una real (Teniente Malutín 516, Villa Morra) y suma confianza.
- **Etiqueta translúcida anclada a la casa** ("Living Room · dirección"): en Edennia, la etiqueta de la propiedad del hero (zona + enlace a su ficha).
- **Trío de imágenes escalonadas** con numeración (`\01`, `\02`) para "Por qué Edennia".

**No tomamos**
- **"Trusted by" con logos**: Edennia no tiene clientes ni prensa todavía. Prohibido rellenarlo.
- **Mar y playa**: Asunción no tiene costa; la casa del hero es una propiedad real del inventario (subida desde el admin).
- Iconos sociales verticales flotando sobre el hero (van al footer).
- Emoji "🔥" y el bloque oscuro "Looks" como galería decorativa sin función.
- **Que la casa tape tanto el wordmark que deje de leerse**: en Edennia la casa cubre solo la franja inferior de las letras; la "E" inicial y la "a" final deben quedar legibles.

---

## 05 · Landing — "EstateEdge" → Home: "Quiénes somos" y Destacadas

**Qué es:** hero con titular centrado sobre foto; "Who we are" con texto a la izquierda y **carrusel con bordes difuminados**; "Featured Deals" como **carrusel acordeón** (una tarjeta expandida + varias estrechas).

**Tomamos**
- **"Quiénes somos" con carrusel lateral de bordes difuminados**: la imagen activa nítida, las vecinas asomando borrosas. Sugiere "hay más" sin flechas gritonas.
- **Carrusel acordeón de destacadas**: una propiedad expandida con dirección + precio sobre la foto, las demás como columnas estrechas que se expanden al hover/foco/tap.

**No tomamos**
- **Tono "Secure Your Share of Elite Property"**: promesa de inversor élite, hype. La voz de Edennia es cercana y transparente.
- **Hero de titular centrado sobre foto genérica**: el hero de Edennia es el de capas (ref. 04).
- La pastilla de teléfono como único CTA del header.

---

## 06 · Dashboard → Panel admin

**Qué es:** dashboard inmobiliario con saludo, sidebar con avatar, banner promocional, KPIs con % de variación, gráfico de líneas, tabla de ventas con estados, lista de propiedades, mapa de ventas por región.

**Tomamos**
- **Saludo personal + avatar en el sidebar**; navegación vertical con iconos y "Logout" separado abajo.
- **Tarjeta KPI**: etiqueta → cifra grande → **variación % vs. período anterior**.
- **Tabla con pills de estado** (en Edennia: etapas del lead / estados de propiedad).
- **Mapa por zona** como widget (→ mapa de demanda vs. inventario).
- Columna lateral derecha con lista corta de propiedades (→ "salud del inventario" / top vistas).

**No tomamos**
- **Banner promocional con la casa en la mano**: un panel interno no se publicita a sí mismo; ese espacio es para "lo que hay que hacer hoy" (leads sin responder).
- **KPIs centrados en ingresos/gastos**: la métrica norte es **leads calificados y tiempo de primera respuesta**.
- Fondos de tarjeta pastel distintos sin significado (gris, menta): el color en el panel solo codifica estado.
- Gráfico de dos líneas sin contexto de objetivo.

---

## 07 · Login — "Realnest" → Admin `/login`

**Qué es:** split screen: foto arquitectónica a la izquierda con frase y puntos de carrusel; formulario a la derecha.

**Tomamos**
- **Split screen** foto | formulario, con **frase de marca** e **indicador de carrusel** (3 imágenes) sobre la foto.
- Formulario mínimo: email, contraseña con **mostrar/ocultar**, "Recordarme", "¿Olvidaste tu contraseña?", botón primario a ancho completo.
- El logo de marca arriba a la izquierda sobre la foto (aquí sí cabe la versión 3D blanca: es un momento de marca, sin competencia fotográfica de contenido).

**No tomamos**
- **Login social** (Google/Facebook) y **"Register"**: no hay registro público; los usuarios los invita un admin.
- Botón "Sign in" redundante arriba a la derecha.
- "Welcome Back to Realnest!" con exclamación → saludo sobrio, bilingüe.
- Botón primario negro: en Edennia es `forest-900`.

---

## Síntesis: lo que hace a Edennia distinta de las 7

1. **Verde, no neutro-con-acento-genérico.** Ninguna referencia usa verde como identidad; Edennia sí (logo).
2. **El país como protagonista secundario.** Ninguna referencia explica un destino. Edennia vende *Paraguay* además de casas: secciones de inversión y residencia que las referencias no tienen.
3. **Contacto remoto primero.** Las referencias asumen visita/compra local; Edennia pone WhatsApp y videollamada en primer plano.
4. **Honestidad visible.** Sin logos de confianza, reseñas, descuentos ni contadores inventados: el espacio que otras llenan con prueba social, Edennia lo usa para explicar el proceso.
