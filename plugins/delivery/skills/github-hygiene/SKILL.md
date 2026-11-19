---
name: github-hygiene
description: Rules for creating GitHub PRs and issues. Use before `gh pr create` or `gh issue create`, and whenever applying priority/type labels, writing a PR body (PR templates), or choosing an issue shape (issue templates).
allowed-tools: Read, Glob, Write, Bash(gh pr create *), Bash(gh pr edit *), Bash(gh pr view *), Bash(gh issue create *), Bash(gh issue edit *), Bash(gh issue view *)
---

# github-hygiene

Follow before `gh pr create` or `gh issue create`.

## PR/Issue labeling

- Whenever you create a new PR or issue (`gh pr create`, `gh issue create`), immediately apply exactly two labels in the same turn before considering the task done:
  - **Priority** — one of `P0-critical` (revenue/data integrity, fix first), `P1-high` (security, important bug clusters), `P2-medium` (reliability, dev process, features), `P3-low` (cosmetic, tech debt, docs). Classify the specific PR/issue against this fixed rubric.
  - **Type** — one of `bug`, `documentation`, `duplicate`, `enhancement`, `good first issue`, `help wanted`, `invalid`, `question`, `wontfix`. Pick whichever fits from context.
- Apply via `gh pr edit <num> --add-label "<priority>" --add-label "<type>"` or `gh issue edit <num> --add-label ...`.
- This only covers PRs/issues created through Claude Code — it does not catch ones opened manually on GitHub.com or by other tools. If that changes, revisit with a GitHub Actions workflow instead.

## PR templates

- When creating a PR (`gh pr create`), if the target repo has its own `.github/PULL_REQUEST_TEMPLATE.md`, always use it as the PR body via `--body-file`, never ad hoc `--body` text. Same pattern as the ISSUE_TEMPLATE deferral rule below, applied to PRs.
- If no `PULL_REQUEST_TEMPLATE.md` exists, fall back to a concise descriptive body written to a temp file and passed via `--body-file`.

## GitHub Issues

- When creating a GitHub issue (`gh issue create`), write the body to a temp file in one of two shapes and open it with `gh issue create --body-file`, never a free-form `--body` string.
  - If the target repo has its own `.github/ISSUE_TEMPLATE/`, treat those templates as authoritative over the shapes below.
  - **Bug / tech debt** — small, self-contained, found during other work:
    ```
    ## Context
    ## Why it matters
    ## Options
    ## Decision
    ```
  - **Feature / Task** — bigger, needs research/design/engineering input before it's build-ready:
    ```
    ## Summary
    ## Current state
    ## Recommendation
    ## Open questions
    ## Not doing
    ## Epic / tracking link
    ```
  - Use Bug/tech debt if: found incidentally while doing other work, fixable without new research/design/engineering input, and scoped to one component. Use Feature/Task if: needs upstream input (`@discovery`/`@designer`/`@engineer`) before it's buildable, or decomposes from a larger initiative.
- For the Feature/Task shape's "## Epic / tracking link": if given a link for the epic this decomposes from, put it there. If not given one, write "Needs epic / tracking link — not yet scoped." Never guess or invent a link.
- A Feature/Task issue is not build-ready while "## Open questions" still has unresolved items. Don't start implementation off it — say so in chat, and leave the issue open with those questions visible rather than resolving them silently.
