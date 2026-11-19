---
name: merge
description: Safe PR merge with check verification, post-merge cleanup, and opted-in stack skill post-merge steps.
disable-model-invocation: true
allowed-tools: Read, Bash(gh pr view *), Bash(gh pr checks *), Bash(gh pr merge *), Bash(gh pr diff *), Bash(git fetch *), Bash(git checkout *), Bash(git pull *), Bash(git branch *), Bash(git worktree *), Bash(supabase migration list *), Bash(supabase db push *), Bash(supabase functions list *)
argument-hint: "[PR number — defaults to current branch's PR]"
---

# /delivery:merge

Use only when the user explicitly asks to merge a PR. Never auto-trigger.

1. Resolve the target PR:
   - If a PR number is provided, use it.
   - Otherwise, find the open PR for the current branch (`gh pr view --json number`).
   - If no PR is found, stop and tell the user.

2. Pre-merge gate (`gh pr view <num> --json state,mergeStateStatus,mergeable,statusCheckRollup,baseRefName`):
   - State must be `OPEN`.
   - `mergeable` must be `MERGEABLE`. If `CONFLICTING`, stop and tell the user to rebase.
   - `mergeStateStatus`:
     - `CLEAN` / `UNSTABLE` / `HAS_HOOKS` → proceed (UNSTABLE is acceptable when only known-ignored checks fail; flag which ones).
     - `BLOCKED` → stop. Print which required check or review is blocking. Do not bypass.
     - `BEHIND` → stop. Tell the user to update the branch from base.
     - `DIRTY` → stop. Conflicts.
   - `statusCheckRollup`: list any failing or pending checks. Required checks must pass before merging. Known-ignored checks (per memory or user instruction) can be tolerated — call them out explicitly.

3. Merge: `gh pr merge <num> --squash --delete-branch`.
   - Default to squash. Only use `--merge` or `--rebase` if the user explicitly asks.
   - Never pass `--auto` (this skill is run on demand, not queued).
   - Never pass `--admin` to bypass branch protection unless the user explicitly authorizes.

4. Verify the merge landed: `gh pr view <num> --json state,mergedAt,mergeCommit`. If `state != MERGED`, stop and report.

5. Post-merge cleanup:
   - `git fetch origin`.
   - Check `git worktree list` for a worktree checked out on `<branch>`.
     - If the branch is checked out in a **separate worktree** (not the current folder): do not `git checkout` or `git pull` there — never switch branches inside a folder another session may be using. Instead run `git worktree remove <path>` for that worktree, then `git branch -d <branch>` from the current folder.
       - If the worktree has uncommitted changes, `git worktree remove` will refuse — stop and tell the user rather than forcing it.
     - Otherwise (branch is checked out in the current folder, or not checked out anywhere): switch to `main` (or the PR's base branch) with `git checkout <base>`, `git pull --ff-only`, then delete the local feature branch with `git branch -d <branch>`. Skip the delete if it has unmerged work locally.

6. If the project's CLAUDE.md has the line `Stack: supabase-vercel`, load the `stack-supabase-vercel` skill and follow its "Post-merge steps". Do not apply the stack skill to a project without that line. A migration that alters production data (not just schema) waits for the user's explicit "yes" before `supabase db push --linked`: state the target, the operation and the row count first.

7. Output a merge summary.

Output:
<merge>
PR: #<num> — <title>
Merge commit: <sha>
Branch deleted: <branch> (remote + local)
Stack pack post-merge items: <the lines the stack skill defines, or "none">
Watch: <deploy URL or other monitor target if known, else "production deploy via main">
Rollback: revert merge commit on GitHub, or `git revert -m 1 <sha>` then push.
</merge>
