# Playbook — LinkedIn and social (static posts, carousels)

> For motion/video see `motion.md`. Voice: `../BRAND.md` §3. Values from the deck system, Shorts spec and website; LinkedIn-specific sizes follow LinkedIn's supported formats. Layout specifics not seen in a shipped asset are marked **[inferred]**.

## 1. Formats

| Format | Size (px) | Use |
|---|---|---|
| **Portrait post (default)** | **1080×1350 (4:5)** | Single-image posts, quote cards, stat cards |
| Square post | 1080×1080 (1:1) | Event announcements, cross-posting to Instagram |
| **Carousel (document/PDF)** | **1080×1350 per page (4:5)**, export as PDF | Step-by-step guides, frameworks, "N lessons" |
| Carousel alt | 1080×1080 per page | When reusing square frames |
| Link preview / OG image | 1200×627 (1.91:1) | Website pages, event pages |
| Event cover (Luma/LinkedIn event) | 1600×900 (16:9) | IRL sessions — "WHAT WILL YOU BUILD THIS WEEK?" style |
| Profile/company avatar | 400×400 | `assets/logo/builders-camp-stacked-white-on-black-500.png` |
| Company banner | 1128×191 | Wordmark white on ink, green tagline |

## 2. Grid and safe area (4:5, 1080×1350)

- Margins 72px all sides [inferred]; 12-column grid, 24px gutters.
- Header row y 72–132: eyebrow left (24px/700 uppercase, tracking 0.12em, green) · page counter right on carousels (`03 / 08`, 24px/600 muted).
- Body zone y 160–1150.
- Footer row y 1210–1278: wordmark black (height 28px) left · handle/URL "builderscamp.com" right (22px/500 muted). Covers and end pages may drop the footer row.
- LinkedIn crops feed previews of tall images near 4:5 — keep the hook inside the top 60% of the cover.

## 3. Type scale @1080 wide

| Element | Size / weight | Tracking | Notes |
|---|---|---|---|
| Cover hook | 96–120px / 800 | −0.03em | ≤ 8 words, key phrase in green |
| Page title | 64–72px / 800 | −0.025em | ≤ 6 words |
| Body | 34–40px / 500 | 0 | ≤ 35 words per page, line-height 1.3 |
| Big number | 240–320px / 800 | −0.04em | green or ink |
| Labels / eyebrows | 24–28px / 700 | 0.12em, uppercase | green |
| Footer / meta | 22px / 500 | 0 | muted `#737373` |

Never below 22px. Montserrat only (Nanum Brush Script allowed for one word on IRL posts).

## 4. Templates

**A. Statement / quote card (4:5).** White (or Paper `#FAFAF7`), optional "rays" motif top-right at 7% opacity, hook 110px/800 left-aligned at y ~300, key phrase in green; attribution 28px/600 + 24px muted; wordmark footer.

**B. Stat card.** Eyebrow ("FROM 4,000+ BUILDERS"), number 300px/800 green, label 40px/700 ink, source line 22px muted (always cite the source).

**C. Carousel (6–10 pages).**
1. **Cover:** ink `#141414` or black background, eyebrow green, hook 110px/800 white with green phrase, "Swipe →" 24px/600 muted bottom-right.
2. **Problem page:** white, title + 1 paragraph.
3–N. **Step pages:** giant step numeral `01` (200px/800 green), title 64px/800, body ≤ 35 words, one diagram/UI mock/checklist (feature-card style: white, 1px `#E6E6E6`, radius 24 at this scale).
4. **Recap page:** all steps as a numbered list (36px/700), mint `#E9F6ED` background.
5. **CTA page:** ink background, white wordmark (height 48px), line "Learn AI + Product at BuildersCamp.com" 64px/800 white with "BuildersCamp.com" green; optional green pill "Free guide" / "Join the Membership".

**D. Event announcement (1:1 or 4:5).** Black background, hook "WHAT WILL YOU BUILD THIS WEEK?" style (uppercase 800, white), wordmark white, green "IRL" pill + city, date/time line 32px/600 "Thu, 12 November · 17:00 – 20:00", venue 28px muted, "FREE" chip green tint.

**E. Bootcamp promo.** Flat cover colour (black or `#5271FF`), bootcamp name 96px/800 white centred, "created by <instructor>" pill with avatar top-left, format chips ("2 weeks", "Live or Self-Paced") bottom.

## 5. Colour use

70% white/paper or ink, accents green only. Coral `#FF7A59` only for time-limited offers (with ink text). Track colours only when the post is about that track. No lime, no navy, no gradients behind text.

## 6. Post copy

- Line 1 = the hook (≤ 60 chars, keyword first, no emoji first). Line 2 blank.
- Short paragraphs (1–2 lines), numbers as digits, one idea per line.
- End with one ask ("Comment GUIDE and I'll send it", "Link in comments", "Join us in Porto →").
- Max 3 hashtags at the end (#ProductManagement #AI #ProductBuilders). No em/en dashes. No "Here's…" opener.
- Tag people only with permission; never name clients without written OK.

## 7. Accessibility

Alt text for every image (describe the content and repeat the on-image words). Contrast per `../tokens/contrast.md`. Carousels: one idea per page; page counters.
