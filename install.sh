#!/bin/bash
set -e

SYNC_WORKFLOWS=false
for arg in "$@"; do
  case "$arg" in
    --sync-workflows) SYNC_WORKFLOWS=true ;;
  esac
done

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

# Cleanup: remove dangling team symlinks and retired entries. Non-fatal.
# Only symlinks pointing into $REPO_DIR/ are ever removed; real files/dirs and
# symlinks pointing elsewhere are left alone.
for stale in "$CLAUDE_DIR/skills"/* "$CLAUDE_DIR/agents"/*; do
  if [ -L "$stale" ] && [ ! -e "$stale" ]; then
    stale_dest="$(readlink "$stale" 2>/dev/null || true)"
    case "$stale_dest" in
      "$REPO_DIR"/*)
        rm -f "$stale" 2>/dev/null || true
        echo "  removed dangling ${stale#$CLAUDE_DIR/}"
        ;;
    esac
  fi
done

if [ -f "$REPO_DIR/retired.txt" ]; then
  while IFS= read -r entry || [ -n "$entry" ]; do
    entry="${entry%$'\r'}"
    # Trim leading/trailing whitespace
    entry="${entry#"${entry%%[![:space:]]*}"}"
    entry="${entry%"${entry##*[![:space:]]}"}"
    case "$entry" in
      ""|\#*) continue ;;
      /*|*..*) continue ;;
    esac
    target="$CLAUDE_DIR/$entry"
    if [ -L "$target" ]; then
      retired_dest="$(readlink "$target" 2>/dev/null || true)"
      case "$retired_dest" in
        "$REPO_DIR"/*)
          rm -f "$target" 2>/dev/null || true
          echo "  retired $entry — removed"
          ;;
      esac
    elif [ -e "$target" ]; then
      echo "  Skipping retired $entry — personal version exists (remove manually if unwanted)"
    fi
  done < "$REPO_DIR/retired.txt" || true
fi

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

# Voices: symlink the whole dir (skipped if a personal non-symlink version exists)
if [ -d "$REPO_DIR/voices" ]; then
  target="$CLAUDE_DIR/voices"
  if [ -L "$target" ]; then
    rm "$target"
  fi
  if [ -e "$target" ]; then
    echo "  Skipping voices — personal version exists (remove manually to use shared)"
  else
    ln -sf "$REPO_DIR/voices" "$target"
    echo "  voices → symlinked"
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

# Hooks: settings.json (hooks only) + hook scripts
target="$CLAUDE_DIR/settings.json"
if [ -L "$target" ]; then
  rm "$target"
fi
if [ -e "$target" ]; then
  echo "  Skipping settings.json — personal version exists (merge the hooks manually)"
else
  ln -sf "$REPO_DIR/settings.json" "$target"
  echo "  settings.json → symlinked"
fi

if [ -d "$REPO_DIR/hooks" ]; then
  mkdir -p "$CLAUDE_DIR/hooks"
  for hook_file in "$REPO_DIR/hooks"/*.sh; do
    [ -f "$hook_file" ] || continue
    hook_name="$(basename "$hook_file")"
    target="$CLAUDE_DIR/hooks/$hook_name"
    if [ -L "$target" ]; then
      rm "$target"
    elif [ -e "$target" ]; then
      echo "  Skipping $hook_name — personal version exists (remove manually to use shared)"
      continue
    fi
    ln -sf "$hook_file" "$target"
    echo "  hook/$hook_name → symlinked"
  done
fi

echo ""
if [ "$SYNC_WORKFLOWS" != true ]; then
  echo "Skipping workflow sync (run ./install.sh --sync-workflows to copy .github/workflows into team repos)"
# Sync .github/workflows to repos listed in .repos
elif [ -f "$REPO_DIR/.repos" ]; then
  echo "Syncing .github/workflows to team repos..."
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
