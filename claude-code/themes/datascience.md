# Data Science Context

## Python stack

### Core libraries
- `pandas` — tabular data (CSV, Excel, Parquet)
- `numpy` — numerical arrays
- `geopandas` — spatial dataframes
- `xarray` — multi-dimensional labeled arrays (NetCDF, Zarr)
- `rasterio` / `rioxarray` — raster I/O
- `scipy` — statistical functions
- `scikit-learn` — ML models, preprocessing

### Validation & schema
- `jsonschema` — JSON Schema validation
- `pydantic` — data validation with Python types
- `pandera` — DataFrame schema validation
- `pyyaml` — YAML config loading

### Visualization
- `matplotlib` — base plotting
- `seaborn` — statistical visualization
- `plotly` — interactive charts
- `folium` / `leafmap` — interactive maps
- `contextily` — basemaps for static maps

### Environment
- Python 3.10+
- Prefer `conda`/`mamba` for environments with geospatial C dependencies (GDAL, PROJ, GEOS)
- `pip` for pure Python packages
- Jupyter Lab for notebook-based exploration

## Coding conventions

### Style
- Type hints on all function signatures
- Dataclasses for structured data (not plain dicts)
- Docstrings for public functions (brief: one line purpose, params, returns)
- f-strings for string formatting
- `pathlib.Path` for file paths, not string concatenation

### Patterns
- Config-driven: externalize parameters to YAML/JSON, not hardcoded
- Separation of concerns: I/O, processing, validation in separate modules
- Atomic file writes: write to temp file, then rename (prevents corrupt output)
- Return `(result, errors)` tuples for validation functions
- Use `logging` module, not print statements (except in notebooks)

### Data pipeline conventions
- Each processing step reads input, produces output, logs summary
- Intermediate outputs saved for auditability and debugging
- Processing state tracked in CSV/JSON manifests
- Progress bars with `tqdm` for long operations

### Notebook conventions
- Numbered sequentially: `01_crawl.ipynb`, `02_filter.ipynb`, etc.
- Each notebook: single purpose, documented inputs/outputs
- Reusable logic extracted to `.py` modules, not duplicated across notebooks
- Notebooks are for orchestration and exploration; modules are for logic

## File format preferences

| Use case | Format | Library |
|----------|--------|---------|
| Tabular exchange | CSV | pandas |
| Tabular fast I/O | Parquet | pandas / pyarrow |
| Spatial vector | GeoPackage | geopandas |
| Spatial web | GeoJSON | geopandas |
| Raster single-band | GeoTIFF / COG | rasterio |
| Raster multi-dim | NetCDF / Zarr | xarray |
| Config | YAML | pyyaml |
| Schema/metadata | JSON | json / jsonschema |
| Streaming records | JSON Lines (.jsonl) | json |

## Common pitfalls

- Loading entire large files into memory — use chunked reading or Dask
- Silent dtype coercion in pandas (int → float when NaN present)
- Timezone-naive datetime comparisons
- Forgetting to close file handles (use context managers)
- Modifying a DataFrame slice without `.copy()` → SettingWithCopyWarning
