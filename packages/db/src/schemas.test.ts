import { describe, expect, it } from 'vitest'
import { leadSubmissionSchema, parsePropertyFilters } from './schemas'

describe('parsePropertyFilters', () => {
  it('parses a complete, valid explorer URL', () => {
    expect(
      parsePropertyFilters({
        tipo: 'house,apartment',
        min: '80000',
        max: '250000',
        dorm: '3',
        banos: '2',
        m2min: '100',
        m2max: '400',
        zona: 'villa-morra,carmelitas',
        amen: 'pool,quincho',
        tour: '1',
        residencia: 'true',
        orden: 'price_asc',
        p: '2',
        bbox: '-57.62,-25.32,-57.45,-25.24',
      }),
    ).toEqual({
      types: ['house', 'apartment'],
      minPrice: 80000,
      maxPrice: 250000,
      minBedrooms: 3,
      minBathrooms: 2,
      minArea: 100,
      maxArea: 400,
      zones: ['villa-morra', 'carmelitas'],
      amenities: ['pool', 'quincho'],
      hasTour: true,
      residency: true,
      sort: 'price_asc',
      page: 2,
      bbox: [-57.62, -25.32, -57.45, -25.24],
    })
  })

  it('returns only defaults for an empty URL', () => {
    expect(parsePropertyFilters({})).toEqual({ sort: 'relevance', page: 1 })
  })

  it('drops invalid values but keeps the valid ones (manipulated URL)', () => {
    expect(
      parsePropertyFilters({
        tipo: 'castle,house',
        min: 'abc',
        max: '250000',
        dorm: '-2',
        orden: 'cheapest',
        p: '0',
        tour: 'maybe',
        amen: 'pool,<script>',
      }),
    ).toEqual({ types: ['house'], maxPrice: 250000, amenities: ['pool'], sort: 'relevance', page: 1 })
  })

  it('drops the maximum price when it is below the minimum', () => {
    expect(parsePropertyFilters({ min: '300000', max: '100000' })).toEqual({
      minPrice: 300000,
      sort: 'relevance',
      page: 1,
    })
  })

  it('rejects a bounding box that is out of range or inverted', () => {
    expect(parsePropertyFilters({ bbox: '-57.4,-25.3,-57.6,-25.2' }).bbox).toBeUndefined()
    expect(parsePropertyFilters({ bbox: '-200,-25.3,-57.6,-25.2' }).bbox).toBeUndefined()
    expect(parsePropertyFilters({ bbox: '1,2,3' }).bbox).toBeUndefined()
  })

  it('takes the first value when a parameter is repeated', () => {
    expect(parsePropertyFilters({ dorm: ['2', '5'] }).minBedrooms).toBe(2)
  })

  it('deduplicates list values', () => {
    expect(parsePropertyFilters({ tipo: 'house,house' }).types).toEqual(['house'])
  })
})

describe('leadSubmissionSchema', () => {
  const valid = {
    fullName: 'Lucía Fernández',
    email: 'lucia@example.com',
    phone: '+34 600 123 456',
    country: 'ES',
    locale: 'es',
    source: 'property_form',
    propertyId: '10000000-0000-4000-8000-000000000001',
    goal: 'live',
    residencyInterest: true,
    preferredChannel: 'video_call',
    interest: 'video_call',
    preferredSlot: 'tardes (hora de España)',
    timezone: 'Europe/Madrid',
    message: 'Me interesa esta casa.',
    consentPrivacy: true,
    turnstileToken: 'token',
  }

  it('accepts a complete qualified lead', () => {
    const parsed = leadSubmissionSchema.parse(valid)
    expect(parsed.consentMarketing).toBe(false)
    expect(parsed.fullName).toBe('Lucía Fernández')
  })

  it('requires explicit privacy consent (GDPR)', () => {
    expect(leadSubmissionSchema.safeParse({ ...valid, consentPrivacy: false }).success).toBe(false)
    const { consentPrivacy: _, ...withoutConsent } = valid
    expect(leadSubmissionSchema.safeParse(withoutConsent).success).toBe(false)
  })

  it('rejects an invalid email, phone or country', () => {
    expect(leadSubmissionSchema.safeParse({ ...valid, email: 'lucia@' }).success).toBe(false)
    expect(leadSubmissionSchema.safeParse({ ...valid, phone: 'call me' }).success).toBe(false)
    expect(leadSubmissionSchema.safeParse({ ...valid, country: 'Spain' }).success).toBe(false)
  })

  it('trims the name and rejects a blank one', () => {
    expect(leadSubmissionSchema.parse({ ...valid, fullName: '  Lucía  ' }).fullName).toBe('Lucía')
    expect(leadSubmissionSchema.safeParse({ ...valid, fullName: '   ' }).success).toBe(false)
  })

  it('caps the message length', () => {
    expect(leadSubmissionSchema.safeParse({ ...valid, message: 'x'.repeat(5001) }).success).toBe(false)
  })

  it('requires the anti-spam token', () => {
    expect(leadSubmissionSchema.safeParse({ ...valid, turnstileToken: '' }).success).toBe(false)
  })
})
