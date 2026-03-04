# to-rdls Module Reference

Complete reference for all modules, their public API, key internals, and inter-dependencies.

## Module dependency graph

```
utils.py ← (all modules)
spatial.py ← translate.py, naming.py
schema.py ← validate_qa.py
naming.py ← integrate.py, translate.py
classify.py ← (pipeline entry)
translate.py ← (pipeline)
extract_hazard.py ← (pipeline)
extract_exposure.py ← (pipeline)
extract_vulnloss.py ← (pipeline)
integrate.py ← (pipeline)
validate_qa.py ← (pipeline exit)
inventory.py ← (standalone — no to-rdls dependencies, stdlib only)
review.py ← inventory.py (uses inventory for file listing; requires geospatial env)
sources/hdx.py ← (source adapter — reference implementation)
sources/geonode.py ← (source adapter — stub, template for new sources)
```

## utils.py — Text & I/O utilities

**Text processing**:
- `sanitize_text(text)` → Clean mojibake, HTML tags, smart quotes, control chars
- `slugify(s, max_len=80)` → URL-safe hyphenated slug
- `slugify_token(s, max_len=80)` → Underscore-separated token
- `norm_str(x)` → NFKD normalize + lowercase
- `normalize_text(s)` → Lowercase + whitespace collapse
- `short_text(s, max_len=100)` → Truncate with ellipsis
- `split_semicolon_list(s)` → Parse delimited strings
- `looks_like_url(s)` → URL detection
- `as_list(x)` → Coerce to list

**File I/O**:
- `load_json(path)`, `write_json(path, obj, pretty=True)`
- `append_jsonl(path, obj)`
- `load_yaml(path)`, `write_yaml(path, obj)`
- `iter_json_files(folder)` → sorted list of .json files

**Directory**:
- `clean_directory(directory, label, mode="replace")` → replace/skip/abort

**Nested dict**:
- `navigate_path(obj, parts)` → (parent, key)
- `set_at_path(obj, parts, value)`, `remove_at_path(obj, parts)`

## schema.py — Schema operations

- `load_rdls_schema(schema_path)` → parsed JSON Schema dict
- `load_codelists(yaml_path)` → Dict[name → list of values]
- `load_codelists_from_schema(schema)` → extract enums from $defs
- `validate_record(record, schema)` → (is_valid, error_messages)
- `summarize_errors(errors)` → Counter by category
- `check_required_fields(record)` → list of missing fields
- `SchemaContext(schema, codelist_config)`:
  - `.enum_lookup[field_name]` → set of valid values
  - `.field_aliases[prop_name]` → $defs enum name
  - `.required_lookup[def_name]` → set of required fields
  - `.allowed_props[def_name]` → set of allowed properties
  - `.fuzzy_codelist_fix(bad_value, field_name)` → best match or None
  - `.is_field_required(parts)` → bool (heuristic)
  - Internal builders: `_build_enum_lookup()`, `_build_field_aliases()`, `_build_required_lookup()`, `_build_allowed_props()`, `_build_property_to_def()`

## spatial.py — Geography

- `load_spatial_config(yaml_path)` → config with regions, fixes, non-country groups
- `load_country_iso3_table(csv_path)` → country name → ISO3 mapping from CSV
- `country_name_to_iso3(name, fixes, iso3_table)` → ISO3 code
  - Resolution: already ISO3? → country_name_fixes → iso3_table → pycountry fallback
- `infer_spatial(groups, ...)` → `{"scale": "national|regional|global", "countries": [...]}`
- `infer_scale(countries)` → scale from country count (0→global, 1→national, 2+→regional)
- `_norm_country_key(s)` → normalize for lookup
- `_try_pycountry(name)` → fallback resolution

## classify.py — Dataset classification

- `Classification(scores, components, rdls_candidate, confidence, top_signals)`
- `load_classification_config(yaml_path)` → scoring config
- `load_exclusion_patterns(signal_dict_path)` → component → regex list
- `classify_dataset(meta, config, keywords, exclusions)` → Classification
- `apply_overrides(classification, overrides, dataset_id)`
- `enforce_component_deps(components, rules)` → enforce V/L require H or E
- Thresholds: high≥7, medium≥4, candidate≥5

## translate.py — Record builder

- `load_format_config(yaml_path)`, `load_license_config(yaml_path)`
- `detect_service_url(url, patterns)` → (data_format, access_modality)
- `infer_format_from_name(name, url)` → format string
- `map_data_format(source_fmt, url, name, config)` → RDLS data_format
- `map_license(license_str, config)` → RDLS license code
- `build_attributions(fields, source_url)` → attributions array
- `build_resources(fields, format_config)` → resources array
- `build_rdls_record(fields, components, ...)` → base RDLS record

## extract_hazard.py — Hazard extraction

**Dataclasses**:
- `ExtractionMatch(value, confidence, source_field, matched_text, pattern)`
- `HazardExtraction(hazard_types, process_types, analysis_type, return_periods, intensity_measures, overall_confidence, calculation_method)`

**Key constants**:
- `TIER1_FIELDS` = {"title", "name", "tags", "resources"}
- `TIER2_FIELDS` = {"notes", "methodology"}
- `TIER2_FALSE_POSITIVE_PATTERNS` — compiled regex list to filter FP in Tier 2
- `RP_PATTERNS` — return period regex patterns (N-year, RP-N, 1-in-N)
- `IM_TEXT_PATTERNS` — intensity measure codes → pattern lists (PGA:g, PGV:m/s, MMI:-, wd:m, etc.)
- `SIMULATED_PATTERNS`, `OBSERVED_PATTERNS`, `INFERRED_PATTERNS` — calculation method detection
- `CONFIDENCE_MAP` = {"high": 0.9, "medium": 0.7, "low": 0.5}

**Public API**:
- `HazardExtractor(signal_dict, defaults_config)`:
  - `.extract(record)` → HazardExtraction
  - 2-tier cascade, false-positive filtering
  - Extracts: hazard_types, process_types, analysis_type, return_periods, intensity_measures
  - Internal: `_compile_patterns()`, `_extract_text_fields()`, `_match_hazard_types()`, `_has_false_positive_context()`, `_match_process_types()`, `_match_analysis_type()`, `_extract_return_periods()`, `_extract_intensity_measures()`, `_infer_calculation_method()`
- `build_hazard_block(extraction)` → RDLS hazard JSON with event_sets

## extract_exposure.py — Exposure extraction

**Dataclasses**:
- `ExposureExtraction(categories, metrics, taxonomy_hint, currency, overall_confidence)`
- `MetricExtraction(dimension, quantity_kind, confidence, source_hint)`

**Key constants**:
- `DIMENSION_PATTERNS` — regex for structure, content, product, disruption, population, index
- `QUANTITY_KIND_PATTERNS` — regex for count, area, length, monetary, time
- `CURRENCY_PATTERNS` — (regex, currency_code) tuples for currency detection
- `COMMON_CURRENCIES` — 80+ ISO 4217 codes for fallback
- `TAXONOMY_PATTERNS` — regex for GED4ALL, MOVER, GLIDE, EMDAT, OED, HAZUS, etc.
- `CORROBORATION_BOOST` = 0.05

**Public API**:
- `ExposureExtractor(signal_dict, defaults_config)`:
  - `.extract(record)` → ExposureExtraction
  - 3-tier cascade with corroboration boost (+0.05)
  - Validates against valid_triplets constraint table
  - Internal: `_scan_tier()`, `_infer_metrics()`, `_detect_taxonomy()`, `_detect_currency()`
- `build_exposure_block(extraction)` → RDLS exposure JSON array

## extract_vulnloss.py — Vulnerability & Loss

**Dataclasses**:
- `FunctionExtraction(function_type, approach, relationship, hazard_primary, impact_type, impact_metric, quantity_kind, confidence)`
- `SocioEconomicExtraction(indicator_name, indicator_code, scheme, description, confidence)`
- `VulnerabilityExtraction(functions, socioeconomic_indices, overall_confidence)`
- `LossEntryExtraction(loss_signal_type, hazard_type, impact_metric, loss_frequency_type, currency, reference_year, is_insured, asset_category, asset_dimension, impact_type, quantity_kind, loss_type, approach)`
- `LossExtraction(entries, overall_confidence)`

**Key constants (Vulnerability)**:
- `FUNCTION_TYPE_PATTERNS` — regex for vulnerability, fragility, damage_to_loss, engineering_demand
- `APPROACH_PATTERNS` — regex for analytical, empirical, hybrid, judgement
- `RELATIONSHIP_PATTERNS` — regex for math_parametric, math_bespoke, discrete
- `IMPACT_TYPE_PATTERNS` — regex for direct, indirect, total
- `IMPACT_MODELLING_PATTERNS` — regex for simulated, observed, inferred

**Key constants (Loss)**:
- `LOSS_SIGNAL_PATTERNS` — 8 signal types with regex patterns
- `LOSS_EXCLUSION_PATTERNS` — compiled FP filters ("data loss", "weight loss", "profit & loss")
- `INSURED_LOSS_PATTERNS` — insured loss detection
- `LOSS_APPROACH_PATTERNS`, `LOSS_FREQUENCY_PATTERNS`
- `CURRENCY_PATTERNS` — 21+ currencies with regex
- `YEAR_PATTERN` — reference year extraction (1900-2099)

**Public API**:
- `VulnerabilityExtractor(defaults_config)`:
  - `.extract(record)` → VulnerabilityExtraction
  - Detects function_type, approach, relationship, impact_metric
  - 18 socioeconomic indicators
  - Internal: `_load_socio_patterns()`, `_detect_approach()`, `_detect_relationship()`, `_detect_impact_type()`, `_validate_metric()`
- `LossExtractor(defaults_config)`:
  - `.extract(record)` → LossExtraction
  - 8 signal types with defaults from config
  - Internal: `_is_excluded()`, `_detect_currency()`, `_detect_insured()`, `_detect_loss_approach()`, `_detect_loss_frequency()`, `_validate_loss_entry()`
- `build_vulnerability_block(extraction)` → RDLS vulnerability JSON
- `build_loss_block(extraction)` → RDLS loss JSON

## naming.py — ID generation

- `load_naming_config(yaml_path)`
- `encode_component_types(components, config)` → type segment (hzd/exp/he/hevl)
- `encode_countries(iso3_codes, config)` → country segment (max 5)
- `resolve_shortname(org_name, org_slug, config)` → org abbreviation
- `slugify_title(title, ...)` → max 25 char slug
- `build_rdls_id(...)` → `rdls_{type}-{iso3}{org}_{slug}`
- `build_rdls_id_with_collision(...)` → with `__{uuid8}` suffix
- `parse_rdls_id(rdls_id, config)` → parsed components
- `is_valid_iso3(code, config)` → bool
- `_iso3_to_names(iso3_codes, config)` → lowercase names for slug stripping
- `_ID_PATTERN` — compiled regex for parsing RDLS IDs

## integrate.py — HEVL merge

- `merge_hevl_into_record(base_record, hevl_blocks)` → merged record
- `integrate_record(...)` → full integration with validation + ID rebuild
- `append_provenance(record, note)` → add to description
- `validate_component_combination(components, ...)` → (is_valid, reason)
- `determine_risk_data_types(base_types, hevl_flags)` → updated list
- `build_integrated_id(components, iso3_codes, org_name, org_slug, naming_config, title)` → wrapper for naming
- `extract_hazard_types_from_block(hazard_block)` → list of hazard_type values
- `extract_exposure_categories_from_block(exposure_block)` → list of category values
- `extract_iso3_from_spatial(spatial)` → list of ISO3 codes
- `extract_org_from_attributions(attributions)` → publisher org name

## validate_qa.py — Validation & QA

**Classes**:
- `ScoredRecord(record, validation_status, error_count, fix_count, warnings, composite_confidence, auto_fixed)`
- `AutoFixer(ctx, defaults, schema_gap_fields)` — 5-pass auto-fix engine:
  1. `_structural_repair()` — fix JSON type mismatches (exposure object→array, etc.)
  2. Error-driven codelist fixes via `SchemaContext.fuzzy_codelist_fix()`
  3. `_deep_clean_empties()` — remove empty strings/dicts/arrays from non-required fields
  4. `_infer_missing_required()` — fill missing required by context inference
  5. `_clean_non_schema_fields()` — remove additional properties not in schema
  - Hazard-specific: `_repair_hazard_obj()`, `_infer_hazard_process_from_events()`, `_build_occurrence_placeholder()`

**Public API**:
- `validate_against_schema(record, schema)` → rich error dicts with path, message, category, validator
- `categorize_error(err, path)` → human-readable category
- `check_business_rules(record, required_roles, schema_link_pattern)` → RDLS-specific checks (attribution roles, resource URLs, entity contact, schema link, risk_data_type consistency, spatial validity, currency)
- `validate_and_score(records, schema, context)` → list of ScoredRecord
- `apply_autofixes(record, errors, schema)` → auto-fixed record
- `compute_composite_confidence(record, context)` → 0.0–1.0
- `distribute_records(scored, thresholds, output_dir)` → tiered output
- `create_validation_report(scored)` → JSON summary
- `generate_validation_csv(scored)` → detailed CSV export

## inventory.py — Delivery folder/ZIP inventory

**Standalone module** — stdlib only, no to-rdls dependencies. Scans folders and ZIP archives without extraction.

**Public API**:
- `inventory_folder(target, *, output_dir=None, formats="json,md,csv", include_hash=False, inspect_zips=True, verbose=True)` → `(markdown, rows, stats)` — high-level convenience function
- `scan_target(cfg: InventoryConfig)` → `(rows, stats)` — core scanner
- `render_and_write(cfg: InventoryConfig)` → `(markdown, rows, stats)` — scan + render + write outputs

**Config dataclass**: `InventoryConfig(target, write_markdown_path, write_csv_path, write_json_path, include_hash, inspect_zips, zip_max, excludes, max_depth, follow_symlinks, verbose)`

**Row dict fields**: `container`, `path`, `name`, `ext`, `mime`, `size_bytes`, `size_human`, `modified_utc`, `is_in_zip`, `sha256`

**Stats dict fields**: `target`, `files`, `dirs`, `total_bytes`, `total_human`, `generated_utc`, `zip_entries`

**CLI**: `python -m src.inventory /path/to/folder [-o OUTPUT_DIR] [--formats json,md,csv] [--hash] [--no-zip-inspect] [-q]`

**Internal helpers**: `human_size()`, `iso_time()`, `sha256_file()`, `mime_from_name()`, `matches_any_glob()`, `iter_dir()`, `list_zip_members()`, `file_row()`, `build_tree_lines()`, `markdown_report()`, `write_csv()`, `write_json()`

## review.py — Automated data review

Inspects delivery folders, classifies files by HEVL, identifies metadata gaps, and generates structured review reports. Requires the `to-rdls` conda environment (GDAL, rasterio, fiona, geopandas, PyMuPDF, python-docx).

**Pipeline phases**: Inventory → Group files → Inspect representative files → Classify HEVL → Gap analysis → Write report

**Entry point**: `review_folder(target, *, output_dir=None, max_inspect=30, verbose=True) → ReviewResult`

**Dataclasses**:
- `FileInspection(path, format, inspection)` — raw inspection result dict per file
- `FileGroup(name, files, formats, total_size_bytes, hevl, hazard_types, exposure_categories, confidence, evidence, inspections)` — logical file grouping with HEVL classification
- `GapAnalysis(group, severity, field, status, missing_required, missing_recommended, actions)` — gap assessment per group
- `ReviewResult(target, generated_utc, stats, file_groups, inspections, gap_analyses, suggested_datasets)` — complete review output

**File inspectors** (dispatch by extension):
- `inspect_geotiff(path)` — rasterio primary (CRS, bounds, bands, resolution, dtype), PIL fallback
- `inspect_vector(path)` — geopandas (CRS, bounds, columns, geometry type, sample row)
- `inspect_fgdb(path)` — fiona layer list + geopandas first layer schema
- `inspect_xlsx(path)` — openpyxl (sheets, columns, row counts)
- `inspect_csv(path)` — pandas (columns, dtypes, row count, sample)
- `inspect_json_data(path)` — JSON structure (array/object, GeoJSON detection, fields)
- `inspect_text(path)` — text excerpt up to 2000 chars
- `_inspect_pdf(path)` — PyMuPDF text extraction
- `_inspect_docx(path)` — python-docx paragraph text

**Grouping**: `group_files(rows)` — groups inventory rows by top-level folder or ZIP container name

**Classification**: `classify_group(group)` — matches file paths and inspection content against embedded HEVL signal patterns (subset of signal_dictionary.yaml)

**Gap analysis**: `analyze_gaps(groups)` — checks available fields against RDLS required/recommended fields

**Dataset mapping**: `suggest_datasets(groups)` — maps groups to RDLS dataset records; splits multi-component groups (e.g., EHL → separate E, H, L records)

**Report**: `render_review_markdown(review)` — generates human-readable markdown with summary table, group classifications, file inspections, gap analysis, and suggested datasets

**Output**: writes `review_{timestamp}.json` + `review_{timestamp}.md` to `_rdls_review/` subfolder

**CLI**: `python -m src.review /path/to/folder [-o OUTPUT_DIR] [--max-inspect 30] [-q]`

## Source adapters (sources/)

Each source adapter follows the same pattern: Config → Client → normalize → extract_fields → common dict.
New sources should follow the HDX adapter as reference implementation.

### sources/hdx.py — Reference implementation (HDX/CKAN)

- `HDXCrawlerConfig.from_yaml(yaml_path)`
- `HDXClient(config)` — rate-limited HTTP client with retry
- `iter_datasets(client, config, query)` → generator of dataset dicts
- `download_dataset_metadata(client, config, id)` → (metadata, source)
- `normalize_dataset_record(raw)` → unwrapped record
- `extract_hdx_fields(ds)` → common field dict (the interface other adapters must match)
- `detect_osm(ds, markers, threshold)` → OSMDetectionResult

### sources/geonode.py — Stub (template for new adapters)

- `GeoNodeConfig` dataclass with `from_yaml()`
- `GeoNodeClient` — not yet implemented
- `normalize_geonode_record(raw)` → stub
- `extract_geonode_fields(ds)` → must return same common field dict as HDX adapter

### Common field dict (interface contract)
All source adapters must produce a dict with these keys:
`id`, `name`, `title`, `notes`, `methodology`, `organization`, `org_name`, `org_description`, `license_title`, `license_url`, `groups`, `tags`, `resources`, `dataset_date`, `dataset_source`, `maintainer`, `url`

## Notebooks (to-rdls/notebooks/)

| Notebook | Purpose | Type |
|---|---|---|
| `rdls_nismod_00a_generate_country_bbox.py` | Generate country bounding boxes from Natural Earth | Preprocessing |
| `rdls_nismod_00b_generate_geonames_lookup.py` | Build GeoNames country ID lookup table | Preprocessing |
| `rdls_nismod_01_generate_icra_records.py` | Generate NISMOD ICRA RDLS records from template | Generator |
| `rdls_desinventar_01_generate_records.py` | Generate RDLS loss records from DesInventar data | Generator |
| `rdls_ind_gobs_csv2gpkg.ipynb` | Convert India GOBS CSV exposure data to GeoPackage | Converter |
| `rdls_data_inventory_contents.ipynb` | Thin wrapper for `src/inventory.py` — interactive delivery inventory | QA |
| `rdls_validate_metadata.ipynb` | Validate RDLS records against schema | QA |

## Documentation (to-rdls/docs/)

| File | Purpose |
|---|---|
| `delta_vs_rdls_schema_comparison.md` | Field-by-field DELTA database vs RDLS v0.3 mapping |
| `delta_vs_rdls_system_comparison.md` | Architectural comparison of DELTA vs RDLS systems |
| `github_issue_19_revision.md` | Revision notes for GFDRR issue (impact_metric, process_type fixes) |
| `jkan_issue_loss_display.md` | Issue tracking for loss display UI in RDL-JKAN portal |
