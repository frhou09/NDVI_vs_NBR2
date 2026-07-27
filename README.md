# NDVI_vs_NBR:Assessing Post-Fire Vegetation Recovery Monitoring at Hermits Peak 

This project compares NDVI (Normalized Difference Vegetation Index) and NBR (Normalized Burn Ratio) trajectories over time to evaluate how well NDVI alone measures post-fire recovery after the Hermits Peak/Calf Canyon fire of 2022. 

Included in this repository is my NDVI/NBR calculation script (under NDVI_NBRcode.py), my NDVI-NBR difference maps by year (labled Difference...image.pdf), my Raster Histograms generated in QGIS by year (Histogram.._ndvi.png), and my point analysis scattergrams by year (point....plot.png). All that is listed above, excluding NDVI_NBRcode.py, can be found under the file named To Show. Due to size, my original downloaded Landsat scenes and the NDVI/NBR maps I generated using the script (NDVI_NBRcode.py) are not linked in this repository. 


# Background
The Hermits Peak/Calf Canyon fire of 2022 is the largest wildfire in New Mexico history, burning approximately 342,000 acres and over 900 structures. 

Post-fire forest regrowth monitoring is an important component of managing forest recovery as it serves as a guide for post-disturbance management of burn scars. In the recent decade, remote sensing (RS) technology has been increasingly incorporated into this monitoring process as a cost-effective and streamlined resource.

The Santa Fe Forest Reserve, responsible for the Hermits Peak/Calf Canyon fire management, primarily uses Normalized Difference Vegetation Index (NDVI) as their sole source of recovery data. NDVI is defined as a graphical indicator that is used to assess vegetation health and density via near-infrared reflectance and red light absorption values. The range is from +1, as in healthy, dense vegetation, and -1, as in bodies of water. Although NDVI serves as the most commonly used proxy of post-fire regrowth, it has a tendency to overshoot forest recovery rate by reaching full saturation levels before genuine canopy and ecosystem recovery.

There is general consensus that, due to this inability to portray structural recovery of forest canopy, NDVI alone is not an optimal tool for monitoring post-fire regeneration. Instead, a more comprehensive view of vegetation recovery can be achieved when NDVI is used alongside other data including field data and similar fire severity indexes such as Normalized Burn Ratio (NBR). Slightly differing from NDVI, NBR is an index primarily constructed to highlight burnt areas from active or recent wildfires, though it is also used for assessing more long-term post-fire vegetation regrowth. 

# Research Question: 
Given that the Santa Fe National Forest relies soley on NDVI to assess post-fire vegetation recovery, how might recovery assessments differ if NBR was used along with the existing metrics? 


# Data Source and Information

Data Source: Landsat 8/9 Collection 2 Level-2 Surface from USGS Explorer
  
  Simply access and download the data from the official website: https://earthexplorer.usgs.gov/

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

  a. Colorizing and Creating Visual NDVI and NBR Maps
 - Open Symbology:Right-click raster layer (e.g., NDVI_2021) in the Layers panel and select Properties.
 - Select the Symbology tab on the left.
 - Set Render Type: Change the Render type dropdown from Singleband gray to Singleband pseudocolor.
 - Choose Color Ramp:For NDVI, click the Color ramp dropdown, choose a preset like RdYlGn (Red-Yellow-Green), or for NBR, YlOrRd.
 -  Click Apply and OK.


  b. Generating Difference Maps ($\text{NDVI} - \text{NBR}$)
- At the menu bar, select Raster, then Raster Calculator
- Write the equation into the expression box:$$\text{Difference} = "NDVI\_2022@1" - "NBR\_2022@1"$$Set Output Parameters:Click ... next to Output layer to name and save the file (e.g., NDVI_minus_NBR_2022.tif).Ensure the Output format is set to GeoTIFF.Run Calculation:Click OK. QGIS will calculate the pixel-by-pixel difference and automatically add the new raster layer to your map.Apply a Singleband pseudocolor symbology to highlight areas where greenness and moisture diverge significantly.3. Calculating Pearson Correlation Between NDVI and NBR Per YearTo calculate spatial correlation across pixels between two rasters, use the built-in processing tool.Step-by-Step:Open the Processing Toolbox panel (Processing $\rightarrow$ Toolbox or press Ctrl + Alt + T).Search for the tool Layer statistics or Raster layer zonal statistics. Alternatively, search for Raster layer correlation (or Layer correlations).Configure Tool:Rasters: Select both NDVI_2022 and NBR_2022.The tool generates a correlation matrix displaying the Pearson correlation coefficient ($r$) between the two layers across all overlapping non-null pixels.Alternative via Python Console in QGIS:Open Plugins $\rightarrow$ Python Console.You can load both rasters using gdal or rasterio inside QGIS to compute numpy.corrcoef() if you want the exact numerical value exported to a report.4. Generating Raster HistogramsHistograms show the statistical distribution of pixel values across your burn scar.Step-by-Step:Right-click your raster layer (e.g., NBR_2022) $\rightarrow$ Properties.Select the Histogram tab on the left panel.Click the Compute Histogram button at the bottom right.Interpreting & Exporting:QGIS will plot the distribution curve showing the count of pixels vs. index values (e.g., showing a leftward shift toward negative values post-fire).Click the Save/Export icon on the histogram toolbar to save the chart as an image (.png or .pdf) for your paper.5. Sampling Random Points within the Burn ScarTo extract pixel values for statistical modeling, you generate random points within the BAER perimeter and sample underlying raster values.Step 1: Generate Random Points inside the PerimeterGo to Vector $\rightarrow$ Research Tools $\rightarrow$ Random Points Inside Polygon.Parameters:Input Layer: Select your BAER burn scar perimeter shapefile/GeoJSON.Sampling Strategy: Set to Point count.Number of points: Enter 500.Minimum distance between points: Set a threshold (e.g., 30 meters) to avoid sampling adjacent, duplicate pixels.Click Run. A new vector point layer will appear on your map screen.Step 2: Sample Raster Values at Each PointOpen the Processing Toolbox (Ctrl + Alt + T).Search for Sample raster values.Parameters:Input Layer: Your layer of 500 random points.Raster Layer(s): Click the ... menu and check all raster layers you want to sample (e.g., NDVI_2021, NDVI_2022, ..., NBR_2021, NBR_2022).Output Column Prefix: Set a prefix like val_.Click Run.Export to CSV:Right-click the output point layer $\rightarrow$ Export $\rightarrow$ Save Features As...Set Format to Comma Separated Values [CSV].Save the file as sampled_points_2021_2026.csv.6. Generating ScattergramsA scattergram plots pixel-level NDVI values against NBR values to visualize their linear relationship.Option A: Using the Data Plotly Plugin in QGISGo to Plugins $\rightarrow$ Manage and Install Plugins...Search for and install Data Plotly.Open the Data Plotly panel on the right sidebar.Configuration:Plot type: Select Scatter Plot.Layer: Select your Sampled Points layer (from Section 5).X Field: Select val_NBR_2022.Y Field: Select val_NDVI_2022.Marker Size / Color: Customize markers as desired.Click Create Plot.

  - Colorize and create visual NDVI and NBR maps
  - Generate difference maps (NDVI − NBR)
  - Calculate Pearson correlation between NDVI and NBR per year
  - Generate Raster Histographs
  - Sample random points within burn scar for point-based comparison + generate scattergram

# Tools and Libraries
- Python 3.12---rasterio, numpy
- QGIS (open sourced, free GIS program)---Raster Calculator, Raster Layer Statistcs, Random Points in Layer, DataPlotly

# QGIS Installation (linux)

```bash
sudo apt update
```


```bash
sudo apt install qgis
```


```bash
qgis
```

The rest of the tools in QGIS are easily accesible using the built-in help features as well as through Youtube or blog tutorials.

# Analysis
Difference...image.pdf 
- Difference graphs of NDVI-NBR. Green represents positive (NDVI>NBR) areas, pink vice versa (NDVI<NBR), and white equal (NDVI=NBR).

Histogram.._ndvi.png
- Raster Histogram that showcases the distribution of NDVI or NBR values across the burn scar area.
  
point....plot.png
- Random sample point analysis generated using 500 random points on the burn scar area. The respective NDVI and NBR is calculated for each point and charted on a scattergram for each year (2021-2026).  

# Limitations
- Limited Statistical Power: One month per year may be too small of a sample size. The project could possibly benefit from multiple data periods per year. 
- Seasonal Noise: The same time of year can vary in climate and rainfall. A wet spring in 2021 compared to a dry spring in 2022 will change baseline vegetation reflection regardless of fire damage.
- NBR Reliability as the "Comparison Index": While NBR is generally more preferable compared to NDVI in post-fire monitering, it is still not an accurate "pillar" of NIR-based indexes, perhaps a different index would provide higher accuracy.
- Scale: Due to inherent differences in design and purpose, NDVI and NBR have different value scales. This is a problem when we are creating a direct comparison, especially in the Histograms and Scattergrams. 

  
Francine Hou, July 2026

This project was completed as part of a research internship with the Institute for Computing in Research. 


