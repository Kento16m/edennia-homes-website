// shortcut: lista estática para el routing de next-intl; la fuente de verdad de idiomas habilitados será la tabla `locales` (Fase 3)
export const locales = ['es', 'en'] as const
export type Locale = (typeof locales)[number]
export const defaultLocale: Locale = 'es'

export function isLocale(value: string): value is Locale {
  return (locales as readonly string[]).includes(value)
}

const present = <T,>(v: T | undefined): v is T => v !== undefined && v !== ''

/** Picks `locale` from a translations map, falling back to `fallback` (default locale) when missing or empty. */
export function getTranslation<T>(
  translations: Partial<Record<string, T>>,
  locale: string,
  fallback: string = defaultLocale,
): { value: T; locale: string; isFallback: boolean } | null {
  const own = translations[locale]
  if (present(own)) return { value: own, locale, isFallback: false }
  const other = translations[fallback]
  if (present(other)) return { value: other, locale: fallback, isFallback: true }
  return null
}
