#!/bin/bash
# PreToolUse hook (Bash): ASK before a commit/push that lands on main or master.
# Never denies. Silent exit 0 when not triggered or on any parse error.
# Heuristic: splits the command on && || ; | newline and reads each segment loosely.
{
  input="$(cat)"

  if command -v jq >/dev/null 2>&1; then
    cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
    cwd="$(printf '%s' "$input" | jq -r '.cwd // empty')"
  else
    cmd="$(printf '%s' "$input" | sed -n -E 's/.*"command" *: *"(([^"\\]|\\.)*)".*/\1/p' | sed 's/\\"/"/g')"
    cwd="$(printf '%s' "$input" | sed -n -E 's/.*"cwd" *: *"([^"]*)".*/\1/p')"
  fi

  [ -n "$cmd" ] || exit 0
  [ -n "$cwd" ] || cwd="$PWD"

  is_main() { case "$1" in main|master|refs/heads/main|refs/heads/master) return 0 ;; esac; return 1; }
  unquote() { local s="${1#[\"\']}"; printf '%s' "${s%[\"\']}"; }
  abs() { case "$1" in /*) printf '%s' "$1" ;; *) printf '%s/%s' "$2" "$1" ;; esac; }
  on_main() {
    local b
    b="$(git -C "$1" rev-parse --abbrev-ref HEAD 2>/dev/null)" || return 1
    [ "$b" = "main" ] || [ "$b" = "master" ]
  }

  triggered=""
  curdir="$cwd"
  set -f
  segments="$(printf '%s' "$cmd" | sed 's/&&/;/g; s/||/;/g' | tr ';|' '\n\n')"
  while IFS= read -r seg; do
    read -r -a tok <<<"$seg"
    i=0
    # skip leading VAR=value assignments
    while [ $i -lt ${#tok[@]} ] && [[ "${tok[$i]}" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; do i=$((i+1)); done
    [ $i -lt ${#tok[@]} ] || continue
    word="${tok[$i]##*/}"

    if [ "$word" = "cd" ]; then
      [ $((i+1)) -lt ${#tok[@]} ] && curdir="$(abs "$(unquote "${tok[$((i+1))]}")" "$curdir")"
      continue
    fi
    [ "$word" = "git" ] || continue

    dir="$curdir"
    i=$((i+1))
    while [ $i -lt ${#tok[@]} ]; do
      t="${tok[$i]}"
      case "$t" in
        -C) i=$((i+1)); [ $i -lt ${#tok[@]} ] && dir="$(abs "$(unquote "${tok[$i]}")" "$curdir")" ;;
        -c) i=$((i+1)) ;;
        -*) ;;
        *) break ;;
      esac
      i=$((i+1))
    done
    [ $i -lt ${#tok[@]} ] || continue
    sub="${tok[$i]}"
    i=$((i+1))

    if [ "$sub" = "commit" ]; then
      on_main "$dir" && triggered="commit"
    elif [ "$sub" = "push" ]; then
      nonflags=()
      while [ $i -lt ${#tok[@]} ]; do
        case "${tok[$i]}" in -*) ;; *) nonflags+=("$(unquote "${tok[$i]}")") ;; esac
        i=$((i+1))
      done
      refs=("${nonflags[@]:1}")
      if [ ${#refs[@]} -eq 0 ]; then
        on_main "$dir" && triggered="push"
      else
        for r in "${refs[@]}"; do
          r="${r#+}"
          if is_main "$r" || is_main "${r##*:}"; then triggered="push"; fi
        done
      fi
    fi
    [ -z "$triggered" ] || break
  done <<<"$segments"

  [ -n "$triggered" ] || exit 0

  reason="This would $triggered directly to main. Work normally goes through a worktree branch and PR. Approve only for an explicit hotfix to main."
  [ "$triggered" = "commit" ] && reason="This would commit directly to main. Work normally goes through a worktree branch and PR. Approve only for an explicit hotfix to main."
  if command -v jq >/dev/null 2>&1; then
    jq -cn --arg r "$reason" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"ask",permissionDecisionReason:$r}}'
  else
    echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"This would commit or push directly to main. Work normally goes through a worktree branch and PR. Approve only for an explicit hotfix to main."}}'
  fi
} 2>/dev/null
exit 0
