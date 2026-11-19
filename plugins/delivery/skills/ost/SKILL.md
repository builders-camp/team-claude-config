---
name: ost
description: Build an Opportunity Solution Tree following Teresa Torres' Continuous Discovery format, pragmatic variant — allows inferred opportunities marked as hypotheses when evidence is thin. Takes a JTBD canvas plus context and produces a tree with desired outcome, clustered opportunities, candidate solutions, and assumption tests for the riskiest paths. Use after JTBD when shaping a feature, or directly when an outcome is already clear.
---

# Opportunity Solution Tree — Pragmatic Torres flavor

## When to use this skill

- A JTBD canvas exists and you need to translate jobs into a structured discovery tree
- A desired business or product outcome is set and opportunities need to be mapped
- The `@discovery` agent has invoked you as Step 2 of the discovery sequence
- Direct invocation when the user already has a clear outcome and wants to map opportunities and solutions

## Philosophy (read before producing output)

Torres' framing in *Continuous Discovery Habits*: a tree connects a **desired outcome** down through **opportunities** (customer needs, pains, desires) to **candidate solutions** and finally to **assumption tests** that de-risk the riskiest solutions.

The strict version requires every opportunity to be evidence-backed by direct customer interviews. The **pragmatic version this skill implements** allows inferred opportunities — but **every inferred opportunity must be tagged `[hypothesis]`** so that nobody downstream mistakes a guess for a finding. This is the honest middle ground: usable when you don't have fresh research, but never pretending to evidence you lack.

Two failure modes you actively guard against:

1. **Solution-first trees.** Trees that start from "we should build X" and reverse-engineer opportunities to justify it. If the input pushes you in this direction, surface it under "framing issues."

2. **Opportunity laundering.** Restating the solution as an opportunity ("opportunity: users need an export button" — no, that's a solution). Real opportunities describe customer needs, pains, or desires in customer language, not product language.

## What you produce

A tree as structured Markdown. Sections in this order:

### 1. Desired outcome

One sentence. The business or product outcome this tree serves. Must be measurable in principle (even if the metric isn't named).

Format: **Outcome: <statement>**. If the input doesn't specify an outcome, infer one from the JTBD canvas and mark `[inferred]`.

If multiple outcomes are bundled (e.g., "increase activation AND retention"), pick the one most directly served by this feature and note the other in framing issues.

### 2. Opportunities

A bulleted hierarchy. Top-level bullets are opportunity *clusters* (themes); sub-bullets are specific opportunities within them.

Each opportunity has:
- A short name in customer language ("I can't tell which dashboards my team is actually using")
- An evidence tag: `[evidence-backed]` (direct customer quote or behavior data exists in source material), `[hypothesis]` (plausible from JTBD or context but unvalidated), or `[assumption]` (we're guessing)
- One sentence of supporting context — quote source if `evidence-backed`, reasoning if `hypothesis`, naked guess acknowledged if `assumption`

Aim for 3–7 opportunities total across 1–3 clusters. More than that is usually a sign of unfocus.

If the JTBD canvas had `[insufficient evidence]` markers, those gaps usually map to `[hypothesis]` or `[assumption]` opportunities here. Do not upgrade their evidence tier.

### 3. Candidate solutions

Under each opportunity, list 1–3 candidate solutions. Solutions are concrete enough to build, abstract enough to allow design choices.

Format per solution:
- Name (short, descriptive — not a feature spec)
- One-line description of what it does for the user
- Effort signal: `S / M / L / XL` — rough order of magnitude only
- Confidence the solution addresses the opportunity: `High / Medium / Low`

Do not propose more than ~10 solutions across the whole tree. If you find yourself wanting more, the opportunities are probably too broad — split them.

### 4. Assumption tests

For the **two riskiest solutions only** (riskiest = highest effort × lowest confidence, or solutions that depend on `[assumption]`-tier opportunities), propose one assumption test each.

Format per test:
- The assumption being tested (single falsifiable statement)
- Test method (interview, prototype, fake door, data analysis, etc.)
- Smallest version of the test that would change your mind
- What "passed" and "failed" look like

Keep tests cheap. A test that takes 2 weeks to design is not an assumption test, it's a project.

### 5. Framing issues

Honest section. List any that apply:

- **Solution-first tree**: the input clearly started from a solution; opportunities were reverse-engineered. State which.
- **Outcome mismatch**: the feature won't move the stated outcome much, even if it ships. State what outcome it would actually move.
- **Tree is mostly hypothesis**: more than half the opportunities are `[hypothesis]` or `[assumption]`. Recommend specific research before building.
- **Solution masquerading as opportunity**: list any opportunities that are actually solutions in disguise.
- **Unbalanced effort**: all candidate solutions are XL, or all are S. The first means we have no near-term option; the second means we're not aiming high enough.

If none apply, write "None identified — tree is well-formed."

### 6. Confidence

One line: `High / Medium / Low — <one-sentence reason>`. Anchor this to the proportion of `evidence-backed` vs. `hypothesis` vs. `assumption` opportunities. A tree that's 80% hypothesis cannot be high-confidence regardless of how clean it looks.

## How to gather input

Read in this order:

1. The JTBD canvas passed by the caller (if Step 2 of `@discovery`)
2. The original feature idea / brief
3. Any context pages the caller mentioned
4. Anything in the source material that looks like customer quotes or behavior data — promote those to `evidence-backed`

Map JTBD canvas sections to tree sections roughly as:
- JTBD struggling moment → top opportunity in the tree
- JTBD forces of progress (push, anxiety) → child opportunities
- JTBD current alternatives → reveal solutions you're competing against, not solutions to build
- JTBD hire/fire criteria → become assumption tests later

## Asking the user questions

Same rule as `jtbd`: at most 3 questions, single batch, only if material. Question-worthy gaps:

- The desired outcome is genuinely ambiguous (multiple plausible interpretations)
- A key constraint is missing that would change which solutions are viable (e.g., "is this for mobile or desktop?")
- You can't tell whether a particular signal is `evidence-backed` or `hypothesis` because the source is unclear

Otherwise, infer and tag honestly.

## Output format

Markdown only. The tree is read in the local discovery file (`docs/features/<slug>/discovery.md`) by humans and as plain text by the next skill (`moscow`).

Header: `# Opportunity Solution Tree — <feature name>`

Then the six sections in order.

End with a single line: `— end of tree —`
