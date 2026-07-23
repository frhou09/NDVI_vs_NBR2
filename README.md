# NDVI_vs_NBR:Assessing Post-Fire Vegetation Recovery Monitoring at Hermits Peak 

This project compares NDVI (Normalized Difference Vegetation Index) and NBR (Normalized Burn Ratio) trajectories over time to evaluate how well NDVI alone measures post-fire recovery after the Hermits Peak/Calf Canyon fire of 2022. 

Included in this repository is my NDVI/NBR calculation script (under NDVI_NBRcode.py), my NDVI-NBR difference maps by year, my Raster Histographs generated in QGIS by year, and my point analysis scattergrams by year (all that is listed above, excluding NDVI_NBRcode.py, can be found under the file named To Show). Due to size, my original downloaded Landsat scenes and the NDVI/NBR maps I generated using the script included, are not linked in this repository. 


# Background
The Hermits Peak/Calf Canyon fire of 2022 is the largest wildfire in New Mexico history, burning approximately 342,000 acres and over 900 structures. 

Post-fire forest regrowth monitoring is an important component of managing forest recovery as it serves as a guide for post-disturbance management of burn scars. In the recent decade, remote sensing (RS) technology has been increasingly incorporated into this monitoring process as a cost-effective and streamlined resource.

The Santa Fe Forest Reserve, responsible for the Hermits Peak/Calf Canyon fire management, primarily uses Normalized Difference Vegetation Index (NDVI) as their sole source of recovery data. NDVI is defined as a graphical indicator that is used to assess vegetation health and density via near-infrared reflectance and red light absorption values. The range is from +1, as in healthy, dense vegetation, and -1, as in bodies of water. Although NDVI serves as the most commonly used proxy of post-fire regrowth, it has a tendency to overshoot forest recovery rate by reaching full saturation levels before genuine canopy and ecosystem recovery.

There is general consensus that, due to this inability to portray structural recovery of forest canopy, NDVI alone is not an optimal tool for monitoring post-fire regeneration. Instead, a more comprehensive view of vegetation recovery can be achieved when NDVI is used alongside other data including field data and similar fire severity indexes such as Normalized Burn Ratio (NBR). Slightly differing from NDVI, NBR is an index primarily constructed to highlight burnt areas from active or recent wildfires, though it is also used for assessing more long-term post-fire vegetation regrowth. 

# Research Question: 
Given that the Santa Fe National Forest relies soley on NDVI to assess post-fire vegetation recovery, how might recovery assessments differ if NBR was used along with the existing metrics? 


# Data Source and Information

Data Source: Landsat 8/9 Collection 2 Level-2 Surface from USGS Explorer

Landsat Path/Row: 033/035

Timeframe: May of 2021–2026 

Location: Hermits Peak–Calf Canyon Fire burn scar, Santa Fe National Forest, New Mexico
  Burn Scar shapefile aquired from:
    https://burnseverity.cr.usgs.gov/baer/baer-imagery-support-data-download/2022/hermits-peak 


# Methodology

1. Data acquisition —Downloaded low-cloud-cover (<15%) Landsat scenes for years 2021-2026 for path/row 033/035 using usgsxplore.
2. Index calculation (Python) — Calculated NDVI and NBR from Red (Band 4), NIR (Band 5), and SWIR2 (Band 7) surface reflectance bands using rasterio and numpy: 
    NDVI = (NIR - Red) / (NIR + Red)
    NBR = (NIR - SWIR2) / (NIR + SWIR2)
3. Visualization and spatial analysis (QGIS) — Loaded NDVI/NBR outputs into QGIS (open source and free to use GIS desktop program for calculation, visualization, and analysis of geospatial information) to: 
  Colorize and create visual NDVI and NBR maps
  Generate difference maps (NDVI − NBR)
  Calculate Pearson correlation between NDVI and NBR per year
  Generate Raster Histographs
  Sample random points within burn scar for point-based comparison + generate scattergram


# Tools and Libraries
- Python 3.12---rasterio, numpy
- QGIS (open sourced, free GIS program)---Raster Calculator, Raster Layer Statistcs, Random Points in Layer, DataPlotly
- LaTex

# Limitations
- Limited Statistical Power: One month per year may be too small of a sample size. The project could possibly benefit from multiple data periods per year. 
- Seasonal Noise: The same time of year can vary in climate and rainfall. A wet spring in 2021 compared to a dry spring in 2022 will change baseline vegetation reflection regardless of fire damage.
- NBR Reliability as the "Comparison Index": While NBR is generally more preferable compared to NDVI in post-fire monitering, it is still not an accurate "pillar" of NIR-based indexes, perhaps a different index would provide higher accuracy. 

  
Francine Hou, July 2026

This project was completed as part of a research internship with the Institute for Computing in Research. 


