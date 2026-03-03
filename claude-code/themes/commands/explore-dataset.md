# Explore Dataset

Quick exploration of an unfamiliar dataset — understand structure, content, and quality before working with it.

## Input
$ARGUMENTS — path to a file or directory containing data files

## Instructions

1. If a directory is given, list all data files and pick the most important ones (by size, format, or name)
2. For each key file:
   - Detect format and read metadata/header
   - Show first few records or a sample
   - Summarize the schema/structure
   - Identify what this data represents (hazard? exposure? vulnerability? loss? reference?)

3. Produce a summary:
   - **What**: What does this dataset contain?
   - **Coverage**: Spatial extent (countries/regions), temporal range
   - **Format**: File format, size, record count
   - **Quality**: Completeness, obvious issues
   - **Suggestion**: How this data could be used or what processing it needs

4. If multiple related files exist, explain how they connect (e.g., "hazard footprints + exposure building inventory → can compute loss estimates")
