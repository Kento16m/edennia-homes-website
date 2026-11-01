# Shape · Login admin `admin.edennia.homes/login`

**Modo:** Operate · **Ref:** 07 · **Fase:** 8

## Job y audiencia
Un miembro del equipo (admin, asesor, editor) entra al panel varias veces al día. Debe ser inmediato, seguro y con un momento de marca sobrio. No hay registro público: los usuarios llegan por **invitación**.

## Resultado
- Acción primaria: iniciar sesión. Secundarias: recuperar contraseña; aceptar invitación (crear contraseña).
- Éxito: login en <5s; ningún mensaje revela si un email existe.

## Wireframe (desktop 1440)

```
┌──────────────────────────────────┬───────────────────────────────────┐
│ [logo 3D blanco ≥240px]          │                                   │
│                                  │                                   │
│                                  │   Bienvenido de nuevo (title-lg)  │
│        FOTO ARQUITECTÓNICA       │   Accede al panel de Edennia      │
│        (propiedad real, velo     │                                   │
│         inferior forest-900)     │   Email                           │
│                                  │   [                         ]     │
│                                  │   Contraseña                      │
│  Tu *hogar* en Paraguay,         │   [                     👁 ]      │
│  acompañado desde España.        │   ☐ Recordarme   ¿Olvidaste tu    │
│  ━━ ● ●   ← 3 imágenes, autoplay │                  contraseña?      │
│            lento, pausable       │   [        Entrar         ]       │
│                                  │                                   │
│                                  │   ES | EN                         │
└──────────────────────────────────┴───────────────────────────────────┘
```

- Proporción 50/50 (≥1280) o 45/55. Panel derecho en `paper`, formulario máx. 400px centrado.
- Botón primario `forest-900` a ancho completo. Mostrar/ocultar contraseña con `aria-pressed`.
- Sin login social, sin "Registrarse", sin botón "Sign in" duplicado.
- Opcional (Fase 8, si se confirma): segundo paso TOTP para rol admin con input de 6 dígitos.

## Estados
- **Enviando:** botón con spinner, campos deshabilitados.
- **Credenciales incorrectas:** "Email o contraseña incorrectos." (genérico) sobre el botón, foco al campo email.
- **Demasiados intentos:** "Demasiados intentos. Espera unos minutos o restablece tu contraseña."
- **Usuario desactivado:** mismo mensaje genérico (no revelar estado).
- **Recuperar contraseña:** pantalla con solo email → siempre "Si el email está registrado, recibirás un enlace." 
- **Aceptar invitación / nueva contraseña:** nombre (prellenado), contraseña + confirmación con requisitos visibles en vivo.
- **Sesión expirada:** redirige a `/login?next=…` con aviso "Tu sesión ha caducado".
- **Error de red:** "No pudimos conectar. Revisa tu conexión e inténtalo de nuevo."

## Móvil (390)
Foto como banda superior de 28vh con el logo; formulario debajo a ancho completo. Carrusel sin autoplay.

## Restricciones
- Auth con Supabase SSR (cookies), protección en middleware y en servidor; roles desde el JWT.
- Respetar reduced-motion (carrusel estático).
- Todos los textos del panel en `messages/{locale}.json` (ES por defecto, EN disponible).
