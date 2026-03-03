# Climate Science Context

## Domain knowledge

This project works with climate and disaster risk data. Key concepts:

- **Hazard types**: coastal_flood, convective_storm, drought, earthquake, extreme_temperature, flood, landslide, strong_wind, tsunami, volcanic, wildfire
- **Process types**: Each hazard has specific processes (e.g., flood → fluvial_flood, pluvial_flood, flash_flood; drought → agricultural_drought, hydrological_drought, meteorological_drought)
- **Return periods**: Probabilistic hazard events expressed as 1-in-N year events (RP10, RP50, RP100, RP250, RP500, RP1000)
- **Climate scenarios**: SSP1-2.6, SSP2-4.5, SSP3-7.0, SSP5-8.5 (CMIP6); RCP2.6, RCP4.5, RCP6.0, RCP8.5 (CMIP5)
- **Time horizons**: baseline (historical), near-term (2030), mid-century (2050), end-century (2080/2100)

## Risk equation

Risk = f(Hazard, Exposure, Vulnerability). Loss/impact is the quantified outcome.

- **Hazard**: The physical event or phenomenon (what could happen)
- **Exposure**: People, assets, infrastructure in harm's way (what is at risk)
- **Vulnerability**: Susceptibility to damage (how badly affected)
- **Loss**: Modeled damage — monetary (USD) or non-monetary (casualties, displacement)

## Intensity measures

Common hazard intensity units:
- Flood: water depth (m), flow velocity (m/s)
- Earthquake: PGA (g), PGV (m/s), MMI, Sa (g)
- Wind: sustained wind speed (m/s, km/h, knots)
- Drought: SPI, SPEI, soil moisture deficit
- Temperature: degrees C, Wet-Bulb Globe Temperature (WBGT)
- Landslide: susceptibility index, factor of safety

## Data sources

Common climate/risk data sources:
- **CMIP6/CMIP5**: Global climate model outputs
- **ERA5**: ECMWF reanalysis (hourly, 0.25° resolution)
- **CHIRPS**: Rainfall estimates (daily, 0.05° resolution)
- **WorldPop**: Population distribution grids
- **OpenStreetMap**: Building footprints, infrastructure
- **EM-DAT**: Historical disaster events database
- **HDX**: Humanitarian Data Exchange (OCHA/UNOCHA)
- **GFDRR/World Bank**: Risk data, country assessments

## Conventions

- Always use ISO 8601 for dates (YYYY-MM-DD)
- Use ISO 3166-1 alpha-3 for country codes (AFG, BGD, ETH, etc.)
- Use SI units unless domain convention dictates otherwise
- Coordinate reference: WGS 84 (EPSG:4326) for geographic, appropriate UTM zone for projected
- Temperature in Celsius unless specified
