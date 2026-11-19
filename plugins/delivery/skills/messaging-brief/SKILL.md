---
name: messaging-brief
description: Product marketing messaging brief for a customer-facing feature or launch. Defines the ICP, positioning (for / who / unlike / we), three key messages with proof points, copy needed per surface, assets needed, claims to avoid, and links to evidence. Use for landing pages, onboarding, emails, pricing, launches and announcements. Never publishes anything.
---

# Messaging brief

## When to use this skill

- A feature has a customer-facing surface or a launch
- The `@pmm` agent has invoked you

## Rules

- Evidence over claims. Link `analysis.md` and `voc.md` when they exist; otherwise flag the message `[assumed — verify]`.
- Any claim we cannot back with evidence goes under "Claims to avoid".
- Brief, not final copy. Never publish or post anything.
- Where the project repo has marketing skills (graphics, announcements, copy), name them under assets.

## Process

1. Read `discovery.md`, `analysis.md`, `voc.md` when present.
2. Define the ICP in one or two lines.
3. Write the positioning statement.
4. Write 3 key messages, each with proof points and Must / Should.
5. List copy needs per surface and assets needed.
6. List words and claims to avoid.
7. Write `docs/features/<slug>/messaging-brief.md` using the template below.

## Output template

```
# Messaging brief — <feature>

## ICP
<who, in what circumstance>

## Positioning
For <ICP> who <need>, <product> is a <category> that <benefit>. Unlike <alternative>, we <differentiator>.

## Key messages
| # | Message | Proof points | Evidence link | Must/Should |
|---|---|---|---|---|

## Copy needed per surface
| Surface | Copy needed |
|---|---|

## Assets needed
<asset, and the project marketing skill to use if one exists>

## Claims and words to avoid
<anything we cannot back with evidence>

## Evidence links
<analysis.md, voc.md, other sources, or "none — assumptions flagged">
```

Stop after the file is written.
