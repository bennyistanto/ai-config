# RDLS Project Config

**Benny Istanto**</br>
Risk Data Librarian/GFDRR/The World Bank Group

---

Claude Code configuration for the **to-rdls** toolkit - a source-independent Python toolkit for transforming dataset metadata from any data catalog into [RDLS v0.3](https://docs.riskdatalibrary.org/) (Risk Data Library Standard) schema.

## What this contains

| File | Purpose | Deployed to |
|------|---------|-------------|
| `CLAUDE.md` | Project instructions - architecture, data flow, codelists, constraints, conventions | Project root |
| `module-reference.md` | Complete API reference - all 14 modules, dataclasses, constants, internals | `.claude/` |
| `schema-reference.md` | RDLS v0.3 JSON Schema structures - all $defs objects with field details | `.claude/` |
| `constraints-reference.md` | Constraint tables - valid triplets, function types, loss signals, impact metrics | `.claude/` |
| `naming-reference.md` | ID generation - format, component codes, slug rules, collision handling | `.claude/` |
| `signals-reference.md` | Signal dictionary - hazard/exposure patterns, exclusions, tag weights | `.claude/` |
| `configs-detail-reference.md` | Config details - format mapping, spatial regions, DesInventar mapping, OSM detection | `.claude/` |
| `commands/*.md` | 8 slash commands for common RDLS tasks | `.claude/commands/` |
| `agents/*.md` | 5 sub-agents for specialized RDLS workflows | `.claude/agents/` |
| `deploy.sh` | Deploy script (bash/Git Bash) | — |
| `deploy.ps1` | Deploy script (PowerShell/Windows) | — |

## Slash commands

| Command | Description |
|---------|-------------|
| `/rdls-validate` | Validate records against RDLS v0.3 schema |
| `/rdls-translate` | Build base RDLS record from source metadata |
| `/rdls-classify` | Classify dataset into HEVL components |
| `/rdls-debug-record` | Diagnose validation errors in a record |
| `/rdls-add-pattern` | Add new extraction pattern to signal dictionary |
| `/rdls-add-source` | Scaffold a new source adapter |
| `/rdls-inspect-config` | Inspect and explain config file contents |
| `/rdls-review-folder` | Full workflow: inventory → inspect → classify → review → draft metadata |

## Sub-agents

| Agent | Description |
|-------|-------------|
| `rdls-expert` | Deep RDLS schema knowledge - answers schema and codelist questions |
| `hevl-extractor` | Analyzes metadata text to extract Hazard, Exposure, Vulnerability, Loss components |
| `pipeline-debugger` | Diagnoses pipeline failures - traces data flow across modules |
| `config-manager` | Reviews and modifies YAML configs - validates consistency |
| `data-reviewer` | Inspects deliverable files, classifies by HEVL, identifies metadata gaps |

## Deploy to a project

**PowerShell (Windows):**
```powershell
.\deploy.ps1 -Target C:\path\to\to-rdls
```

**Bash / Git Bash:**
```bash
bash deploy.sh /path/to/to-rdls
```

Both scripts copy the same files:
- `CLAUDE.md` → project root
- `*-reference.md` (6) → `.claude/`
- `commands/*.md` (8) → `.claude/commands/`
- `agents/*.md` (5) → `.claude/agents/`

Or copy individual files manually:

```powershell
# Just the project instructions
Copy-Item CLAUDE.md C:\path\to\to-rdls\CLAUDE.md

# Just the commands
Copy-Item commands\*.md C:\path\to\to-rdls\.claude\commands\
```

## Design notes

**Why split across multiple files?** Claude Code loads `CLAUDE.md` automatically on every session, so it should stay concise (under 200 lines). The 6 reference docs in `.claude/` are available for Claude to read on demand when it needs deeper detail - constraint tables, full API signatures, schema structures, etc. This balances always-available context with comprehensive coverage.

**Why source-independent?** The to-rdls toolkit was originally built for HDX/CKAN datasets but is now designed to work with any data catalog. Source adapters (in `sources/`) normalize catalog-specific metadata into a common field dict, and the rest of the pipeline operates on that common interface. The HDX adapter serves as the reference implementation; new adapters follow the same pattern.

**Coverage scope:** These configs reflect the complete to-rdls implementation - all 14 Python modules in `src/`, all 14 YAML configs in `configs/`, the RDLS v0.3 JSON Schema in `schema/`, and all 7 notebooks. If a module, config, or pattern exists in to-rdls, it should be documented here.
