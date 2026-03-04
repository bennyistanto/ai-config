# Setup Guide - Using ai-config with your projects

## How Claude Code configuration works

Claude Code reads configuration from these locations (in priority order):

1. **Global**: `~/.claude/CLAUDE.md` - applies to ALL projects
2. **Project**: `<project-root>/CLAUDE.md` - project-specific instructions
3. **Commands**: `<project-root>/.claude/commands/*.md` - slash commands (e.g., `/data-profile`)
4. **Agents**: `<project-root>/.claude/agents/*.md` - sub-agents for delegation
5. **Skills**: `<project-root>/.claude/skills/*.md` - reusable workflows

## Setting up a new project

### Step 1: Compose your CLAUDE.md

Pick relevant theme modules and combine them into your project's CLAUDE.md:

```markdown
# My Project - Claude Code Instructions

## Project overview
<!-- Your project description here -->

## Domain context
<!-- Paste relevant sections from themes/climate.md, themes/geospatial.md, etc. -->
<!-- Only include what's relevant - keep CLAUDE.md under 150 lines -->

## Coding conventions
<!-- Paste from themes/datascience.md or customize -->
```

### Step 2: Copy commands you need

```bash
# Create the .claude directory in your project
mkdir -p /path/to/project/.claude/commands
mkdir -p /path/to/project/.claude/agents

# Copy theme commands
cp ai-config/claude-code/themes/commands/data-profile.md /path/to/project/.claude/commands/
cp ai-config/claude-code/themes/commands/spatial-check.md /path/to/project/.claude/commands/

# For RDLS projects, also copy project-specific commands
cp ai-config/claude-code/projects/rdls/commands/*.md /path/to/project/.claude/commands/
```

### Step 3: Copy agents you need

```bash
cp ai-config/claude-code/themes/agents/data-analyst.md /path/to/project/.claude/agents/
cp ai-config/claude-code/projects/rdls/agents/rdls-expert.md /path/to/project/.claude/agents/
```

## For RDLS projects specifically

```bash
# Copy the RDLS CLAUDE.md as your project CLAUDE.md
cp ai-config/claude-code/projects/rdls/CLAUDE.md /path/to/rdls-project/CLAUDE.md

# Copy all RDLS commands and agents
cp -r ai-config/claude-code/projects/rdls/commands/ /path/to/rdls-project/.claude/commands/
cp -r ai-config/claude-code/projects/rdls/agents/ /path/to/rdls-project/.claude/agents/
```

## Tips

- **Keep CLAUDE.md concise**: Under 150 lines. Long files degrade Claude's attention.
- **Be specific**: "Use geopandas for vector data" is better than "use appropriate libraries"
- **Commands are discoverable**: Users can type `/` in Claude Code to see available commands
- **Agents are automatic**: Claude Code will delegate to agents when the task matches their description
- **Iterate**: Update configs based on what works in practice. Remove what doesn't help.
