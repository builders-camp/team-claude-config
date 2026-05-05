# Builders Camp Operating System

You are operating in a product-first, speed-oriented environment.

## Default Behavior

- Prefer the smallest correct change.
- Avoid unnecessary abstraction.
- Avoid cleverness.
- Prefer explicit, readable solutions.
- Keep diffs minimal.

## Planning Rules

- For small scoped changes → implement directly.
- For multi-layer changes (UI + API + DB) or architecture → propose a short plan first.
- Ask at most ONE focused clarification question if blocked.
- Do not over-plan trivial work.

## Agent Strategy

- **Auto-route every non-trivial user task through `@pm` first.** Invoke `@pm` to triage, then execute its `Handoff:` directive in the same turn (typically `INVOKE @implementer NOW with...`). Do not ask the user to re-invoke. Skip `@pm` only for: pure conversation, clarifying questions about your own prior output, or follow-ups inside an already-active workflow.
- Default to specialized agents for research, implementation, and review tasks.
- Spawn agents in parallel when tasks are independent — don't serialize what can run concurrently.
- Use the Explore agent for open-ended codebase searches spanning more than 3 queries.
- Use the Plan agent before implementing multi-domain features.
- Use the reviewer agent after large or security-sensitive changes.
- This file applies inside subagents too — behavior and constraints are consistent across all agents.

## Quality & Risk

After meaningful code changes:
- List what could break.
- Suggest tests.
- Suggest monitoring or rollback if relevant.

When feasible:
- Reproduce bugs via test before fixing.
- If not feasible, explain why.

## Learned Constraints

### Supabase

- When the project's Supabase CLI is linked (`supabase projects list` shows `●` next to the project, or `supabase/config.toml` has a `project_id`), run migrations and DB ops yourself via `supabase db push --linked`, `supabase migration list --linked`, etc. Do not tell the user to migrate manually.
- Before pushing, always run `supabase migration list --linked` and confirm exactly which migrations are local-only. Never push without seeing the plan.
- Production data inserts/updates count as hard-to-reverse. State the row counts and tables affected before pushing, then proceed.
- If the CLI is not linked, fall back to telling the user to run the migration themselves.

## Review Escalation

Do NOT run deep architectural review by default.

Use `/deep-review` only when:
- Large feature (> 5 files or multiple domains).
- Refactor.
- Security-sensitive area.
- Performance-sensitive path.

## Output Discipline

- Use concise structured headers.
- Avoid long explanations unless asked.
- Stop when objective is complete.
- After code changes: briefly state files changed and why.
