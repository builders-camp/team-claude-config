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

- **ROUTING GATE — every new user task.** Before your first Edit/Write/Bash/Agent(non-pm) tool call on a new user task, you MUST do exactly one of:
  - **(a) Route to @pm:** invoke `Agent(subagent_type=pm)` first (`delivery:pm` when installed as the plugin), then execute its `Handoff:` directive in the same turn (typically `INVOKE @implementer NOW with...`). Before code changes on a new task, use the `implement` skill to set up the worktree branch. Do not ask the user to re-invoke.
  - **(b) Skip with a named reason:** output the literal line `Routing: skip — reason: <X>` at the top of your reply, where `<X>` is **exactly one of** these three strings:
    - `pure conversation` — no code/files/shell touched
    - `clarifying my own prior output` — answering a question about something you just said
    - `inside active workflow` — already inside an @pm-routed flow this turn or the immediately prior turn
  - No other skip reasons are valid. "Task feels small" / "obvious next step" / "just one file" are NOT valid skips — those route through @pm.
- The `delivery` plugin's SessionStart hook loads this gate at the start of every session. If you find yourself rationalizing past it, you are violating the rule — stop and route.
- Prefer subagents: when a task fits a specialist agent, hand it to that agent rather than doing the work inline.
- Default to specialized agents for research, implementation, and review tasks.
- Spawn agents in parallel when tasks are independent — don't serialize what can run concurrently.
- Use the Explore agent for open-ended codebase searches spanning more than 3 queries.
- Use the Plan agent before implementing multi-domain features.
- Use the reviewer agent after large or security-sensitive changes.
- This file applies inside subagents too — behavior and constraints are consistent across all agents.

### Agent architecture

This repository has a single product orchestrator and a set of specialists.

**Orchestrator**

- **`@pm`** — single entry point for all product, feature, and engineering tasks. Classifies the request, decides which specialists need to run, and routes accordingly. Never does the work itself.

**Upstream specialists** (run before implementation when load-bearing)

- **`@visionary`** — rare, optional pre-step even further upstream than `@discovery`. Only for product/company direction itself, explicit strategy vocabulary (vision, north star, 10x, why now, moonshot), or new product line/business model/platform-level bets. Writes `docs/vision.md` or `docs/features/<slug>/vision.md`. Bias toward skipping — routine feature requests go straight to `@discovery`.
- **`@discovery`** — runs JTBD → OST → MoSCoW for unshaped feature ideas. Writes artifacts to `docs/features/<slug>/discovery.md`. Recommends which downstream specialists should run next.
- **`@designer`** — produces strategic design briefs (IA, flows, interaction patterns, accessibility) for features with material UI/flow surface. No mockups.
- **`@engineer`** — produces strategic engineering briefs (architecture, anti-patterns, dependency calls) for architecturally non-trivial features. No code. Anti-overengineering rules baked in.

**Downstream specialists**

- **`@researcher`** — codebase / library / pattern research
- **`@implementer`** — bug fixes, bounded changes, implementation work
- **`@reviewer`** — deep review, audits
- **`@qa`** — acceptance criteria, release readiness

**Routing rule for callers**

Always invoke `@pm` first (per the routing gate above). It will route from there. Do not invoke specialists directly unless `@pm` has handed off explicitly with an `INVOKE @<agent>` directive.

The single exception: re-invocations after a validation gate. When `@pm` has stopped for validation and you've reviewed the artifacts in the local file(s) under `docs/features/<slug>/`, re-invoke `@pm` (not the specialists) with a validation signal like "validated, proceed."

**Validation gate**

When `@pm` invokes upstream specialists (`@discovery` / `@designer` / `@engineer`), it will stop for validation before proceeding to `@implementer`. Two strategies:

- **Single gate (default)**: stop once after all upstream specialists have run.
- **Per-specialist gate (high-stakes features)**: stop after each specialist.

`@pm` chooses the strategy and states it in `Validation strategy:` of its contract block.

Each specialist writes its artifact to a local file under `docs/features/<slug>/` (`discovery.md`, `design-brief.md`, `engineering-brief.md`). `@pm` owns final synthesis at the validation gate: it assembles the upstream artifacts into `docs/features/<slug>/prd.md` (full PRD, if `@discovery` ran) or `docs/features/<slug>/brief.md` (lighter synthesis, if only `@designer`/`@engineer` ran) before stopping for validation.

**What goes to which agent**

| Input | First specialist |
|---|---|
| "Fix this bug" | `@implementer` |
| "Find where X lives in the code" | `@researcher` |
| "I want to rethink what our product even is / find our 10x opportunity" | `@visionary` → `@discovery` → ... |
| "I want to build a feature that…" | `@discovery` |
| "Customer interviews say X — what should we do?" | `@discovery` |
| "Add an export button to the dashboard" (well-defined, low risk) | `@implementer` |
| "Add a new section to the dashboard" (UI surface, flow change) | `@designer` → `@implementer` |
| "Build a real-time sync system" (architecturally non-trivial) | `@engineer` → `@implementer` |
| "Build a new onboarding flow" (UI + architecture) | `@discovery` → `@designer` → `@engineer` → `@implementer` |
| "Audit our auth code" | `@reviewer` |
| "Define acceptance for the export feature" | `@qa` |

When in doubt, `@pm` errs toward more discovery, not less. Cheap to discover that something is well-shaped already; expensive to discover late that an unshaped idea was routed straight to implementation.

## Quality & Risk

After meaningful code changes:
- List what could break.
- Suggest tests.
- Suggest monitoring or rollback if relevant.

When feasible:
- Reproduce bugs via test before fixing.
- If not feasible, explain why.

## Learned Constraints

### GitHub PR/Issue Labeling

- Whenever you create a new PR or issue (`gh pr create`, `gh issue create`), immediately apply exactly two labels in the same turn before considering the task done:
  - **Priority** — one of `P0-critical` (revenue/data integrity, fix first), `P1-high` (security, important bug clusters), `P2-medium` (reliability, dev process, features), `P3-low` (cosmetic, tech debt, docs). Classify the specific PR/issue against this fixed rubric.
  - **Type** — one of `bug`, `documentation`, `duplicate`, `enhancement`, `good first issue`, `help wanted`, `invalid`, `question`, `wontfix`. Pick whichever fits from context.
- Apply via `gh pr edit <num> --add-label "<priority>" --add-label "<type>"` or `gh issue edit <num> --add-label ...`.
- This only covers PRs/issues created through Claude Code — it does not catch ones opened manually on GitHub.com or by other tools. If that changes, revisit with a GitHub Actions workflow instead.

#### PR templates

- When creating a PR (`gh pr create`), if the target repo has its own `.github/PULL_REQUEST_TEMPLATE.md`, always use it as the PR body via `--body-file`, never ad hoc `--body` text. Same pattern as the ISSUE_TEMPLATE deferral rule below, applied to PRs.
- If no `PULL_REQUEST_TEMPLATE.md` exists, fall back to a concise descriptive body written to a temp file and passed via `--body-file`.

### GitHub Issues

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
    ## Notion epic
    ```
  - Use Bug/tech debt if: found incidentally while doing other work, fixable without new research/design/engineering input, and scoped to one component. Use Feature/Task if: needs upstream input (`@discovery`/`@designer`/`@engineer`) before it's buildable, or decomposes from a larger initiative.
- For the Feature/Task shape's "## Notion epic": if given a Notion link for the epic this decomposes from, put it there. If not given one, write "Needs Notion epic — not yet scoped." Never guess or invent a Notion link.
- A Feature/Task issue is not build-ready while "## Open questions" still has unresolved items. Don't start implementation off it — say so in chat, and leave the issue open with those questions visible rather than resolving them silently.

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

## Shipping Recap (mandatory after every PR or Vercel deploy)

Every time you open a PR or push code that triggers a Vercel deploy, end your reply with a **Shipping Recap** in plain language. Three sections, no jargon, no file paths, no internal table names. Written so a non-engineer stakeholder could read it.

1. **What was built** — one short paragraph tying back to the original request and key decisions made along the way ("you asked for X; we did Y because Z").
2. **What changed for the user** — bullet list of user-visible behavior changes only. Skip refactors, types, internal cleanups.
3. **QA checklist for this task** — 3–6 concrete things to click/verify on the preview URL or staging, scoped to *this* PR only. Do not include generic "run the test suite" items. Each item should be a user action + expected result.

Keep the recap tight (under 200 words total). If nothing user-visible changed (pure refactor, types-only), say so explicitly and skip the QA checklist.
