#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Installing team Claude config from $REPO_DIR..."

# Backup existing files if they exist and aren't already symlinks
backup() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "  Backing up $target → $target.bak"
    mv "$target" "$target.bak"
  elif [ -L "$target" ]; then
    echo "  Removing existing symlink $target"
    rm "$target"
  fi
}

backup "$CLAUDE_DIR/CLAUDE.md"
backup "$CLAUDE_DIR/skills"
backup "$CLAUDE_DIR/agents"

# Create symlinks
ln -sf "$REPO_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
ln -sf "$REPO_DIR/skills"    "$CLAUDE_DIR/skills"
ln -sf "$REPO_DIR/agents"    "$CLAUDE_DIR/agents"

echo "Done. Symlinks created:"
ls -la "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/skills" "$CLAUDE_DIR/agents"
