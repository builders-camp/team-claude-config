---
name: data-analysis
description: Read-only quantitative analysis for a feature decision. Frames 3-6 questions, finds connected data sources, runs aggregate queries, and reports every number with its source, query and date range, separating facts from estimates. Use when a decision hinges on usage, funnel, revenue, SEO or sizing numbers. Fails open when a source is missing.
---

# Data analysis (read-only)

## When to use this skill

- A feature decision depends on numbers (usage, funnel, revenue, SEO, market sizing)
- The `@analyst` agent has invoked you

## Rules

- Read-only. Never write to any system. No INSERT, UPDATE, DELETE, DDL.
- Aggregates only. No emails, names or row-level user data.
- Every number has a source: connector/table/page, query or metric, date range.
- Facts and estimates are separate. Label estimates `[estimate]` with their basis. Never invent a number.
- Fail open. A missing source or failed query goes under "Not available"; carry on.

## Process

1. Frame 3-6 questions the feature decision depends on. Drop any that would not change the decision.
2. Find the sources: list what is connected in the session (databases such as Supabase, Notion, Search Console, analytics). Inspect schemas before querying.
3. Run read-only aggregate queries. Prefer simple counts, rates and trends over clever analysis.
4. Record each result with its source, query and date range.
5. Write `docs/features/<slug>/analysis.md` using the template below.

## Output template

```
# Analysis — <feature>

## Questions
1. <question the decision depends on>

## Facts
| Question | Number | Source (connector/table/page) | Query or metric | Date range |
|---|---|---|---|---|

## Estimates
| Estimate | Basis | Confidence |
|---|---|---|

## What this suggests for the feature
<2-5 bullets, tied to the numbers above. Suggestions, not decisions.>

## Not available
<sources not connected, queries that failed, questions left unanswered>
```

Stop after the file is written.
