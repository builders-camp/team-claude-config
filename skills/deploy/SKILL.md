---
name: deploy
description: Safe deploy via feature branch with conflict check and rollback.
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Bash(git status), Bash(git log --oneline -20), Bash(git log -1 *), Bash(git add *), Bash(git commit *), Bash(git push *), Bash(git checkout *), Bash(git branch *), Bash(npx tsc *), Bash(gh pr create *), Bash(gh pr view *)
argument-hint: "[branch or feature to deploy]"
---

# /deploy

1. Check for uncommitted changes.
2. If there are uncommitted changes, commit them with a clear message.
3. Auto-generate a feature branch name from the latest commit message:
   - Format: `feat/<slug>`, `fix/<slug>`, or `chore/<slug>`
   - Slug: lowercase, hyphened, max 50 chars (e.g. `feat/add-newsletter-signup`)
4. If already on a feature branch (not main/master), use the current branch.
5. If on main/master, create and switch to the new feature branch.
6. Check for conflicts with main:
   - If conflict risk: stop and explain resolution steps.
7. Preflight:
   - TypeScript compiles (`npx tsc --noEmit`)
8. Push the feature branch to remote with `-u`.
9. **Never push directly to main.** Always use a feature branch.
10. Open a PR (do NOT merge):
    - Title: latest commit subject (verbatim, no rewrite).
    - Body: latest commit body + a short test/verification checklist tied to the actual diff. Do not invent context that isn't in the commit or the changed files.
    - Use `gh pr create` against `main` (or the project's default base). Print the PR URL.
    - Never pass `--merge`, `--auto`, or any auto-merge flag.
11. Output a deploy summary.

Output:
<deploy>
Branch: <branch name>
Changes: <summary of what changed>
Preflight: <pass/fail>
PR: <url>
Next: Review & merge the PR to trigger production deploy.
Rollback: git revert <commit> or revert the merge on GitHub.
</deploy>
