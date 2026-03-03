# Data Profile

Profile a dataset file and produce a concise summary.

## Input
$ARGUMENTS — path to a data file (CSV, JSON, GeoJSON, Parquet, Excel, NetCDF, GeoTIFF)

## Instructions

1. Detect the file format from the extension
2. Read the file and produce a profile:

**For tabular data (CSV, Excel, Parquet, JSON)**:
- Row count, column count
- Column names, dtypes
- Null counts per column
- Numeric columns: min, max, mean, median
- Categorical columns: unique count, top 5 values
- Date columns: min, max range

**For GeoJSON / GeoPackage**:
- Geometry type(s), feature count
- CRS (EPSG code)
- Bounding box (min/max lat/lon)
- Attribute columns summary (same as tabular)

**For NetCDF / Zarr**:
- Dimensions and their sizes
- Variables with dtype and dimensions
- Global attributes (title, source, conventions)
- Coordinate ranges (lat, lon, time)
- Any nodata/fill values

**For GeoTIFF**:
- Band count, dtype
- CRS (EPSG code)
- Resolution (pixel size in CRS units)
- Bounding box
- Nodata value
- Basic statistics per band (min, max, mean)

3. Present results as a clean markdown summary
4. Flag any data quality issues (excessive nulls, mixed types, invalid geometries, suspicious nodata)
