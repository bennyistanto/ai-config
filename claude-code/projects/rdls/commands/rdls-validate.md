# RDLS Validate

Validate one or more RDLS records against the RDLS v0.3 JSON Schema.

## Input
$ARGUMENTS — path to a JSON file (single record or array) or a directory of JSON files

## Instructions

1. Locate the RDLS schema. Check these locations in order:
   - `to-rdls/configs/rdls_schema.yaml` (project schema config)
   - `{output_dir}/rdls/schema/` or `to-rdls/schema/` (schema directory)
   - Ask the user if not found

2. Load and validate each record. For each, check:
   - **Schema compliance**: All required fields present, correct types, valid enum values
   - **Codelist compliance**: `hazard_type`, `process_type`, `exposure_category`, `risk_data_type` match closed codelists
   - **Constraint compliance**: process_type matches hazard_type, metric_dimension valid for exposure_category
   - **Completeness**: Which optional but recommended fields are missing

3. Report results:
   - Total records checked, valid count, invalid count
   - For invalid records: list each error with JSON path, expected vs actual
   - Group errors by category (missing required, invalid enum, constraint violation, type mismatch)
   - Suggest specific fixes for each error

4. If validating a directory, produce a summary table:
   | File | Valid | Errors | Top Issue |
