# Edennia Homes — Reglas del proyecto

## Contexto
- Plan maestro: docs/MASTERPLAN.md · Producto: docs/PRODUCT.md · Diseño: docs/DESIGN.md
- Si existe graphify-out/GRAPH_REPORT.md, léelo antes de explorar archivos.
- Consulta la memoria del proyecto (Claude-Mem) al empezar cada sesión.

## Arquitectura
- Monorepo pnpm + Turborepo: apps/web (pública), apps/admin (panel), packages/{db,ui,i18n,config}.
- supabase/migrations es la ÚNICA fuente de verdad del esquema. Nunca cambies la BD desde el dashboard de Supabase.
- Tipos de BD solo desde packages/db (generados). Schemas zod compartidos ahí.

## Reglas no negociables
- RLS en todas las tablas. La service_role key solo existe en Edge Functions.
- Cero textos hardcodeados en UI: todo en messages/{locale}.json.
- Contenido traducible siempre en tablas *_translations. Nunca columnas por idioma.
- Los idiomas se leen de la tabla `locales`; nunca asumas solo es/en.
- Tokens de diseño solo desde packages/ui. No inventes colores ni tamaños sueltos.
- Animaciones GSAP con useGSAP y cleanup; siempre respetar prefers-reduced-motion.
- Imágenes con next/image. Nada de layout shift.

## Flujo de trabajo
- Tareas grandes: brainstorming → plan → ejecución (Superpowers). Plan Mode para BD, auth y seguridad.
- Antes de decir "terminado": build + typecheck + lint + tests en verde, y captura de pantalla revisada para cambios de UI (1440px y 390px).
- Commits pequeños con Conventional Commits.
- Si algo falla 2 veces seguidas, para, aplica systematic-debugging y explícame la causa raíz.
