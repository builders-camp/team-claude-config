#!/usr/bin/env bash
# Maintainer tool (not part of the plugin install): copy this repo's
# .github/workflows/* into the repos listed in .repos.
# Dry run by default. Never commits, pushes or switches branches.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
SRC="$ROOT/.github/workflows"
REPOS_FILE="$ROOT/.repos"
APPLY=false

usage() {
  echo "Usage: scripts/sync-workflows.sh [--apply] [--repos-file <path>]"
  echo "  Default is a dry run. --apply copies the files."
}

while [ $# -gt 0 ]; do
  case "$1" in
    --apply) APPLY=true; shift ;;
    --repos-file)
      [ $# -ge 2 ] || { echo "--repos-file needs a path" >&2; exit 2; }
      REPOS_FILE="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

[ -d "$SRC" ] || { echo "No source workflows at $SRC" >&2; exit 1; }
[ -f "$REPOS_FILE" ] || { echo "Repos file not found: $REPOS_FILE" >&2; exit 1; }

if [ "$APPLY" = true ]; then echo "Mode: APPLY"; else echo "Mode: dry run (use --apply to copy)"; fi

changed_repos=()
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in ''|\#*) continue ;; esac
  repo="${line/#\~/$HOME}"
  name="$(basename "$repo")"

  if [ ! -d "$repo/.git" ]; then
    echo "SKIP $name: not found or not a git repo ($repo)"
    continue
  fi
  if [ "$(cd "$repo" && pwd -P)" = "$ROOT" ]; then
    echo "SKIP $name: this is the source repo"
    continue
  fi
  if [ -n "$(git -C "$repo" status --porcelain -- .github/workflows)" ]; then
    echo "SKIP $name: uncommitted changes in .github/workflows"
    continue
  fi

  dest="$repo/.github/workflows"
  n=0
  for f in "$SRC"/*; do
    [ -f "$f" ] || continue
    base="$(basename "$f")"
    if [ ! -e "$dest/$base" ]; then
      status="add"
    elif ! diff -q "$f" "$dest/$base" >/dev/null; then
      status="change"
    else
      continue
    fi
    n=$((n + 1))
    if [ "$APPLY" = true ]; then
      mkdir -p "$dest"
      cp "$f" "$dest/$base"
      echo "  $name: $status $base (copied)"
    else
      echo "  $name: would $status $base"
    fi
  done

  if [ "$n" -eq 0 ]; then
    echo "OK   $name: already in sync"
  else
    changed_repos+=("$repo")
  fi
done < "$REPOS_FILE"

if [ "$APPLY" = true ] && [ ${#changed_repos[@]} -gt 0 ]; then
  echo ""
  echo "Next: review and commit in each repo (this script does not commit):"
  for repo in "${changed_repos[@]}"; do
    echo "  cd \"$repo\" && git add .github/workflows/ && git commit -m 'ci: sync workflows from team-claude-config'"
  done
fi
