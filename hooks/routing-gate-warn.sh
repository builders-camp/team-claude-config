#!/bin/bash
# PreToolUse hook: WARN ONLY (never blocks). Always exits 0, silent on any error.
# Warns once per session if the transcript shows no @pm routing or Routing: skip line.
{
  input="$(cat)"

  if command -v jq >/dev/null 2>&1; then
    transcript="$(printf '%s' "$input" | jq -r '.transcript_path // empty')"
    session="$(printf '%s' "$input" | jq -r '.session_id // empty')"
  else
    transcript="$(printf '%s' "$input" | sed -n 's/.*"transcript_path" *: *"\([^"]*\)".*/\1/p')"
    session="$(printf '%s' "$input" | sed -n 's/.*"session_id" *: *"\([^"]*\)".*/\1/p')"
  fi

  [ -n "$session" ] || exit 0
  [ -n "$transcript" ] && [ -f "$transcript" ] || exit 0

  marker="/tmp/routing-gate-warned-$session"
  [ -e "$marker" ] && exit 0

  if tail -n 200 "$transcript" | grep -Eq '"subagent_type" *: *"pm"|Routing: skip — reason:'; then
    exit 0
  fi

  touch "$marker"
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"ROUTING GATE: route this task via @pm first, or state Routing: skip — reason: <one of the 4 valid reasons>."}}'
} 2>/dev/null
exit 0
