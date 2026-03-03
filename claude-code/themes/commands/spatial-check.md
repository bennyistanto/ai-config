# Spatial Check

Validate spatial data for common issues.

## Input
$ARGUMENTS — path to a spatial file (GeoJSON, GeoPackage, Shapefile, GeoTIFF, NetCDF)

## Instructions

1. Read the file and check for these issues:

**For vector data**:
- CRS defined? What EPSG code?
- Invalid geometries (self-intersections, null geometries)
- Empty features (geometry exists but no attributes)
- Bounding box — does it look reasonable for the expected region?
- Duplicate geometries
- Mixed geometry types in a single layer

**For raster data**:
- CRS defined? What EPSG code?
- Nodata value set? Are there nodata pixels?
- Resolution consistent (square pixels vs rectangular)?
- Bounding box — does it look reasonable?
- Any bands with all-nodata or all-same-value?
- Data type appropriate for the values (e.g., float32 for continuous, uint8 for classified)

2. Produce a checklist-style report:
   - [PASS] or [WARN] or [FAIL] for each check
   - Brief explanation for any WARN/FAIL items
   - Suggested fix where applicable

3. If the file path includes a country name or ISO code, verify the bounding box falls within that country's extent.
