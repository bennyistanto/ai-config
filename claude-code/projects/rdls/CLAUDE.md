# RDLS Project — Claude Code Instructions

## Project overview

A source-independent toolkit for transforming dataset metadata from any data catalog into RDLS (Risk Data Library Standard) v0.3 schema. Designed to work with multiple sources: HDX, GeoNode, CKAN, World Bank Data Catalog, and others. Maintained under GFDRR/World Bank's Digital Earth team. License: MPL-2.0.

Pipeline: **Source Crawl → Filter → Classify → Translate → HEVL Extract → Integrate → Validate → Distribute**

## Architecture

The `to-rdls/` module is the core: portable, source-independent Python modules + YAML configs + notebooks. Originally extracted from an HDX-specific notebook pipeline, now designed to support any metadata source via pluggable source adapters.

### to-rdls module structure
```
to-rdls/
├── src/                    # Python modules
│   ├── utils.py            # Text sanitization, file I/O, nested dict navigation
│   ├── schema.py           # JSON Schema loading, validation, SchemaContext
│   ├── spatial.py          # Country name→ISO3, region expansion, spatial block
│   ├── classify.py         # Tag-weighted HEVL classification → Classification
│   ├── translate.py        # Source metadata → base RDLS record builder
│   ├── extract_hazard.py   # 2-tier cascade → HazardExtraction
│   ├── extract_exposure.py # 3-tier cascade → ExposureExtraction
│   ├── extract_vulnloss.py # Vulnerability + Loss extractors
│   ├── integrate.py        # Merge HEVL blocks into base record
│   ├── naming.py           # Structured ID: rdls_{type}-{iso3}{org}_{slug}
│   ├── validate_qa.py      # 5-pass autofix, confidence scoring, distribution
│   ├── inventory.py        # Delivery folder/ZIP inventory (standalone, stdlib only)
│   ├── review.py           # Automated data review: inspect, HEVL classify, gap analysis
│   └── sources/
│       ├── hdx.py          # HDX/CKAN source adapter (reference implementation)
│       └── geonode.py      # GeoNode source adapter (stub — template for new sources)
├── configs/                # 14 YAML config files (see below)
├── schema/                 # RDLS v0.3 JSON Schema + template
└── notebooks/              # Pipeline notebooks + generators
```

### Data flow
```
Source (any catalog) → source adapter → extract_fields() → common dict
  → classify.classify_dataset() → Classification
  → translate.build_rdls_record() → base RDLS record
  → HazardExtractor.extract() → HazardExtraction → build_hazard_block()
  → ExposureExtractor.extract() → ExposureExtraction → build_exposure_block()
  → VulnerabilityExtractor.extract() → build_vulnerability_block()
  → LossExtractor.extract() → build_loss_block()
  → integrate.integrate_record() → merged record
  → validate_qa.validate_and_score() → ScoredRecord (with autofix)
  → validate_qa.distribute_records() → tiered output
```

## Key dataclasses

```python
Classification(scores, components, rdls_candidate, confidence, top_signals)
ExtractionMatch(value, confidence, source_field, matched_text, pattern)
HazardExtraction(hazard_types, process_types, analysis_type, return_periods, intensity_measures, overall_confidence)
ExposureExtraction(categories, metrics, taxonomy_hint, currency, overall_confidence)
FunctionExtraction(function_type, approach, relationship, hazard_primary, impact_type, impact_metric, quantity_kind, confidence)
LossEntryExtraction(loss_signal_type, hazard_type, impact_metric, loss_frequency_type, currency, reference_year, is_insured)
ScoredRecord(record, validation_status, error_count, fix_count, warnings, composite_confidence, auto_fixed)
```

## Config files reference

| File | Purpose | Key contents |
|------|---------|-------------|
| `rdls_schema.yaml` | Codelists & required fields | All closed/open codelists, 195+ country codes |
| `signal_dictionary.yaml` | HEVL extraction patterns | 100+ regex patterns with confidence levels |
| `rdls_defaults.yaml` | Default values & constraints | process defaults, valid triplets, loss signal defaults, socioeconomic indicators |
| `classification.yaml` | Scoring rules | tag_weights, keyword_patterns, org_hints, thresholds (high≥7, medium≥4, candidate≥5) |
| `naming.yaml` | ID generation | 265 org abbreviations, 249 ISO3 codes, component codes, title slug rules |
| `format_mapping.yaml` | Format aliases | 81 format aliases, 12 skip formats, 6 service URL patterns |
| `license_mapping.yaml` | License normalization | 33 license variants → RDLS codes |
| `spatial.yaml` | Geography | 77 country name fixes, region→country maps |
| `pipeline.yaml` | Runtime settings | Thresholds (high≥0.8, medium≥0.5), output paths, batch settings |
| `desinventar_mapping.yaml` | DesInventar→RDLS | 31 event type mappings, 14 loss columns, 16 datasets |
| `country_bbox.yaml` | Bounding boxes | ~250 ISO3→[minlon,minlat,maxlon,maxlat] |
| `geonames_country_ids.yaml` | GeoNames IDs | ~250 ISO3→{geoname_id, name} |
| `sources/hdx.yaml` | HDX source adapter config | Rate limiting, field paths, OSM markers (reference implementation) |
| `sources/geonode.yaml` | GeoNode source adapter config | Stub — template for new source adapters |

## Schema (schema/)

- `rdls_schema_v0.3.json` — Full JSON Schema (3,280 lines) with all $defs, codelists, constraints
- `rdls_template_v0.3.json` — Complete template record with example data (Aruba ICRA)

### Required dataset fields
`id`, `title`, `risk_data_type`, `attributions` (publisher+creator+contact_point), `spatial`, `license`, `resources` (id+title+description+data_format)

### Closed codelists (must match exactly)
- **risk_data_type**: hazard, exposure, vulnerability, loss
- **hazard_type**: coastal_flood, convective_storm, drought, earthquake, extreme_temperature, flood, landslide, strong_wind, tsunami, volcanic, wildfire
- **process_type**: 32 values (fluvial_flood, pluvial_flood, ground_motion, liquefaction, storm_surge, tropical_cyclone, tornado, agricultural_drought, etc.)
- **exposure_category**: agriculture, buildings, infrastructure, population, natural_environment, economic_indicator, development_index
- **analysis_type**: probabilistic, deterministic, empirical
- **function_approach**: analytical, empirical, hybrid, judgement
- **metric_dimension**: structure, content, product, disruption, population, index
- **impact_metric**: 21 values (damage_ratio, loss_ratio, casualty_count, economic_loss_value, etc.)
- **data_format**: 20+ values (GeoTIFF, NetCDF, CSV, GeoJSON, Shapefile, GeoPackage, etc.)
- **access_modality**: file_download, download_page, API, OGC_API, GEE_collection, WMS, WFS, WCS, STAC, REST, dashboard

## Companion reference docs

Detailed lookup tables are in separate files (deployed to `.claude/` alongside this CLAUDE.md):

| File | Contents |
|------|----------|
| `.claude/module-reference.md` | All modules with function signatures, dataclasses, key constants, internal methods, notebooks, docs |
| `.claude/schema-reference.md` | Full RDLS v0.3 JSON Schema $defs: Event_set, Event, VulnerabilityFunction, Losses, Resource, Attribution, Location structures |
| `.claude/constraints-reference.md` | All constraint tables: function_type_constraints, loss signal defaults, valid asset triplets, impact metric constraints, compound tags |
| `.claude/naming-reference.md` | ID format, component codes, hazard/exposure item codes, slug rules, org shortname rules, classification thresholds |
| `.claude/signals-reference.md` | Hazard/exposure signal patterns, exclusion patterns, tag weights, socioeconomic indicators |
| `.claude/configs-detail-reference.md` | Format mapping details (service URLs, ZIP inference, skip formats), region→country mappings, DesInventar event/loss mappings, org_hints, HDX field paths, OSM detection |

## Key constraint tables (quick reference)

### hazard_type → valid process_types
- flood → fluvial_flood, pluvial_flood, groundwater_flood, coastal_flood
- earthquake → primary_rupture, ground_motion, liquefaction
- coastal_flood → storm_surge, coastal_flood
- convective_storm → tropical_cyclone, tornado, extratropical_cyclone
- strong_wind → tropical_cyclone, tornado, extratropical_cyclone
- landslide → landslide, debris_flow, rock_fall, shallow_landslide, slow_moving_landslide
- drought → agricultural_drought, hydrological_drought, meteorological_drought, socioeconomic_drought
- extreme_temperature → extreme_cold, extreme_heat
- volcanic → volcanic_eruption, ash_fall, lahar, pyroclastic_flow, lava_flow
- tsunami → tsunami
- wildfire → wildfire

### exposure_category → valid (dimension, quantity_kind) triplets
- agriculture: (product, area), (product, monetary), (product, count)
- buildings: (structure, count), (structure, area), (content, monetary), (structure, monetary)
- infrastructure: (structure, count), (structure, length), (structure, monetary)
- population: (population, count)
- natural_environment: (product, area)
- economic_indicator: (index, monetary), (index, count)
- development_index: (index, count)

For vulnerability function constraints, loss signal defaults, impact metric constraints, and all other tables → see `.claude/constraints-reference.md`

## HEVL extraction cascade

### Hazard (2-tier, HazardExtractor)
- **Tier 1** (title, name, tags, resources): Can INTRODUCE hazard_types — high authority
- **Tier 2** (notes, methodology): CORROBORATE only, or fallback if Tier 1 found nothing
- False-positive filter on Tier 2 (suppresses "earthquake risk reduction", "flood preparedness")
- Also extracts: return_periods, intensity_measures, analysis_type, calculation_method

### Exposure (3-tier, ExposureExtractor)
- **Tier 1** (title, name, tags): Introduce categories
- **Tier 2** (resources): Introduce new or corroborate (+0.05 confidence boost)
- **Tier 3** (notes, methodology): Corroborate only
- Validates metrics against exposure_valid_triplets constraint table

### Vulnerability (VulnerabilityExtractor)
- Extracts function_type, approach, relationship, impact_metric
- Detects 18 socioeconomic indicators (POV_HEADCOUNT, HDI, SVI, FOOD_SECURITY, etc.)
- Validates against function_type_constraints table

### Loss (LossExtractor)
- 8 signal types: human_loss, displacement, affected_population, economic_loss, structural_damage, agricultural_loss, catastrophe_model, general_loss
- Each has default impact_metric, asset_category, quantity_kind from rdls_defaults.yaml
- Exclusion patterns filter false positives ("data loss", "profit & loss")
- Detects insured loss, currency, reference_year

## Validation & QA (validate_qa.py)

5-pass autofix engine:
1. Codelist fuzzy matching (case-insensitive, substring, fuzzy)
2. Enum fixes for nested properties
3. Component validation
4. Type coercion
5. Defaults for missing required fields

Confidence scoring: composite from data completeness, attribution variety, resource format quality, spatial precision, component confidence. Weights: hazard 0.3, exposure 0.3, vulnerability 0.2, loss 0.2.

Distribution tiers: high (≥0.8 valid), medium (≥0.5 valid), low (<0.5 valid), plus invalid variants.

## Coding conventions

- Python 3.10+, type hints on all functions, dataclasses for structured data
- Config-driven: all patterns, mappings, thresholds in YAML — never hardcoded
- Text: `sanitize_text()` (mojibake, HTML, smart quotes), `norm_str()` (NFKD+lowercase), `slugify()`
- File I/O: `load_json/yaml()`, `write_json()` (atomic via temp+rename), `append_jsonl()`
- Nested dict ops: `navigate_path()`, `set_at_path()`, `remove_at_path()`
- Validation: `(is_valid, errors_list)` tuples
- Extractions: `ExtractionMatch(value, confidence, source_field, matched_text, pattern)`
- IDs: `rdls_{type}-{iso3}{org}_{titleslug}` with collision suffix `__{uuid8}`

## When modifying code

- Check `configs/rdls_schema.yaml` for valid codelist values before adding patterns
- New extraction patterns → `configs/signal_dictionary.yaml`, not Python code
- New format aliases → `configs/format_mapping.yaml`
- New org abbreviations → `configs/naming.yaml` under org_abbreviations
- Test constraint validity against tables in rdls_defaults.yaml
- Run `validate_record()` after any changes to record structure
- Preserve cascade tiering — Tier 2/3 must not introduce values without Tier 1 evidence
- Use `SchemaContext.fuzzy_codelist_fix()` for auto-correction, not manual string matching
