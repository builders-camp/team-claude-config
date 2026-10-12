# team-claude-config

Builders Camp's Claude Code plugin marketplace.

This repo is a marketplace (`builders-camp`) with two plugins:

| Plugin | What | Who installs it |
|---|---|---|
| `delivery` | The delivery harness: `@pm` routing, discovery, design, engineering, implement, review, QA, deploy, merge. 9 agents, 16 skills, 1 SessionStart hook. | Each developer, once per machine |
| `team-os` | Builders Camp ops skills (placeholder — see [plugins/team-os/README.md](plugins/team-os/README.md)) | Each person, once |

Plugins install at user scope, so they work in every repo you open, and never take over your personal `~/.claude/CLAUDE.md`.

---

## Install

One command per person:

```bash
claude plugin install delivery --marketplace builders-camp/team-claude-config
```

Optional, for the ops placeholder:

```bash
claude plugin install team-os --marketplace builders-camp/team-claude-config
```

Restart Claude Code after installing. To update later:

```bash
claude plugin update delivery@builders-camp
```

To switch the harness off in one project: `claude plugin disable delivery@builders-camp --scope project`.

### Moving from `install.sh`

`install.sh` still works exactly as before (symlinks `CLAUDE.md`, skills and agents into `~/.claude/`, syncs workflows to repos in `.repos`). It is kept for the transition only. To move to the plugin:

1. Remove the symlinks `install.sh` created: `~/.claude/CLAUDE.md` (restore `~/.claude/CLAUDE.md.bak` if you had one), and the symlinked entries in `~/.claude/skills/` and `~/.claude/agents/` that point into this repo.
2. Run the install command above.

Don't run both: you'd load the house rules twice and see each skill and agent twice.

---

## Layout

```
.claude-plugin/
  marketplace.json      # the builders-camp marketplace (lists both plugins)
  plugin.json           # delivery plugin manifest (plugin root = repo root)
CLAUDE.md               # house rules + routing gate, loaded by the SessionStart hook
hooks/hooks.json        # delivery: SessionStart hook
agents/                 # delivery: 9 agents
skills/                 # delivery: 16 skills
plugins/team-os/        # team-os plugin (placeholder)
install.sh, .repos      # legacy installer + workflow sync
```

`delivery` keeps its files at the repo root so `install.sh` keeps working unchanged.

---

## Where rules live

- **Always-on** (house rules, `@pm` routing gate): `CLAUDE.md`. The `delivery` SessionStart hook loads it into every session (startup, resume, clear, compact).
- **Situational** rules live in the skill that uses them:
  - Worktrees and "never commit to main" → `/implement`
  - Supabase (linking, migration timestamps, `db push`, prod data writes, edge functions) → `/deploy` and `/merge`
- **Repo-specific** rules and skills stay in that repo's own `CLAUDE.md` and `.claude/` (use `/bootstrap` to scaffold).

When Claude works in a repo it sees both: the plugin's rules, then the repo's own on top. Repo-local wins on conflicts.

---

## How work flows

```
You ask Claude to do something
        ↓
Routing gate (SessionStart hook) → @pm
        ↓
@pm classifies: SINGLE / BATCH / EPIC / DIRECT
        ↓
Upstream, only when load-bearing:
        @visionary (rare) → @discovery → @designer → @engineer
        ↓ writes docs/features/<slug>/…, stops for your validation
/implement → worktree branch from origin/main
        ↓
@implementer — bounded code changes
        ↓
@qa / @reviewer — acceptance, release safety, deep review
        ↓
/deploy → PR (never merges)    →    /merge (manual) → migrations, cleanup
```

`@researcher` (codebase/library research, options) runs on `@pm`'s handoff whenever a question needs answering first.

`@pm` is **not** invoked for: pure conversation, clarifying questions about Claude's own prior output, follow-ups inside an already-active workflow.

---

## Agents (9)

All agents enforce **output contracts** and **scope-drift guardrails**: if the work leaves their lane, they hand back to `@pm`. When installed as the plugin, agent types are namespaced (`delivery:pm`, `delivery:implementer`, …).

| Agent | When to use | Stops at |
|---|---|---|
| `@pm` | First touch for any non-trivial task. Classifies and routes. | Naming the specialist + handoff brief |
| `@visionary` | Rare. Product/company direction, strategy bets | `vision.md` |
| `@discovery` | Unshaped feature ideas: JTBD → OST → MoSCoW | `discovery.md` + next specialists |
| `@designer` | New UI surface, flow or IA changes | `design-brief.md` |
| `@engineer` | Architecturally non-trivial features | `engineering-brief.md` |
| `@researcher` | Codebase discovery, options analysis, decision framing | Recommendation + next owner |
| `@implementer` | Bounded code changes, bug fixes, small features | Implementation or implementation brief |
| `@qa` | Acceptance criteria, user journeys, release readiness | Validation boundary + checklist |
| `@reviewer` | Architecture audit, large refactors, security/performance review | Review + recommended remediation |

---

## Skills (16)

### Lifecycle

| Command | What it does |
|---|---|
| `/plan` | Execution-ready plan: goal, assumptions, scope, milestones, risks, acceptance criteria |
| `/research` | High-level concept research: best practices, failure patterns, recommendation |
| `/implement` | Worktree branch from `origin/main`, then hand off to `@implementer` |
| `/fix` | Minimal safe patch: failing behavior → root cause → smallest fix → risks → tests |
| `/test` | Regression-preventing tests: happy path + 2 edge cases + 1 failure case |
| `/qa` | Product QA checklist: user journeys, functional + non-functional checks, release safety |
| `/deep-review` | Full audit. **Only for** large features, refactors, or security/performance work |
| `/deploy` | Feature branch → preflight → push → PR. **Never auto-merges.** |
| `/merge` | Pre-merge gate → squash merge → cleanup → Supabase migrations. **Manual trigger only.** |

### Discovery

| Command | What it does |
|---|---|
| `/jtbd` | Jobs-to-be-Done canvas for a feature idea or problem |
| `/ost` | Opportunity Solution Tree (Teresa Torres, pragmatic variant) |
| `/moscow` | MoSCoW prioritization of candidate solutions |

### Orchestration and reporting

| Command | What it does |
|---|---|
| `/pm` | Same triage as `@pm`, invoked manually — for explicit orchestration on a list of tasks |
| `/recap` | Monday standup-style recap of last week's merged work |

### Meta

| Command | What it does |
|---|---|
| `/bootstrap` | Scaffold per-repo Claude OS structure in a new repo. Run once per project. |
| `/improve` | Promote durable patterns into `CLAUDE.md` or skills. Shows diff before applying. |

---

## House rules (from `CLAUDE.md`)

Highlights — the full `CLAUDE.md` is the source of truth.

- **Default behavior:** smallest correct change, no unnecessary abstraction, explicit over clever, minimal diffs.
- **Planning:** small changes → implement directly; multi-layer or architecture → short plan first; at most one clarification question.
- **Quality:** after changes, list what could break, suggest tests, suggest monitoring/rollback.
- **GitHub:** priority + type labels on every PR/issue; repo templates win over default bodies.
- **Deep review:** not the default — only large features, refactors, security- or performance-sensitive work.
- **Shipping recap:** plain-language recap after every PR or Vercel deploy.

---

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` with the frontmatter used by existing skills (`name`, `description`, `disable-model-invocation`, `allowed-tools`, `argument-hint`).
2. Body: short, structured — process steps, output format, stop condition. `skills/plan/SKILL.md` is the canonical minimal example.
3. Put rules that only matter for this skill inside it, not in `CLAUDE.md`.
4. Bump `version` in `.claude-plugin/plugin.json`, open a PR. Slack notification fires on merge.
5. Everyone runs `claude plugin update delivery@builders-camp`.

## Adding a new agent

1. Create `agents/<agent-name>.md` with frontmatter (`name`, `description`, `tools`, `model`, `maxTurns`, `memory`).
2. Body: execution guardrails, what you own, core behavior, decision principles, output contract, stop conditions.
3. Update `@pm`'s routing rules if it should be auto-routed to.
4. Bump the plugin version, PR, update.

---

## When to update what

| Change | Where |
|---|---|
| New always-on house rule | `CLAUDE.md` |
| Rule that only matters during one workflow | That skill's `SKILL.md` |
| New reusable workflow | New skill |
| New specialist role | New agent |
| Repo-specific stack, deploy steps, conventions | That repo's own `CLAUDE.md` / `.claude/` |
| One-off project decision | Not here — Notion or a repo ADR |

---

## Syncing GitHub workflows across repos (legacy)

`install.sh` also copies `.github/workflows/` to every repo listed in `.repos` (one path per line, `~/` allowed; missing repos are skipped), then prints the commit command for each. The plugin does not do this.

---

## Troubleshooting

**Plugin skills or agents don't show up.**
Run `claude plugin list` and check `delivery@builders-camp` is enabled, then restart Claude Code.

**Routing gate isn't applied.**
The SessionStart hook loads `CLAUDE.md`. Check the plugin is enabled in this project (`claude plugin enable delivery@builders-camp`).

**Everything appears twice.**
You have both `install.sh` symlinks and the plugin. Follow "Moving from `install.sh`".

**Slack notification didn't fire after a push.**
`.github/workflows/slack-notify.yml` runs on push to `main` only. Check the Actions tab for failures.
