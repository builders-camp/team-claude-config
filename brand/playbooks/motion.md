# Playbook — Motion graphics (LinkedIn, Shorts, reels)

> Drives the automated motion pipeline (LinkedIn infographic/step-by-step videos) and the YouTube Shorts Engine. Derived from the Shorts Engine spec (rules v3.2–v4, Oct–Nov 2026, the most-tested motion spec we have), plus the deck motion system. LinkedIn-specific numbers that the Shorts pilots did not test are marked **[inferred]**.
> Tokens: `../tokens/tokens.json` (`motion.*`, `color.*`). Read `../BRAND.md` §3 (voice) first.

## 1. Formats

| Output | Size | Ratio | fps | Length (target / hard) | Notes |
|---|---|---|---|---|---|
| **LinkedIn feed video (default)** | 1080×1350 | 4:5 | 30 | 30–45 s / 15–90 s [inferred] | Best feed real estate; most viewers have sound off. |
| LinkedIn square | 1080×1080 | 1:1 | 30 | 30–45 s / 15–90 s [inferred] | When reused on Instagram feed. |
| YouTube Shorts / Reels / TikTok | 1080×1920 | 9:16 | 30 | 35–42 s / 20–58 s | Never ≥ 60 s (Content ID blocks). |
| Teaser loop (GIF/MP4) | 1080×1350 | 4:5 | 30 | 6–10 s | No narration; captions = on-screen text. |

Codec H.264 High, yuv420p, MP4, ~8–12 Mbps; AAC 48 kHz. Audio −14 LUFS integrated (±1), true peak ≤ −1.5 dBTP, two-pass loudnorm. Burn in captions (LinkedIn autoplays muted).

## 2. Look — two locked themes

| | **Paper & Ink** (house default) | **Dark** |
|---|---|---|
| Background | warm paper `#FAFAF7` (quizzes background; the Shorts spec names it only "warm paper") with subtle grain | `#0D0D0D`/`#141414` with dot grid (ink `#FFFFFF` at 6%) + animated grain |
| Type | ink `#141414` | white `#FFFFFF` |
| Accent | **green `#27A54D` as highlighter** (marker strokes behind words, underlines, strike-throughs) | **green as light**: soft glow (`#27A54D` radial at ~22% → 0), glowing key word |
| Illustration | ink line drawings, simple objects with minimal ink faces (eye, mouth), no mascots | same objects, white line, green glow on the focal one |
| Loss/error | red `#EF4444` only for loss | same |

Rules: one glowing/highlighted focal thing per frame. Blues and purples never dominate a frame. Never lime, never neon. Gradients/vignettes allowed only as light (glow, vignette), never as fills behind text.

## 3. Type

| Element | Font | Size @1080 wide | Notes |
|---|---|---|---|
| Hook / kinetic text | Montserrat 800 | 96–140px, tracking −0.03em | ≤ 7 words on frame 1 |
| Scene headline | Montserrat 800 | 72–96px | ≤ 5 words per beat on screen |
| Diagram labels | Montserrat 600 | 36–48px | never below 32px |
| Stat hero | Montserrat 800 | 400px numeral (9:16), 300px (4:5) | counts up, label 48px/600 below |
| Captions | Montserrat 700 | ~72px (min 64px) | see §6 |
| End card | Montserrat 800 | 72–88px | text only |

On-screen text **complements** the narration (the number, keyword or contrast word), never repeats it — except the hook.

## 4. Layout and safe zones

**9:16 (1080×1920)** — from Shorts pilot 5 (binding):
- Content zone: x 60–940, y 140–1600. Main action drawn big and low (fills down to ~y 1600 — no empty bottom third).
- Captions: y 1280–1440 on a soft backing.
- Keep clear: y > 1600 (platform UI) and the right strip x > 940 between y 900–1600 (buttons).

**4:5 (1080×1350)** [inferred, scaled from 9:16]:
- Content zone: x 72–1008, y 96–1150.
- Captions: y 1010–1150.
- Keep clear: bottom 120px.
- Title band (optional, for step-by-step): y 96–260.

**1:1 (1080×1080)** [inferred]: content x 72–1008, y 72–860; captions y 880–1000.

Automated QA must fail a render for: text outside zone (check every bounding box, every frame), empty bottom third, crops during camera moves, more than ~12 words on screen at once, colours outside palette.

## 5. Structure (beat sheet)

Default 40 s at 165 wpm ≈ 105 spoken words.

| Beat | Time | Content | Rules |
|---|---|---|---|
| **Hook / boom** | 0–2.5 s | First sentence 6–12 words with a concrete number, object or person; opens a question. | Frame 1 must read at 180px wide, sound off, in < 1 s. First visual change by 1.5 s. No logo, no greeting, no "So", "Meet…", "Here's…". |
| Promise | 2.5–8 s | Say what they'll get; keyword spoken. | |
| Story | 8–20 s | Character + tension (fictional first names allowed, never a real company presented as real). | |
| **Lesson switch** | ~50% | Visible switch (camera move + light change) on the lesson's first word. | Re-hook with *new information*, never "but wait". |
| Lesson | 20–34 s | One move, taught deeply. A framework of 3 reads as a list — avoid. | One number per sentence; ≤ 14 words per sentence. |
| Punch | 34–38 s | Final line ≤ 10 words; the picture lands on the last word. | |
| **End card** | last 1.5–2.3 s | Text only, unnarrated: **"Learn AI + Product at BuildersCamp.com"** (LinkedIn variant may use "Free guide · BuildersCamp.com/<path>" in a green lower bar). | No icon, no logo. Last frame visually matches frame 1 for a clean loop. |

**Step-by-step / infographic variant (LinkedIn)** [inferred from the scene library]: Hook (0–3 s) → "N steps" title card (3–5 s) → one scene per step, 5–7 s each, numbered `01`–`0N` (green numeral 120px/800, step title 72px/800, one diagram or UI mock) with the previous step shrinking to a progress rail → recap frame showing all steps (3 s, screenshot moment) → end card. Max 5 steps in 45 s.

## 6. Captions

- Word-synced from TTS timestamps; chunks of 2–4 words; 100% of narration covered.
- Montserrat 700 ~72px, white with black stroke (Dark) / ink on soft paper backing (Paper & Ink); **active word in green**.
- Hide captions when on-screen kinetic text says the same words.
- Max 2 lines; never split a number from its unit.

## 7. Motion grammar

- **Camera:** 2.5D, always drifting 1–3% scale/pan per beat; transitions are camera moves (push into a diagram node, whip-pan with motion blur). Nothing flies in from off-screen in a straight line.
- **Depth:** ≥ 3 parallax layers (texture, content, foreground particle/blur).
- **Physics:** type slams use springs with overshoot (`cubic-bezier(0.3,1.6,0.5,1)`, 400–700 ms) + slight squash; 1–2px camera shake on hard hits. Numbers roll up, overshoot, lock with a green glow pulse. Diagrams draw themselves in sync with the words.
- **Timing:** shots hold 2–4 s with internal motion (max 6 s). Cuts 0.15–0.3 s. Build-in stagger 60–100 ms. UI-style eases: `cubic-bezier(0.2,0.8,0.2,1)` 500 ms.
- **Budget:** one focal motion + ambient; 3–6 moving parts max.
- **Payoff:** 2–4 frame contrast spike. **≤ 3 flashes/contrast spikes per second** (photosensitivity).
- **Sound sync:** whoosh on transitions, tick per counter step, thud on slams, riser into the re-hook, hit on the payoff; cut music 0.3–0.5 s before the payoff line. Music ≥ 12 dB under voice; SFX ~7 dB under.

### Scene library (pick from these only)
| Scene | Use | Motion |
|---|---|---|
| `kinetic_slam` | Hooks, contrarian lines | Words punch in one at a time, 120%→100%, key word turns green |
| `kinetic_stack` | Lists of 3 | Items stack upward, previous dims to 40% |
| `myth_truth` | Myth → truth | Green strike-through draws, truth types in |
| `before_after` | Mistakes → fixes | Split frame, wipe left→right |
| `diagram.bar_compare` | 2–3 values | Bars grow from zero, value counts up; highlight bar green, others ink/grey |
| `diagram.line_curve` | Growth, retention | Line draws, green dot rides the key point |
| `diagram.funnel` | Drop-off | Stages narrow in turn, % pops in |
| `diagram.2x2` | Trade-offs | Axes draw, items drop into quadrants |
| `diagram.flow` | Steps, agent pipelines | Boxes appear in order, connectors draw |
| `ui_mock` | PRD, Slack message, code diff | Stylised card slides up; brand palette only; never a real product's UI |
| `illustration` | Story beats, metaphors | Code-drawn SVG, slow 105% push-in |
| `stat_hero` | One big number | Counts up, label fades in |
| `cta_bar` | Last 3 s (LinkedIn) | Green lower bar slides in: "Free guide · BuildersCamp.com" |

## 8. Voice-over

- TTS Kokoro-82M (Apache-2.0), voice **af_heart** pinned; story speed ≈ 1.06, lesson ≈ 0.97; overall ~165 wpm; no line > 190 wpm locally.
- Whisper round-trip on the final mix; any misheard word that changes meaning fails the render.
- Tone: a wry narrator telling a 30-second TV episode — real character, a laugh, then the lesson.

## 9. Copy rules (on top of BRAND.md §3)

- No em or en dashes in on-screen text or titles. Never open with "Here's…".
- Banned: secret, hack, insane. No contrast-reframe clichés ("X isn't Y. It's Z.").
- One word, one meaning per video.
- Post title/first line ≤ 60 characters, keyword first; thumbnail/cover = one 3–6-word question. Cover, title, frame 1 and boom sentence make the same promise.

## 10. Pipeline QA checklist (automatable)

- [ ] Dimensions/fps/codec per §1; length within hard limits.
- [ ] −14 ±1 LUFS, true peak ≤ −1.5 dBTP.
- [ ] Every text box inside the safe zone in every frame.
- [ ] Only palette colours (± anti-aliasing); no blue/purple-dominant frame.
- [ ] Hook visible on frame 1; frame 1 legible at 180px wide.
- [ ] Captions cover 100% of narration; active-word green.
- [ ] ≤ 3 flashes/s.
- [ ] Last frame matches frame 1; end card text only, no logo.
