# Playbook — Diagrams, charts and explainers

> Derived from the on-brand Builders Camp explainers: Product MBA Session 10, Product Mindset in the AI era, the AI-Native PM decks' embedded diagrams and the Builders Camp × client deck. Several older explainers carry the Builders Camp name but use off-brand styles (Agent Loops, Claude OS Routing Flow, Toolchain Flow). Others are supermodular.ai material. None of those were used for rules, and they should be migrated to this spec when next touched (`../DECISIONS.md` D-25).

## 1. Principles

1. **One idea per step.** A diagram builds in the order you explain it. Each click adds one node, edge or highlight.
2. **Ink is structure, green is meaning.** Every shape is black or grey. Green marks the active, current, AI-driven or "now" thing, and only that.
3. **Always a legend** when shape or line style carries meaning.
4. **Real numbers, shown.** Equations are worked out on screen: `n(n−1)/2 = 5×4/2 = 10`.

## 2. Node grammar

| Node | Shape | Stroke | Fill | Text |
|---|---|---|---|---|
| Step / agent | rect `rx 16` | 2.5px `#000` | white or `#F4F4F4` | 20–24px/700 ink |
| **Active / now** | same | 2.5px `#27A54D` + ring `0 0 0 6px rgba(39,165,77,.18)` | white or `#27A54D` (then white text) | |
| Start / end | pill (`rx` = half height) | — | `#000` | white 700 |
| Human decision | diamond | — | `#000` | white |
| Judge / review loop | rect `rx 16` | 2.5px `#27A54D`, dash `8 6` | mint `#E9F6ED` | ink |
| Automated / hook | rect `rx 16` | 2px `#8A8A8A` | `#F4F4F4` | muted |
| Optional | any | dash `3 5` | — | muted |
| Timeline node | circle 68–76px | 4px `#000` | mint `#E9F6ED` | numeral 28–32px/800 |

Number steps `01`, `02`… only when order matters.

## 3. Edges

| Edge | Style |
|---|---|
| Flow | 2.5px `#8A8A8A`, round caps |
| Loop (repeat, fix rounds) | 2.5px `#27A54D`, dash `7 6`, arcs over or under the row it returns to |
| Send-back / reject | 2.5px `#000`, dash `7 6` |
| Emphasised connector (deck overlays) | 3px `#000`, round caps |
| Arrowheads | filled triangle in the edge colour: `<marker viewBox="0 0 10 10">` with path `M0,0 L10,5 L0,10 z`, size 6 |
| Edge labels | 16px/700 `#6B6B6B`, or a small pill chip (radius 10, `#F4F4F4`, 14px/600) when the label sits on the line. Judge labels in green-strong `#1D7F41` |

Elbow connectors (vertical, horizontal, vertical) for row breaks; no diagonal spaghetti. Timeline rail: 4px `#000`.

## 4. Layout

- **Left → right** for processes. Wrap to a second row (S-shape) past about 6 nodes.
- **Top → down** for trees (opportunity trees, org trees). Tree connectors may be 4px ink rules.
- Loops sit above or below their row, never crossing nodes.
- Leave 24–32px between nodes; keep labels inside the safe padding (128px on slides).
- **Legend:** bottom-left. Swatches 34×22 `rx 5`, or 52×26 boxes with the real border style. Labels 24px/600 on slides, 14px on pages.

## 5. Step-through and highlight

- **Phase highlight:** dim everything outside the current phase to `opacity .16`. Rewrite the title as "**Phase:** text" (bold phase name).
- **Highlight swap (lists):** the active row becomes black with a white title and green subtitle; the others stay grey.
- **Camera zoom:** animate the SVG `viewBox` between named stops over **1100ms** `cubic-bezier(.65,0,.35,1)`. Show the stop as an "n / 5" pill.
- **Steps:** the hash is `#<slide>.<step>`. Going back shows the final state. Autoplay (if any) stops on any key.

## 6. Motion

| Motion | Value |
|---|---|
| Node entry | `translateY(24px)` → 0 with opacity, 450–500ms `cubic-bezier(.2,.8,.2,1)`, 420ms stagger when auto |
| Edge draw | `pathLength="1"`, `stroke-dasharray:1`, `stroke-dashoffset` 1 → 0: **500ms ease** for short edges, **900ms ease** for underlines and paths, **1600ms `cubic-bezier(.2,.8,.2,1)`** for hero curves |
| Labels after a draw | fade in, staggered 250ms |
| Colour change (state) | `stroke/fill 400ms` |
| Bars | `width 700–800ms cubic-bezier(.2,.8,.2,1)`, stagger 120ms; or 1600ms for a single hero bar |
| Counters | roll up, lock at the final value; numerals 120px/800, green when it's the point |
| Pop (badges, markers) | `cubic-bezier(.3,1.6,.5,1)` 450–700ms (slides only) |
| Ambient (orbits, pulses, flow dashes) | one per slide; orbits 40–85s/turn, pulse 2.4s, flow dash `10 12` at 1.2s linear; minimum cycle 1300ms |
| Reduced motion | `animation:none`, show the final state |

## 7. Charts

- Baseline series in ink `#000`, the highlighted or AI series in green `#27A54D`, comparison series in `#8A8A8A`/`#D9D9D9`.
- Dim non-focus rows to `opacity .22`.
- Averages and targets: dashed 2px `#6B6B6B` with a pill label ("AIM", "ON TRACK").
- Grid lines `#D9D9D9`, 1px; no chart borders; axis labels 14–18px/600 muted; tabular numbers.
- Title carries the takeaway, with its last phrase in green: "AI cut cycle time **by 40%**".
- Ramp for heat or contribution grids: `#EBEDF0 → #BFE6CB → #6CC58A → #27A54D → #146B34`.
- Red `#EF4444` (or the decks' `#E03131`) only for loss or failure, never as a series colour.
- Cite the source under the chart (12–18px muted).

## 8. Tooling

- Hand-drawn SVG or canvas inside the page, or a sandboxed iframe in decks.
- Mermaid is acceptable for quick internal flows only if restyled to this grammar. The default Mermaid theme is off-brand.
- Never use stock diagram icons or clip-art; use Lucide line icons (2px stroke) inside nodes when an icon helps.
