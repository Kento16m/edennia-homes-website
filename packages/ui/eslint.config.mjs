import base from '@edennia/config/eslint'

// Not a Next app: no pages/ dir for this rule to inspect.
export default [...base, { rules: { '@next/next/no-html-link-for-pages': 'off' } }]
