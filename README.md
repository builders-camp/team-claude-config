# team-claude-config

<!-- counts: skills=18 agents=12 -->

The shared Claude config for the team.

This repo holds the global rules, agents, and skills we both want Claude to use across every project, on every machine. Install it once per laptop, pull updates as we improve them.

---

## What this is

When you install this repo, these things end up symlinked into your `~/.claude/` directory:

- **`CLAUDE.md`** — the operating system. Default behavior, planning rules, agent strategy, output discipline. Applied to every Claude Code session you run, in any repo.
- **`agents/`** — twelve specialized subagents (`@pm`, `@visionary`, `@analyst`, `@voc`, `@discovery`, `@designer`, `@pmm`, `@engineer`, `@researcher`, `@implementer`, `@reviewer`, `@qa`). Claude routes work to them based on task shape.
- **`settings.json`** — routing-gate hooks (a `UserPromptSubmit` reminder and a `PreToolUse` warning), linked by `install.sh`. Skipped if you already have a personal `~/.claude/settings.json`.
- **`skills/`** — eighteen slash-commands you can invoke directly (`/plan`, `/fix`, `/deploy`, `/jtbd`, `/ost`, `/moscow`, `/recap`, etc.) for specific lifecycle moments.
- **`loops/`** — the generator -> judge loop kit (see below). Linked to `~/.claude/loops/`.
- **`stacks/`** — opt-in stack packs. Each `stacks/<name>` is linked to `~/.claude/stacks/<name>`.

Because these live globally in `~/.claude/`, they apply to every project you open with Claude Code — not just one repo. Per-repo `CLAUDE.md` files (when they exist) layer *on top* of this global config.

---

## Install

```bash
git clone git@github.com:<org>/team-claude-config.git ~/team-claude-config
cd ~/team-claude-config
./install.sh
```

That's it. The installer symlinks files into `~/.claude/`, so future updates flow live — usually no need to re-run `install.sh` after a `git pull`. Re-run it only when new skill, agent or stack files are added (so they get linked).

To update:

```bash
cd ~/team-claude-config && git pull && ./install.sh
```

You'll also see a Slack notification in our team channel when either of us pushes a change here, with the exact pull-and-install command.

---

## How updates feel

`install.sh` is non-destructive:

- Existing `~/.claude/CLAUDE.md` (if it's a real file, not a symlink) gets backed up to `CLAUDE.md.bak` before we replace it with the symlink.
- Personal skills or agents you've added to `~/.claude/skills/<name>/` or `~/.claude/agents/<name>.md` are **preserved** — the installer skips any name that already exists as a real file. To switch to the shared version, delete your local one and re-run.
- Skills/agents deleted upstream are cleaned up on re-run: dangling symlinks into this repo and entries listed in `retired.txt` are removed, but only if they're symlinks into this repo. Real files and other symlinks are never touched.

So you can keep personal experiments alongside team config. They don't collide.

---

## Syncing GitHub workflows across repos

Beyond global Claude rules, we also share GitHub workflows (like auto-assign reviewers). Workflow sync is **opt-in**: it only runs when you pass `./install.sh --sync-workflows`. A plain `./install.sh` does not touch your other repos.

**List your repos** in `.repos`:

```
~/repos/github/<org>/<repo-one>
~/repos/github/<org>/<repo-two>
~/team-claude-config
```

One repo per line. Paths use `~/` (expands to `$HOME`). Now when you run:

```bash
cd ~/team-claude-config && git pull && ./install.sh --sync-workflows
```

It will:
1. Update global config in `~/.claude/`
2. Copy `.github/workflows/` to each repo listed in `.repos`
3. Skip any repo not found locally (e.g., one you haven't cloned yet)

Tell you which repos were synced and which to commit to:

```bash
cd ~/repos/github/<org>/<repo-one>
git add .github/workflows/
git commit -m 'ci: sync workflows from team-claude-config'
git push
```

**Adding new repos later:** Just edit `.repos` and re-run `./install.sh --sync-workflows`.

---

## The mental model

Three layers of config:

**1. Team process (this repo, lives at `~/.claude/`)**
House rules, agents, skills and the loops kit that apply to every project we touch. No project specifics.

**2. Stack packs (`stacks/`, linked to `~/.claude/stacks/`)**
Opt-in rules for a specific stack. A project opts in by adding an import line to its own CLAUDE.md, for example:

```
@~/.claude/stacks/supabase-vercel/STACK.md
```

Projects without the line do not get the pack. A project that wants the Supabase rules (migrations, edge-function deploys) and the Supabase/Vercel `/merge` post-merge steps must add that line.

**3. Project-specific (lives at `<repo>/.claude/` and `<repo>/CLAUDE.md`)**
Project context: tech stack, deploy process, design-system location, past incidents, repo-specific rules. Use `/bootstrap` (described below) to scaffold this in a fresh repo.

When Claude is working in a repo, it sees all three — team process first, then any imported stack packs, then repo-local on top. Repo-local wins on conflicts.

---

## Loops (generator -> judge)

`loops/` is a small kit for skills that produce text, content or review verdicts and want an independent check: `README.md` (the rules), `JUDGE_TEMPLATE.md` (fresh-subagent judge prompt), `FIX_ITEM.md` (fix-item contract) and `CHANGELOG.md` (a template). The kit lives at `~/.claude/loops/`. Each project keeps its own promoted-checks log at `.claude/loops/CHANGELOG.md` in the project repo; copy the template there to start it.

---

## How work flows

The default flow for any non-trivial task:

```
You ask Claude to do something
        ↓
Claude routes to @pm (auto, per CLAUDE.md)
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

`@pm` is **not** invoked for: pure conversation, clarifying questions about Claude's own prior output, follow-ups inside an already-active workflow.

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

Every agent can use project skills (see "Project skills" in `CLAUDE.md`).

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
| `/merge` | Safe PR merge: pre-merge gate → squash merge → cleanup → opted-in stack pack post-merge steps. **Manual trigger only.** |
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

### Meta (managing the system)

| Command | What it does |
|---|---|
| `/bootstrap` | Scaffolds per-repo Claude OS structure (`CLAUDE.md`, `.claude/skills/`, standards, registries) in a new repo. Run once per project. |
| `/improve` | Promote durable patterns into `CLAUDE.md` or skills. Shows diff before applying. |

---

## House rules (from `CLAUDE.md`)

The global `CLAUDE.md` enforces these defaults across every session. Highlights:

**Default behavior**
Smallest correct change. No unnecessary abstraction. Explicit over clever. Minimal diffs.

**Planning**
Small changes → implement directly. Multi-layer or architecture → propose a short plan first. Max one clarification question if blocked.

**Quality after changes**
List what could break. Suggest tests. Suggest monitoring or rollback. Reproduce bugs via test before fixing when feasible.

**Stack packs**
Stack-specific rules (e.g. Supabase migrations and edge-function deploys) live in `stacks/<name>/STACK.md` and apply only to projects that import them.

**Deep review escalation**
`/deep-review` is **not** the default. Use it only for: large features (> 5 files or multiple domains), refactors, security-sensitive code, or performance-sensitive paths.

**Output discipline**
Concise structured headers. No long explanations unless asked. Stop when objective is complete. After code changes: briefly state files changed and why.

The full `CLAUDE.md` is the source of truth. This summary just exists so you don't have to read it every time.

---

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md`
2. Use the YAML frontmatter convention from existing skills:
   ```
   name: <skill-name>
   description: <one line — when should Claude use this>
   disable-model-invocation: <true|false>
   allowed-tools: <comma-separated list>
   argument-hint: [<what the skill expects>]
   ```
3. Body: short, structured. Process steps, output format, stop condition. Look at `skills/plan/SKILL.md` as the canonical minimal example.
4. Open a PR. Slack notification will fire on merge.
5. Either of us runs `./install.sh` to symlink the new skill into our local `~/.claude/skills/`.

**Don't duplicate `CLAUDE.md` rules inside skills.** Skills should focus on their specific output protocol.

---

## Adding a new agent

1. Create `agents/<agent-name>.md`
2. Frontmatter:
   ```
   name: <agent-name>
   description: <one line — when @pm or the user should route work here>
   tools: <comma-separated>
   model: <sonnet | opus | haiku>
   maxTurns: <integer>
   memory: <project | session>
   ```
3. Body must include:
   - **Execution guardrails** — output contract, scope-drift handoff rules, tool budget
   - **What you own** — the lane
   - **Core behavior** — numbered steps
   - **Decision principles** — the bias
   - **Output contract** — the structured block this agent emits
   - **Stop conditions**
4. Update `@pm`'s routing rules if the new agent should be auto-routed to.
5. PR + install.

Match the structure of existing agents. Consistency across agents is what makes the system predictable.

---

## When to update what

| Change | Where |
|---|---|
| New global house rule | `CLAUDE.md` |
| New reusable workflow | New skill |
| New specialist role | New agent |
| Stack-specific rules shared across projects | New or existing `stacks/<name>/STACK.md` |
| Repo-specific tech stack, deploy steps, conventions | That repo's local `CLAUDE.md` (use `/bootstrap`) |
| One-off project decision | Don't put it here. Your tracker or a repo ADR. |

---

## Troubleshooting

**A skill or agent isn't being invoked.**
Run `ls -la ~/.claude/skills/` and `ls -la ~/.claude/agents/` — should show symlinks pointing into `~/team-claude-config/`. If a name you expect isn't there, you probably have a personal version that's blocking it. Delete the personal one and re-run `./install.sh`.

**`CLAUDE.md` changes don't seem to apply.**
Confirm `~/.claude/CLAUDE.md` is a symlink (`ls -la ~/.claude/CLAUDE.md`). If not, re-run `./install.sh` — it backs up the existing file and replaces with the symlink.

**Slack notification didn't fire after a push.**
Check `.github/workflows/slack-notify.yml` — it runs on push to `main`. If your push went to a branch, no notification. If it went to `main`, check the Actions tab in GitHub for failures.
