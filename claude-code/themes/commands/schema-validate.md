# Schema Validate

Validate a JSON/YAML data file against a JSON Schema.

## Input
$ARGUMENTS — two paths: `<data-file> <schema-file>`, or just `<data-file>` if schema path is known from project context

## Instructions

1. Load the data file (JSON or YAML)
2. Load the JSON Schema file
3. Validate using `jsonschema` library
4. Report results:

**If valid**:
- Confirm the file passes validation
- List any optional fields that are missing but recommended

**If invalid**:
- List each validation error with:
  - JSON path to the error (e.g., `$.datasets[0].spatial.countries`)
  - What was expected vs what was found
  - Suggested fix
- Group errors by type (missing required, wrong type, invalid enum value, pattern mismatch)
- Prioritize: required field errors first, then type errors, then format errors

5. If the schema uses `$ref` or external references, note which refs were resolved and which failed.
