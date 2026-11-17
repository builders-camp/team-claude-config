# Brand decisions and conflicts log

Every place the sources disagreed, what we chose, and why. Rule of precedence from the brief: **official brand docs → newest shipped site → other shipped code → artifacts**. Add new entries at the bottom; never rewrite old ones (mark them superseded).

## Sources inventoried (2026-11-17)

| # | Source | Date / state | What it gave us |
|---|---|---|---|
| S1 | **builderscamp.com** (live; built from `builderscamp-homepage-refresh` / monorepo `apps/web`) — computed styles via Playwright at 1440px and 390px | Live Nov 2026 | Font, colour tokens (`:root` vars), type scale, radii, shadows, spacing, components, copy, logo SVG |
| S2 | builderscamp.com/irl (live) | Live Nov 2026 | Event cards, IRL voice |
| S3 | members.builderscamp.com (live) | Live Nov 2026 | App sign-in UI, app microcopy |
| S4 | challenges-builders-camp.vercel.app + repo `challenges-builders-camp` | Last commit Jul 2026 | Challenge cards, story-driven copy, Inter font, orange primary var |
| S5 | repo `builders-camp-irl-site` | May 2026 | Brush-script accent, IRL long-form voice, neutral dark mode |
| S6 | repo `builders-camp-registration` | May 2026 | **Same `:root` token set as live homepage** (lime, navy, sidebar, shadows) + navy-tinted dark mode |
| S7 | repo `builderscamp-quizzes` | Jul 2026 | Results-state colours, quiz layout, feedback voice |
| S8 | repo `producthon` | May 2025 | 2025 event microsite (VT323 pixel font, neon palette) — event-specific, not core brand |
| S9 | Claude artifacts: AI-Native PM Session 1 deck, AI-Native PM Workbook, IRL Porto deck, AI Native deck, IRL Porto Kickoff (Slides), Shorts Engine scope doc, Notifications map | Oct–Nov 2026 | Slide system, workbook components, motion grammar, Shorts spec, email naming |
| S10 | Notion "Brand" page (Design / Key Resources) + attached `brand_guidelines.pdf` | May 2025 PDF | **Turned out to be the supermodular.ai brand, not Builders Camp** — see D-01 |
| S11 | Canva brand kit `kAFq47BVsjw` | — | The API returned the kit id only (no name, colours, fonts or logos) and no brand templates. Nothing usable. See G-04 |

Not reachable: `builders-camp/builderscamp-homepage-refresh` and `builders-camp/builderscampdm` (repo attach was denied in this session). S1 (the live build of the homepage) stands in for the homepage repo. `builderscampdm` not analysed — see G-05.

## Decisions

**D-01 · The Notion "Brand" page is not the Builders Camp brand.** It documents *supermodular.ai* (fonts Denim INK / Icona Serif / Aeonik Fono, the supermodular logotype and "mutations", nomenclature "supermodular.ai"). supermodular.ai appears on builderscamp.com/irl only as a *backer*. **Decision:** do not import any supermodular rule, font or asset. Builders Camp's "official" doc therefore does not exist; precedence falls to the newest shipped site (S1). **[human call]** confirm, and decide whether Builders Camp should get its own Notion brand page pointing here.

**D-02 · Primary typeface = Montserrat.** S1, S2, S3, S5, S6 and all decks use Montserrat; S4 uses Inter; S7 uses the system stack; S8 uses VT323. **Chosen:** Montserrat (newest site + majority). Inter/system are legacy; migrate when touched.

**D-03 · Brand green = `#27A54D` (hsl 138 62% 40%).** Variants found: `#27A54D` (S1 computed, decks, workbook), `#26A653` (IRL Porto deck, "from apps/web index.css" comment), `#26A355` (Shorts spec "website green", challenges hover), all rounding of the same HSL. **Chosen:** `#27A54D` = exact computed value on the live site.

**D-04 · Ink = `#141414`, muted = `#737373`, line = `#E6E6E6`, surface = `#F5F5F5`.** Decks/workbook use `#000/#0D0D0D`, `#6B6B6B/#8A8A8A`, `#D9D9D9`, `#F4F4F4`; quizzes use `#0A0A0A`, `#6B6B6B`, `#E5E5E5`, `#FAFAF7`. **Chosen:** S1 values. Pure black `#000` stays allowed for full-bleed dark slides/frames (deck practice).

**D-05 · Primary var conflict.** shadcn `--primary` is ink in S1/S5/S6 but **orange `#F97015`** in S4 (challenges), while the rendered challenges site shows no orange in use. **Chosen:** primary = ink, accent = green. Orange is not a brand colour (only the Vibe Coding track gradient).

**D-06 · Lime `#C2FF33` and navy `#1F242E`.** Declared in S1/S6 CSS, not visibly used; Shorts spec says green is "never fluorescent or lime". **Chosen:** keep in tokens as `declared`, excluded from the visible palette. **[human call]** delete from code or give them a role.

**D-07 · Green CTA contrast.** White 14px/600 on `#27A54D` = 3.19:1, failing WCAG AA (S1 ships this). **Chosen:** keep `#27A54D` as the brand green; add `green-strong #1F843D` (4.74:1) [inferred] as `accent-hover` and as the recommended resting fill for small-label buttons in *new* work. **[human call]** whether to switch the live site's CTAs.

**D-08 · Dark mode.** S5 has neutral dark (`#141414` bg); S6 (same lineage as live homepage tokens) has navy-tinted dark (`#101318`); decks/workbook use `#000/#0D0D0D/#1A1A1A`. Marketing site ships no dark mode. **Chosen:** S6 values for UI dark mode (newest lineage); decks/motion may keep pure black backgrounds. Dark `destructive` raised to the light value [inferred] because S6's `hsl(0 62.8% 30.6%)` fails contrast.

**D-09 · "AI-Native" spelling.** Live site H1 "AI-Native Product Builder"; decks mix "AI Native", "AI-Native", "AI-native", "AI native". **Chosen:** "AI-Native" in titles/Title Case, "AI-native" mid-sentence. Rename "AI Native Product Management" titles to "AI-Native Product Management" when next edited.

**D-10 · Heading weight.** Web H1 800 / H2 700; Session 1 deck 700; Porto/Kickoff/Shorts 800. **Chosen:** web follows S1 (800/700); slides & social headings 800; deck body titles may use 700.

**D-11 · Hard "brutalist" shadows.** Used in deck cards and workbook panels; absent from all shipped web UI. **Chosen:** allowed only in decks/workbooks/artifacts; never on the website or platform.

**D-12 · Logo on motion.** Session 1 deck: logo top-left; Kickoff: top-right; Shorts: binding rule **no logo on screen**. **Chosen:** decks top-left on content slides (cover may vary); Shorts/motion follow the binding no-logo rule with the text end card.

**D-13 · Card radius.** Live site: 12px most common, 16px large; challenges 16px; quizzes 16px; decks 20px. **Chosen:** 12px default, 16px large (web); decks may use 16–20px at 1920px scale.

**D-14 · White logo and transparent stacked logo are derived files** (colour swap / background removed from shipped SVGs). Recorded in `assets/SOURCES.md`.

**D-15 · Mono font.** No brand mono found; challenges uses Tailwind `font-mono` system stack; workbook maps "mono" to Montserrat. **Chosen:** system mono stack for code only [inferred].

**D-16 · Section spacing.** Live: 96px standard, 64px compact. Adopted as `section-y` / `section-y-tight`.

**D-17 · Motion easing.** Web: Tailwind ease-out; decks `cubic-bezier(.2,.8,.2,1)`; IRL deck spring `cubic-bezier(.3,1.6,.5,1)`. **Chosen:** all three, scoped (UI = standard/out; slides & motion = emphasis/spring).

**D-18 · Shorts length.** Spec evolved 25–35s → 35–42s; pilots 30.6–53.8s. **Chosen:** target 35–42s, hard limits 20–58s (latest binding values).

## Gaps that need a human call

- **G-01 Logo masters.** No vector master (AI/Figma), no record of the wordmark's typeface, no clear-space/min-size spec. Clear space and min sizes in BRAND.md are [inferred].
- **G-02 Official brand guidelines.** None exist for Builders Camp (D-01). This folder becomes the official doc once approved.
- **G-03 Green CTA contrast** (D-07) and **lime/navy** (D-06).
- **G-04 Canva brand kit** `kAFq47BVsjw` returned no readable contents through the API. Someone should open it in Canva and either align it to `tokens.json` (Montserrat; #141414, #FFFFFF, #F5F5F5, #737373, #27A54D, #E9F6ED; logo files from `assets/`) or tell us what it holds.
- **G-05 Unanalysed repos.** `builderscamp-homepage-refresh` (covered via the live site) and `builderscampdm` (unknown — possibly email/DM templates). Re-run the inventory with access to confirm email styles.
- **G-06 Photography.** No photo library or art-direction source found; §8 of BRAND.md is derived from the IRL site and decks.
- **G-07 Email templates.** No HTML email template found; `playbooks/email.md` is [inferred] from the web system and the notifications map.
- **G-08 Brush script.** Nanum Brush Script is used only on the IRL site. Confirm it stays an IRL-only accent or becomes brand-wide.
- **G-09 Bootcamp cover blue `#5271FF`** is pixel-sampled from cover images; confirm the source file value.
