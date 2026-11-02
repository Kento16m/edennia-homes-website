import type { ComponentProps } from 'react'
import { cn } from './cn'

export type InputProps = ComponentProps<'input'> & { invalid?: boolean }

export function Input({ className, invalid, ...props }: InputProps) {
  return (
    <input
      aria-invalid={invalid || undefined}
      className={cn(
        'h-12 w-full rounded-md border border-line-strong bg-white px-4 text-body text-ink placeholder:text-stone-500 disabled:opacity-50 aria-invalid:border-danger',
        className,
      )}
      {...props}
    />
  )
}
