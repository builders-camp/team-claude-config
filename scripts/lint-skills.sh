#!/usr/bin/env bash
# Lints plugins/*/skills/*/SKILL.md frontmatter, plugin JSON, hook scripts and README skill/agent counts
# (the delivery plugin in plugins/delivery, plus plugins/*/ for any skills they ship).
# Usage: scripts/lint-skills.sh   (run from anywhere)
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 1

errors=()

# Read a frontmatter key (first block between the leading --- lines).
fm_value() {
  awk -v key="$2" '
    NR == 1 && $0 != "---" { exit }
    NR > 1 && $0 == "---" { exit }
    NR > 1 && index($0, key ":") == 1 { sub("^" key ":[ \t]*", ""); print; exit }
  ' "$1"
}

lint_skill_dirs() {
for dir in "$@"; do
  [ -d "$dir" ] || continue
  name_dir="$(basename "$dir")"
  file="${dir}SKILL.md"
  if [ ! -f "$file" ]; then
    errors+=("$dir: missing SKILL.md")
    continue
  fi
  if [ "$(head -n 1 "$file")" != "---" ]; then
    errors+=("$file: missing frontmatter (first line must be ---)")
    continue
  fi
  fm_name="$(fm_value "$file" name | tr -d '\r' | sed 's/[[:space:]]*$//')"
  fm_desc="$(fm_value "$file" description | tr -d '\r' | sed 's/[[:space:]]*$//')"
  if [ "$fm_name" != "$name_dir" ]; then
    errors+=("$file: name '$fm_name' does not match directory '$name_dir'")
  fi
  if [ -z "$fm_desc" ]; then
    errors+=("$file: description is empty or missing")
  fi
done
}

lint_skill_dirs plugins/*/skills/*/

# Plugin and marketplace JSON must parse; hooks.json too.
for j in .claude-plugin/marketplace.json plugins/delivery/hooks/hooks.json plugins/*/.claude-plugin/plugin.json; do
  [ -f "$j" ] || { errors+=("$j: missing"); continue; }
  python3 -m json.tool "$j" >/dev/null 2>&1 || errors+=("$j: invalid JSON")
done

# Hook scripts must be executable.
for h in plugins/delivery/hooks/*.sh; do
  [ -x "$h" ] || errors+=("$h: not executable (chmod 755)")
done

# README counts, from a marker line like: <!-- counts: skills=14 agents=9 -->
actual_skills="$(ls -d plugins/delivery/skills/*/ | wc -l | tr -d ' ')"
actual_agents="$(ls plugins/delivery/agents/*.md | wc -l | tr -d ' ')"
marker="$(grep -E '<!-- counts: skills=[0-9]+ agents=[0-9]+ -->' README.md | head -n 1)"
if [ -z "$marker" ]; then
  errors+=("README.md: missing '<!-- counts: skills=N agents=N -->' line")
else
  readme_skills="$(echo "$marker" | sed -E 's/.*skills=([0-9]+).*/\1/')"
  readme_agents="$(echo "$marker" | sed -E 's/.*agents=([0-9]+).*/\1/')"
  [ "$readme_skills" = "$actual_skills" ] || errors+=("README.md: skills=$readme_skills but plugins/delivery/skills/ has $actual_skills")
  [ "$readme_agents" = "$actual_agents" ] || errors+=("README.md: agents=$readme_agents but plugins/delivery/agents/ has $actual_agents")
fi

# CLAUDE.md is printed by the SessionStart hook; output over 10,000 chars is cut to a 2,000-char preview.
claude_md_chars="$(wc -c < plugins/delivery/CLAUDE.md | tr -d ' ')"
if [ "$claude_md_chars" -gt 9000 ]; then
  errors+=("plugins/delivery/CLAUDE.md: $claude_md_chars characters exceeds the 9,000 cap (hook output limit is 10,000)")
fi

if [ "${#errors[@]}" -gt 0 ]; then
  echo "lint-skills: ${#errors[@]} problem(s) found:" >&2
  for e in "${errors[@]}"; do
    echo "  - $e" >&2
  done
  exit 1
fi

echo "lint-skills: OK ($actual_skills skills, $actual_agents agents)"
