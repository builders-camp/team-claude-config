---
name: merge
description: Safe PR merge with check verification, post-merge cleanup, migration reminder, and edge-function deploy reminder.
disable-model-invocation: true
allowed-tools: Read, Bash(gh pr view *), Bash(gh pr checks *), Bash(gh pr merge *), Bash(gh pr diff *), Bash(git fetch *), Bash(git checkout *), Bash(git pull *), Bash(git branch *), Bash(supabase migration list *), Bash(supabase db push *), Bash(supabase functions list *)
argument-hint: "[PR number — defaults to current branch's PR]"
---

# /merge

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
   - If currently on the merged feature branch, switch to `main` (or the PR's base branch): `git checkout <base>`.
   - `git pull --ff-only`.
   - Delete the local feature branch: `git branch -d <branch>`. Skip if it has unmerged work locally.

6. Migration reminder — if the merged diff includes any file under `supabase/migrations/`:
   - Run `supabase migration list --linked` and check whether each new file is already applied on remote.
   - If any are local-only, run `supabase db push --linked`. Confirm one-by-one in the printed plan.
   - If the CLI is not linked, tell the user explicitly which migrations need applying and how.

7. Edge-function deploy reminder — if the merged diff includes any file under a `supabase/functions/<name>/` directory (new or modified — check `gh pr diff <num> --name-only` against that path):
   - Edge functions do **not** auto-deploy on merge/push, unlike the rest of the app (which deploys via Vercel or similar CI on push to main) — this is a common gap projects miss, not specific to one repo. Do not assume it deploys itself.
   - List each distinct function directory touched by the diff.
   - Tell the user explicitly, per function: `supabase functions deploy <name> --linked` (or the project's equivalent deploy command). Do not run it yourself unless the user explicitly asks — this changes a live, deployed artifact outside the migration/branch-protection safety net this skill otherwise relies on.
   - If the diff also touches shared/imported code under `supabase/functions/_shared/` (or an equivalent shared-helpers path), call out that every function importing from it needs redeploying too, not just the ones directly changed — a shared-helper change alone won't surface in a simple directory diff.

8. Output a merge summary.

Output:
<merge>
PR: #<num> — <title>
Merge commit: <sha>
Branch deleted: <branch> (remote + local)
Migrations applied: <list, or "none in diff">
Edge functions to deploy: <list of function names + deploy command, or "none in diff">
Watch: <Vercel deploy URL or other monitor target if known, else "production deploy via main">
Rollback: revert merge commit on GitHub, or `git revert -m 1 <sha>` then push.
</merge>
