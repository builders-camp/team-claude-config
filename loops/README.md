# Generator -> judge loops

A minimal generator -> judge pattern for skills that produce text, content or review verdicts. Any skill that
generates work and wants an independent check can use it.

This kit lives at `~/.claude/loops/`. Each project keeps its own promoted-checks log at
`.claude/loops/CHANGELOG.md` in the project repo (copy `CHANGELOG.md` from this kit to start it).

## Rules

1. **Deterministic first.** Every script, lint, build or grep a skill already has runs BEFORE any judge. A judge
   never sees work that fails a deterministic check. A judge round is never spent on something
   a script could have caught.
2. **Judges are fresh subagents.** Spawn each one with the Agent tool as a new subagent (`subagent_type`
   `general-purpose`, or `reviewer` if the skill says so). Build the prompt from `JUDGE_TEMPLATE.md` and pass ONLY
   the inputs the skill lists as allowed. Never pass drafting notes, the author's reasoning, earlier judge output,
   or who wrote it. Do not resume or message an earlier judge. Each extra round is a NEW subagent that never saw an
   earlier draft.
3. **Output is PASS or fix-items.** Fix-items follow `FIX_ITEM.md`. A judge that returns anything else is re-run
   once with the same inputs; a second malformed reply counts as `judge: unavailable` and the generator's version
   proceeds (rule 5). One exception: a blind-answer judge returns an
   answer sheet, and the orchestrator converts mismatches into fix-items.
4. **Round caps are per skill.** The skill names its cap (2 for judges, 3 for deterministic fix loops). The cap is
   never raised mid-run. Hitting a cap means: ship the best version so far and record the open items.
5. **Fail open.** A judge never prevents anything from running. It exists to make the work better; if it breaks, we
   run nonetheless. If a judge cannot be spawned, errors, or returns garbage, proceed with the generator's version
   and record `judge: unavailable`. If it returns fix-items, apply them and ship the improved version. Never drop,
   block or withhold output because of a judge, and do not run an extra round to "get it over the line". Open
   fix-items left after the last round are recorded, not used to stop the work.
6. **Record the pass.** Every judged item gets one line in the place the skill already logs results (PR body,
   preview, or PR comment), in this format:

   `loop: <skill> | item: <page / PR# / quiz slug> | judge: <name> | rounds: <1 or 2> | result: PASS | FIXED | UNAVAILABLE | OPEN | open items: <ids or none>`

   No separate pass files are created in the repo. If a skill has no existing log, it uses its final report.
7. **Authors apply fix-items literally.** A fix-item that changes a fact is labelled `claim change`. A claim
   change goes back through the skill's own fact check before the next judge round.
8. **Changelog promotion.** When the same failure appears in 2 or more runs, add a row to `CHANGELOG.md` and move
   the check earlier: into a script if it can be scripted, otherwise into the generator's instructions. The
   promoted check is the one that runs next time; the judge rubric keeps its line for 3 more runs, then drops it.
   If the project has a regression set (`.claude/loops/regression/`), also add a case for the failure, so a later
   rule or agent edit cannot bring it back unnoticed.

## When NOT to add a judge

- A script, regex, schema validator, grep or build can check it. Write the check instead.
- The answer is a lookup (is this migration timestamp taken, does this file exist).
- The rubric is taste with no cited rule. A judge with no rule produces banned vague feedback.
- The work is a one-line or purely mechanical edit.

A judge is for what scripts cannot see: whether a claim is supported by its source, whether a question has one
defensible answer, whether a fix introduced a new defect.
