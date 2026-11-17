# Playbook — Claude artifacts (workbooks, explainers, session pages, interactive tools)

> Derived from the AI-Native Product Management workbook and session artifacts. Applies to any HTML page Claude publishes with the Artifact tool for Builders Camp (and to typed artifacts: Slides → `slides.md`, Docs → `pdf-guides.md` voice rules).

## 1. Page contract

- Self-contained HTML; Montserrat from Google Fonts; tokens copied as CSS variables (paste the `:root` and `.dark` blocks from `../tokens/tokens.css`, or the short set below).
- Light + dark: define colours on `:root`, redefine under `@media (prefers-color-scheme: dark)` guarded by `:root:not([data-theme="light"])`, and under `:root[data-theme="dark"]`. `body` gets an explicit background.
- Mobile first: works at 390px with 16px side gutter, no horizontal scroll.
- Title: 2–4 words ("AI-Native PM Workbook"), not "X: explainer".

### Minimal token block for artifacts
```css
:root{
  --bg:#FFFFFF; --surface:#F4F4F4; --ink:#141414; --body:#141414; --muted:#737373; --line:#E6E6E6;
  --green:#27A54D; --green-strong:#1F843D; --mint:#E9F6ED; --on-green:#FFFFFF;
  --radius:12px; --font:'Montserrat',system-ui,sans-serif;
}
@media (prefers-color-scheme: dark){ :root:not([data-theme="light"]){
  --bg:#000000; --surface:#1A1A1A; --ink:#FFFFFF; --body:#D9D9D9; --muted:#8A8A8A; --line:#333333; --mint:#E9F6ED;
}}
:root[data-theme="dark"]{ --bg:#000000; --surface:#1A1A1A; --ink:#FFFFFF; --body:#D9D9D9; --muted:#8A8A8A; --line:#333333; }
body{ background:var(--bg); color:var(--body); font:16px/1.5 var(--font); }
```
(Artifacts keep the workbook's pure-black dark theme — D-08.)

## 2. Layout

- Sticky header 56px: wordmark (18px tall; white version in dark) left · title/section crumbs centre or right in 14px muted ("Exercise 1 · Session 1 · Prompting").
- Content `max-width: 768px` (reading) or 1024px (dashboards/maps).
- H1 `clamp(28px, 4vw, 40px)`/800, tracking −0.03em. Eyebrow 12px/700, 0.12em, uppercase, green.

## 3. Components (workbook vocabulary)

| Component | Spec |
|---|---|
| Step / exercise card | `--surface` or white with 1px line, radius 14; current step gets 2px ink border + `4px 4px 0 var(--ink)` shadow |
| Panel (brutalist, optional) | 2px ink border, radius 6, `8px 8px 0 var(--ink)` shadow — use for the one hero panel per page |
| Prompt block | dark (#141414) radius 12, mono or Montserrat 15px, fill-in blanks highlighted `rgba(39,165,77,.25)`; copy button top-right |
| Callout | `--surface` radius 12, green uppercase key ("TIP", "WHY") 12px/700 |
| Pills | radius 999, 12px/700 uppercase; green fill for status, 2px ink border for links ("WORKBOOK · TAB 1 →") |
| Progress | score dots or 4px green bar |
| Tabs | underline style, active ink 2px + green text |

## 4. Interaction and motion

Fade-up 20px / 500ms `cubic-bezier(.2,.8,.2,1)` on first view; hover ring `0 0 0 6px rgba(39,165,77,.18)`; disable under reduced motion. Persist per-viewer conveniences (current tab) in `localStorage` with try/catch; shared state via artifact capabilities, not localStorage.

## 5. Content rules

- One job per artifact (a workbook, a map, a calculator).
- Lead with what the reader will do, in one sentence.
- Name exercises "Exercise N · Session N · Topic". Use the `·` separator.
- Keep client names out unless the artifact is for that client; then co-brand per BRAND.md §5.

## 6. Design System artifact

The Builders Camp **Design System** artifact is at https://claude.ai/artifact/CFqmfSpmckB5d4wJyEtXq1 (owner must share it for others to open it). For Slides/Design typed artifacts, select it as the design system; if absent, follow `slides.md`.
