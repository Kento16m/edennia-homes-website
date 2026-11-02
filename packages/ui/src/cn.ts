import { clsx, type ClassValue } from 'clsx'
import { extendTailwindMerge } from 'tailwind-merge'

// Teach tailwind-merge our custom scale so `text-body` (size) and `text-ink` (color) don't cancel out.
const twMerge = extendTailwindMerge({
  extend: {
    classGroups: {
      'font-size': [
        {
          text: ['wordmark', 'display', 'headline', 'title-lg', 'title', 'body-lg', 'body', 'small', 'label'],
        },
      ],
    },
    theme: { radius: ['pill'] },
  },
})

export function cn(...inputs: ClassValue[]): string {
  return twMerge(clsx(inputs))
}
