import { describe, expect, it } from 'vitest'
import { defaultLocale, getTranslation, isLocale } from './index'

describe('getTranslation', () => {
  it('returns the requested locale when it exists', () => {
    expect(getTranslation({ es: 'Hola', en: 'Hi' }, 'en')).toEqual({ value: 'Hi', locale: 'en', isFallback: false })
  })
  it('falls back to the default locale when the requested one is missing', () => {
    expect(getTranslation({ es: 'Hola' }, 'en')).toEqual({ value: 'Hola', locale: 'es', isFallback: true })
  })
  it('falls back for a future locale that has no translation yet', () => {
    expect(getTranslation({ es: 'Hola' }, 'de')).toEqual({ value: 'Hola', locale: 'es', isFallback: true })
  })
  it('honours an explicit fallback locale', () => {
    expect(getTranslation({ en: 'Hi' }, 'de', 'en')).toEqual({ value: 'Hi', locale: 'en', isFallback: true })
  })
  it('returns null when neither the locale nor the fallback exist', () => {
    expect(getTranslation({}, 'es')).toBeNull()
  })
})

describe('isLocale', () => {
  it('accepts supported locales and rejects others', () => {
    expect(isLocale('es')).toBe(true)
    expect(isLocale('fr')).toBe(false)
  })
  it('uses Spanish as the default locale', () => {
    expect(defaultLocale).toBe('es')
  })
})
