#!/bin/bash
# Deploy RDLS Claude Code config into a target project
# Usage: bash deploy.sh /path/to/target-project
#
# This copies CLAUDE.md, commands, agents, and reference docs
# from ai-config into the target project's Claude Code locations.

set -e

TARGET="${1:?Usage: bash deploy.sh /path/to/target-project}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -d "$TARGET" ]; then
    echo "Error: Target directory does not exist: $TARGET"
    exit 1
fi

echo "Deploying RDLS Claude Code config to: $TARGET"

# Create .claude directories
mkdir -p "$TARGET/.claude/commands"
mkdir -p "$TARGET/.claude/agents"

# Deploy CLAUDE.md (project root)
cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
echo "  -> CLAUDE.md"

# Deploy reference docs into .claude/ (context for Claude Code)
cp "$SCRIPT_DIR/module-reference.md" "$TARGET/.claude/module-reference.md"
cp "$SCRIPT_DIR/constraints-reference.md" "$TARGET/.claude/constraints-reference.md"
cp "$SCRIPT_DIR/naming-reference.md" "$TARGET/.claude/naming-reference.md"
cp "$SCRIPT_DIR/signals-reference.md" "$TARGET/.claude/signals-reference.md"
echo "  -> .claude/*.md (reference docs)"

# Deploy commands
for cmd in "$SCRIPT_DIR/commands/"*.md; do
    cp "$cmd" "$TARGET/.claude/commands/"
    echo "  -> .claude/commands/$(basename "$cmd")"
done

# Deploy agents
for agent in "$SCRIPT_DIR/agents/"*.md; do
    cp "$agent" "$TARGET/.claude/agents/"
    echo "  -> .claude/agents/$(basename "$agent")"
done

echo ""
echo "Done. Deployed to $TARGET:"
echo "  - CLAUDE.md (project instructions)"
echo "  - .claude/commands/ ($(ls "$SCRIPT_DIR/commands/"*.md | wc -l) commands)"
echo "  - .claude/agents/ ($(ls "$SCRIPT_DIR/agents/"*.md | wc -l) agents)"
echo "  - .claude/*.md (4 reference docs)"
