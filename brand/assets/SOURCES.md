# Asset sources

Every file here was copied from something already shipped. Nothing was redrawn.

| File | Source | Notes |
|---|---|---|
| `logo/builders-camp-wordmark-black.svg` | builderscamp.com `/assets/logo-black-*.svg` (live, Nov 2026). Byte-identical to `challenges-builders-camp/src/assets/logo.svg` | Horizontal wordmark, black glyphs, transparent background. **Primary logo.** |
| `logo/builders-camp-wordmark-white.svg` | Derived from the file above: only `fill="#000000"` → `#FFFFFF` | For dark backgrounds. Derived, not separately sourced. |
| `logo/builders-camp-stacked-black.svg` | builderscamp.com `/favicon.svg` (live) | Two-line lock-up ("BUILDERS / CAMP") on a white square. |
| `logo/builders-camp-stacked-black-transparent.svg` | Derived from the file above: white background rects removed | Stacked mark for any light background. |
| `logo/builders-camp-stacked-white.svg` | Derived: transparent stacked mark with fills → `#FFFFFF` | Stacked mark for dark/colour backgrounds. |
| `logo/builders-camp-stacked-white-on-black-500.png` | `challenges-builders-camp/public/favicon.png` | 500×500, used as app icon/favicon/avatar. |
| `logo/builders-camp-stacked-black-on-white-500.png` | `builderscamp-quizzes/public/builders-camp-logo.png` | 500×500. |
| `logo/builders-camp-stacked-black-transparent-945x451.png` | `builders-camp-registration/src/assets/builders-camp-logo.png` | Raster fallback (decks, email). |

Not available (needs a human — see DECISIONS.md G-01): the logo's master file (AI/Figma), the name of the typeface the wordmark was set in, an official one-colour green version, and a square "BC" monogram. Do not invent any of these.
