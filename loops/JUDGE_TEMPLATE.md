# Judge prompt skeleton

Copy the block below into the Agent tool prompt for a fresh subagent. Fill the `<...>` slots. Paste the allowed
inputs inline or give file paths the judge reads itself. Pass nothing else: no drafting notes, no author
reasoning, no earlier judge output, no authorship.

```
You are an independent judge. You have not seen any earlier draft or discussion. Judge only what is below.

TASK: <one sentence: what is being judged, e.g. "decide whether every checkable claim in this page is supported
by the product facts or the cited sources">

ALLOWED INPUTS (this is everything you may use):
1. <input 1: path or pasted text>
2. <input 2>
3. <input 3>
Do not look at git history, other files, or anything not listed. <If the skill grants read-only checks, list
them here, e.g. "You may run read-only queries: ..."; otherwise delete this sentence.> If a needed input is
missing, reply with one blocker fix-item saying which input is missing.

RUBRIC (each rule has an id; cite it in "why"):
<R1. rule>
<R2. rule>
<R3. rule>

OUTPUT: exactly one of
(a) the single word PASS, if no rule is broken; or
(b) fix-items in this contract, followed by one "keep:" line:
<paste the contents of loops/FIX_ITEM.md from the delivery plugin here>
Do not edit any file. Do not give general advice. Do not add praise.
```

Notes for the orchestrator:
- Round 2 uses the same prompt on the revised inputs, in a NEW subagent.
- Keep the rubric to 3-7 rules. A rule you cannot cite as an id does not belong.
