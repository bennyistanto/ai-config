# Cross-Repo Documentation Session Detail
> 2026-03-15

## Repo 1: hdx-metadata-crawler

### Per-notebook docs rewritten (docs/01-07)
Major corrections across all 7:
- **Scoring system**: Was described as normalized 0-1 floats → actually integer-based (2-5 points)
- **Function names**: Wrong class/method names replaced with actual code (e.g., `TagMappingConfig` → doesn't exist, `HDXClient.search_datasets()` → `HDXClient.get_json()`)
- **Statistics**: All counts updated to match actual pipeline output
- **Missing features**: Auto-repair M5, nested field validation M8, component gating, signal dictionary enrichment — all added

### Per-notebook docs updated (docs/08-13)
Minor updates: version tags added, counts corrected

### STORY.md
Added epilogue "What Comes Next: Content-Driven Review" with post-LLM-review numbers:
- 3,443 reclassified, 4,103 non-disaster separated
- 8,822 RDLS-relevant, 6,132 valid, 2,690 blocked by occurrence schema
- Links to to-rdls repo for content-driven pipeline
- Kept all existing regex pipeline numbers intact (these are the main narrative)

### Already existed (no changes needed)
- `docs/known_limitations.md` — Problem 7 content already there
- `docs/ARCHITECTURE.md` — Already had Known Limitations section
- `docs/QUICKSTART.md` — Already up-to-date
- `README.md` — Already references known_limitations.md

---

## Repo 2: to-rdls

### New docs created
| File | Lines | Content |
|------|-------|---------|
| `docs/ARCHITECTURE.md` | ~450 | Design principles, pipeline flow, dependency graph, source adapter pattern, HEVL cascade, validation engine, LLM review, MCP server, config architecture |
| `docs/MODULE_REFERENCE.md` | ~400 | All 20 src/ modules with functions, classes, dependencies |
| `docs/CONFIG_REFERENCE.md` | ~250 | All 16 YAML configs with structure and examples |
| `docs/FEATURES.md` | ~300 | 8 capability sections with production numbers |
| `docs/LIMITATIONS_AND_ROADMAP.md` | ~150 | Gaps, pending work, DELTA exploration, roadmap |
| `docs/GETTING_STARTED.md` | ~150 | Installation, pipeline runs, standalone tools |

### README.md updated
Added capabilities overview, full directory tree, docs links, dependency listing

---

## Repo 3: ai-config

### Files modified
| File | Changes |
|------|---------|
| `CLAUDE.md` | +5 modules in tree, +LLM pipeline section, +dataclasses, +llm_review.yaml config |
| `module-reference.md` | +5 module sections (zipaccess, hdx_review, ckan_columns, llm_review, __main__) |
| `configs-detail-reference.md` | +llm_review.yaml section (5 config groups with all keys) |
| `README.md` | Updated counts: 20 modules, 16 configs, 10 commands, 6 agents |
| `agents/pipeline-debugger.md` | +4 pipeline stages (11-14), +4 common issues |
| `agents/data-reviewer.md` | +Cross-references section (LLM reviewer, column cache, inventory notebook) |

### Files created
| File | Purpose |
|------|---------|
| `agents/llm-reviewer.md` | New agent: LLM-assisted classification specialist |
| `commands/rdls-llm-review.md` | New command: run/inspect LLM review pipeline |
| `commands/rdls-inventory.md` | New command: scan delivery folder/ZIP |
| `HANDOFF.md` | Session handoff for all 3 repos |

### Files unchanged (verified current)
- `agents/rdls-expert.md` — still accurate
- `agents/hevl-extractor.md` — still accurate
- `agents/config-manager.md` — still accurate (review_knowledge.yaml already mentioned)
- `commands/rdls-validate.md` — still accurate (known issues already listed)
- `commands/rdls-debug-record.md` — still accurate (known patterns already listed)
- All other commands — still accurate
- `schema-reference.md` — still accurate
- `constraints-reference.md` — still accurate
- `naming-reference.md` — still accurate
- `signals-reference.md` — still accurate
- `deploy.ps1` / `deploy.sh` — use globs, auto-pick up new files

---

## Problem 7 Documentation Trail

The "Content-Blind Over-Classification" problem is documented in:
1. **hdx-metadata-crawler**: `docs/known_limitations.md` (the gap description)
2. **hdx-metadata-crawler**: `docs/ARCHITECTURE.md` Known Limitations section (reference)
3. **hdx-metadata-crawler**: `docs/STORY.md` epilogue (what comes next)
4. **to-rdls**: `docs/FEATURES.md` LLM-Assisted Classification section (the solution)
5. **to-rdls**: `docs/LIMITATIONS_AND_ROADMAP.md` (remaining gaps)
6. **to-rdls**: `temp/github_issue_problem7.md` (original issue write-up)
7. **ai-config**: `agents/llm-reviewer.md` (Claude Code agent for the solution)
8. **ai-config**: `CLAUDE.md` LLM-Assisted Review section (project instructions)
