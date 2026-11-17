# Playbook — Slides and decks

> Derived from our shipped decks: AI-Native Product Management (Session 1), the IRL Porto deck, the AI Native deck and the IRL Porto Kickoff (Slides type). Conflicts between them resolved in `../DECISIONS.md` (D-04, D-10, D-12).
> Behaviour (keys, builds, branching, notes, copy) for hand-built decks: `interactions.md`. Diagrams and charts: `diagrams.md`.
> When making a deck with the Artifact **Slides** type, use the Builders Camp design system (`../README.md` → Design System artifact) if published; otherwise apply this file.

## 1. Canvas

- **1920×1080 (16:9).** Safe padding **128px** (min 120px left/right, 90px top/bottom).
- Background options: **white** (content), **black `#000` / ink `#141414`** (cover, section dividers, statements, closing, "PAUSE / Questions?"), **mint `#E9F6ED`** (live demo / exercise slides), **full green `#27A54D`** (rare statement slide, white type).
- Signature motif: **rays** — 46 thin black lines fanning down-left from the top-right corner, 7% opacity (every fifth 11%). Covers and statement slides only.
- Dark-slide glow: radial `#27A54D` at ~22% alpha from one corner.

### Deck neutrals (`color.deck` in tokens)
Teaching decks use their own neutral set, not the website's (D-19): ink `#000`, body `#0D0D0D`, muted `#6B6B6B` (light) / `#8A8A8A` (on black), line `#D9D9D9`, card `#F4F4F4`, line on black `#333333`, card on black `#1A1A1A`, green-dark surface `#0E1A12`, labels on black `#D8D8D8`. Accent green is always `#27A54D` (not `#26A355`/`#26A653` — D-03); small green text on white uses `#1D7F41`.

## 2. Type scale (Montserrat only)

| Element | Size / weight / tracking | Colour |
|---|---|---|
| Cover title | 150–184px / 800 / −0.03em, line-height 1.0 | white on black (key word green) |
| Cover sub | 48–64px / 600 | green or `#8A8A8A` |
| Section divider title | 118–150px / 800 / −0.025em | white, key word green; giant section numeral 420px green at 12% opacity bottom-right |
| Slide title (H2) | 56–88px / 700–800 / −0.02em, lh 1.05–1.08 | ink; second half/key word **green** |
| Eyebrow / kicker | 24–28px / 700 / 0.12em–0.3em uppercase | **green** |
| Lede | 28–32px / 400 / lh 1.3 | `#6B6B6B`–`#737373` |
| Body / bullets | 24–28px / 400–500 | ink |
| Running header (right) | 24px / 400 | muted: "AI-Native Product Management · Session 1 · Foundations" |
| Closing | "Thank you." 200px / 800, only the full stop (or "you") in green | white on black |

Emphasis = green colour, never italics. ≤ 40 words per content slide; one idea per slide.

## 3. Logo

Two deck families (D-22):
- **Teaching decks** (sessions, trainings, talks): wordmark **top-left at x 128, y 55, 217×26, on every slide** (black on light, white on dark) + running title top-right 24px `#6B6B6B`. Client trainings name the client in text only — cover eyebrow "CLIENT · AI-NATIVE CLAUDE · SESSION 1" and title — never a client logo.
- **Event decks** (IRL kickoffs, community events): wordmark **top-right, 420×60, `object-fit: contain`, top 96px**, on every slide; partners only in the sponsor strip.
- Dark slides: white wordmark. Never the logo in the closing slide's title.
- Co-branded deck covers: "Builders Camp × Partner" — partner logo right of ours, same height.

## 4. Slide patterns

1. **Cover** — black, rays or green glow; eyebrow ("AI-NATIVE PRODUCT MANAGEMENT · SESSION 1"), title, sub, presenter line 32px muted. IRL: green pill "IRL" + city.
2. **Agenda** — numbered list, black 48px circles with green numerals.
3. **Section divider** — black, "Part one" kicker, big title, giant faded numeral; push transition.
4. **Content** — eyebrow + two-tone title + lede + 2–4 items (cards `#F4F4F4` radius 16–20, or bullet list).
5. **Statement** — one sentence, 88–120px/800, on white over rays (green underline draws in 0.9 s) / full green / black with word-by-word rise.
6. **Big number** — 300–420px/800 green numeral + 40px label + source line.
7. **Comparison / before-after** — two columns, left grey, right with green header band.
8. **Framework cards** ("brutalist" allowed in decks): 3px black border, radius 4, shadow `8px 8px 0 #000`, header band mint or black with green label "01 · ROLE".
9. **Quote** — green text, 2px dashed `#6B6B6B` rule above, attribution 24px muted.
10. **Live demo / exercise** — mint background, all text ink, pill link "WORKBOOK · TAB 1 →" (white fill, 2px black border, radius 999).
11. **Chart** — black bars, highlighted bar green, axis/grid `#D9D9D9`; contribution ramp `#EBEDF0 → #BFE6CB → #6CC58A → #27A54D → #146B34`; alert red `#E03131` pill only for loss.
12. **PAUSE / Questions?** — black, "Questions ?" 120px white.
13. **Closing** — black, "Thank you." + next-step line in green ("See you in Session 2.") + logo, optional QR (white tile, 3px green border, radius 20).

## 5. Components

**Radius at slide scale:** 20px is the standard slide card (D-26); 4px for brutalist boxes; 999 pills; 50% circles. Avoid 6/10/14/18/22/26.

Teaching-deck components (from the shared deck runtime):
- **Agenda timeline:** 4px black rail; 76px circle nodes (mint fill, 4px black border, numeral); 316×350 cards `#F4F4F4` r20 below; last card `#0D0D0D`; green "HANDS-ON · IN SESSION · 20 MIN" pills above.
- **Session pills (cover):** 26px/700, padding 8/24; current = green fill, others transparent with 2px `#333` border and `#8A8A8A` text.
- **Goto card** (drill-down): 541×222, r20, 2px `#D9D9D9` or mint fill; hover ring — see `interactions.md`.
- **Copy-prompt card:** black r20, padding 24/30, green 24px label (3px tracking), white 24px prompt, green "Copy prompt" pill.
- **Neo-brutalist box:** 3px `#000` border, r4, shadow `8px 8px 0 #000`.
- **Halo card:** 4px black border, r28, shadow `0 0 0 14px #E9F6ED` (one per deck, the key concept).
- **Focus veil:** white 80% overlay, r22, dims finished content.
- **Chat bubble:** r `20 20 4 20`, `#F4F4F4` (user) / mint (assistant).
- **Tool-logo tiles:** 52–64px, r12, white with 1px line.
- **Timeline row:** time · source chip · status tag (READ / CHECK / YOU, 14px/700 uppercase pill).
- **Dark spec card:** `#0D0D0D`, rows separated by `border-top: 2px #2C2D27`.
- **Featured card:** `#F3FAF5` fill, 2px green border, green "best value" pill.
- **Footer (co-branded talks):** pinned 24px `#737373` "BUILDERS CAMP × PARTNER" + page number.
- **Background patterns:** rays (46 lines, opacity .07/.11) or green dot grid (36px cell) with a radial mint glow top-right.

Event-deck components (IRL kickoffs):
- **Sponsor/host strip:** 1px `#333` rule, label "SPONSORED BY" / "HOSTED AT" 28px/600, letter-spacing 6px, `#D8D8D8`, partner logos 190–300px wide.
- **Speaker card:** photo 512×400, 3px green border, r16; 64×6 green bar (r3) + name 44px/800; role 28px/500 `#B8B8B8`; tagline 34px/800 with one green keyword.
- **Checklist grid:** Lucide CheckCircle 60px green + 56px/700 labels.
- **Giveaway pill:** 28px/800, letter-spacing 5px, ink on green, r999, padding 14/32 (one emoji allowed: 🎁).
- **Cohort QR card:** `#0E1A12`, 3px green border, r24, padding 28; QR on white with 3px green border, r20.
- **Promo-code pill:** 2px dashed green border r999 padding 18/40 + code chip (ink on green, r12, padding 6/20). **Voucher box:** 4px dashed green, r32, padding 64/48, glow `0 0 80px rgba(39,165,77,.35)`.
- **Radial green glow** on black: `rgba(39,165,77,.18–.28)` → transparent at 62–65%.

General: pills radius 999 · chips mint radius 8 · grey cards `#F4F4F4` radius 20 · icon medallion 76px (mint fill, 4px black border, Lucide 2px stroke) · numbered circle 48px black/green numerals · progress bar 4px green at top · hover ring `0 0 0 6px rgba(39,165,77,.18)` in HTML decks.

## 6. Motion (HTML/interactive decks)

Canonical values from the shared deck runtime (full spec in `interactions.md`):
- Slide change: **fade only, `opacity 350ms ease`** for every slide, dividers included. The IRL decks' 450ms + 14px rise and the declared-but-unplayed `push` are retired (D-20, D-21).
- Build-ins: rise 28px / left-right 48px / pop scale .85 / wipe scaleX, **500ms** `cubic-bezier(.2,.8,.2,1)`; build-outs 450ms ease; auto groups at +350ms then every **420ms**.
- Statement slides: underline draw 900ms after a 600ms delay; word-by-word rise 500ms.
- Part covers: elements in at 600–700ms with delays .1/.25/.55s; giant numeral fades to opacity .12.
- Numbers: spring pop `cubic-bezier(.3,1.6,.5,1)` 700ms. Strokes draw 500ms–1.6s (`diagrams.md`).
- Hover ring 200ms, progress bar 300ms. Everything off under `prefers-reduced-motion`.
- Slides-type decks: the platform's fade; no script, so prompts get QR panels instead of copy buttons.

## 7. Exports

PDF for sharing (fonts embedded), PPTX only when asked (Slides type downloads both). Speaker notes in full sentences. File name: `YYYY-MM-DD — Builders Camp — <Title>`.
