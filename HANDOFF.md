# Session Handoff
> Last updated: 2026-03-15 | Session: Cross-repo documentation update (3 repos)

## Current Task
Updated documentation across all 3 connected RDLS repositories.

## Status
- [x] **Repo 1 (hdx-metadata-crawler)**: All 13 per-notebook docs rewritten, STORY.md epilogue added, known_limitations.md verified
- [x] **Repo 2 (to-rdls)**: Created ARCHITECTURE.md, MODULE_REFERENCE.md, CONFIG_REFERENCE.md, FEATURES.md, LIMITATIONS_AND_ROADMAP.md, GETTING_STARTED.md; updated README.md
- [x] **Repo 3 (ai-config)**: Updated CLAUDE.md, module-reference.md, configs-detail-reference.md, README.md; created llm-reviewer agent, rdls-llm-review + rdls-inventory commands; updated pipeline-debugger + data-reviewer agents

## Key Decisions
| Decision | Why | Alternatives Rejected |
|----------|-----|----------------------|
| Added 5 missing modules to ai-config | hdx_review, ckan_columns, llm_review, zipaccess, __main__ were developed but not in config | Leave undocumented (confusing) |
| Created llm-reviewer as separate agent | LLM pipeline is complex enough for its own agent | Merge into pipeline-debugger (too overloaded) |
| Added rdls-llm-review + rdls-inventory commands | These are distinct workflows users invoke | Bundle into rdls-review-folder (too broad) |
| STORY.md epilogue (not overwrite) for post-LLM numbers | LLM review is a different pipeline in a different repo | Overwrite regex numbers (misleading) |

## Architecture Notes
### ai-config structure
```
claude-code/projects/rdls/
├── CLAUDE.md                    # Main project instructions (updated: 20 modules, LLM pipeline section)
├── module-reference.md          # All 20 src/ modules (updated: +5 new modules)
├── configs-detail-reference.md  # Config details (updated: +llm_review.yaml section)
├── agents/
│   ├── llm-reviewer.md          # NEW: LLM-assisted classification specialist
│   ├── data-reviewer.md         # UPDATED: cross-references to LLM reviewer
│   ├── pipeline-debugger.md     # UPDATED: stages 11-14, LLM issues
│   ├── rdls-expert.md           # Unchanged
│   ├── hevl-extractor.md        # Unchanged
│   └── config-manager.md        # Unchanged
├── commands/
│   ├── rdls-llm-review.md       # NEW: run/inspect LLM review pipeline
│   ├── rdls-inventory.md        # NEW: scan delivery folder/ZIP
│   └── (8 existing commands)    # Unchanged
└── README.md                    # UPDATED: counts (20 modules, 10 commands, 6 agents)
```

### Cross-repo relationships
```
hdx-metadata-crawler (repo 1) → produces RDLS JSON via regex pipeline
    ↓ output/rdls/dist/
to-rdls (repo 2) → LLM review pipeline fixes content-blind over-classification
    ↓ src/ modules + configs/
ai-config (repo 3) → Claude Code instructions for working with to-rdls
```

## Findings
- ai-config had 5 undocumented modules: hdx_review.py, ckan_columns.py, llm_review.py, zipaccess.py, __main__.py
- ai-config had 1 undocumented config: llm_review.yaml
- Module count was stated as 14 in multiple places; actual count is 20
- Config count was stated as 14; actual count is 16
- deploy.ps1/deploy.sh use globs (*.md) so new files are auto-deployed — no script changes needed

## Next Steps
1. Run `deploy.ps1` to deploy updated configs to the to-rdls project
2. Verify deployed CLAUDE.md, commands, agents work in Claude Code sessions
3. Consider adding hdx-metadata-crawler project config (currently only to-rdls has one)

## Gotchas
- Agent subprocesses can't write files due to sandbox permissions — must write directly in main conversation
- `claude-haiku-4-20250414` model ID 404s — must use `claude-haiku-4-5-20251001`
- CKAN column cache takes 48+ hours to build from scratch even with API key
- `occurrence:{}` schema gap blocks 2,690 records — pending RDLS schema revision
