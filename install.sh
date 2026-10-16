#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"

echo "Installing team Claude config from $REPO_DIR..."

# CLAUDE.md: replace with symlink (backs up existing)
if [ -e "$CLAUDE_DIR/CLAUDE.md" ] && [ ! -L "$CLAUDE_DIR/CLAUDE.md" ]; then
  echo "  Backing up CLAUDE.md → CLAUDE.md.bak"
  mv "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.bak"
elif [ -L "$CLAUDE_DIR/CLAUDE.md" ]; then
  rm "$CLAUDE_DIR/CLAUDE.md"
fi
ln -sf "$REPO_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "  CLAUDE.md → symlinked"

# Skills: symlink each skill individually (preserves personal skills)
mkdir -p "$CLAUDE_DIR/skills"
for skill_dir in "$REPO_DIR/skills"/*/; do
  skill_name="$(basename "$skill_dir")"
  target="$CLAUDE_DIR/skills/$skill_name"
  if [ -L "$target" ]; then
    rm "$target"
  elif [ -e "$target" ]; then
    echo "  Skipping $skill_name — personal version exists (remove manually to use shared)"
    continue
  fi
  ln -sf "$skill_dir" "$target"
  echo "  skill/$skill_name → symlinked"
done

# Agents: symlink each agent individually (preserves personal agents)
mkdir -p "$CLAUDE_DIR/agents"
for agent_file in "$REPO_DIR/agents"/*.md; do
  agent_name="$(basename "$agent_file")"
  target="$CLAUDE_DIR/agents/$agent_name"
  if [ -L "$target" ]; then
    rm "$target"
  elif [ -e "$target" ]; then
    echo "  Skipping $agent_name — personal version exists (remove manually to use shared)"
    continue
  fi
  ln -sf "$agent_file" "$target"
  echo "  agent/$agent_name → symlinked"
done

# Loops: symlink the whole dir (skipped if a personal non-symlink version exists)
if [ -d "$REPO_DIR/loops" ]; then
  target="$CLAUDE_DIR/loops"
  if [ -L "$target" ]; then
    rm "$target"
  fi
  if [ -e "$target" ]; then
    echo "  Skipping loops — personal version exists (remove manually to use shared)"
  else
    ln -sf "$REPO_DIR/loops" "$target"
    echo "  loops → symlinked"
  fi
fi

# Stacks: symlink each stack pack individually (preserves personal stacks)
if [ -d "$REPO_DIR/stacks" ]; then
  mkdir -p "$CLAUDE_DIR/stacks"
  for stack_dir in "$REPO_DIR/stacks"/*/; do
    [ -d "$stack_dir" ] || continue
    stack_name="$(basename "$stack_dir")"
    target="$CLAUDE_DIR/stacks/$stack_name"
    if [ -L "$target" ]; then
      rm "$target"
    elif [ -e "$target" ]; then
      echo "  Skipping $stack_name — personal version exists (remove manually to use shared)"
      continue
    fi
    ln -sf "${stack_dir%/}" "$target"
    echo "  stack/$stack_name → symlinked"
  done
fi

echo ""
echo "Syncing .github/workflows to team repos..."

# Sync .github/workflows to repos listed in .repos
if [ -f "$REPO_DIR/.repos" ]; then
  repos_to_sync=()
  while IFS= read -r repo_path || [ -n "$repo_path" ]; do
    # Skip empty lines and comments
    [[ -z "$repo_path" || "$repo_path" =~ ^# ]] && continue

    # Expand ~ to $HOME
    repo_path="${repo_path/#\~/$HOME}"

    if [ -d "$repo_path/.git" ]; then
      mkdir -p "$repo_path/.github/workflows"
      cp "$REPO_DIR/.github/workflows/"* "$repo_path/.github/workflows/" 2>/dev/null || true
      echo "  ✓ Synced to $(basename "$repo_path")"
      repos_to_sync+=("$repo_path")
    else
      echo "  ⊘ Skipped $(basename "$repo_path") — not found locally"
    fi
  done < "$REPO_DIR/.repos"

  if [ ${#repos_to_sync[@]} -gt 0 ]; then
    echo ""
    echo "Next: commit the synced workflows in each repo:"
    for repo_path in "${repos_to_sync[@]}"; do
      echo "  cd $repo_path && git add .github/workflows/ && git commit -m 'ci: sync workflows from team-claude-config'"
    done
  fi
else
  echo "  ⊘ No .repos file found — skipping workflow sync"
fi

echo ""
echo "Done. Run 'git pull && ./install.sh' to update shared config."
