#!/usr/bin/env bash
# Lints skills/*/SKILL.md frontmatter and README skill/agent counts.
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

for dir in skills/*/; do
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
  fm_name="$(fm_value "$file" name | tr -d '\r' | sed 's/[ \t]*$//')"
  fm_desc="$(fm_value "$file" description | tr -d '\r' | sed 's/[ \t]*$//')"
  if [ "$fm_name" != "$name_dir" ]; then
    errors+=("$file: name '$fm_name' does not match directory '$name_dir'")
  fi
  if [ -z "$fm_desc" ]; then
    errors+=("$file: description is empty or missing")
  fi
done

# README counts, from a marker line like: <!-- counts: skills=14 agents=9 -->
actual_skills="$(ls skills | wc -l | tr -d ' ')"
actual_agents="$(ls agents/*.md | wc -l | tr -d ' ')"
marker="$(grep -E '<!-- counts: skills=[0-9]+ agents=[0-9]+ -->' README.md | head -n 1)"
if [ -z "$marker" ]; then
  errors+=("README.md: missing '<!-- counts: skills=N agents=N -->' line")
else
  readme_skills="$(echo "$marker" | sed -E 's/.*skills=([0-9]+).*/\1/')"
  readme_agents="$(echo "$marker" | sed -E 's/.*agents=([0-9]+).*/\1/')"
  [ "$readme_skills" = "$actual_skills" ] || errors+=("README.md: skills=$readme_skills but skills/ has $actual_skills")
  [ "$readme_agents" = "$actual_agents" ] || errors+=("README.md: agents=$readme_agents but agents/ has $actual_agents")
fi

if [ "${#errors[@]}" -gt 0 ]; then
  echo "lint-skills: ${#errors[@]} problem(s) found:" >&2
  for e in "${errors[@]}"; do
    echo "  - $e" >&2
  done
  exit 1
fi

echo "lint-skills: OK ($actual_skills skills, $actual_agents agents)"
