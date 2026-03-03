# ai-config

Personal AI assistant configurations for climate, geospatial, agriculture, and data science workflows.

## Structure

```
ai-config/
├── claude-code/
│   ├── themes/                    # Reusable topic modules — mix & match across projects
│   │   ├── climate.md             # Climate science conventions & terminology
│   │   ├── geospatial.md         # GIS, spatial data, CRS, formats
│   │   ├── agriculture.md        # Agricultural data & food security
│   │   ├── datascience.md        # Python data science stack & patterns
│   │   ├── commands/              # Theme-level slash commands
│   │   └── agents/                # Theme-level sub-agents
│   └── projects/                  # Project-specific configs (portable)
│       └── rdls/                  # Risk Data Library Standard toolkit
│           ├── CLAUDE.md          # Project instructions
│           ├── constraints-reference.md
│           ├── naming-reference.md
│           ├── signals-reference.md
│           ├── module-reference.md
│           ├── commands/          # Project slash commands
│           ├── agents/            # Project sub-agents
│           └── deploy.sh          # Deploy script
└── references/                    # Notes, patterns, learnings
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

```bash
# Deploy RDLS config into your to-rdls project (or any RDLS project)
bash claude-code/projects/rdls/deploy.sh /path/to/to-rdls

# This copies:
#   CLAUDE.md            → /path/to/to-rdls/CLAUDE.md
#   commands/*.md        → /path/to/to-rdls/.claude/commands/
#   agents/*.md          → /path/to/to-rdls/.claude/agents/
#   *-reference.md       → /path/to/to-rdls/.claude/
```

Or copy manually:

```bash
cp claude-code/projects/rdls/CLAUDE.md /path/to/project/CLAUDE.md
cp -r claude-code/projects/rdls/commands/ /path/to/project/.claude/commands/
cp -r claude-code/projects/rdls/agents/ /path/to/project/.claude/agents/
```

Project folders can be moved to another machine or repo independently.

## Domain focus

- **Climate**: Hazard modeling, climate projections, risk assessment
- **Geospatial**: Raster/vector processing, CRS, spatial formats (GeoTIFF, NetCDF, GeoJSON, GeoPackage)
- **Agriculture**: Crop modeling, food security, agricultural exposure
- **Data Science**: Python scientific stack, notebooks, ETL pipelines, data validation
- **Risk Data (RDLS)**: GFDRR Risk Data Library Standard, HEVL components, source-independent metadata transformation
