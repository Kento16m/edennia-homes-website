import type { ComponentProps } from 'react'
import { cn } from './cn'

export function Container({ className, ...props }: ComponentProps<'div'>) {
  return <div className={cn('mx-auto w-full max-w-site px-gutter', className)} {...props} />
}
