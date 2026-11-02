import { cva, type VariantProps } from 'class-variance-authority'
import type { ComponentProps } from 'react'
import { cn } from './cn'

const badge = cva('inline-flex items-center rounded-pill px-3 py-1 text-label uppercase', {
  variants: {
    tone: {
      available: 'bg-status-available-bg text-forest-900',
      reserved: 'bg-status-reserved-bg text-status-reserved-text',
      sold: 'bg-status-sold-bg text-ink',
      neutral: 'bg-sand-100 text-ink',
    },
  },
  defaultVariants: { tone: 'neutral' },
})

export type BadgeProps = ComponentProps<'span'> & VariantProps<typeof badge>

export function Badge({ className, tone, ...props }: BadgeProps) {
  return <span className={cn(badge({ tone }), className)} {...props} />
}
