# team-claude-config

<!-- counts: skills=22 agents=12 -->

Builders Camp's Claude Code plugin marketplace (`builders-camp`). Two plugins:

| Plugin | Contains |
|---|---|
| `delivery` (repo root) | 12 agents (`@pm` + specialists), 22 skills (18 workflow skills, `/implement`, the `github-hygiene` and `gh-actions-safety` rule skills, and the opt-in `stack-supabase-vercel`), 5 hooks (house rules at session start, routing-gate reminder, routing-gate warning, `guard-main`, `guard-prod-db`), the loops kit (`loops/`, 4 files), `CLAUDE.md` (house rules) |
| `team-os` (`plugins/team-os`) | Placeholder. No skills yet; reserves the name |

## Install

```bash
claude plugin marketplace add builders-camp/team-claude-config
claude plugin install delivery@builders-camp
claude plugin install team-os@builders-camp
```

In a session: `/plugin marketplace add builders-camp/team-claude-config`, then `/plugin install delivery@builders-camp`.

Update: `claude plugin marketplace update builders-camp && claude plugin update delivery@builders-camp`. The plugin has no `version` field, so every commit on `main` is a new version.

Plugin components are namespaced: skills are `/delivery:plan`, `/delivery:fix`, and so on; agents are `delivery:pm` (`@agent-delivery:pm`). The rest of this README uses the short names.

The house rules in `CLAUDE.md` reach Claude through a `SessionStart` hook that prints the file, because plugins cannot ship a native CLAUDE.md. Hook output has no `@imports`, so `CLAUDE.md` must stay self-contained and under 9,000 characters (hook output over 10,000 is cut to a preview; `scripts/lint-skills.sh` enforces the cap). Put detail in skills or agents.

## Switch it off for one project

Add to `.claude/settings.json` (team) or `.claude/settings.local.json` (only you):

```json
{ "enabledPlugins": { "delivery@builders-camp": false } }
```

Or: `claude plugin disable delivery --scope project`.

## Roll back

- Remove: `claude plugin uninstall delivery@builders-camp`, then `claude plugin marketplace remove builders-camp` (this also deletes plugin data).
- Return to the pre-plugin setup: check out `641e75d`, the last commit before the plugin restructure (`git checkout 641e75d`), and run its `./install.sh`.

## Breaking changes

- `install.sh` is gone. Nothing writes to `~/.claude/` any more. Install and update with the commands above.
- The `@~/.claude/stacks/supabase-vercel/STACK.md` import no longer works. In the project's CLAUDE.md, replace it with the line `Stack: supabase-vercel`. The rules now live in the `stack-supabase-vercel` skill and load on demand.
- `.repos` and `install.sh --sync-workflows` have no plugin equivalent yet. Sync workflows by hand.
- Old symlinks into this repo must be removed by hand, or you get double hooks and duplicate skills. List them (this only lists):

  ```bash
  find ~/.claude -maxdepth 2 -type l -lname '*team-claude-config*'
  ```

  Expect entries under `~/.claude/{skills,agents,hooks,loops,stacks}`, plus `settings.json` and `CLAUDE.md`. Review the list, then delete only what it shows. Check `ls -la ~/.claude/settings.json ~/.claude/CLAUDE.md` before deleting: if they point elsewhere, leave them.

---

## Loops (generator -> judge)

`loops/` ships in the delivery plugin: `README.md` (the rules), `JUDGE_TEMPLATE.md` (fresh-subagent judge prompt), `FIX_ITEM.md` (fix-item contract) and `CHANGELOG.md` (a template). Each project keeps its own promoted-checks log at `.claude/loops/CHANGELOG.md`; copy the template there to start it.

---

## How work flows

The default flow for any non-trivial task:

```
You ask Claude to do something
        ↓
Claude routes to @pm (auto, per CLAUDE.md; `delivery:pm` as the plugin)
        ↓
@pm classifies: SINGLE / BATCH / EPIC / DIRECT
        ↓
@pm hands off to a specialist with a self-contained brief:
        ├── @visionary / @analyst ∥ @voc / @discovery / @designer ∥ @pmm / @engineer — upstream shaping, when load-bearing
        ├── @researcher   — discovery, options, framing
        ├── @implementer  — bounded code changes
        ├── @qa           — acceptance criteria, release safety
        └── @reviewer     — architecture audit, deep review
        ↓
Specialist returns its output contract
        ↓
@pm names the next command (e.g. /test, /deploy)
```

`@pm` is auto-invoked. The specialists run on its handoff. You don't usually call them by name unless you want to skip triage.

`@pm` is **not** invoked for: pure conversation, clarifying questions about Claude's own prior output, follow-ups inside an already-active workflow, read-only checks that change nothing.

---

## Agents

All agents enforce **output contracts** — a structured block they must emit before exiting. This keeps handoffs clean and prevents "running commentary with no result."

| Agent | When to use | Stops at |
|---|---|---|
| `@pm` | First touch for any non-trivial task. Classifies and routes. Runs a PRD carry-through check so requirements in the PRD reach the handoff brief. | Naming the specialist + handoff brief |
| `@visionary` | Rare. Product/company direction, strategy-level bets. | Vision doc |
| `@analyst` | Optional. Decision hinges on usage, funnel, revenue, SEO or sizing numbers. Read-only, aggregates only; inherits the session's MCP tools (no `tools:` line). | `analysis.md`, every number sourced; missing sources listed |
| `@voc` | Optional. Decision hinges on what customers say or competitor positioning. Read-only; inherits the session's MCP tools. | `voc.md`: ranked themes, sourced quotes, win/lose vs alternatives |
| `@discovery` | Unshaped feature ideas (JTBD → OST → MoSCoW). Has the Skill tool, so it can run `/jtbd`, `/ost`, `/moscow`. | Discovery doc + recommended next specialists. Optional synthetic ICP interviews via handoff (`NEEDS_INTERVIEWS`), findings labelled `[synthetic]`. |
| `@designer` | Material UI/flow surface: IA, flows, accessibility. | Design brief (no mockups) |
| `@pmm` | Optional. Customer-facing surface or launch; runs alongside `@designer`. Never publishes. | `messaging-brief.md` |
| `@engineer` | Architecturally non-trivial features. | Engineering brief (no code) |
| `@researcher` | Unclear problem, options analysis, codebase discovery, decision framing | Recommendation + next owner |
| `@implementer` | Bounded code changes, bug fixes, small features with clear scope. Has Bash. | Implementation or implementation brief |
| `@qa` | Acceptance criteria, user journey validation, release readiness. Has Bash. | Validation boundary + checklist. Also has browser verification mode (uses `/browser-qa` on the preview, fail-open). |
| `@reviewer` | Architecture audit, large refactors, security/performance review. Also has premise-critic mode (challenges a brief's premises) and brief-conformance mode (checks the work against the brief). | Review + recommended remediation |

Every agent can use project skills (see "Project skills" in `agents/pm.md`).

All agents have **scope-drift guardrails**: if the work shifts out of their lane, they hand back to `@pm` instead of overreaching. They also have soft tool-call budgets to prevent endless exploration.

---

## Skills (slash commands)

Three groups: lifecycle (day-to-day work), discovery frameworks, and meta (managing the system itself). Orchestration is handled by the `@pm` agent, not a slash command.

### Lifecycle

| Command | What it does |
|---|---|
| `/plan` | Execution-ready plan: goal, assumptions, scope, milestones, risks, acceptance criteria |
| `/research` | High-level concept research: best practices, failure patterns, recommendation |
| `/fix` | Minimal safe patch: failing behavior → root cause → smallest fix → risks → tests |
| `/test` | Regression-preventing tests: happy path + 2 edge cases + 1 failure case |
| `/qa` | Product QA checklist: user journeys, functional + non-functional checks, release safety |
| `/deep-review` | Full audit (architecture, code quality, tests, performance). **Use only for** large features, refactors, or security/performance work |
| `/deploy` | Safe feature-branch deploy: branch → commit → preflight (TS compile) → push → open draft PR with labels. **Never auto-merges.** |
| `/merge` | Safe PR merge: pre-merge gate → squash merge → cleanup → opted-in stack skill post-merge steps. **Manual trigger only.** |
| `/implement` | Creates a worktree branch from `origin/main`, then hands off to `@implementer`. Does not bypass `@pm`. |
| `/recap` | Plain-language recap of what shipped or changed |
| `/browser-qa` | Read-only Playwright check of a deploy preview (never production); PASS/FAIL/SKIPPED with evidence. Fail-open. |

### Discovery frameworks

| Command | What it does |
|---|---|
| `/jtbd` | Jobs-to-be-done framing for a feature idea |
| `/ost` | Opportunity solution tree |
| `/moscow` | MoSCoW prioritization |
| `/data-analysis` | Read-only quantitative analysis; every number sourced |
| `/voice-of-customer` | Themes, sourced quotes, win/lose vs alternatives |
| `/messaging-brief` | ICP, positioning, key messages with proof, copy and assets per surface |

### Rule skills (loaded on demand)

| Skill | What it does |
|---|---|
| `github-hygiene` | Before `gh pr create` / `gh issue create`: priority + type labels, PR templates, issue shapes |
| `gh-actions-safety` | When editing `.github/workflows/`: base-branch checkout, no PR-derived string interpolation, same-repo check before merge |

### Stack skills (opt-in)

| Skill | What it does |
|---|---|
| `stack-supabase-vercel` | Supabase migration, edge-function and `/merge` post-merge rules. Applies only when the project's CLAUDE.md has the line `Stack: supabase-vercel`. Loads on demand. |

### Meta (managing the system)

| Command | What it does |
|---|---|
| `/bootstrap` | Scaffolds per-repo Claude OS structure (`CLAUDE.md`, `.claude/skills/`, standards, registries) in a new repo. Run once per project. |
| `/improve` | Promote durable patterns into `CLAUDE.md` or skills. Shows diff before applying. |

---

---

## House rules (from `CLAUDE.md`)

Smallest correct change, no unnecessary abstraction, minimal diffs. Small changes go straight to implementation; multi-layer changes get a short plan first. After changes: list what could break, suggest tests and rollback. Never write to or delete production data without an explicit "yes". `/deep-review` only for large, risky or performance-sensitive work. The full `CLAUDE.md` is the source of truth.

---

## Contributing

**New skill:** create `skills/<name>/SKILL.md` (frontmatter: `name` equal to the directory, `description`, optional `disable-model-invocation`, `allowed-tools`, `argument-hint`). Keep the body short: steps, output format, stop condition. Update the counts marker at the top of this file.

**New agent:** create `agents/<name>.md` with frontmatter (`name`, `description`, `tools`, `model`, `maxTurns`, `memory`) and the sections used by existing agents: execution guardrails, what you own, core behavior, decision principles, output contract, stop conditions. Update `@pm`'s routing rules.

**New stack:** add a skill `skills/stack-<name>/SKILL.md` that applies only when the project's CLAUDE.md has `Stack: <name>`.

**Guard hooks (`PreToolUse` on `Bash`).** Both ask for approval; they never deny, so an explicit "hotfix to main" still works once you approve.

- `guard-main.sh`: asks before `git commit` on `main`/`master`, and before `git push` that targets `main`/`master` (explicit refspec such as `origin main` or `HEAD:main`, or a bare push while on `main`).
- `guard-prod-db.sh`: asks before `supabase db push`, `supabase db reset`, `supabase migration repair` and `psql`.

Both read the command loosely (split on `&&`, `||`, `;`, `|`), so exotic shell forms can slip past. `scripts/test-hooks.sh` runs the cases.

**New hook:** add it to `hooks/hooks.json`, scripts executable (`chmod 755`), paths via `${CLAUDE_PLUGIN_ROOT}`.

Run `scripts/lint-skills.sh` and `claude plugin validate .` before opening a PR. CI runs the lint.

| Change | Where |
|---|---|
| Global house rule | `CLAUDE.md` |
| Reusable workflow | New skill |
| New specialist role | New agent |
| Stack-specific rules | `skills/stack-<name>/` |
| Repo-specific conventions | That repo's CLAUDE.md (use `/bootstrap`) |

Pushes to `main` post a Slack notification with the update command.

## Troubleshooting

- **Skill or agent missing:** run `/plugin` and check `delivery` is enabled for the project; check old symlinks in `~/.claude` (see Breaking changes).
- **Routing reminder fires twice:** an old `~/.claude/settings.json` symlink still points at this repo's hooks. Remove it.
- **House rules not applied:** check the `SessionStart` hook ran (`/hooks`).
