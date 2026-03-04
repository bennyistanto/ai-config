# AI configuration

**Benny Istanto**</br>
bistanto@worldbank.org

Personal AI assistant configurations for climate, geospatial, agriculture, and data science workflows.

> [!NOTE] 
> This is a personal configuration tailored to my specific work context - climate risk, geospatial analysis, RDLS metadata, and the Python scientific stack. The domain knowledge, coding conventions, and tool choices reflect my workflow and may not be suitable for other users. Feel free to browse for ideas, but please adapt to your own needs rather than using as-is.

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
│           ├── README.md          # RDLS config overview & deploy guide
│           ├── CLAUDE.md          # Project instructions
│           ├── module-reference.md
│           ├── schema-reference.md
│           ├── constraints-reference.md
│           ├── naming-reference.md
│           ├── signals-reference.md
│           ├── configs-detail-reference.md
│           ├── commands/          # 8 slash commands
│           ├── agents/            # 5 sub-agents
│           ├── deploy.sh          # Deploy script (bash)
│           └── deploy.ps1         # Deploy script (PowerShell)
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

Or copy manually:

```powershell
Copy-Item claude-code\projects\rdls\CLAUDE.md C:\path\to\project\CLAUDE.md
Copy-Item claude-code\projects\rdls\commands\*.md C:\path\to\project\.claude\commands\
Copy-Item claude-code\projects\rdls\agents\*.md C:\path\to\project\.claude\agents\
```

Project folders can be moved to another machine or repo independently.

## Domain focus

- **Climate**: Hazard modeling, climate projections, risk assessment
- **Geospatial**: Raster/vector processing, CRS, spatial formats (GeoTIFF, NetCDF, GeoJSON, GeoPackage)
- **Agriculture**: Crop modeling, food security, agricultural exposure
- **Data Science**: Python scientific stack, notebooks, ETL pipelines, data validation
- **Risk Data (RDLS)**: GFDRR Risk Data Library Standard, HEVL components, source-independent metadata transformation
