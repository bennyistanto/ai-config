# Agriculture Context

## Domain knowledge

This project involves agricultural data in the context of food security, climate adaptation, and disaster risk. Key concepts:

### Exposure categories (RDLS-aligned)
- **Agriculture**: cropland, livestock, fisheries/aquaculture, forestry
- Metrics: area (hectares), production (tonnes), yield (tonnes/ha), livestock count (heads)

### Agricultural hazards
- **Drought**: agricultural drought (soil moisture deficit), meteorological drought (rainfall deficit)
- **Flood**: crop inundation, waterlogging
- **Extreme temperature**: heat stress on crops/livestock, frost damage
- **Pest/disease**: locust outbreaks, crop disease (not in RDLS hazard taxonomy but relevant context)
- **Strong wind**: crop lodging, infrastructure damage

### Key datasets
- **FAOSTAT**: Production, trade, food balance sheets by country/year
- **SPAM (Spatial Production Allocation Model)**: Crop production maps at ~10km resolution
- **CropWatch**: Remote sensing crop monitoring
- **NDVI/EVI**: Vegetation indices from MODIS, Sentinel-2, Landsat
- **CHIRPS**: Rainfall estimates for agricultural drought monitoring
- **SPI/SPEI**: Standardized drought indices
- **IPC/CH**: Integrated Food Security Phase Classification

### Crop calendars & seasons
- Planting, growing, harvesting seasons vary by crop, latitude, and climate zone
- Data often aggregated by crop calendar year, not calendar year
- Key crops: maize, rice, wheat, sorghum, millet, cassava, beans, groundnut

## Conventions

- Area in hectares (ha) or square kilometers (km²)
- Production in metric tonnes
- Yield in tonnes per hectare (t/ha)
- Livestock in heads (cattle, sheep, goats, poultry)
- Monetary values in USD unless specified
- Food security indicators: prevalence of undernourishment (%), food consumption score
