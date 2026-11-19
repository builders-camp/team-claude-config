---
name: stack-supabase-vercel
description: Supabase and Vercel rules for migrations, edge functions, supabase db push and post-merge steps. Use only when the project's CLAUDE.md has the line "Stack: supabase-vercel".
---

# Stack: Supabase + Vercel

Opt-in rules for projects that use Supabase (migrations, edge functions) and Vercel (deploys).

Opt-in: the project's CLAUDE.md must contain the line `Stack: supabase-vercel`. If it does not, do not apply these rules. This skill loads on demand; it is not always-on context.

## Supabase

- When the project's Supabase CLI is linked (`supabase projects list` shows `●` next to the project, or `supabase/config.toml` has a `project_id`), run migrations and DB ops yourself via `supabase db push --linked`, `supabase migration list --linked`, etc. Do not tell the user to migrate manually.
- Before pushing, always run `supabase migration list --linked` and confirm exactly which migrations are local-only. Never push without seeing the plan. A `supabase db push --linked` of data-altering migrations (inserts, updates, deletes, backfills) waits for the user's explicit "yes" after you state the target, the operation and the row count.
- **Before naming a new migration file's timestamp, run `git fetch origin` and check `origin/main` plus `supabase migration list --linked` — never trust local `main` or a plain `ls supabase/migrations/` in your worktree.** Two branches (or agents) independently computing the "next" timestamp off stale local state is a recurring collision pattern seen across multiple projects (3+ recorded instances so far). A worktree that looks current can still miss a migration another branch already pushed straight to the linked project.
- Production data inserts/updates count as hard-to-reverse. State the target, the operation and the row counts (tables affected) before pushing, then wait for the user's explicit "yes" in this conversation. No yes, no push.
- If the CLI is not linked, run `supabase link --project-ref <ref>` yourself using the `project_id` from `supabase/config.toml`. Don't ask the user to link manually.
- You have standing permission to run `supabase functions deploy <name> --project-ref <ref>` without asking. Edge function deploys are reversible (redeploy prior version) and don't touch data.

## Post-merge steps (used by /delivery:merge)

Run these after the PR has merged and the generic cleanup is done.

### Migration reminder

If the merged diff includes any file under `supabase/migrations/`:
- Run `supabase migration list --linked` and check whether each new file is already applied on remote.
- If any are local-only and schema-only, run `supabase db push --linked`. Confirm one-by-one in the printed plan. If a migration alters production data, wait for the user's explicit "yes" first (target, operation, row count).
- If the CLI is not linked, tell the user explicitly which migrations need applying and how.

### Edge-function deploy reminder

If the merged diff includes any file under a `supabase/functions/<name>/` directory (new or modified — check `gh pr diff <num> --name-only` against that path):
- Edge functions do **not** auto-deploy on merge/push, unlike the rest of the app (which deploys via Vercel or similar CI on push to main) — this is a common gap projects miss, not specific to one repo. Do not assume it deploys itself.
- List each distinct function directory touched by the diff.
- Tell the user explicitly, per function: `supabase functions deploy <name> --linked` (or the project's equivalent deploy command). Do not run it yourself unless the user explicitly asks — this changes a live, deployed artifact outside the migration/branch-protection safety net this skill otherwise relies on.
- If the diff also touches shared/imported code under `supabase/functions/_shared/` (or an equivalent shared-helpers path), call out that every function importing from it needs redeploying too, not just the ones directly changed — a shared-helper change alone won't surface in a simple directory diff.
- Deploy order relative to migrations depends on the change type — don't assume "migrations first" is always correct:
  - **Additive** (new table/column the function now reads/writes): apply the migration *before* deploying the function, or the function will fail against the old schema.
  - **Destructive** (dropping/renaming something the *currently live* function still uses): deploy the updated function *before* running the migration, or the live function breaks the instant the column/table disappears.
  - If the diff is ambiguous or mixes both, flag it explicitly and ask the user for the intended order rather than guessing.

### Merge summary additions

Put these lines under `Stack pack post-merge items:` in the `<merge>` summary, and use this `Watch:` value instead of the base one:

```
Migrations applied: <list, or "none in diff">
Edge functions to deploy: <list of function names + deploy command, or "none in diff">
Watch: <Vercel deploy URL or other monitor target if known, else "production deploy via main">
```
