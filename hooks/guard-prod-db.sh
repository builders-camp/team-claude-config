#!/bin/bash
# PreToolUse hook (Bash): ASK before commands that can change a production database.
# Never denies. Silent exit 0 when not triggered or on any parse error.
# Heuristic: command position only, per segment split on && || ; | newline.
{
  input="$(cat)"

  if command -v jq >/dev/null 2>&1; then
    cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
  else
    cmd="$(printf '%s' "$input" | sed -n -E 's/.*"command" *: *"(([^"\\]|\\.)*)".*/\1/p' | sed 's/\\"/"/g')"
  fi
  [ -n "$cmd" ] || exit 0

  matched=""
  set -f
  segments="$(printf '%s' "$cmd" | sed 's/&&/;/g; s/||/;/g' | tr ';|' '\n\n')"
  while IFS= read -r seg; do
    read -r -a tok <<<"$seg"
    i=0
    while [ $i -lt ${#tok[@]} ] && [[ "${tok[$i]}" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; do i=$((i+1)); done
    [ $i -lt ${#tok[@]} ] || continue
    word="${tok[$i]##*/}"
    if [ "$word" = "psql" ]; then
      matched="psql"
    elif [ "$word" = "supabase" ]; then
      args=()
      for ((j=i+1; j<${#tok[@]}; j++)); do
        case "${tok[$j]}" in -*) ;; *) args+=("${tok[$j]}") ;; esac
      done
      case "${args[0]} ${args[1]}" in
        "db push"|"db reset"|"migration repair") matched="supabase ${args[0]} ${args[1]}" ;;
      esac
    fi
    [ -z "$matched" ] || break
  done <<<"$segments"

  [ -n "$matched" ] || exit 0

  if command -v jq >/dev/null 2>&1; then
    jq -cn --arg r "\`$matched\` can change a production database. Confirm the target and get the user's explicit yes." \
      '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"ask",permissionDecisionReason:$r}}'
  else
    echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"This command can change a production database. Confirm the target and get the user'"'"'s explicit yes."}}'
  fi
} 2>/dev/null
exit 0
