# Playbook — Platform and product UI (members portal, challenges, quizzes, registration, admin)

> Reference implementations: members.builderscamp.com, challenges, quizzes, registration. These are moving into one monorepo (`apps/*`) — all apps use the same `tokens.css` + Tailwind preset.

## 1. Principles

1. **Calm and functional.** Marketing energy stays on the website; the app is quiet: white, ink, grey, green only for the primary action and progress.
2. **Content first.** Learning content (challenge stories, quiz questions) is the hero — generous whitespace, reading width 768px.
3. **One primary action per screen.**
4. **Dark mode supported** via `class="dark"` (tokens `color.dark`).

## 2. App shell

- Top bar 64px: logo left (20px tall), search/centre optional, avatar menu right (32px circle).
- Sidebar (desktop ≥ 1024) 256px: `--sidebar-*` tokens; items 14/500, 36px tall, radius 8; active = `bg-accent-tint` + green icon + ink text.
- Content: `max-w-content` (1024) for dashboards, `max-w-reading` (768) for learning flows; `px-6 py-10`.
- Mobile: bottom sheet nav or hamburger; no sidebar.

## 3. Screens and patterns

| Screen | Pattern |
|---|---|
| **Sign in** (members) | Centred card max-w 400, H1 24/600 "Sign in", sub 14 muted "Welcome back. Sign in to your Builders Camp membership.", email + password, "Forgot password?" link right, green full-width "Sign in", "or" divider, outline "Continue with LinkedIn", legal 12 muted; footer "Privacy · Terms · Cookies". |
| **Catalogue / list** | Page title H1 36–48/800, count line ("47 challenges", 14 muted), 3-col card grid (gap 24), filters as pills. |
| **Challenge / lesson** | Back link "← Back to Challenges" (14 muted) → title 36/800 → meta chips (time, bootcamp) → story overview (16/1.6) → step cards with inputs (text, sections, table, code) → progress saved silently; "Saved" toast. |
| **Quiz** | Header logo; title 30/700; name/email fields; 10 question cards (white, 1px border, radius 16, p-6–8, gap 24); options bordered boxes; submit pill button centred (ink when enabled, muted when disabled). |
| **Results** | Grade pill by band (0–49 red, 50–74 amber, 75–100 green); per-question cards with ✓/⚠/✗ states and italic feedback paragraph. |
| **Dashboard** | Greeting H1 ("Welcome back, <first name>"), next live session card (green left border), progress per track (track gradient bars), continue-learning carousel, leaderboard table. |
| **Admin** | Same shell, denser: tables 14px, row height 44, zebra none, 1px dividers, sticky header `bg-muted`. |

## 4. States

- **Empty:** icon (Lucide, 32px muted) + one sentence + one action. "No answers yet. Start your first challenge →".
- **Loading:** skeletons `bg-muted animate-pulse` matching layout; no spinners over 1s without text.
- **Error:** inline under the field (12px destructive); page errors in a card with "Try again" + "Contact us" (hey@builderscamp.com).
- **Success:** toast, 4s, plus inline confirmation where the action happened.
- **Progress:** green bars/rings; percentages as integers.

## 5. Microcopy

Sentence case, verb-first buttons ("Start challenge", "Submit quiz"). The shipped quiz app's "Submit Quiz" is a legacy exception; keep one convention per app. Use "you". Times in Lisbon time with 24h clock. Never blame the user ("That email isn't registered yet" not "Invalid email").

## 6. Data viz in app

Ink for the main series, green for the user/highlight, greys for context; track colours only for track-specific charts. Numbers in tables right-aligned, tabular figures (`font-variant-numeric: tabular-nums`).

## 7. Accessibility

Keyboard-complete (Radix gives this — don't break it), focus ring green 2px offset 2, 44px targets, `aria-live` for saved/submitted, results never colour-only, respects reduced motion.
