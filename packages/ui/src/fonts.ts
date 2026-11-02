import { Instrument_Serif } from 'next/font/google'
import localFont from 'next/font/local'

// Fontshare ITF Free Font License: self-hosting OK, never redistribute the files (see fonts/LICENSE-ITF-FFL.txt).
const clashDisplay = localFont({
  src: './fonts/ClashDisplay-Variable.woff2',
  weight: '200 700',
  variable: '--font-clash-display',
  display: 'swap',
})

const generalSans = localFont({
  src: './fonts/GeneralSans-Variable.woff2',
  weight: '200 700',
  variable: '--font-general-sans',
  display: 'swap',
})

const instrumentSerif = Instrument_Serif({
  weight: '400',
  style: 'italic',
  subsets: ['latin', 'latin-ext'],
  variable: '--font-instrument-serif',
  display: 'swap',
  preload: false, // accent only (≤1 word per heading) and never used in admin
})

export const fontVariables = [clashDisplay.variable, generalSans.variable, instrumentSerif.variable].join(' ')
