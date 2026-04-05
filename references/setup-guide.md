# Setup Guide - Using ai-config with your projects

## How Claude Code configuration works

Claude Code reads configuration from these locations (in priority order):

1. **Global**: `~/.claude/CLAUDE.md` - applies to ALL projects
2. **Project**: `<project-root>/CLAUDE.md` - project-specific instructions
3. **Rules**: `<project-root>/.claude/rules.local.md` - local rules (never deployed, never committed)
4. **Commands**: `<project-root>/.claude/commands/*.md` - slash commands (e.g., `/rdls-validate`)
5. **Agents**: `<project-root>/.claude/agents/*.md` - sub-agents for delegation
6. **Reference docs**: `<project-root>/.claude/*.md` - on-demand context for Claude

## Deploying to a project

### RDLS projects (automated)

Use the deploy scripts - they handle everything:

```powershell
# PowerShell (Windows)
.\claude-code\projects\rdls\deploy.ps1 -Target C:\path\to\to-rdls

# Bash / Git Bash
bash claude-code/projects/rdls/deploy.sh /path/to/to-rdls
```

What gets deployed:
- `CLAUDE.md` → project root (project instructions, architecture, codelists)
- `*-reference.md` (6 files) → `.claude/` (module, schema, constraints, naming, signals, configs)
- `commands/*.md` (13 files) → `.claude/commands/`
- `agents/*.md` (6 files) → `.claude/agents/`

What is **never** overwritten:
- `.claude/rules.local.md` - project-specific runtime lessons
- `.claude/settings.local.json` - accumulated permissions

### Other projects (manual)

Pick relevant theme modules and combine:

```bash
# Create the .claude directory in your project
mkdir -p /path/to/project/.claude/commands
mkdir -p /path/to/project/.claude/agents

# Copy theme commands
cp ai-config/claude-code/themes/commands/data-profile.md /path/to/project/.claude/commands/
cp ai-config/claude-code/themes/commands/spatial-check.md /path/to/project/.claude/commands/

# Copy theme agents
cp ai-config/claude-code/themes/agents/data-analyst.md /path/to/project/.claude/agents/
```

### Composing a CLAUDE.md from themes

```markdown
# My Project - Claude Code Instructions

## Project overview
<!-- Your project description here -->

## Domain context
<!-- Paste relevant sections from themes/climate.md, themes/geospatial.md, etc. -->
<!-- Only include what's relevant - keep CLAUDE.md under 200 lines -->

## Coding conventions
<!-- Paste from themes/datascience.md or customize -->
```

## Cross-repo sync workflow

ai-config is the **source of truth** for Claude Code configs:

```
ai-config (edit here)
    ↓ deploy.sh / deploy.ps1
to-rdls (deployed configs)
    + rules.local.md (local-only, never overwritten)
    + settings.local.json (local-only, never overwritten)
```

**Rules:**
1. Edit commands, agents, reference docs in **ai-config first**
2. Run deploy to push changes to target projects
3. Never edit deployed files in-place (they'll be overwritten on next deploy)
4. Project-specific runtime lessons go in `rules.local.md` (local, not deployed)

## Tips

- **Keep CLAUDE.md concise**: Under 200 lines. Long files degrade Claude's attention. Put details in reference docs.
- **Be specific**: "Use geopandas for vector data" is better than "use appropriate libraries"
- **Commands are discoverable**: Users can type `/` in Claude Code to see available commands
- **Agents are automatic**: Claude Code will delegate to agents when the task matches their description
- **Reference docs are on-demand**: Claude reads them from `.claude/` only when needed - no token cost when unused
- **Iterate**: Update configs based on what works in practice. Remove what doesn't help.
