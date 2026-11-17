---
name: builders-camp-brand
description: Builders Camp brand guidelines and design system. Use BEFORE any visual, UI, design or brand-facing writing work for Builders Camp — website pages, platform/app screens, components, Tailwind/CSS theming, slides and decks, Claude artifacts (workbooks, session pages, AI-Native PM material), PDF guides and lead magnets, LinkedIn posts and carousels, motion graphics and Shorts, emails, landing-page or marketing copy, naming, logos, colours, fonts, icons. Tells you which brand file to read for the medium.
disable-model-invocation: false
allowed-tools: Read, Glob, Grep
argument-hint: "[medium or task, e.g. 'linkedin carousel', 'app screen', 'deck']"
---

# Builders Camp brand

The brand lives in `brand/` of the team config repo. Installed path: **`~/.claude/brand/`** (symlinked by `install.sh`). If that path is missing, read the same files from the `team-claude-config` checkout (`brand/`) or from GitHub `builders-camp/team-claude-config` → `brand/`.

## Process

1. **Always read** `~/.claude/brand/BRAND.md` (voice, naming, logo, colour, type, a11y). It is short; read it whole.
2. **Then read the playbook for the medium** (one or two, not all):

| Task | Read |
|---|---|
| Website / landing page / microsite | `playbooks/web.md` + `DESIGN-SYSTEM.md` |
| Platform, app screen, component, admin | `playbooks/platform-app.md` + `DESIGN-SYSTEM.md` |
| Deck, slides, presentation (any tool) | `playbooks/slides.md` |
| Claude artifact (workbook, explainer, interactive page) | `playbooks/artifacts.md` |
| PDF guide, lead magnet, printable | `playbooks/pdf-guides.md` |
| LinkedIn / social static post or carousel | `playbooks/social-linkedin.md` |
| Motion graphic, LinkedIn video, Short, reel | `playbooks/motion.md` |
| Email (transactional, newsletter) | `playbooks/email.md` |
| Copy only (headline, CTA, post) | `BRAND.md` §3–4 is enough |

3. **Use the tokens, never re-derive values.**
   - Code: import `brand/tokens/tokens.css` and use `brand/tokens/tailwind-preset.cjs` (see `brand/README.md`). Exact values: `brand/tokens/tokens.json`.
   - Non-code (slides, social, PDF, motion): copy hex/sizes from the playbook or `tokens.json`.
   - Logos: use files from `brand/assets/logo/` exactly as provided (`assets/SOURCES.md`). Never retype or redraw the wordmark.
4. **Check** before finishing: the quick checklist at the end of `BRAND.md` (§12) and contrast in `tokens/contrast.md`.

## Rules that override your defaults

- Montserrat only (Nanum Brush Script only as an IRL accent). Heavy, tightly tracked headings.
- Black / white / grey + **one** green `#27A54D`. No lime, navy, neon, purple-dominant or gradient-heavy looks.
- White text on `#27A54D` only at ≥ 18.66px bold; otherwise `#1F843D` fill or ink text.
- "Builders Camp" (two words). "AI-Native" in titles, "AI-native" mid-sentence.
- Values marked `[inferred]` or `[human call]` are provisional — don't present them as official; check `DECISIONS.md`.
- Do not use the supermodular.ai brand (Notion "Brand" page) for Builders Camp work (DECISIONS D-01).

## When the brand doesn't cover something

Follow the closest existing pattern, mark it `[inferred]` in your output, and suggest adding it to `brand/` via a PR (`/improve`). Never invent a new colour, font or logo variant.

## Output

No fixed format — produce the requested asset. In your reply, name which brand files you applied and list any `[inferred]` choices you made.
