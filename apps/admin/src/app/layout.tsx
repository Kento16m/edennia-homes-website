import type { Metadata } from 'next'
import { fontVariables } from '@edennia/ui/fonts'
import './globals.css'

export const metadata: Metadata = {
  title: 'Edennia Homes · Panel',
}

export default function RootLayout({ children }: LayoutProps<'/'>) {
  return (
    // shortcut: lang fijo en 'es' hasta que next-intl gestione el idioma (Fase 4)
    <html lang="es" className={fontVariables}>
      <body className="min-h-dvh">{children}</body>
    </html>
  )
}
