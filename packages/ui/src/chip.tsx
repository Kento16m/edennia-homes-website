import type { ComponentProps } from 'react'
import { cn } from './cn'

const base = 'inline-flex items-center gap-2 rounded-pill border px-4 py-2 text-small whitespace-nowrap'

/** Static label by default; pass `selected` to render a toggle button (filters, tabs). */
export type ChipProps =
  | (ComponentProps<'span'> & { selected?: undefined })
  | (ComponentProps<'button'> & { selected: boolean })

export function Chip(props: ChipProps) {
  if (props.selected === undefined) {
    const { className, ...rest } = props
    return <span className={cn(base, 'border-line text-ink', className)} {...rest} />
  }
  const { className, selected, type = 'button', ...rest } = props
  return (
    <button
      type={type}
      aria-pressed={selected}
      className={cn(
        base,
        'transition-colors duration-200 ease-soft',
        selected ? 'border-forest-900 bg-forest-900 text-white' : 'border-line-strong text-ink hover:bg-sand-100',
        className,
      )}
      {...rest}
    />
  )
}
