import { z } from 'zod'
import { Constants } from './database.types'

// Enum values come from the generated database types, so they can't drift from the migrations.
const enums = Constants.public.Enums
export const propertyTypes = enums.property_type
export const leadSources = enums.lead_source
export const leadGoals = enums.lead_goal
export const contactChannels = enums.contact_channel
export const leadInterests = enums.lead_interest
export const sortOptions = ['relevance', 'price_asc', 'price_desc', 'newest', 'area_desc'] as const // search_properties p_sort

// ── Explorer filters (URL is the source of truth) ────────────────────────────
// Every field fails soft: an invalid value is dropped, the rest of the URL still applies.

const slug = z.string().regex(/^[a-z0-9]+(-[a-z0-9]+)*$/)
const key = z.string().regex(/^[a-z0-9_]+$/)

function csv<T extends string>(item: z.ZodType<T>) {
  return z
    .string()
    .transform((value) => {
      const items = [...new Set(value.split(',').map((part) => part.trim()))].filter(
        (part): part is T => item.safeParse(part).success,
      )
      return items.length > 0 ? items : undefined
    })
    .optional()
    .catch(undefined)
}

const positiveInt = (max: number) => z.coerce.number().int().min(1).max(max).optional().catch(undefined)
const flag = z
  .enum(['1', 'true'])
  .transform(() => true as const)
  .optional()
  .catch(undefined)

const bbox = z
  .string()
  .transform((value) => value.split(',').map(Number))
  .refine(
    (n): n is [number, number, number, number] =>
      n.length === 4 &&
      n.every(Number.isFinite) &&
      n[0]! >= -180 && n[2]! <= 180 && n[1]! >= -90 && n[3]! <= 90 &&
      n[0]! < n[2]! && n[1]! < n[3]!,
  )
  .optional()
  .catch(undefined)

export const propertyFiltersSchema = z.object({
  tipo: csv(z.enum(propertyTypes)),
  min: positiveInt(1_000_000_000),
  max: positiveInt(1_000_000_000),
  dorm: positiveInt(20),
  banos: positiveInt(20),
  m2min: positiveInt(100_000),
  m2max: positiveInt(100_000),
  zona: csv(slug),
  amen: csv(key),
  tour: flag,
  residencia: flag,
  orden: z.enum(sortOptions).catch('relevance').default('relevance'),
  p: z.coerce.number().int().min(1).max(1000).catch(1).default(1),
  bbox,
})

export type PropertyFilters = {
  types?: (typeof propertyTypes)[number][]
  minPrice?: number
  maxPrice?: number
  minBedrooms?: number
  minBathrooms?: number
  minArea?: number
  maxArea?: number
  zones?: string[]
  amenities?: string[]
  hasTour?: true
  residency?: true
  sort: (typeof sortOptions)[number]
  page: number
  bbox?: [number, number, number, number]
}

type SearchParams = Record<string, string | string[] | undefined>

/** Parses Next.js searchParams for /propiedades into typed filters, dropping anything invalid. */
export function parsePropertyFilters(searchParams: SearchParams): PropertyFilters {
  const firstValues = Object.fromEntries(
    Object.entries(searchParams).map(([name, value]) => [name, Array.isArray(value) ? value[0] : value]),
  )
  const raw = propertyFiltersSchema.parse(firstValues)
  const filters: PropertyFilters = {
    types: raw.tipo,
    minPrice: raw.min,
    // A maximum below the minimum is a typo or a tampered URL: keep the minimum, drop the maximum.
    maxPrice: raw.max !== undefined && raw.min !== undefined && raw.max < raw.min ? undefined : raw.max,
    minBedrooms: raw.dorm,
    minBathrooms: raw.banos,
    minArea: raw.m2min,
    maxArea: raw.m2max !== undefined && raw.m2min !== undefined && raw.m2max < raw.m2min ? undefined : raw.m2max,
    zones: raw.zona,
    amenities: raw.amen,
    hasTour: raw.tour,
    residency: raw.residencia,
    sort: raw.orden,
    page: raw.p,
    bbox: raw.bbox,
  }
  return Object.fromEntries(Object.entries(filters).filter(([, value]) => value !== undefined)) as PropertyFilters
}

// ── Lead form (validated identically in the browser and in the submit-lead Edge Function) ──
export const leadSubmissionSchema = z.object({
  fullName: z.string().trim().min(1).max(200),
  email: z.email().max(254),
  phone: z.string().trim().regex(/^\+?[0-9 ()-]{5,40}$/),
  country: z.string().regex(/^[A-Z]{2}$/),
  locale: z.string().regex(/^[a-z]{2}(-[A-Z]{2})?$/),
  source: z.enum(leadSources),
  propertyId: z.uuid().optional(),
  goal: z.enum(leadGoals),
  residencyInterest: z.boolean().default(false),
  preferredChannel: z.enum(contactChannels),
  interest: z.enum(leadInterests).optional(),
  preferredDate: z.iso.date().optional(),
  preferredSlot: z.string().trim().max(100).optional(),
  timezone: z.string().max(64).optional(),
  message: z.string().trim().max(5000).optional(),
  consentPrivacy: z.literal(true), // GDPR: explicit, never pre-ticked
  consentMarketing: z.boolean().default(false),
  turnstileToken: z.string().min(1),
})
export type LeadSubmission = z.output<typeof leadSubmissionSchema>

// ── Property editor (admin) ──────────────────────────────────────────────────
const count = z.number().int().min(0).max(100)
const httpsUrl = z.url({ protocol: /^https$/ })

export const propertyBaseSchema = z.object({
  type: z.enum(propertyTypes),
  price: z.number().positive(),
  currency: z.string().regex(/^[A-Z]{3}$/).default('USD'),
  bedrooms: count.optional(),
  bathrooms: count.optional(),
  areaM2: z.number().positive().optional(),
  lotM2: z.number().positive().optional(),
  parking: count.optional(),
  yearBuilt: z.number().int().min(1850).max(2100).optional(),
  zoneId: z.uuid().optional(),
  agentId: z.uuid().optional(),
  addressLine: z.string().trim().max(300).optional(),
  hideExactAddress: z.boolean().default(true),
  isFeatured: z.boolean().default(false),
  residencyEligible: z.boolean().default(false),
  virtualTourUrl: httpsUrl.optional(),
  videoUrl: httpsUrl.optional(),
  constructionProgress: z.number().int().min(0).max(100).optional(),
  deliveryDate: z.iso.date().optional(),
})
export type PropertyBase = z.output<typeof propertyBaseSchema>
