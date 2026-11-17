# Builders Camp — Design System

> Version 1.0 · 2026-11-17. Tokens live in `tokens/tokens.json` (source of truth) → `tokens/tokens.css` + `tokens/tailwind-preset.cjs` (generated: `node brand/tokens/build.mjs`).
> Stack assumption: React + Tailwind + **shadcn/ui** (Radix) + Lucide — what every Builders Camp app already uses. The CSS variable names (`--background`, `--primary`, `--accent`…) match shadcn, so dropping in `tokens.css` re-themes existing shadcn components with no code changes.
> Measured values come from builderscamp.com computed styles (Nov 2026). Status per value (shipped/declared/sampled/inferred) is in `tokens.json`.

---

## 1. Colour tokens

### Semantic (use these in code)
| Token | Light | Dark | Use |
|---|---|---|---|
| `background` | `#FFFFFF` | `#101318` | Page |
| `foreground` | `#141414` | `#FAFAFA` | Text, headings |
| `card` | `#FFFFFF` | `#14181F` | Cards (always with 1px border) |
| `primary` | `#141414` | `#FAFAFA` | Ink buttons, dark pills, selected states |
| `primary-foreground` | `#FFFFFF` | `#101318` | Text on primary |
| `secondary` / `muted` | `#F5F5F5` | `#21242C` | Alternate sections, chip/pill fills, disabled bg |
| `muted-foreground` | `#737373` | `#A6A6A6` | Body copy on white, captions, second headline line |
| `accent` | `#27A54D` | `#27A54D` | **Brand green.** Primary CTA, links-in-UI, eyebrows on slides |
| `accent-foreground` | `#FFFFFF` | `#FFFFFF` | Text on green (only ≥18.66px bold, else use `accent-hover`) |
| `accent-hover` | `#1D7F41` | `#2EBF5A` | Hover/pressed green; accessible CTA fill |
| `accent-tint` | green @10% | green @18% | Icon chips, selected rows, highlights |
| `border` / `input` | `#E6E6E6` | `#272C35` | All 1px lines, input borders |
| `ring` | `#27A54D` | `#27A54D` | Focus ring |
| `destructive` | `#EF4343` | `#EF4343` | Errors, destructive actions |

Dark mode is opt-in: add `class="dark"` (shadcn) or `data-theme="dark"`. The marketing site ships light only; dark tokens exist for the platform/app and for dark slides. For artifacts honour `prefers-color-scheme` (see `playbooks/artifacts.md`).

### Feedback
| State | Border/icon | Background | Text/badge |
|---|---|---|---|
| Success / correct | `#16A34A` | `#F0FDF4` | badge bg `#DCFCE7`, text `#16A34A` (≥14px bold) |
| Warning / partial | `#F59E0B` | `#FEF3C7` | text `#78350F` (preferred) or `#D97706` |
| Error / incorrect | `#EF4444` | `#FEF2F2` | badge bg `#FEE2E2`, text `#DC2626` |

### Track & category
Tracks: `bg-gradient-track-vibe-coding` (orange), `bg-gradient-track-ai-product` (blue), `bg-gradient-track-leadership` (slate), `bg-gradient-track-discovery` (green) — horizontal gradients (solid fallbacks: `bg-track-<name>`), white 14px/600 label. Calendar cards use a 3px left border in purple `#8B5CF6`, blue `#3B82F6` or emerald `#10B981` by programme family. **Chart series order:** ink `#141414`, green `#27A54D`, blue `#3B82F6`, orange `#EA580C`, purple `#8B5CF6`, slate `#4B5563`; highlight series always green, the rest greys when only one series matters.

## 2. Typography

Font: **Montserrat** 300–900 (`font-sans`), accent **Nanum Brush Script** (`font-brush`), code `font-mono`. Load: `https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800;900&family=Nanum+Brush+Script&display=swap` (already imported by `tokens.css`).

| Style | Desktop size/line | Mobile (<768) | Weight | Tracking | Tailwind | Use |
|---|---|---|---|---|---|---|
| Display | 128/128 | 64/64 | 800 | −0.05em | `text-bc-display` | One statement per page ("build anything") |
| H1 | 60/60 | 36/45 | 800 | −0.025em | `text-bc-h1` | Page hero; two-tone |
| H2 | 36/40 | 30/36 | 700 | −0.025em | `text-bc-h2` | Section titles |
| H3 | 20/28 | 18/28 | 700 | −0.025em | `text-bc-h3` | Card titles |
| H4 | 18/28 | 16/24 | 700 | −0.025em | `text-bc-h4` | Sub-heads, list titles |
| Lead | 20/28 | 18/28 | 300 | 0 | `text-bc-lead` | Hero subtitle, muted colour |
| Body | 16/24 | 16/24 | 400 | 0 | `text-bc-body` | Paragraphs |
| Small | 14/20 | 14/20 | 400–500 | 0 | `text-bc-small` | Card descriptions, nav, meta |
| Caption | 12/16 | 12/16 | 400–600 | 0 | `text-bc-caption` | Legal, timestamps, chip text |
| Eyebrow | 12–14/16 | 12/16 | 600 | 0.05em, UPPER | `text-bc-eyebrow` | Section kickers |
| Button | 14/20 | 14/20 | 600 | 0 | `text-bc-button` | All buttons |

Slides and social use their own scale — see `playbooks/slides.md` and `playbooks/social-linkedin.md`.

## 3. Spacing, layout, grid

- **Base unit 4px** (Tailwind scale). Common: 8 (tight), 16 (default gap), 24 (card padding, gutter), 32, 48, 64, 96.
- **Section rhythm:** `py-24` (96px) standard, `py-16` (64px) compact, alternating white and `#F5F5F5` bands for long pages.
- **Containers:** `max-w-container` 1200px (page), `max-w-content` 1024px, `max-w-reading` 768px (articles, quizzes, forms), `max-w-copy` 512px (hero subtitles, hero form). Side padding `px-6` (24px), `lg:px-8`.
- **Grid:** 12 columns, 24px gutters. Feature cards 3-up (lg) → 2-up (md) → 1-up. Bootcamp carousel cards ~320px wide. Pricing 2-up centred.
- **Breakpoints:** sm 640 · md 768 · lg 1024 · xl 1280 · 2xl 1400 (container capped at 1200).
- **Alignment:** hero and section titles centred on marketing pages; left-aligned in app and long-form.

## 4. Radius, borders, elevation

| Token | Value | Use |
|---|---|---|
| `rounded-md` | 8px | Buttons, inputs, nav buttons, code blocks |
| `rounded-lg` | 10px | shadcn default (`--radius`) — dialogs, dropdowns |
| `rounded-xl` | 12px | **Cards** (default), image frames |
| `rounded-2xl` | 16px | Large cards, quiz/challenge cards, video frame |
| `rounded-3xl` | 24px | Hero panels on grey |
| `rounded-full` | 9999px | Pills, badges, chips, avatars, small CTAs in bars, tabs/filters |
| `rounded-deck` | 20px | **Slide-scale cards only** (decks at 1920×1080) |
| `rounded-brutal` | 4px | Neo-brutalist deck boxes |

Borders: always 1px `border` colour. Elevation is subtle: `shadow-bc-sm` (inputs), `shadow-bc-md` (cards on hover, carousel cards — most used), `shadow-bc-lg` (popovers), `shadow-bc-xl` (hero media, featured pricing). **Hard "brutalist" shadows** (`shadow-bc-brutal` `8px 8px 0 #000`, `shadow-bc-brutal-sm` `4px 4px 0 #000`, with a 2–3px black border) are a **deck/workbook/artifact-only** treatment — never in the website or app. Also deck-only: `shadow-bc-halo` (`0 0 0 14px #E9F6ED`) and the focus ring `shadow-bc-focus-ring` (`0 0 0 6px rgba(39,165,77,.18)`).

## 5. Components

Spec format: anatomy → tokens → states. All interactive elements: `transition-colors duration-bc-fast`, focus `ring-2 ring-ring ring-offset-2`.

### Buttons
| Variant | Fill / text | Size | Use |
|---|---|---|---|
| **Primary (green)** | `bg-accent text-white` → hover `bg-accent-hover` | h-12 (48) px-6 / h-10 px-4 / h-9 px-3; radius 8; 14px/600 | The one main CTA per view: "Join the Membership →" |
| **Primary (ink)** | `bg-primary text-primary-foreground` → hover 90% | same | Secondary-important CTA, CTAs on green or on photos, quiz submit |
| **Outline** | white, 1px border, ink text → hover `bg-muted` | h-9/h-10 | "Member Login", "Start challenge →" (full-width in cards) |
| **Ghost / link** | text ink, underline-offset-2 on hover | — | "See all Quests →", "Book a 15 min call" |
| **Pill** | `rounded-full` ink or white, 12px/600, px-3 py-1 | h-6–8 | In promo bar ("Claim 50€"), filters ("Porto", "Lisbon") |
| Disabled | `bg-muted text-muted-foreground`, no shadow | — | Incomplete forms |
Trailing `ArrowRight` 16px on forward actions; leading emoji allowed only on soft CTAs ("📞 Book a 15 min call").

> Accessibility note: shipped green buttons use white 14px text on `#27A54D` (3.19:1). New work: use `bg-accent-hover` (`#1D7F41`) as the resting fill for small-label buttons, or 18.66px+ bold labels. See DECISIONS D-07.

### Inputs
h-12 (hero) or h-10, radius 8, 1px `input` border, px-3, 14–16px, placeholder `muted-foreground`. Label 14px/500 above. Inline hero form: name + email + green button in one row (stack on mobile). Errors: border `destructive` + 12px message below.

### Cards
- **Feature card:** white, 1px border, radius 12, p-6. Icon chip (40px circle, `bg-accent-tint`) + H3 18/700 inline, body 14px muted, footer link green 14px/500 "See all … →".
- **Bootcamp card:** cover (aspect ~16:10, black or `#5271FF`, white bold centred title, "created by" pill with avatar top-left) + body p-4: duration chip ("2 weeks", `bg-muted rounded-full text-xs`), title 16/700, 2-line description 14 muted, arrow top-right.
- **Challenge card:** radius 16, grey header band (80px `#F4F4F5`), time meta "⏱ 60 min" right-aligned 12px muted, title 16/700, story teaser 14 muted, full-width outline "Start challenge →" button.
- **Calendar card:** white, border, radius 8, **3px coloured left border**, date chip, title 16/700, "View details →".
- **Testimonial card:** white, border, radius 12, p-6: initials avatar (40px circle, `bg-muted`, 14/600) + name 14/600 + 5 amber stars 14px, quote 14px muted.
- **Pricing card:** radius 16, featured = ink background white text with green "MOST POPULAR" pill overlapping the top edge; price 48/800 "€749"; green checklist; CTA full width (white on ink card, green on white card).
- **Event card (IRL):** cover image/graphic top, chips "FREE" (green tint, green text) + "PAST" (muted), title 18/700, meta lines 14 muted, social proof "71 builders came" 14/600, "See it on Luma ↗".

### Badges, chips, pills
- **Eyebrow pill:** `rounded-full`, amber ★ + "INCLUDED WITH MEMBERSHIP" 12–14px/600 uppercase, tracking 0.05em, ink 80%, background amber tint gradient.
- **Status chip:** `rounded-full px-3 py-1 text-xs font-semibold` — primary (ink) for active/filter-on, muted for neutral, green tint for "FREE"/"New".
- **Grade pill (results):** feedback badge colours, 14px/600.
- **Social-proof pill:** `bg-muted rounded-full` with stacked avatars + "★★★★★ 4.9/5 rated by participants".

### Navigation
- **Promo bar** (optional, top): coral `#FF7A59`, 40px, centred 14px ink text with bold key phrase + amber countdown chip + ink pill CTA; dismiss ×.
- **Header:** white, 1px bottom border, sticky; logo left (20–24px tall); centre dropdowns "For Teams / For Companies / For Individuals / Free Masterclasses" (14/500 ink, chevron); right: outline "Member Login" + green "Book 15 min call".
- **Footer:** white, logo + mission line + "We bring 🍀 to product builders"; 4 link columns with 12px/600 uppercase muted headings (IS THIS FOR ME? · GUIDES · COMPARE · COMPANY); bottom rule + "© 2026 Builders Camp. All rights reserved." centred 12–14 muted.
- **App shell** (platform/members): left sidebar 256px (`--sidebar-*` tokens: bg `#FAFAFA`, text `#3F3F46`), top bar 64px, content `max-w-content`.

### Feedback & overlays
- **Toast:** shadcn Sonner, bottom-right, white card, 14px, icon by state.
- **Dialog:** radius 10, p-6, max-w 512px, overlay black/60.
- **Cookie banner:** card bottom-left, 🍪 + "Cookie Time!" H3, three buttons (green Accept All, outline Reject All, ghost Customize).
- **Quiz answer option:** bordered box radius 12, p-4; selected = `bg-muted` + ink border; result states use feedback colours + ✓/⚠/✗ icon left; feedback paragraph 14px italic muted below.
- **Code block:** bg `#1A1A1A`, border `#333`, radius 8, p-4, 14px mono `#E6E6E6`, copy button top-right.
- **Progress / score:** radar or ring in ink with green value; big % 48/800.

### Patterns
- **Two-tone hero:** social-proof pill → H1 (line 2 muted) → lead (max 512px, muted, 300) → inline form or CTA pair → 12px legal line → logo strip "Join 4,000+ product builders from these companies" (greyscale logos) → media frame (radius 16, shadow-xl).
- **Statement band:** eyebrow "IMAGINE YOU COULD" (12px tracking 0.2em muted) → display "build anything" → eyebrow "YOU CAN. HERE'S HOW."
- **Section header:** eyebrow pill → H2 two-tone → 16–18px muted paragraph (max 640px) → content → centred CTA + "Not sure? Talk to us. Book a 15 min call" (12px muted, underlined link).
- **Empty states:** one-line explanation + one action. Friendly, not cute.

### Interactive patterns
Deck controller, build steps, branching, copy-to-clipboard, workbook tabs/step rail/saving/grading: `playbooks/interactions.md`. Diagrams and charts: `playbooks/diagrams.md`. Tailwind exposes the deck neutrals as `bg-deck-card`, `text-deck-muted`, `border-deck-line` etc.

## 6. Do / Don't (UI)
- Do keep one green CTA per viewport. Don't make every button green.
- Do use `#F5F5F5` bands to separate sections. Don't use coloured section backgrounds (except black for a single high-emphasis band/pricing card).
- Do use radius 8 for controls, 12–16 for containers, full for pills. Don't mix sharp and round corners in one component.
- Don't introduce new colours, fonts or shadows. Add a token first (PR to this repo).
