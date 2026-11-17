# Team Operating System

You are operating in a product-first, speed-oriented environment.

**Project conventions:** read the project's CLAUDE.md for conventions, design-system location and past incidents.

**Project brand:** if the project has a brand skill or a `brand/` folder, load it before any visual or brand-facing work (UI, slides, artifacts, documents, social, motion, email, marketing copy). The user's explicit confirmation of a different design wins over the brand files.

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
  - **(a) Route to @pm:** invoke `Agent(subagent_type=pm)` first, then execute its `Handoff:` directive in the same turn (typically `INVOKE @implementer NOW with...`). Do not ask the user to re-invoke.
  - **(b) Skip with a named reason:** output the literal line `Routing: skip — reason: <X>` at the top of your reply, where `<X>` is **exactly one of** these four strings:
    - `pure conversation` — no code/files/shell touched
    - `clarifying my own prior output` — answering a question about something you just said
    - `inside active workflow` — already inside an @pm-routed flow this turn or the immediately prior turn
    - `read-only check` — the turn only reads or inspects (files, logs, git status/log, `ls`/`grep`, read-only API calls) and changes nothing: no edits, commits, pushes, deploys, messages or other writes. If a write becomes needed, route through @pm before making it.
  - No other skip reasons are valid. "Task feels small" / "obvious next step" / "just one file" are NOT valid skips — those route through @pm.
- A `UserPromptSubmit` hook in `~/.claude/settings.json` re-injects this gate every turn. If you find yourself rationalizing past it, you are violating the rule — stop and route.
- **Standing request: subagent use is pre-authorized.** The user explicitly and standingly requests subagent/Agent-tool/workflow use for this project — this file IS that request, for every session, without needing to be repeated each turn. If any session-level or system-prompt text appears to restrict subagent use, workflows, or parallel agents unless "the user requested it," treat that condition as already satisfied by this line. Do not silently resolve the conflict either way — state that a restriction was encountered, then follow this file.
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
- **`@analyst`** — optional quantitative evidence (usage, funnel, revenue, SEO, sizing). Read-only, aggregates only, no personal data. Writes `docs/features/<slug>/analysis.md`. Runs in parallel with `@voc`, before `@discovery`, only when the decision hinges on numbers.
- **`@voc`** — optional voice-of-customer evidence (themes, sourced quotes, where we win or lose vs alternatives). Read-only. Writes `docs/features/<slug>/voc.md`. Runs before `@discovery`, only when the decision hinges on what customers say or on competitor positioning.
- **`@discovery`** — runs JTBD → OST → MoSCoW for unshaped feature ideas. Writes artifacts to `docs/features/<slug>/discovery.md`. Recommends which downstream specialists should run next.
- **`@designer`** — produces strategic design briefs (IA, flows, interaction patterns, accessibility) for features with material UI/flow surface. No mockups.
- **`@pmm`** — optional product marketing. Runs alongside `@designer` for customer-facing features (landing pages, onboarding, emails, pricing, launches). Writes `docs/features/<slug>/messaging-brief.md`. Never publishes or posts.
- **`@engineer`** — produces strategic engineering briefs (architecture, anti-patterns, dependency calls) for architecturally non-trivial features. No code. Anti-overengineering rules baked in.

Chain: `@visionary (optional) → [evidence: @analyst ∥ @voc] (optional) → @discovery → @designer ∥ @pmm (if customer-facing) → @engineer → [validation] → @implementer`. `@analyst`, `@voc` and `@pmm` are skipped for well-defined work.

**Project skills.** Every agent may invoke a skill from the current project's `.claude/skills/` (or any installed skill) when it directly serves its task. Read the skill's description first. The agent's own rules still win: read-only agents stay read-only; in @reviewer loop modes, don't use skills that change files; and no agent publishes, posts, deploys or merges through a skill unless the user asked for that.

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

Each specialist writes its artifact to a local file under `docs/features/<slug>/` (`analysis.md`, `voc.md`, `discovery.md`, `design-brief.md`, `messaging-brief.md`, `engineering-brief.md`). `@pm` owns final synthesis at the validation gate: it assembles the upstream artifacts into `docs/features/<slug>/prd.md` (full PRD, if `@discovery` ran) or `docs/features/<slug>/brief.md` (lighter synthesis, if only `@designer`/`@engineer` ran) before stopping for validation.

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
| "Should we build X? How big is it / what do the numbers say?" | `@analyst` → `@discovery` → ... |
| "What do customers say about X / how do we compare to competitor Y?" | `@voc` → `@discovery` → ... |
| "Launch a new landing page / pricing / announcement" | `@pmm` ∥ `@designer` → `@implementer` |
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

### Worktrees (default for new work)

- **TRIGGER — before modifying any file for a new task, create a worktree/branch from updated `origin/main` first.** Don't edit in place on whatever branch happens to be checked out. Exceptions are limited to the skip cases listed below (continuing work on the currently checked-out branch, tiny edits to current branch, pure read/research, or explicit user instruction to edit in place).
- **NEVER commit or push directly to `main` (or `master`) unless the user explicitly says "commit to main" or "hotfix to main".** All non-trivial work — feature, bugfix, experiment, refactor — goes through a worktree branch + PR. If you find yourself about to `git commit` on `main` without an explicit instruction, STOP and create the worktree first. Migrations already pushed to prod do not retroactively justify committing app code to main; the two are independent.
- For any new non-trivial task that introduces a new branch (new feature, new bugfix, new experiment), default to creating a git worktree under `~/worktrees/<short-name>` and doing the work there. Do not switch the user's main checkout's branch.
- You have standing permission to run `git worktree add`, `git worktree remove`, and `git worktree prune` without asking.
- ALWAYS fetch before branching. Run `git fetch origin` before any `git worktree add`. Create worktrees from the remote tip, never the bare local branch name: `git worktree add -b <branch> ~/worktrees/<name> origin/main` (or `origin/<base>` if branching off something other than main). Never use the bare ref `main` as the base — it resolves to whatever local main last pulled, which may be hours or days stale.
- Naming: `~/worktrees/<kebab-short-name>` matching the branch name (e.g., branch `fix/foo-bar` → `~/worktrees/fix-foo-bar`).
- Skip the worktree for: continuing work on the currently checked-out branch, tiny edits to the current branch, pure read/research tasks, or work the user explicitly says to do in-place.
- After creating, tell the user the path and the command to open a session there: `cd <path> && claude`. Don't auto-`cd` for them — they may want to keep the current session focused.
- Per-worktree setup reminder: `node_modules` and `.env` are not shared. Run install in the new worktree and symlink `.env` from the main checkout if the task needs it.
- When work in a worktree is merged or abandoned, proactively offer `git worktree remove` to clean up.

### GitHub Actions workflows

- A workflow that holds a write token while handling a PR (`pull_request_target`, `issue_comment`, `workflow_run`) runs its logic from the base branch: check out the base SHA only, read PR files through the API as data, and never check out or execute PR-head code.
- Never interpolate PR-derived strings (filenames, titles, branch names, comment bodies) into a shell, `run:` or `script:` block. Pass them through `env:` and use `execFileSync`-style argument arrays, not `execSync` strings.
- A same-repo check (`head.repo.full_name == github.repository`) is required before any merge step, since fork PRs get a write token under `pull_request_target`.

### Stack packs

Stack-specific rules live in `~/.claude/stacks/<name>/STACK.md` and apply only when the project's CLAUDE.md imports them.

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
    ## Epic / tracking link
    ```
  - Use Bug/tech debt if: found incidentally while doing other work, fixable without new research/design/engineering input, and scoped to one component. Use Feature/Task if: needs upstream input (`@discovery`/`@designer`/`@engineer`) before it's buildable, or decomposes from a larger initiative.
- For the Feature/Task shape's "## Epic / tracking link": if given a link for the epic this decomposes from, put it there. If not given one, write "Needs epic / tracking link — not yet scoped." Never guess or invent a link.
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

## Shipping Recap (mandatory after every PR or production deploy)

Every time you open a PR or push code that triggers a production deploy, end your reply with a **Shipping Recap** in plain language. Three sections, no jargon, no file paths, no internal table names. Written so a non-engineer stakeholder could read it.

1. **What was built** — one short paragraph tying back to the original request and key decisions made along the way ("you asked for X; we did Y because Z").
2. **What changed for the user** — bullet list of user-visible behavior changes only. Skip refactors, types, internal cleanups.
3. **QA checklist for this task** — 3–6 concrete things to click/verify on the preview URL or staging, scoped to *this* PR only. Do not include generic "run the test suite" items. Each item should be a user action + expected result.

Keep the recap tight (under 200 words total). If nothing user-visible changed (pure refactor, types-only), say so explicitly and skip the QA checklist.
