# Playbook — Email (transactional, lifecycle, newsletter)

> No shipped HTML email template was reviewed (G-05/G-07): this spec is **[inferred]** from the web system and the notifications map (message names, sender, time zone). Confirm against Mailchimp/ESP templates before treating as final.

## 1. Sender and basics

- From: **Builders Camp <hey@builderscamp.com>** (team sender). Personal emails from a named person only for founder notes.
- Times always "Lisbon time", 24h ("17:00 Lisbon time").
- Subject ≤ 45 chars, specific, no clickbait, max one emoji. Preheader ≤ 90 chars that completes the subject.

## 2. Message catalogue (names from the notifications map)

| Message | Subject pattern | One ask |
|---|---|---|
| Confirm your presence | "Confirm your seat for <session>" | Confirm |
| Here's your day | "Today in <cohort>: <topic>" | Join live |
| Starting soon | "<Session> starts in 1 hour" | Join link |
| Session moved | "New time: <session> on <date>" | Update calendar |
| Wrap-up | "<Session> recap + your exercise" | Do the exercise |
| Certificate congrats | "You did it: your <bootcamp> certificate" | Share on LinkedIn |

(The Notifications map uses "Here's your day" internally; that's fine for a subject. The "never open with Here's" rule applies to social/Shorts only.)

## 3. Layout

- 600px wide single column, white body on `#F5F5F5` page background, 32px padding (20px on mobile).
- Header: wordmark black PNG (`assets/logo/builders-camp-stacked-black-transparent-945x451.png` scaled, or a 2x PNG export of the horizontal wordmark — G-01) 24px tall, left.
- Headline 28px/800 ink, tracking −0.5px; body 16px/24px `#141414`; secondary 14px `#737373`.
- **Button:** bulletproof (table-based) `#1D7F41` fill (accessible green — D-07), white 16px/700, radius 8, padding 14×24, full-width on mobile. One primary button per email.
- Info card (session details): `#F5F5F5`, radius 12, 16px padding, rows "📅 Thu, 12 Nov · 17:00 Lisbon time", "📍 Venue / Zoom link".
- Footer: 12px muted — "Builders Camp · We bring 🍀 to product builders", unsubscribe/preferences, address as legally required.
- Fonts: Montserrat via `<link>` with fallback `Arial, Helvetica, sans-serif` (Outlook will fall back).

## 4. Voice

Friendly, scannable, one ask. First line says why they're getting it. Bullets for details. Sign-off "See you there," + "The Builders Camp team" (or the instructor's first name).

## 5. Dark mode

Use transparent-background logo PNGs with a 1px white outer stroke baked in or provide both versions with `prefers-color-scheme` in `<style>`; avoid pure white boxes on large areas; test in Apple Mail and Gmail dark.

## 6. Accessibility

Real text (no image-only emails), alt on logo "Builders Camp", 16px min body, link text meaningful ("Join the live session", not "click here"), `lang="en"`, role="presentation" on layout tables.
