#!/bin/bash
# UserPromptSubmit hook: re-inject the ROUTING GATE reminder. Always exits 0.
cat <<'EOF'
ROUTING GATE (every new user task): before your first Edit/Write/Bash/Agent(non-pm) call, either
(a) invoke Agent(subagent_type=pm) (delivery:pm when installed as the plugin) first and execute its Handoff directive in the same turn, or
(b) output the literal line at the top of your reply: Routing: skip — reason: <pure conversation | clarifying my own prior output | inside active workflow | read-only check>
"read-only check" means nothing is changed this turn. No other skip reasons are valid. "Task feels small" is not a valid skip.
EOF
exit 0
