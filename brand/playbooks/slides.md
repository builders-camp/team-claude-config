# Playbook — Slides and decks

> Derived from our shipped decks: AI-Native Product Management (Session 1), the IRL Porto deck, the AI Native deck and the IRL Porto Kickoff (Slides type). Conflicts between them resolved in `../DECISIONS.md` (D-04, D-10, D-12).
> When making a deck with the Artifact **Slides** type, use the Builders Camp design system (`../README.md` → Design System artifact) if published; otherwise apply this file.

## 1. Canvas

- **1920×1080 (16:9).** Safe padding **128px** (min 120px left/right, 90px top/bottom).
- Background options: **white** (content), **black `#000` / ink `#141414`** (cover, section dividers, statements, closing, "PAUSE / Questions?"), **mint `#E9F6ED`** (live demo / exercise slides), **full green `#27A54D`** (rare statement slide, white type).
- Signature motif: **rays** — 46 thin black lines fanning down-left from the top-right corner, 7% opacity (every fifth 11%). Covers and statement slides only.
- Dark-slide glow: radial `#27A54D` at ~22% alpha from one corner.

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

- Content slides: wordmark **top-left**, ~217×26px, at x 128, y 55.
- Cover: wordmark under the title (420×50) or top-right (420×60) — pick one per deck.
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

Pills radius 999 · chips mint radius 8 · grey cards `#F4F4F4` radius 20 · icon medallion 76px (mint fill, 4px black border, Lucide 2px stroke) · numbered circle 48px black/green numerals · progress bar 4px green at top · hover ring `0 0 0 6px rgba(39,165,77,.18)` in HTML decks.

## 6. Motion (HTML/interactive decks)

Slide change: fade 350–450 ms (+ translateY 14px). Dividers: push. Build-ins: rise 28px / left-right 48px / pop scale 0.85, 500 ms `cubic-bezier(.2,.8,.2,1)`, 60–100 ms stagger. Pop with spring `cubic-bezier(.3,1.6,.5,1)` 700 ms for numbers. Strokes draw in 0.5–1.2 s. All disabled under `prefers-reduced-motion`.

## 7. Exports

PDF for sharing (fonts embedded), PPTX only when asked (Slides type downloads both). Speaker notes in full sentences. File name: `YYYY-MM-DD — Builders Camp — <Title>`.
