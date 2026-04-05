# AI Configuration

**Benny Istanto**</br>
bistanto@worldbank.org

Personal AI assistant configurations for climate, geospatial, agriculture, and data science workflows.

> [!NOTE]
> This is a personal configuration tailored to my specific work context - climate risk, geospatial analysis, RDLS metadata, and the Python scientific stack. The domain knowledge, coding conventions, and tool choices reflect my workflow and may not be suitable for other users. Feel free to browse for ideas, but please adapt to your own needs rather than using as-is.

## Structure

```
ai-config/
├── claude-code/
│   ├── themes/                    # Reusable topic modules - mix & match across projects
│   │   ├── climate.md             # Climate science conventions & terminology
│   │   ├── geospatial.md         # GIS, spatial data, CRS, formats
│   │   ├── agriculture.md        # Agricultural data & food security
│   │   ├── datascience.md        # Python data science stack & patterns
│   │   ├── commands/              # Theme-level slash commands (4)
│   │   └── agents/                # Theme-level sub-agents (3)
│   └── projects/                  # Project-specific configs (portable)
│       └── rdls/                  # Risk Data Library Standard toolkit
│           ├── README.md          # RDLS config overview & deploy guide
│           ├── CLAUDE.md          # Project instructions (20 modules, pipeline, codelists)
│           ├── *-reference.md     # 6 reference docs (module, schema, constraints, naming, signals, configs)
│           ├── commands/          # 13 slash commands
│           ├── agents/            # 6 sub-agents
│           ├── deploy.sh          # Deploy script (bash)
│           └── deploy.ps1         # Deploy script (PowerShell)
└── references/                    # Notes, patterns, learnings
    └── setup-guide.md             # How to use ai-config with projects
```

## How to use

### Themes (composable)

Theme files contain domain knowledge. Include relevant sections in your project's `CLAUDE.md`:

```markdown
<!-- In your project's CLAUDE.md -->
## Domain context
<!-- Copy relevant sections from themes/climate.md, themes/geospatial.md, etc. -->
```

Copy theme commands/agents into your project:

```bash
cp claude-code/themes/commands/data-profile.md /path/to/project/.claude/commands/
cp claude-code/themes/agents/data-analyst.md /path/to/project/.claude/agents/
```

### Projects (portable)

Each project folder is self-contained. Use the deploy script to set up a target project:

```powershell
# PowerShell (Windows)
.\claude-code\projects\rdls\deploy.ps1 -Target C:\path\to\to-rdls

# Bash / Git Bash
bash claude-code/projects/rdls/deploy.sh /path/to/to-rdls
```

This copies:
- `CLAUDE.md` → project root
- `commands/*.md` → `.claude/commands/`
- `agents/*.md` → `.claude/agents/`
- `*-reference.md` → `.claude/`

Project folders can be moved to another machine or repo independently.

### Cross-repo sync

ai-config is the **source of truth** for Claude Code configs. The workflow:

1. **Edit** commands, agents, reference docs here in ai-config
2. **Deploy** to target projects using the deploy scripts
3. **Local files** in target repos (`rules.local.md`, `settings.local.json`) are never overwritten

Currently deployed to:
- **to-rdls** (`C:\Users\benny\OneDrive\Documents\Github\to-rdls`) - 13 commands, 6 agents, 6 reference docs

## Connected repositories

| Repo | Purpose | Config relationship |
|------|---------|-------------------|
| [hdx-metadata-crawler](../hdx-metadata-crawler) | HDX-specific notebook pipeline (Notebooks 01-13) | No Claude Code config yet (notebook-based, standalone) |
| [to-rdls](../to-rdls) | Modular RDLS toolkit (`src/` modules + configs) | **Deployed from ai-config** - CLAUDE.md, commands, agents, refs |
| [ai-config](.) | Claude Code configurations (this repo) | Source of truth for all Claude Code configs |

## Domain focus

- **Climate**: Hazard modeling, climate projections, risk assessment
- **Geospatial**: Raster/vector processing, CRS, spatial formats (GeoTIFF, NetCDF, GeoJSON, GeoPackage)
- **Agriculture**: Crop modeling, food security, agricultural exposure
- **Data Science**: Python scientific stack, notebooks, ETL pipelines, data validation
- **Risk Data (RDLS)**: GFDRR Risk Data Library Standard, HEVL components, source-independent metadata transformation

## What's excluded (via .gitignore)

- `.claude/` - Claude Code local state (settings, plans)
- `HANDOFF.md` - Session continuity file (ephemeral)
- `temp/` - Scratch files and drafts
