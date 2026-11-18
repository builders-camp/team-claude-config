# Issues to open (from the plugin restructure)

Not fixed in code. Format: Title / Why / Suggested labels (priority + type). Delete this file once the issues exist.

## 1. CLAUDE.md exceeded the 10k-character hook output cap (resolved)
- **Why:** The `SessionStart` hook prints `CLAUDE.md`; it was 17,398 characters and Claude Code caps hook output at about 10,000. Resolved by the split: `CLAUDE.md` is now a short core, detail moved to `agents/pm.md` and the `implement`, `github-hygiene` and `gh-actions-safety` skills. Guarded by `scripts/lint-skills.sh` (9,000-character cap). Not verified in a live session; hook-injected context is still weaker than native memory (no `@imports`).
- **Labels:** none needed; delete once the split is merged.

## 2. Routing-gate and slash-command namespacing audit
- **Why:** Plugin components are namespaced (`/delivery:plan`, `delivery:pm`). Agent and skill text still says `/plan`, `/deploy`, `@pm`, `subagent_type=pm` (about 14 slash-command references and 61 `@pm` / `subagent_type` mentions). Only the warn hook, reminder and CLAUDE.md routing line were updated. The `/implement` handoff text and `@pm` handoff directives (`INVOKE @implementer`) should be checked for the plugin form.
- **Labels:** P2-medium, bug

## 3. `.repos` and workflow sync have no plugin equivalent
- **Why:** `.repos` fed `install.sh --sync-workflows`, which copied `.github/workflows/` into team repos. The script is retired. `.repos` is left in place. Decide: a small standalone script, a reusable workflow, or drop the sync.
- **Labels:** P2-medium, enhancement

## 4. Hidden consumers of `retired.txt`
- **Why:** `retired.txt` said it was also read by "project session-start hooks (cloud)" in other repos. Those hooks may now fail or leave retired `skills/pm` in place. Grep the team repos' `.claude/` settings and hooks for `retired.txt`, `install.sh` and `team-claude-config`. Also check the three paths in `.repos` for hardcoded `~/.claude/{skills,agents,stacks,loops}` references.
- **Labels:** P1-high, bug

## 5. Stack skill is on-demand, not always-on
- **Why:** The old `@~/.claude/stacks/...` import put the Supabase rules in context every session. `stack-supabase-vercel` loads only when Claude decides the description matches (or `/merge` loads it). The migration-timestamp collision rule could be missed. Alternative (Option A): the `SessionStart` hook greps the project's CLAUDE.md for `Stack: <name>` and prints the matching `skills/stack-<name>/SKILL.md` body, giving always-on behaviour with the same opt-in line.
- **Labels:** P2-medium, enhancement

## 6. `${CLAUDE_PLUGIN_ROOT}` in agent bodies is unverified
- **Why:** `agents/reviewer.md` references `${CLAUDE_PLUGIN_ROOT}/loops/FIX_ITEM.md`. The docs disagree on whether the variable is substituted in agent bodies. A one-line inline summary of the contract is included as a fallback. Verify in a live session, then drop the fallback or the variable.
- **Labels:** P3-low, question

## 7. Version pinning and the update flow
- **Why:** Both `plugin.json` files omit `version`, so the git SHA versions the plugin and every commit to `main` is an update (setting a version would pin users until bumped). `claude plugin validate` warns about the missing version. Decide whether to keep SHA versioning, and how people get told about updates (Slack message now says `claude plugin marketplace update` + `claude plugin update`). Marketplace auto-update setting is per user.
- **Labels:** P2-medium, question

## 8. PR #16 removed the subagent pre-authorization line
- **Why:** #16 deleted the "Standing request: subagent use is pre-authorized" bullet and the Worktrees and Supabase sections from `CLAUDE.md`. This restructure keeps them (out of scope); the worktree and Actions detail now lives in the `implement` and `gh-actions-safety` skills. Decide on the line separately, and close #16 as superseded.
- **Labels:** P2-medium, question

## 9. slack-notify wording and path coverage
- **Why:** The workflow's change summary now lists `.claude-plugin/*` instead of `install.sh`, and the update command is `claude plugin marketplace update builders-camp && claude plugin update delivery@builders-camp`. It still does not summarise `hooks/`, `loops/` or `plugins/` changes, and the shell block interpolates `${{ steps.changes.outputs.summary }}` directly (see the `gh-actions-safety` skill: pass through `env:`).
- **Labels:** P3-low, enhancement

## 10. team-os is a placeholder
- **Why:** `plugins/team-os` ships no skills. The Notion-backed ops skills (newsletter, outreach, mentors, Cheque-Formacao, end-of-day review) currently live as personal or Cowork skills. Decide which move in.
- **Labels:** P3-low, enhancement

## 11. `lint-skills.sh` was broken on macOS
- **Why:** `sed 's/[ \t]*$//'` strips trailing `t` characters on BSD sed, so the lint failed locally on `ost`, `test` and `implement`. Fixed here with `[[:space:]]` (a small in-scope change so lint passes locally). Noted for review.
- **Labels:** P3-low, bug

## 12. No CI check for `claude plugin validate`
- **Why:** The lint script checks JSON parsing, hook modes and counts, but not full plugin validation. Add the CLI to CI if it can be installed there.
- **Labels:** P3-low, enhancement

## 13. Rules that are prompt-only and need a wall
Moving rules into skills does not enforce them. Each item below is advice Claude can ignore until a hook, branch protection or CI check backs it.

### 13a. Block pushes to `main`
- **Why:** "Never commit or push to main" is prompt-only. Add branch protection on `main` plus a `PreToolUse` hook that blocks `git push` to `main`/`master` unless the user said "commit to main" or "hotfix to main".
- **Status:** hook done in #24; branch protection on `main` still pending (repo admin).
- **Labels:** P1-high, enhancement

### 13b. Approval hook for production DB writes
- **Why:** The explicit-"yes" production-data rule is prompt-only. Add a hook that forces approval on `supabase db push` and `psql` against prod.
- **Status:** done in #24.
- **Labels:** P1-high, enhancement

### 13c. CI linter for PR-derived string interpolation
- **Why:** The `gh-actions-safety` rule (no PR-derived strings in `run:` / `script:`) is prompt-only. Add a workflow linter that fails on `${{ github.event.pull_request.* }}`-style interpolation in shell blocks (see also item 9).
- **Labels:** P2-medium, enhancement

### 13d. Label-check workflow
- **Why:** The two-label rule (priority + type) only covers PRs and issues created through Claude Code. Add a workflow that checks every PR and issue has one priority and one type label.
- **Labels:** P3-low, enhancement

## 14. Tag rules by type and keep an incident log
- **Why:** Tag each rule as world (facts about the environment), taste (house preference) or model-patch (compensates for a model weakness), and log the incident behind each rule. Model-patch rules can then be retired as models improve.
- **Labels:** P3-low, enhancement

## 15. Add a harness-assistant skill to delivery
- **Why:** A skill that helps people tune the harness itself (hooks, settings, plugin structure) could live in `delivery` later. Not needed now.
- **Labels:** P3-low, enhancement
