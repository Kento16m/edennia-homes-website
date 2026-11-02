import Image from 'next/image'
import emblemForest from './logo/emblem-forest.svg'
import emblemWhite from './logo/emblem-white.svg'
import lockupForest from './logo/lockup-forest.svg'
import lockupWhite from './logo/lockup-white.svg'

// Flat SVGs traced from docs/brand/logo-color.png (potrace + svgo). Static files, so they never land in the JS bundle.
const sources = {
  lockup: { forest: lockupForest, white: lockupWhite },
  emblem: { forest: emblemForest, white: emblemWhite },
}

export type LogoProps = {
  variant: 'lockup' | 'emblem'
  tone: 'forest' | 'white'
  className?: string
  priority?: boolean
}

export function Logo({ variant, tone, className, priority }: LogoProps) {
  return (
    <Image src={sources[variant][tone]} alt="Edennia Homes" className={className} priority={priority} unoptimized />
  )
}
