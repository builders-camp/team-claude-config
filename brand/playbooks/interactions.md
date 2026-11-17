# Playbook — Interactions (decks, workbooks, interactive artifacts)

> Derived from the Builders Camp deck runtime and workbooks, which are shared, byte-identical code across the AI-Native PM, AI-Native Product Teams, Product MBA and client-training decks (9 decks, 3 workbooks, Oct–Nov 2026). Values are copied from that code. Where the artifacts disagreed, the decision is logged in `../DECISIONS.md` (D-19 to D-27). Motion tokens: `tokens.json → motion`.
> Any new hand-built deck or workbook must behave like this, so a person who has used one Builders Camp deck can drive them all.

---

## 1. Decks (hand-built HTML)

### Stage
- Author at **1920×1080**. Scale the stage with `min(innerWidth/1920, innerHeight/1080)` and letterbox it on black.
- Speaker notes live in each slide's hidden `<aside>`.
- Slides carry `id`s, used for deep links.

### Navigation
| Input | Action |
|---|---|
| `→` `PageDown` `Space`, click anywhere on the stage | Next build step, then next slide |
| `←` `PageUp` | Back (the previous slide appears **fully built**) |
| `Home` / `End` | First / last slide |
| `N` | Toggle speaker-notes panel |
| `Esc` | Close notes |
| `F` | Fullscreen |
| Hash `#<slideId>` or `#<slide>.<step>` | Deep link on load and on `hashchange`. Write it back with `history.replaceState` when the slide changes. (Today's runtime reads it but doesn't write it, D-24.) |

Optional: split click zones (left half back, right half forward), as the Product Mindset deck does. Don't add swipe or a grid overview unless the deck needs it. No Builders Camp deck has them today.

### Chrome
- **Progress bar:** 4px, green `#27A54D`, at the very top. `transition: width 300ms`.
- **Bottom bar:** 56px, shown on hover or focus. It holds `←` `→` buttons (`aria-label`s, `radius 999`, green on hover), an `i / N` counter (tabular numbers), a Back pill when inside a branch, and a "Notes" button.
- **Notes panel:** floating, radius 14, label "SPEAKER NOTES" at 12px/700 with `0.12em` tracking. Empty state: "No notes for this slide." Mark it `aria-live="polite"`.
- **Logo:** wordmark at `left:128px; top:55px; 217×26`, on every slide. White on dark slides. Top-right running title at 24px `#6B6B6B`, written as "AI-Native Product Management · Session 1 · Foundations".

### Slide change and builds
- **Slide change:** fade only, `opacity 350ms ease`. Drop `data-transition="push"`: it's declared on dividers but no runtime plays it (D-20).
- **Builds:** `data-build-in="<kind> <order> [auto]"`. Kinds:

| Kind | From | Transition |
|---|---|---|
| `fade` | opacity 0 | `opacity 500ms ease` |
| `rise` | `translateY(28px)` | + `transform 500ms cubic-bezier(.2,.8,.2,1)` |
| `left` / `right` | `translateX(∓48px)` | same |
| `pop` / `scale` | `scale(.85)` | same |
| `wipe` | `scaleX(0)`, origin left | same |

- **Build-outs:** `data-build-out`, `450ms ease`. Rise-out goes to `translateY(-28px)`, pop-out to `scale(.9)`. Use a **focus veil** (white at 80% over the earlier content, radius 22) to dim what's done.
- **Auto groups:** the first fires **350ms** after the slide enters, then one every **420ms**. A click finishes any pending groups at once.
- **Reduced motion:** `transition:none !important`. Builds and auto groups appear immediately.

### Branching (drill-down)
- A `.goto` card (`data-goto="<slideId>" data-return="<slideId>"`) opens an annex slide.
- **Next** steps through the annex, then returns to the parent slide.
- The counter reads "Stage 1 of 10 · Vision · Opened from the flow · Next returns there". Show a "← Back to flow" pill.
- **Card style:** radius 20, padding 20/26. Either 2px `#D9D9D9` on white, or a mint `#E9F6ED` fill.
- **Hover and focus:** green border plus ring `0 0 0 6px rgba(39,165,77,.18)`, transition 200ms.

### Live embeds
- Animated diagrams run in sandboxed `srcdoc` iframes, using Montserrat, never a Helvetica fallback (D-27).
- Start on `IntersectionObserver` or slide entry, restart on re-entry.
- Always ship a reduced-motion final state.
- Ambient loops: at least **1300ms** per cycle, one per slide.

---

## 2. Copy to clipboard (everywhere)

One pattern, unifying the 3 variants that shipped (D-23):

| State | Deck card / inline button | Workbook / page |
|---|---|---|
| Rest | "Copy prompt" — green pill, 700, radius 999 | "Copy" or "Copy prompt" button |
| Success | "Copied ✓" — button turns ink, **2000ms**, then resets | Toast "Copied ✓" (bottom-centre ink pill), 2000ms |
| Failure | Select the text + "Select the text and copy" | Select the text + toast "Press Ctrl+C or ⌘C to copy" |

- Call `navigator.clipboard.writeText` inside the click handler, with a fallback that selects the text.
- Keep the prompt source in `<script type="text/plain" id=…>` or in the element itself.
- **Slides-type decks run no script.** Pair each prompt with a "Scan to copy" QR panel: inline SVG, crisp edges, ink on white, caption 18–24px muted.

**Copy-prompt card (deck):**
- Black, radius 20, padding 24/30.
- Label 24px green, 3px tracking, uppercase ("PROMPT TO PASTE").
- Prompt text 24px white. Placeholder `[blanks]` highlighted with `rgba(39,165,77,.25)`.

---

## 3. Workbooks

### Structure
- Hash-routed **tabs** (`#tab-1` …, active tab `aria-current="page"`). Folder style, radius `10px 10px 0 0`.
- A sticky **step rail**:
  - Step cards radius 14.
  - The current step has a 2px ink border and shadow `4px 4px 0 #000`.
  - Done steps get a green ✓.
- Exercise naming: "Exercise 1 · Session 1 · Prompting".
- Each step ends with **"Done when:"**, one line with the completion criterion.

### Inputs and choices
| Element | Spec |
|---|---|
| Text inputs | radius 10, 15px text, 1px line border, green focus outline 3px, offset 2px |
| Option cards / chips | radius 14 (cards) or 999 (chips). Pressed = green fill and white text, `aria-pressed` |
| Segmented toggle | `aria-pressed` buttons in a pill track |
| Prompt builder | Live preview in an ink prompt block (radius 12, 13.5px/1.55, max-height 380px, scroll). `[bracket]` blanks highlighted at 25% green |
| Accordions | Native `<details>` / `<summary>` |
| Empty state | Dashed 1px border, radius 12, one sentence + one action |

### Saving
- Use `localStorage` key **`bc-<course>-v<n>`** (e.g. `bc-ainpm-workbook-v1`). Never `sm-…` (legacy prefix).
- Debounce saves by **300ms**. Wrap every read and write in `try/catch`. The page must render correctly with empty storage.
- Migrating old keys is allowed (read old, write new). Save the participant's name field too.

### Feedback, grading and room
- **Claude grading** (artifact `sample` capability):
  - 5 criteria × 0–2 = **/10**, with a 44px score and 14px dot meters.
  - Callouts "What works" / "Change this first", plus "A stronger version".
  - Always offer the fallback "Or grade it in your own Claude" with a copyable grading prompt.
- **Downloads** (`downloads` capability): `.md` files, and `SKILL.md` zipped with JSZip. Without the capability, show the text with a Copy button.
- **Facilitator view** (`room` + `user`, editors only): a "★ The room" tab with a live board (table, tabular numbers) and "Room average".

### Theme
Follow the OS theme (`prefers-color-scheme`) plus `[data-theme]` overrides. The dark theme uses `#000` bg, `#1A1A1A` cards, `#D9D9D9` body and `#8A8A8A` muted. There's no theme toggle in the UI.

---

## 4. Page-level interactive artifacts (hubs, explainers, tools)

- Cards that link: radius 16, hover lift `translateY(-2px)` + border to ink over **150ms**.
- Keyboard hints: `<kbd>` chips with a 1px border, radius 6, 12px.
- Focus: `outline: 3px solid #27A54D; outline-offset: 2px`. On green surfaces, use the `#E9F6ED` outline.
- A deck hub card shows "01" (64px/800 green), the title, and an "Open deck" green pill.
- **Accessibility:** every control is reachable by keyboard, with a visible focus ring and 44px touch targets. Use `aria-live` for saved, copied and graded states. Results never rely on colour alone.

---

## 5. Not part of the system (avoid unless the brief needs it)

Timers and countdowns, modals (use inline panels), tooltips for essential info, autoplaying audio, print buttons (the artifact viewer can't print), swipe-only navigation.

---

## 6. QA checklist for any interactive piece

- [ ] The keys in §1 work; Back shows built state; deep link opens the right slide or step.
- [ ] Builds use the kinds and timings above; a click skips the auto chain.
- [ ] Reduced motion: no transforms, everything visible.
- [ ] Copy works and its fallback works. Slides-type decks have a QR instead.
- [ ] Storage key is `bc-…-v<n>` with try/catch; the page works with storage blocked.
- [ ] Logo position and running title are correct on every slide.
