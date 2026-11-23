---
name: ship-story
description: Turn a finished Claude Code session into a review-ready ship story (redacted notes, LinkedIn post drafts, a deterministic insights page, a how-to guide draft) in a draft PR. Only for projects that have a .claude/ship-story.md. Never posts or publishes.
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, Edit, mcp__claude-code-remote, Bash(gh api *), Bash(gh pr create *), Bash(gh pr edit *), Bash(gh pr view *), Bash(gh pr list *), Bash(git status *), Bash(git diff *), Bash(git log *), Bash(git config *), Bash(git fetch *), Bash(git switch *), Bash(git add *), Bash(git commit *), Bash(git push *), Bash(mktemp *), Bash(mkdir *), Bash(rm -rf *), Bash(node *), Bash(bash *)
argument-hint: "[session link | session title | none = this session] [--author=<handle>]"
---

# /ship-story

Read a finished session, redact it, and draft the story of what was built for human review. The workflow ends at "draft PR ready for review". Nothing is posted, published or deployed.

## Hard rules

- Only runs when the project has `.claude/ship-story.md`. If it is missing, say so and stop.
- Never post, publish, schedule, deploy, or open an approval or promotion PR.
- Never use a branch name or PR title pattern that the project config names as auto-merge. Use the `pr` pattern from config only.
- The PR is always a draft.
- No raw transcript, tool output or scratch file ever enters git, a PR body or a chat reply.
- No em or en dashes in anything written. Project copy rules apply to everything that is not the author's personal post.
- No GraphQL. Cloud sessions block it; use `gh api` REST only.

## 1. Resolve inputs

1. Session: a link or id, a title, or nothing (this session). For a title, call `list_sessions` with `mine: true` and match it. If two match, ask once.
2. Author, in order: `--author=<handle>`; the `authors:` map in `.claude/ship-story.md`; the local part of `git config user.email` matching a file in `~/.claude/voices/`; otherwise ask once. Never fall back to another author's voice.
3. Read `.claude/ship-story.md`. Required keys: `brand`, `copy_rules`, `review_queue`, `pr`, `guide.staging`, `cta`, `renderer`. Optional: `authors`, `company_tags`, `redaction_extra`, `lead_capture`, `guide.destination`. If a required key is missing, stop and ask once for it. Never default to any specific company's values.
4. Load the brand files, copy rules and voice file named above, before drafting anything.

## 2. Read the session into scratch

1. Create a scratch dir outside the repo (`mktemp -d`). Everything below goes there until redacted.
2. Page `list_events` with `kinds: ["user","assistant"]`, using `before_id` to walk back, and write `raw.jsonl` plus a `cursor` file after each page so an interrupted run resumes from the cursor. Tool output and file contents are excluded by `kinds`.
3. PRs and commits: `gh api` REST only (titles, merged_at, file names, diff stats). Use the public repo links, never private ones, in anything that leaves scratch.

## 3. Redact first

Redaction happens before any drafting, and drafting only reads redacted notes.

1. Regex pass over `raw.jsonl`: emails, JWTs (`eyJ...`), key and token prefixes (`sk_`, `ghp_`, `whsec_`, `AKIA`), UUIDs, IPv4 addresses, cloud project refs and API hostnames, payment IDs, internal hostnames, preview hosts, plus every pattern in `redaction_extra`.
2. Semantic pass by you: client, customer and member names, private member data, undisclosed partners, business metrics, anything that identifies a person who did not agree to appear.
3. Replace with typed placeholders: `[client]`, `[email]`, `[token]`, `[host]`, `[metric]`, `[person]`.
4. Long transcripts: windowed map-reduce. About 60 events per window, one notes block per window, then one merge pass. Never load the whole transcript in one prompt. Save the window index in scratch so the run resumes.

## 4. notes.md (quote-grounded)

Write `<review_queue>/notes.md` from redacted text only. Each note has: `id`, one-line claim, a verbatim quote of at most about 25 words with its event index, and `kind` (decision, mistake, constraint, trick, outcome, number). Every post line and every guide step must trace to a note id. No quote, no claim.

## 5. redaction-report.md

Counts only, never original strings: category, count, and the note ids where a replacement happened. List withheld business metrics by description ("signup count, post 2 line 3"), not by value. Withheld metrics stay out of every output until the author approves each one in chat. After approval, insert it, record the approval date in the report, and give it a `data-source` pointing at its note id.

## 6. Dedup against the build index

1. Read the build index at the path the project config names (`review_queue.index`), else `build-index.md` in the review queue root. Rows: build name, one-line description, story slug, date, post status. Migration: an old `angle-index.md`, or rows with an angle column, are read as build rows (the angle label is the build name).
2. Name the build(s) this story shipped. Default is one. Several only if the session shipped clearly separate builds.
3. Drop a build if it matches a `draft`, `approved` or `posted` row for the same author. If the story extends an already-posted build, keep only the new increment and name the earlier build in the post. For guides, also check existing guide titles and target queries.
4. State which builds were dropped or reduced to an increment, and why. Append dropped ones to the index with status `dropped`, and kept ones as `draft`. Never set `posted`; a human does.

## 7. Posts

Draft ONE build walkthrough per shipped story, in the author's voice: "here's what I built, and how". More posts only if the session shipped clearly separate builds: one post per build, never one per lesson.

Beats, in order:
1. Hook: what was built, concretely, in one or two lines.
2. The problem or trigger.
3. How: numbered steps in the order they happened. Each says what was done, which tool or agent did it, and how the author steered it (the instruction, where they pushed back, what they checked).
4. What it took: elapsed time, number of PRs and similar engineering numbers. Business metrics stay out unless the author approved them; list them as an open question.
5. You can do this too: the replicable steps in one or two lines, so a reader could repeat the build with their own tools.

Lessons are one-line remarks inside the relevant step, never standalone posts.

- Grounding: every step cites a note id. A step without a note is marked `[assumed, verify]` and listed as an open question. Never invent prompts, tool names or numbers.
- The voice file wins for the author's personal posts, including anything it explicitly allows that the project copy rules would otherwise ban. Project copy rules govern everything else (page text, guide, captions, PR text).
- One ask. Link goes in the first comment, not the body. Tag only handles in `company_tags`.
- Each post gets alt text for its media.
- Each post ends with an Asset section: upload the GIF as an image (LinkedIn plays it in the feed), or the carousel PDF for a carousel post. The MP4 is an optional alternative only.
- Write `posts/post-<n>.md`. Every line cites a note id in a comment line at the end of the file, not in the post body.

## 8. Insights page

Build one self-contained HTML file at `assets/insights.html`. Brand from the project's `brand` path (tokens, fonts, logo files untouched). Stage 1080x1350 (4:5).

Page contract:
- Normal open is interactive: keyboard and click next/back, progress, no autoplay, `prefers-reduced-motion` respected.
- `?render=1` hides controls and exposes `window.__duration` (seconds, 20 to 40), `window.__seek(t)` (async; resolves after layout and `document.fonts.ready`), and `window.__slides` (array of `t` values, one per carousel page).
- In render mode every animation is a pure function of `t`. No `setTimeout`, `setInterval`, `requestAnimationFrame`, `Date.now`, `performance.now` or randomness.
- `?captions=0` turns captions off for stills.
- Captions burned in, Montserrat or the brand heading font, 64px minimum, inside the safe zone. Write `transcript.md` with all narration.
- Same narrative as the post. Scenes in order: hook (what was built), the steps (one scene per step, up to 3 to 5), numbers (what it took), cta. Frame 1 legible at 180px wide.
- Every number carries `data-source="<note id>"`. A number without a note id and a redaction-report line does not render.
- Semantic markup: a `<section aria-label>` per scene, real headings, visually hidden text for numerals.

## 9. Render and lint

Run the commands from the config `renderer` key (render, then lint). Lint runs on the notes first, then on every final file. A lint hit blocks the PR step: fix the source, regenerate, re-run. Run the project's copy lint (the config's copy rules or guardrail script) on the review queue folder as well. Report frame size, duration, page count and file sizes.

The renderer produces an animated GIF as the primary LinkedIn asset, plus the carousel PDF. The MP4 is secondary. GIF expectations: loops forever, about 10 to 12 fps, 4:5, under 8 MB (aim for 3 to 5 MB). The renderer may offer a flag to skip the GIF. After render, check the GIF size, view a few extracted frames, and flag it if it exceeds 8 MB. JPG cannot animate, so GIF is the format for an image with motion. Commit binaries only within the size limits stated in config; otherwise leave them in scratch and list size plus the regeneration command in the README.

## 10. Guide draft

A general, tool-agnostic how-to that someone can follow without having seen the session. It follows the same build narrative: what was built, then the steps.

- Reader-query H1, the key number in the first answer, question-style H2s, at least 6 FAQ entries, one CTA in the final third (from the `cta` key, never invented).
- Every step traces to a note id. Replace project-specific names with generic equivalents.
- Write to `guide.staging` only. Front matter `published: false`, `review_status: draft`. Never write to `guide.destination` or any publish path.

## 11. Review README and PR

1. Write `README.md` in the story folder: summary, status table (post(s), page, GIF, MP4 (optional), carousel PDF, guide; status `draft`), post(s) with first line and alt text, assets with regeneration command, guide summary, redaction report link, checks run, an approvals table (reviewer, scope, decision, date), and an empty publish log.
2. Branch and title from the config `pr` key. Open a DRAFT PR (`gh pr create --draft`) with the body from the project's PR template via `--body-file`. If there is no template, use a short body: what was built, what to review, what was withheld.
3. Apply the labels the project requires.
4. Delete the scratch dir (`rm -rf`), including `raw.jsonl`, frames and cursors.

## Stop condition

Stop after the draft PR exists and scratch is deleted. Tell the author: what was produced, which builds were dropped or reduced to an increment, which metrics are still withheld and need approval, and that nothing was posted or published.
