# Playbook — Marketing website (builderscamp.com and microsites)

> Reference implementation: builderscamp.com (live, Nov 2026). Components and tokens: `../DESIGN-SYSTEM.md`. Install: `../README.md`.

## 1. Setup

1. Import `brand/tokens/tokens.css` once at the app root (it loads Montserrat + Nanum Brush Script and defines all CSS variables, shadcn-compatible).
2. Tailwind: `presets: [require("<path>/brand/tokens/tailwind-preset.cjs")]`.
3. shadcn/ui components as-is; Lucide icons.
4. Light theme only on marketing pages.

## 2. Page skeleton

```
[Promo bar — optional, coral, dismissible]
[Header — sticky, white, 1px bottom border]
[Hero — centred, two-tone H1]
[Logo strip — "Join 4,000+ product builders from these companies"]
[Sections — py-24, alternating white / #F5F5F5 bands]
[Final CTA / pricing]
[Footer]
```

## 3. Section recipes (in the order the homepage uses them)

| Section | Recipe |
|---|---|
| Hero | Social-proof pill (avatars + ★ 4.9/5 + "Helping 4,000+ builders ship better products") → H1 60/800 two-tone → lead 20/300 muted, max 512px → inline form (name, email, green "Join the Membership →") → legal 12px → "Not sure? Talk to us. 📞 Book a 15 min call" |
| "Everything included" | Eyebrow "EVERYTHING INCLUDED" → H2 → 3×2 feature cards (icon chip, title, 2-line body, green "See all … →") |
| Interactive teaser | `#F5F5F5` panel radius 16, copy left + visual right (e.g. Builder Score radar), green CTA |
| Testimonials | H2 centred + stars line → masonry/carousel of testimonial cards, round prev/next buttons (36px, white, border) |
| Statement | "IMAGINE YOU COULD" / "build anything" (display 128) / "YOU CAN. HERE'S HOW." |
| Catalogue rows | Amber "★ INCLUDED WITH MEMBERSHIP" pill → H2 two-tone → copy → horizontal carousel of bootcamp cards → centred green "Discover all 41 Bootcamps →" + "Not sure? Talk to us." |
| Tracks | Left: track gradient bars with trophy icons; right: pill + H2 two-tone + copy + green CTA |
| Calendar | H2 + view toggle (Card / Calendar, segmented, radius 8) → month headings 18/600 muted → calendar cards with coloured left border |
| Pricing | `#F5F5F5` band, "Ready to be a Product Builder?" H2 + 💡 line → featured ink card ("MOST POPULAR", Lifetime) + white card (Monthly) |
| FAQ | shadcn Accordion, 16/600 questions, 1px dividers |
| Footer | see DESIGN-SYSTEM §5 Navigation |

## 4. Copy rules for web

- H1/H2 Title Case. Buttons Title Case + arrow. Body sentence case.
- Every section answers "what do I get" with a number: "All 41 Bootcamps", "9 Learning Tracks", "under 90 minutes".
- Social proof near every CTA ("Join 4,000+ builders", "Rated 4.9/5").
- Secondary path always available: "Not sure? Talk to us."
- Comparison pages ("Builders Camp vs X"): factual, tables, no disparaging language.

## 5. SEO and metadata

- `<title>`: "<Promise> | Builders Camp" (e.g. "Become an AI-Native Product Builder | Builders Camp").
- Meta description ≤ 160 chars with a number ("Join 4,000+ builders").
- OG image 1200×627: white, H1 72/800 two-tone, wordmark top-left, green accent bar or element.
- Favicon: `favicon.svg` (stacked mark) + 500px PNG.

## 6. Responsive rules

- Design at 1440 and 390. Hero H1 36px on mobile; inline form stacks (inputs full-width, button full-width h-12).
- Carousels become horizontal scroll with snap; show 1.2 cards to hint scroll.
- Nav collapses to logo + "Book a call" + hamburger sheet.
- No horizontal page scroll at 360px.

## 7. Microsites (IRL, events, challenges, quizzes)

Same tokens and header/footer. Allowed extras: IRL may use **Nanum Brush Script** for 1–2 accent words next to uppercase 800 Montserrat ("BUILDERS CAMP *irl*"), and large photography. Event sites never invent a new palette (the 2025 Producthon neon/pixel look is retired — D-02/D-05).

## 8. Performance and a11y

LCP < 2.5s; fonts `display=swap`; images WebP/AVIF with width/height; one `<h1>` per page; skip link; focus rings green; all form inputs labelled (placeholders are not labels); cookie banner keyboard-accessible.
