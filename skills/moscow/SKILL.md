---
name: moscow
description: Apply MoSCoW prioritization (Must / Should / Could / Won't) to a list of candidate solutions, defending each placement against explicit criteria and inviting challenge. Designed for discussion mode — never just outputs a table, always defends placements and surfaces where MoSCoW is the wrong framework. Use after OST when shaping a feature, or directly when you have a solution list and need to negotiate scope.
---

# MoSCoW Prioritization — Discussion mode

## When to use this skill

- Candidate solutions exist (from an OST, a backlog, or a brief) and need to be sorted into Must / Should / Could / Won't
- The `@discovery` agent has invoked you as Step 3 of the discovery sequence
- A scope negotiation is about to happen and the user wants a defensible starting position
- The user wants to challenge an existing prioritization

## Philosophy (read before producing output)

MoSCoW is a **scope negotiation framework**, not a discovery prioritization framework. Its strength is forcing explicit Won'ts — committing to what's *out* of a fixed-scope, fixed-time delivery. Its weakness is that it has no native mechanism for confidence, sequencing, or learning value.

Two things you do every time this skill is invoked:

1. **Check whether MoSCoW is even the right tool.** If the situation is open-ended discovery, continuous delivery without a fixed release, or you're sorting opportunities rather than solutions, MoSCoW is a poor fit. Say so up front and recommend RICE or ICE if appropriate. Then proceed with MoSCoW anyway if the user explicitly asked for it.

2. **Defend every placement.** A MoSCoW table without reasoning is theater. Every Must has to answer "must for what release, by what criterion?" Every Won't has to answer "why not in this cycle, and when?"

The "discussion" in discussion mode means: you place each solution, defend each placement in one or two sentences, and explicitly invite challenge. The user is expected to push back, move things around, and re-run.

## What you produce

A MoSCoW prioritization as Markdown. Sections in this order:

### 1. Framework fit check

One short paragraph answering:
- Is MoSCoW the right framework for this situation? (Yes / Partial / No)
- If Partial or No, what would be better and why?
- If Partial or No but we're proceeding anyway, what to watch for

If the situation is clearly continuous discovery (no fixed release, no scope deadline, evidence is still being gathered), say so directly. Recommend RICE if the user is comparing solutions across opportunities, or ICE for a quick gut-check.

### 2. Criteria

Before placing anything, state the criteria you're applying. Pull these from:
- The JTBD hire criteria (if a JTBD canvas was passed)
- The OST desired outcome (if an OST was passed)
- Any constraints the user mentioned (timeline, capacity, dependencies)

Format as a short bulleted list. Examples:
- **Must serve the core job statement**: solution directly addresses the JTBD struggling moment
- **Must fit within <constraint>**: capacity / timeline / dependency
- **Should improve <outcome metric>**: enough to be observable in the target window
- **Won't if it depends on <unresolved assumption>**: don't commit before validating

If no criteria can be derived from the inputs, ask one question (see "Asking the user questions" below) — you cannot do MoSCoW without criteria.

### 3. Placements

A table or structured list with four sections: **Must**, **Should**, **Could**, **Won't (this cycle)**.

For each solution, provide:
- Name (matches the OST solution name if applicable)
- Effort: `S / M / L / XL`
- Confidence: `High / Medium / Low`
- One-sentence defense referencing specific criteria from section 2
- Risk flag: `[depends on hypothesis]` or `[depends on assumption]` if the solution traces back to an unvalidated OST opportunity

Format guidance:

```
## Must
- **<Solution name>** (Effort: M, Confidence: High)
  *Defense:* Directly addresses the struggling moment in the JTBD canvas; without this, the feature does not solve the job.

## Should
- **<Solution name>** (Effort: S, Confidence: Medium) [depends on hypothesis]
  *Defense:* Strong support for the desired outcome but the underlying opportunity is hypothesis-tier; ship if Must items leave capacity, validate the hypothesis in parallel.

## Could
- **<Solution name>** (Effort: L, Confidence: Low)
  *Defense:* Plausible value but high effort and low confidence; defer until learning from Must/Should ships.

## Won't (this cycle)
- **<Solution name>** (Effort: XL, Confidence: Low) [depends on assumption]
  *Defense:* Effort is too large to commit before validating the underlying assumption; revisit after <named test>.
```

Aim for distribution roughly: 20–40% Must, 20–40% Should, 20–40% Could, plus explicit Won'ts. **A MoSCoW where everything is Must is a failed MoSCoW** — flag it in section 5 if it happens.

### 4. Sequencing note

MoSCoW does not specify order within a tier. Add a single short paragraph identifying:
- Which Must should ship first (usually highest-confidence, lowest-effort)
- Any Must that has a hard dependency on another Must
- Any Should worth pulling forward if Must items shrink

This is not a Gantt chart. Two to four sentences.

### 5. Framing issues

Honest section. List any that apply:

- **Everything-is-Must**: the placements collapsed and MoSCoW lost its discrimination power. Re-state criteria and force at least one demotion.
- **Hypothesis-heavy Musts**: any Must marked `[depends on hypothesis]` or `[depends on assumption]`. Committing to Must on unvalidated opportunities is the most common MoSCoW failure mode.
- **Won't is empty**: a MoSCoW with no Won'ts is a wishlist. State at least one explicit out-of-scope item and defend it.
- **Wrong framework persisting**: if section 1 flagged MoSCoW as a poor fit, restate the warning here so it's not buried.

### 6. Invitation to challenge

End with a short prompt to the user. Three to five specific questions inviting them to push back on placements. Examples:
- "Is <Solution X> really a Must, or is it a Should we'd love to have? What breaks if we cut it?"
- "Should <Solution Y> be promoted given that <criterion> matters more than I weighted it?"
- "Is the Won't list defensible, or are we deferring something that will block the Musts?"

This is the discussion in discussion mode. Do not skip it.

## Asking the user questions

Same rule: at most 3, single batch, only if material. Question-worthy gaps:

- No criteria can be derived from the inputs (this is the most common — ask once)
- The fixed scope or deadline is unstated and would change Must / Won't decisions materially
- Two solutions look interchangeable and the user's preference would change placements

Otherwise, infer with stated assumptions and proceed.

## Output format

Markdown. Read by humans in Notion. The handoff to `@pm` (after validation) will include only the Musts and Shoulds, so make those defenses especially crisp.

Header: `# MoSCoW Prioritization — <feature name>`

Then the six sections in order.

End with a single line: `— end of prioritization —`
