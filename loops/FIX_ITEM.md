# Fix-item contract (shared by every judge).
One fix-item is a JSON-style block:

```
{"id": "F1", "severity": "blocker | major | polish",
 "where": "the exact location and quoted words: \"Section 'Salary in Spain', sentence 2: 'averages 62,000 EUR'\"",
 "observed": "what a reader or the checker finds, in plain terms",
 "why": "the rule it breaks, one line, citing the rubric id (e.g. C2)",
 "fix": "the exact rewrite, or 2 concrete options in quotes",
 "verify": "how the next judge or a tool checks it (e.g. 'source page states 62,000 EUR')"}
```

- blocker = most severe, must be fixed before shipping if possible (false or unsupported claim, wrong answer key, broken rule); major = clearly weaker;
  polish = optional.
- At most 3 blockers + 3 majors + 3 polish per reply. Prioritise. Quote the words. Name the second option.
- A fix that changes a fact is labelled `claim change` at the start of `fix`, so the author re-runs the skill's
  fact check.
- Banned without a concrete rewrite: "tighten", "improve", "clarify", "more engaging", "feels off",
  "could be stronger", "consider rewording".
- End every set of fix-items with one line: `keep: <what the author must NOT touch>`.
- No fix-items, no `keep:` line: the whole reply is the single word `PASS`.
- Lint your own reply before sending: every item has all 6 fields, the counts are within the caps, the `keep:`
  line is present, and none of the banned words appear.
