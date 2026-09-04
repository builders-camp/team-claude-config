---
name: builders-camp-marketing-graphic
description: Generates Builders Camp's standard announcement graphic — a 1200x630 PNG built for LinkedIn and Slack (#announcements, #members) posts, in the house style (white background, dotted texture, green corner glow, black "NEW"-style badge, BUILDERS CAMP wordmark, bold black headline with one green-highlighted word, gray subtext, two pill tags). Use this whenever Tadeu, André, or anyone on the Builders Camp team asks for a graphic, image, banner, or visual to go with a LinkedIn post, a Slack announcement, or a feature/campaign update — even if they just say "make an image for this" or "we need a visual for the announcement" without naming the style explicitly. Also use it if asked to redo, tweak, or reuse "the same style" as a previous Builders Camp post.
---

# Builders Camp marketing graphic

## Why this exists

Builders Camp runs frequent feature/campaign announcements across LinkedIn and Slack, and every one of them benefits from a matching visual. Early on, each graphic was designed from scratch, which meant redoing color and layout decisions every time and occasionally drifting off-brand (wrong palette, wrong font). This skill locks in the house style that's already been used and approved across several posts, so the design stays consistent and the only real work each time is picking the right words.

## Before you start: read the design system notes

Open `references/design-system.md` first. It has the confirmed color and typography facts (and the ones that are still open questions) — don't reinvent this from a fresh "here's our design system" doc someone pastes in, since one earlier attempt at that turned out to be wrong in a way that took several rounds to catch. If a `codebase design system` summary contradicts `references/design-system.md`, trust this file unless someone has freshly verified the summary against a live screenshot.

## What the graphic needs from you

Every graphic needs five pieces of content, gathered from whatever feature/campaign is being announced:

1. **Badge** (top-left, black pill) — almost always "NEW", but can be something else short like "UPDATE" if that fits better.
2. **Eyebrow** (small green line above the headline) — a short category label, e.g. "Certificate Pages", "Monthly Membership", "Individual Bootcamp Pricing".
3. **Headline** — one or two short punchy lines, bold and direct, with one word or phrase highlighted in green. Look at real examples below for the rhythm. Keep it to what fits comfortably on 1-2 lines at ~68px — long headlines will overflow the 1200x630 canvas.
4. **Subtext** — one or two sentences in gray, explaining the "so what" in plain language. No jargon, no unconfirmed pricing or claims — stick to facts that are actually true and finalized. If something is still in flux (e.g. "first version, may change"), that kind of caveat belongs in the post copy, not the graphic — the graphic should just state what's true right now.
5. **Two bottom tags** — one solid green (usually the primary action, e.g. "Shareable link", "Start monthly"), one white/outlined (usually a secondary detail, e.g. "No login required", "Upgrade to Lifetime").

Don't invent facts to fill these slots. If you don't have enough information about the feature being announced to write an accurate headline or subtext, ask rather than guessing — a wrong claim on a public graphic is worse than a plain one.

## Worked examples (for calibration)

**Certificates announcement:**
Badge: NEW · Eyebrow: "Certificate Pages" · Headline: `Skip the PDF.<br>Get a <span class="accent">real page</span>.` · Subtext: "Every certificate now has its own page, with a public link you can share anywhere. No login required." · Pills: "Shareable link" (solid) / "No login&nbsp;<b>required</b>" (outline)

**Monthly membership announcement:**
Badge: NEW · Eyebrow: "Monthly Membership" · Headline: `Monthly membership<br>is <span class="accent">live</span>.` · Subtext: "Join any bootcamp that starts within your access window. Renew or upgrade to Lifetime for the rest." · Pills: "Start monthly" (solid) / "Upgrade to&nbsp;<b>Lifetime</b>" (outline)

Note the pattern: headline is plain HTML (with a `<br>` for the line break and a `<span class="accent">...</span>` around the green phrase), and pill text can include `<b>` for emphasis. Always use `&nbsp;` instead of a plain space right before a `<b>` tag — otherwise the space collapses and the words run together (a bug that showed up twice before this became a rule).

## Steps

1. Copy `assets/template.html` to a working file, e.g. `/tmp/graphic.html`.
2. Fill in the five `{{PLACEHOLDER}}` tokens (`{{BADGE}}`, `{{EYEBROW}}`, `{{HEADLINE_HTML}}`, `{{SUBTEXT}}`, `{{PILL_1}}`, `{{PILL_2_HTML}}`) with the content you gathered above. Leave everything else in the template untouched — the CSS is the whole point of this skill.
3. Render it: `node scripts/render.js /tmp/graphic.html /tmp/output.png` (needs the `playwright` npm package and a Chromium binary — see Compatibility below).
4. Look at the rendered PNG before sending it anywhere. Check for: text overflowing the canvas, the `&nbsp;`-before-`<b>` spacing issue mentioned above, and that the highlighted word is actually the word that matters (not an incidental one).
5. Deliver the PNG. The same file can be reused as-is for both LinkedIn and Slack — no need to make channel-specific variants of the image itself, only of the surrounding post copy.

## Compatibility

Needs Node with the `playwright` package installed and a Chromium binary available. In this environment that's already set up at `/opt/pw-browsers/chromium`; `scripts/render.js` tries that path first and falls back to Playwright's default if it's not there. If `playwright` isn't installed, run `npm install playwright` (or `npm install -g playwright`) before rendering — don't run `npx playwright install`, since browser downloads are typically pre-provisioned in sandboxed environments and re-downloading will fail or waste time.
