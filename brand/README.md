# brand/ — Builders Camp brand system

The single source for how Builders Camp looks and sounds, for humans and for Claude. Derived from what we've shipped (see `DECISIONS.md` for every source and conflict).

```
brand/
├── BRAND.md            guidelines: positioning, voice, naming, logo, colour, type, imagery, icons, motion, a11y
├── DESIGN-SYSTEM.md    tokens explained, components, patterns, layout
├── DECISIONS.md        sources, conflicts, decisions, open gaps (audit trail)
├── tokens/
│   ├── tokens.json         SOURCE OF TRUTH (each value has $status + $source)
│   ├── build.mjs           node brand/tokens/build.mjs  → regenerates the three files below
│   ├── tokens.css          generated: CSS variables (shadcn-compatible) + Montserrat import
│   ├── tailwind-preset.cjs generated: Tailwind v3 preset
│   └── contrast.md         generated: WCAG contrast of real pairings
├── playbooks/          one file per medium: web, platform-app, slides, artifacts, pdf-guides, social-linkedin, motion, email
│                       + cross-medium: interactions (decks, workbooks, copy, saving), diagrams (nodes, edges, charts)
├── assets/logo/        logo files (+ assets/SOURCES.md provenance)
└── specimen.html       visual check of tokens, type, components, slide + social frames (open in a browser)
```

## Using it in a Claude session

`./install.sh` links this folder to `~/.claude/brand/` and installs the **`builders-camp-brand`** skill. The skill auto-triggers on design, UI, deck, artifact, document, social, motion and copy work; you can also call `/builders-camp-brand <medium>`. The team `CLAUDE.md` tells every session to load it first.

Cloud sessions without `install.sh`: the skill falls back to reading `brand/` from this repo.

## Using it in a code repo

**Option A — copy (simplest, recommended until we publish a package).**
```bash
mkdir -p src/styles/brand
cp ~/.claude/brand/tokens/tokens.css src/styles/brand/
cp ~/.claude/brand/tokens/tailwind-preset.cjs ./brand-preset.cjs
cp ~/.claude/brand/assets/logo/builders-camp-wordmark-*.svg src/assets/
```
```css
/* src/index.css — first line, before @tailwind */
@import "./styles/brand/tokens.css";
```
```js
// tailwind.config.ts (v3)
export default {
  presets: [require("./brand-preset.cjs")],
  content: ["./index.html", "./src/**/*.{ts,tsx}"],
  plugins: [require("tailwindcss-animate")],
};
```
Then delete the repo's own `:root { --background … }` block (the shadcn variables now come from `tokens.css`) and the local `fontFamily`/`colors` overrides. Existing shadcn components re-theme automatically. Add a line to the repo's CLAUDE.md: `Brand tokens copied from team-claude-config brand/ vX.Y — re-copy on upgrade.`

**Tailwind v4** (`@import "tailwindcss"`): import `tokens.css`, then map what you need in `@theme inline { --color-background: hsl(var(--background)); --color-accent: hsl(var(--accent)); --font-sans: var(--bc-font-sans); … }`. The preset is a reference for the full mapping.

**Option B — monorepo.** When the Builders Camp monorepo lands, move `tokens/` into `packages/brand` and import `@builderscamp/brand/tokens.css`; this folder stays the documentation and the source JSON.

**Claude artifacts (Slides, Design).** A **Builders Camp** Design System artifact mirrors this folder: https://claude.ai/artifact/CFqmfSpmckB5d4wJyEtXq1 (private until shared from its Share menu). Pick it as the design system for decks and designs made as artifacts. When tokens change here, update it too.

**Non-code tools (Canva, Figma, Gamma, Google Slides).** Set fonts to Montserrat; colours #141414, #FFFFFF, #F5F5F5, #737373, #E6E6E6, #27A54D, #1D7F41, #E9F6ED; upload logos from `assets/logo/`.

## Changing the brand

1. Edit `tokens.json` (never the generated files) or the markdown.
2. `node brand/tokens/build.mjs`.
3. Add an entry to `DECISIONS.md` if you resolved a conflict or changed a value.
4. Bump `$meta.version` in `tokens.json` and add a changelog line below.
5. Open `specimen.html` and eyeball it. PR as usual.

## Changelog

| Version | Date | Change |
|---|---|---|
| 1.1.0 | 2026-11-17 | Inventoried ~40 more Builders Camp artifacts (teaching decks, workbooks, client trainings, kickoffs, explainers). Added `playbooks/interactions.md` and `playbooks/diagrams.md`; deck neutrals (`color.deck`), radius `deck-card` 20 / `brutal` 4, brutalist/halo/focus-ring shadows, full deck motion tokens; green-strong now the shipped `#1D7F41` (5.04:1). Slides playbook gains teaching vs event deck families and ~20 components. Decisions D-19…D-27. |
| 1.0.0 | 2026-11-17 | First version. Inventory of builderscamp.com (live), IRL, members portal, challenges, quizzes, registration, producthon repos and Builders Camp artifacts/decks/Shorts spec. Tokens, guidelines, design system, 8 playbooks, logos, skill, specimen. Open gaps G-01…G-09 in DECISIONS.md. Design System artifact published (README, tokens, logos, Button, Badge, FeatureCard, BootcampCard, cover). |
