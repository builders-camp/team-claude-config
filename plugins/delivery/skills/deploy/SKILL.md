---
name: deploy
description: Safe deploy via feature branch with conflict check and rollback.
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, Bash(git status), Bash(git status *), Bash(git diff *), Bash(git log --oneline -20), Bash(git log -1 *), Bash(git log *), Bash(git fetch *), Bash(git add *), Bash(git commit *), Bash(git push *), Bash(git checkout *), Bash(git switch *), Bash(git branch *), Bash(npx tsc *), Bash(gh pr create *), Bash(gh pr edit *), Bash(gh pr view *), Bash(gh pr list *)
argument-hint: "[branch or feature to deploy]"
---

# /delivery:deploy

1. Check for uncommitted changes (`git status`, `git diff`).
2. Pick the branch FIRST, before any commit:
   - If already on a feature branch (not main/master), use the current branch.
   - If on main/master, run `git fetch origin`, then create and switch to a new feature branch (`git switch -c <name>`). Uncommitted changes carry over.
   - Branch name: `feat/<slug>`, `fix/<slug>`, or `chore/<slug>`; slug lowercase, hyphened, max 50 chars (e.g. `feat/add-newsletter-signup`). Derive it from the change summary (or the latest commit message if there is nothing uncommitted).
3. If there are uncommitted changes, commit them on the feature branch with a clear message. Never commit on main/master.
4. Check for conflicts with main (`git fetch origin` first):
   - If conflict risk: stop and explain resolution steps.
5. Preflight:
   - TypeScript compiles (`npx tsc --noEmit`)
6. Push the feature branch to remote with `-u`.
7. **Never push directly to main.** Always use a feature branch.
8. Open a PR as a draft (do NOT merge):
    - Title: latest commit subject (verbatim, no rewrite).
    - Before writing the body, run `gh pr list` against the target repo and check for other open PRs touching the same files, migrations, or database tables/triggers as this change. Note any overlap by name.
    - If the target repo has `.github/PULL_REQUEST_TEMPLATE.md`, treat its section structure as authoritative over the shape below.
    - Write the body to a temp file in this shape (calibrate section length to the actual complexity — a one-line fix gets one-line sections; never invent context that isn't in the commit or the changed files):
      ```
      ## Problem
      What's broken, missing, or needed. Real context, a few sentences — not a one-liner, not a wall of text.

      ## Solution
      How this fixes it, with enough detail that someone who didn't write the code understands the approach and any real design decisions made.

      ## What changed
      Bullet list, plain language, no unexplained internal function/table names without context.

      ## How to verify
      Concrete steps a reviewer can actually follow — not "tests pass," actual steps.

      ## Risk & overlap
      - Overlap: does this PR share commits, migrations, or database tables/triggers with any other currently-open PR? Name it, or say "none found."
      - Blast radius: contained to one function, or does it touch production data / send real emails / create real calendar events? If it touches production data, stop and get the user's explicit "yes" (target, operation, row count) before opening the PR or running anything.
      - Anything else a reviewer needs to know before merging that isn't obvious from the diff.
      ```
    - If the repo has `.github/PULL_REQUEST_TEMPLATE.md`, use it as the body file (fill it in); otherwise use the concise temp file above.
    - Use `gh pr create --draft --body-file <path>` against `main` (or the project's default base). Print the PR URL.
    - Never pass `--merge`, `--auto`, or any auto-merge flag.
    - Immediately apply exactly two labels with `gh pr edit <num> --add-label "<priority>" --add-label "<type>"`:
      - Priority: one of `P0-critical` (revenue/data integrity), `P1-high` (security, important bug clusters), `P2-medium` (reliability, dev process, features), `P3-low` (cosmetic, tech debt, docs).
      - Type: one of `bug`, `documentation`, `duplicate`, `enhancement`, `good first issue`, `help wanted`, `invalid`, `question`, `wontfix`.
9. Output a deploy summary.

Output:
<deploy>
Branch: <branch name>
Changes: <summary of what changed>
Preflight: <pass/fail>
PR: <url>
Next: Review & merge the PR to trigger production deploy.
Rollback: git revert <commit> or revert the merge on GitHub.
</deploy>
