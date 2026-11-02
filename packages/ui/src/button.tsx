import { cva, type VariantProps } from 'class-variance-authority'
import type { ComponentProps } from 'react'
import { cn } from './cn'

const button = cva(
  'inline-flex items-center justify-center gap-2 rounded-md font-medium whitespace-nowrap transition-colors duration-200 ease-soft disabled:pointer-events-none disabled:opacity-50',
  {
    variants: {
      variant: {
        primary: 'bg-forest-900 text-white hover:bg-forest-600',
        secondary: 'border border-line-strong text-ink hover:bg-sand-100',
        ghost: 'text-ink hover:bg-sand-100',
      },
      // lg = 48px (web), md = 40px (admin) — DESIGN.md › Buttons
      size: { md: 'h-10 px-4 text-small', lg: 'h-12 px-6 text-body' },
    },
    defaultVariants: { variant: 'primary', size: 'lg' },
  },
)

export type ButtonProps = ComponentProps<'button'> & VariantProps<typeof button>

export function Button({ className, variant, size, type = 'button', ...props }: ButtonProps) {
  return <button type={type} className={cn(button({ variant, size }), className)} {...props} />
}
