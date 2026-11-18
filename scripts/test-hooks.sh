#!/bin/bash
# Feeds sample PreToolUse JSON to hooks/guard-main.sh and hooks/guard-prod-db.sh.
set -u
root="$(cd "$(dirname "$0")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

mk() { # dir branch
  git init -q -b main "$1"
  git -C "$1" config user.name t; git -C "$1" config user.email t@example.com
  git -C "$1" commit -q --allow-empty -m init
  [ "$2" = main ] || git -C "$1" checkout -q -b "$2"
}
mk "$tmp/onmain" main
mk "$tmp/onfeat" feature/x

pass=0; fail=0
check() { # hook expect(ask|none) cwd command
  local hook="$1" expect="$2" cwd="$3" cmd="$4" json out rc
  json="$(jq -n --arg c "$cmd" --arg d "$cwd" '{tool_name:"Bash",tool_input:{command:$c},cwd:$d}')"
  out="$(printf '%s' "$json" | "$root/hooks/$hook")"; rc=$?
  local ok=0
  if [ "$expect" = ask ]; then
    [ $rc -eq 0 ] && printf '%s' "$out" | jq -e . >/dev/null 2>&1 && [[ "$out" == *'"permissionDecision":"ask"'* ]] && ok=1
  else
    [ $rc -eq 0 ] && [ -z "$out" ] && ok=1
  fi
  if [ $ok -eq 1 ]; then pass=$((pass+1)); echo "PASS [$hook] $expect: $cmd"; else fail=$((fail+1)); echo "FAIL [$hook] $expect: $cmd (rc=$rc out=$out)"; fi
}
garbage() { # hook input label
  local out rc
  out="$(printf '%s' "$2" | "$root/hooks/$1")"; rc=$?
  if [ $rc -eq 0 ] && [ -z "$out" ]; then pass=$((pass+1)); echo "PASS [$1] garbage: $3"; else fail=$((fail+1)); echo "FAIL [$1] garbage: $3"; fi
}

M="$tmp/onmain"; F="$tmp/onfeat"
for c in 'git push origin main' 'git push origin HEAD:main' 'git push origin :main' 'git push origin master' \
         'git push' 'git commit -m x' 'cd x && git push origin main' "git -C $M commit -m x"; do
  check guard-main.sh ask "$M" "$c"
done
check guard-main.sh ask "$F" "git -C $M commit -m x"
for c in 'git push -u origin feature/main-fix' 'git push origin plugin-restructure-v2' 'git push' 'git commit -m x' \
         'git status' 'git log main' 'git checkout main'; do
  check guard-main.sh none "$F" "$c"
done
for c in 'supabase db push' 'supabase db push --linked' 'supabase db reset' 'supabase migration repair --status applied 1' \
         'psql $DB_URL -c "select 1"' 'PGPASSWORD=x psql -h h' '/usr/bin/psql -h h'; do
  check guard-prod-db.sh ask "$F" "$c"
done
for c in 'supabase migration list --linked' 'supabase db diff' 'supabase start' 'echo psql' 'grep psql file' 'ls'; do
  check guard-prod-db.sh none "$F" "$c"
done
for h in guard-main.sh guard-prod-db.sh; do
  garbage "$h" 'not json' 'not json'
  garbage "$h" '' 'empty stdin'
done

echo "---"; echo "passed: $pass, failed: $fail"
[ $fail -eq 0 ]
