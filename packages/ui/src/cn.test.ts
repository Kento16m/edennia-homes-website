import { describe, expect, it } from 'vitest'
import { cn } from './cn'

describe('cn', () => {
  it('keeps a custom font-size and a text color together', () => {
    expect(cn('text-body', 'text-ink')).toBe('text-body text-ink')
  })
  it('lets a later custom font-size override an earlier one', () => {
    expect(cn('text-body', 'text-small')).toBe('text-small')
  })
  it('lets a later color override an earlier one', () => {
    expect(cn('bg-forest-900', 'bg-forest-600')).toBe('bg-forest-600')
  })
  it('treats rounded-pill as a radius', () => {
    expect(cn('rounded-md', 'rounded-pill')).toBe('rounded-pill')
  })
})
