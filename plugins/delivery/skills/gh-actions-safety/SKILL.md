---
name: gh-actions-safety
description: Safety rules for GitHub Actions workflows. Use when editing or adding files under .github/workflows/, or any workflow triggered by pull_request_target, issue_comment or workflow_run, or that handles PR-derived strings.
allowed-tools: Read, Glob, Grep
---

# gh-actions-safety

Follow when editing `.github/workflows/`.

- A workflow that holds a write token while handling a PR (`pull_request_target`, `issue_comment`, `workflow_run`) runs its logic from the base branch: check out the base SHA only, read PR files through the API as data, and never check out or execute PR-head code.
- Never interpolate PR-derived strings (filenames, titles, branch names, comment bodies) into a shell, `run:` or `script:` block. Pass them through `env:` and use `execFileSync`-style argument arrays, not `execSync` strings.
- A same-repo check (`head.repo.full_name == github.repository`) is required before any merge step, since fork PRs get a write token under `pull_request_target`.
