# Geospatial Context

## Coordinate Reference Systems

- **Geographic**: WGS 84 (EPSG:4326) — lat/lon in degrees. Default for exchange formats.
- **Projected**: UTM zones, national grids, web mercator (EPSG:3857). Use for area/distance calculations.
- Always check and document CRS. Never assume EPSG:4326.
- Use `pyproj` or `rasterio.crs` for CRS operations, not manual PROJ strings.

## Raster data

**Formats**: GeoTIFF (.tif), Cloud Optimized GeoTIFF (COG), NetCDF (.nc), GRIB (.grib2), HDF5 (.h5), Zarr

**Libraries** (prefer in this order):
- `rasterio` — reading/writing GeoTIFF, COG, general raster I/O
- `xarray` + `rioxarray` — multi-dimensional arrays (NetCDF, Zarr, GRIB), labeled dimensions
- `rasterstats` — zonal statistics (raster + vector)
- `h5py` — raw HDF5 access when xarray doesn't fit

**Conventions**:
- Use COG for cloud-hosted rasters
- NetCDF/Zarr for multi-dimensional climate data (time × lat × lon × variable)
- Check nodata values — common: -9999, -3.4e38, NaN
- Resolution: expressed as degrees (0.25°, 0.05°) or meters (30m, 90m, 1km)

## Vector data

**Formats**: GeoJSON, GeoPackage (.gpkg), Shapefile (.shp), FlatGeobuf (.fgb), KML, File Geodatabase

**Libraries**:
- `geopandas` — primary vector library (read/write/analyze)
- `shapely` — geometry operations
- `fiona` — low-level vector I/O (used by geopandas)

**Conventions**:
- Prefer GeoPackage over Shapefile (no 10-char column limit, no multi-file mess)
- GeoJSON for web/API exchange (always WGS 84)
- Always validate geometries before spatial operations (`gdf.is_valid`)

## Spatial operations

Common operations and the right tool:
- **Spatial join**: `geopandas.sjoin()` — point-in-polygon, intersects
- **Buffer**: `gdf.buffer(distance)` — use projected CRS for metric buffers
- **Zonal stats**: `rasterstats.zonal_stats()` — aggregate raster values by polygon
- **Rasterize/vectorize**: `rasterio.features`
- **Reproject**: `gdf.to_crs()` for vector, `rasterio.warp.reproject()` for raster
- **Clip**: `geopandas.clip()` or `rasterio.mask.mask()`

## Web services & catalogs

- **STAC**: SpatioTemporal Asset Catalog — use `pystac-client` for searching, `stackstac` for loading
- **OGC Services**: WMS, WFS, WCS — access via `owslib`
- **GeoNode**: REST API for catalog search and data download
- **HDX/CKAN**: `ckanapi` or `requests` for metadata crawling

## Common pitfalls

- Mixing CRS without reprojecting → wrong distances/areas
- Using geographic CRS (degrees) for area calculations → wildly wrong results
- Ignoring nodata values → corrupted statistics
- Large vector files in GeoJSON → use GeoPackage or Parquet instead
- Shapefile column name truncation → silent data loss
