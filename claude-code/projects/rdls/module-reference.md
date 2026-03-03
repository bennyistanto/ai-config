# to-rdls Module Reference

Quick reference for all modules, their public API, and inter-dependencies.

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
  - `.fuzzy_codelist_fix(bad_value, field_name)` → best match

## spatial.py — Geography

- `load_spatial_config(yaml_path)` → config with regions, fixes, non-country groups
- `country_name_to_iso3(name, fixes, iso3_table)` → ISO3 code
  - Resolution: already ISO3? → country_name_fixes → iso3_table → pycountry fallback
- `infer_spatial(groups, ...)` → `{"scale": "national|regional|global", "countries": [...]}`

## classify.py — Dataset classification

- `Classification(scores, components, rdls_candidate, confidence, top_signals)`
- `load_classification_config(yaml_path)` → scoring config
- `load_exclusion_patterns(signal_dict_path)` → component → regex list
- `classify_dataset(meta, config, keywords, exclusions)` → Classification
- `apply_overrides(classification, overrides, dataset_id)`
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

- `HazardExtractor(signal_dict, defaults_config)`:
  - `.extract(record)` → HazardExtraction
  - 2-tier cascade, false-positive filtering
  - Extracts: hazard_types, process_types, analysis_type, return_periods, intensity_measures
- `build_hazard_block(extraction)` → RDLS hazard JSON with event_sets

## extract_exposure.py — Exposure extraction

- `ExposureExtractor(signal_dict, defaults_config)`:
  - `.extract(record)` → ExposureExtraction
  - 3-tier cascade with corroboration boost (+0.05)
  - Validates against valid_triplets constraint table
- `build_exposure_block(extraction)` → RDLS exposure JSON array

## extract_vulnloss.py — Vulnerability & Loss

- `VulnerabilityExtractor(defaults_config)`:
  - `.extract(record)` → VulnerabilityExtraction
  - Detects: function_type, approach, relationship, impact_metric
  - 18 socioeconomic indicators (POV_HEADCOUNT, HDI, SVI, FOOD_SECURITY, etc.)
- `LossExtractor(defaults_config)`:
  - `.extract(record)` → LossExtraction
  - 8 signal types with defaults from config
  - Exclusion patterns for false positives
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

## integrate.py — HEVL merge

- `merge_hevl_into_record(base_record, hevl_blocks)` → merged record
- `integrate_record(...)` → full integration with validation + ID rebuild
- `append_provenance(record, note)` → add to description
- `validate_component_combination(components, ...)` → (is_valid, reason)
- `determine_risk_data_types(base_types, hevl_flags)` → updated list

## validate_qa.py — Validation & QA

- `validate_and_score(records, schema, context)` → list of ScoredRecord
- `apply_autofixes(record, schema)` → auto-fixed record (5-pass engine)
- `compute_composite_confidence(record, context)` → 0.0–1.0
- `distribute_records(scored, thresholds, output_dir)` → tiered output
- `create_validation_report(scored)` → JSON summary
- `generate_validation_csv(scored)` → detailed CSV export

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
