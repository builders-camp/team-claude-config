---
name: implement
description: Set up a worktree branch from origin/main before modifying files for a new task, then hand the work to @implementer. Use before the first code change on any new feature, bugfix, experiment, or refactor.
allowed-tools: Read, Glob, Grep, Bash(git fetch *), Bash(git status), Bash(git branch *), Bash(git worktree *)
argument-hint: "[short task name]"
---

# /implement

Use before modifying any file for a new task. Creates the branch in a worktree, then hands off to `@implementer`.

## Worktree rules

- **Before modifying any file for a new task, create a worktree/branch from updated `origin/main` first.** Don't edit in place on whatever branch happens to be checked out.
- **Never commit or push directly to `main` (or `master`) unless the user explicitly says "commit to main" or "hotfix to main".** All non-trivial work — feature, bugfix, experiment, refactor — goes through a worktree branch + PR. If you find yourself about to `git commit` on `main` without an explicit instruction, STOP and create the worktree first. Migrations already pushed to prod do not retroactively justify committing app code to main; the two are independent.
- Do not switch the user's main checkout's branch.
- You have standing permission to run `git worktree add`, `git worktree remove`, and `git worktree prune` without asking.
- Skip the worktree for: continuing work on the currently checked-out branch, tiny edits to the current branch, pure read/research tasks, or work the user explicitly says to do in-place.

## Steps

1. Check the skip cases above. If one applies, say which and go to step 6.
2. `git fetch origin`. Always fetch before branching.
3. Pick names: branch `feat/<slug>`, `fix/<slug>`, or `chore/<slug>`; worktree `~/worktrees/<kebab-short-name>` matching the branch (e.g. branch `fix/foo-bar` → `~/worktrees/fix-foo-bar`).
4. Create from the remote tip, never the bare local branch name:
   `git worktree add -b <branch> ~/worktrees/<name> origin/main` (or `origin/<base>` if branching off something other than main). Never use the bare ref `main` as the base — it resolves to whatever local main last pulled, which may be hours or days stale.
5. Per-worktree setup: `node_modules` and `.env` are not shared. Run install in the new worktree and symlink `.env` from the main checkout if the task needs it.
6. If the task adds a Supabase migration: before naming the file's timestamp, run `git fetch origin` and check `origin/main` plus `supabase migration list --linked` — never trust local `main` or a plain `ls supabase/migrations/` in the worktree.
7. Hand off to `@implementer` with the worktree path in the brief.
8. Tell the user the path and the command to open a session there: `cd <path> && claude`. Don't auto-`cd` for them — they may want to keep the current session focused.

When work in a worktree is merged or abandoned, proactively offer `git worktree remove` to clean up.

Output:
<implement>
Branch: <branch name, or "current branch — <skip reason>">
Worktree: <path, or "none">
Handoff: @implementer
Open: cd <path> && claude
</implement>
