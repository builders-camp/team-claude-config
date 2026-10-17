---
name: voice-of-customer
description: Qualitative customer evidence for a feature decision. Gathers feedback, reviews, support or interview material, community posts and public competitor signals, clusters them into themes ranked by frequency, picks sourced quotes without personal identifiers, and compares against alternatives (where we win or lose). Use when a decision hinges on what customers say. Fails open when sources are thin.
---

# Voice of customer (read-only)

## When to use this skill

- A decision hinges on what customers say, or on how competitors position
- The `@voc` agent has invoked you

## Rules

- Read-only. Never post, message or write to any system.
- Real evidence first. Synthetic interviews only fill gaps and are labelled `[synthetic]`.
- Quotes carry a source (channel, page, date). No names, emails or handles.
- Fail open. Thin sources are fine; say how thin. Never invent a quote or a frequency.

## Process

1. Gather from connected sources (Notion, Slack, support or feedback tools) and the web (reviews, community posts, competitor pages).
2. Cluster into themes. Count how many distinct pieces of evidence support each.
3. Rank themes by frequency.
4. Pick 1-3 representative quotes per top theme, with source.
5. Compare against named alternatives, including non-software workarounds: where we win, where we lose.
6. List gaps and what to validate with real users.
7. Write `docs/features/<slug>/voc.md` using the template below.

## Output template

```
# Voice of customer — <feature>

## Evidence base
<sources used, counts, date range, and how thin or rich it is>

## Themes (ranked by frequency)
| # | Theme | Mentions | Sources |
|---|---|---|---|

## Quotes
- "<quote>" — <source, date>

## Alternatives: where we win or lose
| Alternative | Where we win | Where we lose | Source |
|---|---|---|---|

## Gaps and open questions
<what the evidence does not cover; what to validate with real users>
```

Stop after the file is written.
