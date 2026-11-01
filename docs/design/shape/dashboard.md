# Shape · Dashboard admin `admin.edennia.homes/`

**Modo:** Operate · **Ref:** 06 · **Fase:** 10

## Job y audiencia
- **Admin (dueño):** ¿cómo va el negocio? ¿respondemos rápido? ¿qué inventario falla?
- **Asesor:** ¿a quién tengo que responder **hoy**?
- **Editor:** ¿qué propiedades están incompletas (traducciones, fotos, coordenadas)?

Hoy son 2 asesores en la misma oficina; el diseño debe funcionar con 2 y con 20.

## Resultado
- Primera lectura en **5 segundos: qué hacer hoy** (leads sin responder, con SLA).
- Segunda lectura: tendencia de leads y conversión; dónde hay demanda sin inventario.

## Wireframe (desktop 1440)

```
┌──────────┬────────────────────────────────────────────────────────────────┐
│ (avatar) │ Buenos días, Ana            [⌘K Buscar]   [🔔 3]    [7d|30d|90d|Año]│
│ Ana      ├────────────────────────────────────────────────────────────────┤
│ Asesora  │ HOY ─────────────────────────────────────────────────────────── │
│          │ ⚠ 4 leads sin responder (2 > 2 h)  [Ver]  │ [+ Nueva propiedad] │
│ ▣ Inicio │   · Marta G. · España · Casa Villa Morra · hace 3 h  [WhatsApp]│
│ ⌂ Propie-│   · John P.  · UK     · Condominio Luque   · hace 2 h  [WhatsApp]│
│   dades  ├──────────────┬──────────────┬──────────────┬──────────────────┤
│ ☰ Leads  │ Leads nuevos │ 1ª respuesta │ Activas      │ Vendidas (mes)   │
│ ◎ Zonas  │ 23  ▲ 15 %   │ 1 h 40 ▼ 20 %│ 37 · 4 reserv│ 2 · USD 410k     │
│ ☆ Testim.│ vs 30d prev. │ (mejor = ▼)  │ por tipo ▸   │ días en mercado 48│
│ 🌐 Idiomas├──────────────┴──────────────┴──────┬───────┴──────────────────┤
│ 👥 Usuar.│ LEADS Y VENTAS POR MES (barras+línea)│ EMBUDO                   │
│ 🕘 Audit.│                                      │ Lead 120 ▸ Contactado 96 │
│ ⚙ Ajustes│                                      │ ▸ Visita 31 ▸ Negoc. 9   │
│          │                                      │ ▸ Cerrado 4              │
│          ├──────────────────────────────────────┼──────────────────────────┤
│          │ ORIGEN DE LEADS                      │ MAPA DE DEMANDA          │
│          │ País: España 58 % · Alemania 9 % …   │ zonas: leads vs inventario│
│          │ Fuente: ficha · WhatsApp · contacto  │ (coroplético + tabla)    │
│          │ Idioma: ES · EN                      │                          │
│          ├──────────────────────────────────────┼──────────────────────────┤
│          │ TOP PROPIEDADES  vistas | leads | ratio  ⚠ ratio alto = precio?│
│          ├──────────────────────────────────────┬──────────────────────────┤
│ [Salir]  │ SALUD DEL INVENTARIO                 │ ASESORES (≥2 usuarios)   │
│          │ 3 sin traducción EN · 2 con <5 fotos │ atendidos · cierres · 1ª │
│          │ 1 sin coordenadas · 5 sin tocar 60 d │ respuesta media          │
└──────────┴──────────────────────────────────────┴──────────────────────────┘
```

- **Nuevo vs MASTERPLAN (propuesta):** desglose de leads por **país de residencia** (clave para un negocio orientado a Europa) y SLA visible en "Hoy".
- KPI con variación vs período anterior; la flecha se colorea por **bueno/malo**, no por subir/bajar (bajar el tiempo de respuesta es verde).
- Gráficos siguiendo la skill `dataviz`: un color de marca por serie, ejes sobrios, tooltips con valores exactos, tabla accesible alternativa.
- Todo calculado con vistas/funciones SQL (Fase 3), nunca en el cliente.

## Variantes por rol
- **Asesor:** "Hoy" y KPIs solo con **sus** leads (RLS); sin ranking de asesores ni valor total del inventario.
- **Editor:** sin leads; ve "Salud del inventario" ampliado y traducciones pendientes por idioma.
- **Admin:** todo.

## Estados
- **Carga:** skeleton por widget (misma geometría); cada widget carga y falla de forma independiente (Suspense por bloque).
- **Vacío (BD recién creada):** "Hoy" → "Todo respondido. No hay leads pendientes."; gráficos sin datos → mensaje + acción ("Publica tu primera propiedad"); ranking oculto con <2 asesores.
- **Error de un widget:** tarjeta con "No se pudo cargar" + [Reintentar]; el resto sigue.
- **Datos insuficientes para comparar** (período anterior vacío): se muestra el valor sin variación y "sin datos previos".
- **Tiempo real:** nuevos leads actualizan "Hoy" y la campana (Supabase Realtime) sin recargar.

## Móvil / tablet
El panel es principalmente de escritorio, pero el asesor responde desde el móvil:
- Móvil: sidebar → menú inferior (Inicio, Leads, Propiedades, Más). Orden de bloques: **Hoy** → KPIs (2×2) → embudo → resto colapsado.
- Tablet: sidebar colapsada a iconos (72px), grilla de 2 columnas.

## Restricciones y decisiones abiertas
- shadcn/ui + Recharts, tokens de `packages/ui`.
- **Abierto:** umbral del SLA (propuesta: 2 h en horario laboral de Asunción) y definición de "horario laboral" para no penalizar leads entrados de madrugada desde Europa.
