import { Badge, Button, Card, Chip, Container, Input, Logo } from '@edennia/ui'
import { notFound } from 'next/navigation'
import type { ReactNode } from 'react'

// Internal dev page: the only place allowed hardcoded copy (no i18n).
export const metadata = { title: 'Styleguide · Edennia', robots: { index: false } }

const colors = [
  ['forest-900', '#0F3D24', 'Primario · blanco encima 12.3:1'],
  ['forest-600', '#1E7A3E', 'Hover, enlaces · sobre paper 5.1:1'],
  ['leaf-400', '#5FBF4A', 'Solo detalles · nunca texto sobre claro'],
  ['sand-100', '#F3EFE7', 'Fondos cálidos'],
  ['paper', '#FAFAF7', 'Fondo base'],
  ['white', '#FFFFFF', 'Superficies flotantes'],
  ['ink', '#121411', 'Texto · 17.7:1 sobre paper'],
  ['stone-500', '#656962', 'Secundario · 4.9:1 sobre sand'],
  ['line', '#E4E1D9', 'Divisores'],
  ['line-strong', '#868A82', 'Bordes de control · ≥3:1'],
  ['danger', '#B42318', 'Error · 6.3:1 sobre paper'],
] as const

const swatchBg: Record<(typeof colors)[number][0], string> = {
  'forest-900': 'bg-forest-900',
  'forest-600': 'bg-forest-600',
  'leaf-400': 'bg-leaf-400',
  'sand-100': 'bg-sand-100',
  paper: 'bg-paper',
  white: 'bg-white',
  ink: 'bg-ink',
  'stone-500': 'bg-stone-500',
  line: 'bg-line',
  'line-strong': 'bg-line-strong',
  danger: 'bg-danger',
}

const type = [
  ['text-display font-display', 'Display'],
  ['text-headline font-display', 'Headline'],
  ['text-title-lg', 'Title large · USD 185.000'],
  ['text-title', 'Title'],
  ['text-body-lg', 'Body large — Casa con jardín en Villa Morra, a diez minutos del centro.'],
  ['text-body', 'Body — Te acompañamos en cada paso de la compra y de tu residencia.'],
  ['text-small text-stone-500', 'Small — Zona aproximada · Asunción'],
  ['text-label uppercase text-stone-500', 'Label · Asunción // Residencia'],
] as const

function Section({ title, children }: { title: string; children: ReactNode }) {
  return (
    <section className="border-t border-line pt-12 pb-16">
      <h2 className="mb-8 text-title-lg font-display">{title}</h2>
      {children}
    </section>
  )
}

export default function Styleguide() {
  if (process.env.NODE_ENV === 'production') notFound()

  return (
    <main className="py-16">
      <Container>
        <div className="mb-16 flex flex-wrap items-end justify-between gap-8">
          <h1 className="text-headline font-display">Styleguide</h1>
          <Logo variant="lockup" tone="forest" className="h-20 w-auto" priority />
        </div>

        <Section title="Color">
          <ul className="grid grid-cols-2 gap-6 sm:grid-cols-3 lg:grid-cols-4">
            {colors.map(([name, hex, use]) => (
              <li key={name}>
                <div className={`mb-3 h-20 rounded-lg border border-line ${swatchBg[name]}`} />
                <p className="text-body font-medium">{name}</p>
                <p className="text-small text-stone-500 tabular-nums">{hex}</p>
                <p className="text-small text-stone-500">{use}</p>
              </li>
            ))}
          </ul>
        </Section>

        <Section title="Tipografía">
          <p className="mb-10 overflow-hidden text-wordmark font-display text-forest-900">Edennia</p>
          <div className="space-y-6">
            {type.map(([cls, sample]) => (
              <p key={cls} className={cls}>
                {sample}
              </p>
            ))}
            <p className="text-headline font-display">
              Tu <span className="font-accent">hogar</span> en Paraguay
            </p>
          </div>
        </Section>

        <Section title="Botones">
          <div className="flex flex-wrap items-center gap-4">
            <Button>Agendar videollamada</Button>
            <Button variant="secondary">Escribir por WhatsApp</Button>
            <Button variant="ghost">Ver todas</Button>
            <Button disabled>Enviando…</Button>
            <Button size="md">Nueva propiedad</Button>
            <Button variant="secondary">Videoanruf mit unserem Team vereinbaren</Button>
          </div>
        </Section>

        <Section title="Campos">
          <div className="grid max-w-xl gap-4">
            <label className="grid gap-2 text-small font-medium">
              Email
              <Input type="email" placeholder="tu@email.com" />
            </label>
            <label className="grid gap-2 text-small font-medium">
              Teléfono (con error)
              <Input invalid defaultValue="12" aria-describedby="phone-error" />
              <span id="phone-error" className="text-danger">
                Introduce un número con prefijo internacional, p. ej. +34 600 000 000.
              </span>
            </label>
            <Input disabled placeholder="Deshabilitado" />
          </div>
        </Section>

        <Section title="Badges y chips">
          <div className="mb-6 flex flex-wrap gap-3">
            <Badge tone="available">Disponible</Badge>
            <Badge tone="reserved">Reservado</Badge>
            <Badge tone="sold">Vendido</Badge>
            <Badge>Residencia incluida</Badge>
          </div>
          <div className="flex flex-wrap gap-3">
            <Chip selected>Casas</Chip>
            <Chip selected={false}>Apartamentos</Chip>
            <Chip selected={false}>Eigentumswohnungen mit Gemeinschaftsgarten</Chip>
            <Chip>Piscina</Chip>
            <Chip>Quincho</Chip>
          </div>
        </Section>

        <Section title="Tarjeta, radios y sombras">
          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
            {(['shadow-xs', 'shadow-sm', 'shadow-md', 'shadow-lg'] as const).map((s) => (
              <Card key={s} className={s}>
                <p className="text-title">{s}</p>
                <p className="text-small text-stone-500">radio lg (16px)</p>
              </Card>
            ))}
          </div>
        </Section>

        <Section title="Logo">
          <div className="grid gap-6 sm:grid-cols-2">
            <div className="flex items-center gap-8 rounded-xl bg-paper p-8 ring-1 ring-line">
              <Logo variant="lockup" tone="forest" className="h-16 w-auto" />
              <Logo variant="emblem" tone="forest" className="h-10 w-auto" />
            </div>
            <div className="flex items-center gap-8 rounded-xl bg-forest-900 p-8">
              <Logo variant="lockup" tone="white" className="h-16 w-auto" />
              <Logo variant="emblem" tone="white" className="h-10 w-auto" />
            </div>
          </div>
        </Section>
      </Container>
    </main>
  )
}
