---
name: jtbd
description: Apply Jobs-to-be-Done (Christensen / Competing Against Luck flavor) to a feature idea, document, or problem statement. Produces a JTBD canvas with the job, the struggling moment, desired progress, current alternatives, and hire/fire criteria. Flags where the stated feature is a solution masquerading as a job, and where evidence is thin. Use when shaping a feature, challenging a brief, or interpreting customer research.
---

# Jobs to be Done — Christensen flavor

## When to use this skill

- A feature idea has been proposed and you need to test whether it solves a real job
- A document or interview transcript needs to be interpreted through a JTBD lens
- A brief is vague and the underlying problem needs to be surfaced
- The `@discovery` agent has invoked you as Step 1 of the discovery sequence

## Philosophy (read before producing output)

Christensen's framing: **people don't buy products, they hire them to make progress in a specific circumstance.** A job is a description of progress someone is trying to make in a particular context, including the functional, emotional, and social dimensions of that progress.

Two failure modes you actively guard against:

1. **The solution-as-job trap.** "Users want to export dashboards" is not a job. The job is the progress they're trying to make *that exporting would unlock* — sharing analysis with a stakeholder who won't log in, archiving a snapshot before a number changes, escaping the tool to work in Excel. Different jobs, different solutions.

2. **The persona-as-job trap.** "Marketing managers want X" is not a job either. Jobs are circumstance-driven, not persona-driven. The same person hires different products for different jobs depending on the moment.

If the input you receive falls into either trap, **say so explicitly in the canvas** under "framing issues" rather than producing a clean canvas that hides the problem.

## What you produce

A JTBD canvas as Markdown. The canvas has these sections, in this order. Do not omit sections. If a section can't be filled from the input, write `[insufficient evidence — <what's missing>]` and continue.

### 1. The job statement

One sentence in the form: **When [situation], I want to [motivation], so I can [expected outcome].**

If the input names a feature instead of a job, derive the most likely job underneath it and mark it `[inferred]`.

### 2. The struggling moment

The specific circumstance where the person realizes the status quo isn't working. Concrete, scenic, time-bound. Not "users get frustrated with reports" but "Friday afternoon, the CFO asks for last quarter's number, the dashboard shows this quarter, and the analyst has 20 minutes before the board call."

If the input has no struggling moment, surface that as a framing issue (see section 7) — it's the strongest signal that the feature is a solution looking for a job.

### 3. Forces of progress

Four forces, each as a short bulleted list:

- **Push of the situation** — what's painful about the current state
- **Pull of the new solution** — what's attractive about the imagined future
- **Anxiety of the new** — what makes the new solution scary or risky
- **Habit of the present** — what makes staying put easy

A weak hire happens when push + pull don't outweigh anxiety + habit. If the input suggests anxiety/habit dominate, flag it.

### 4. Current alternatives

What is the person hiring today to make this progress? Include non-software alternatives (spreadsheets, screenshots, asking a colleague, doing nothing). The competition for a new feature is rarely another feature — it's usually a workaround.

### 5. Hire criteria

What would make the person hire this solution? List 3–5 criteria, each falsifiable. "Fast" is not a criterion. "Result available in under 10 seconds without leaving the current view" is.

### 6. Fire criteria

What would make the person fire this solution after trying it? Often the inverse of hire criteria but not always — there are unique fire conditions (data felt wrong, broke a habit they actually liked, made them look bad to a stakeholder).

### 7. Framing issues

The brutally honest section. List any of these that apply:

- **Solution-as-job**: the input describes a feature, not progress. State what the actual job likely is.
- **Persona-as-job**: the input describes who, not when. State what circumstance is missing.
- **No struggling moment**: nothing in the input describes a specific painful situation. The feature may be a nice-to-have, not a job.
- **Multiple jobs bundled**: the input conflates two or more jobs. List them separately.
- **Unfalsifiable hire criteria**: criteria are vague ("better," "faster," "easier") in a way that can't be tested.

If none apply, write "None identified — canvas is well-formed."

### 8. Confidence

One line: `High / Medium / Low — <one-sentence reason>`. Low confidence is fine and useful. Do not inflate confidence to look decisive.

## How to gather input

Read in this order, stopping when you have enough:

1. The brief / feature idea passed by the caller
2. Any context pages the caller mentioned (Notion, transcripts, research docs)
3. Direct quotes from interviews if present — these are gold for the struggling moment
4. **Do not invent a struggling moment from thin air.** If there isn't one in the source material, leave it `[insufficient evidence]` and flag it in section 7.

## Asking the user questions

You may ask **at most 3 questions, all in a single batch**, and only if the answers would change the canvas materially. Examples of question-worthy gaps:

- The struggling moment is missing and the input is a one-line feature idea
- Two distinct jobs are bundled and you can't tell which the user means
- The "current alternatives" are unknowable without user input

Examples of questions you should NOT ask:

- "What's the success metric?" (not a JTBD question — out of scope)
- "Who is the user?" (persona-thinking, not job-thinking)
- "What features should this have?" (you're not designing solutions yet)

If you ask questions, present them as a numbered list at the end of your output, before the canvas. Mark the canvas sections that depend on the answers as `[awaiting input — Q<n>]`. The caller will pass the answers back in the next turn.

If the caller's context is rich enough, do not ask. Produce the canvas with `[inferred]` and `[insufficient evidence]` markers as needed.

## Output format

Markdown only. No JSON. No tool-specific syntax. The canvas is read by humans in Notion and by the next skill (`ost`) as plain text.

Header: `# JTBD Canvas — <one-line feature name>`

Then the eight sections in order.

End with a single line: `— end of canvas —`
