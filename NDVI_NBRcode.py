import os
import glob
import rasterio
import numpy as np


#Using glob to find bands
scene = ["/home/francine/hermits_peak_data/raw_scenes/LC08_L2SP_033035_20210527_20210607_02_T1","/home/francine/hermits_peak_data/raw_scenes/LC08_L2SP_033035_20220530_20220609_02_T1","/home/francine/hermits_peak_data/raw_scenes/LC09_L2SP_033035_20230509_20230511_02_T1",
"/home/francine/hermits_peak_data/raw_scenes/LC09_L2SP_033035_20240527_20240528_02_T1","/home/francine/hermits_peak_data/raw_scenes/LC09_L2SP_033035_20250530_20250531_02_T1","/home/francine/hermits_peak_data/raw_scenes/LC09_L2SP_033035_20260517_20260518_02_T1"]
for path in scene:

b4_path = glob.glob(f"{path}/*_02_T1_SR_B4.TIF")
b5_path = glob.glob(f"{path}/*_02_T1_SR_B5.TIF")
b7_path = glob.glob(f"{path}/*_02_T1_SR_B7.TIF")


#opening the bands
with rasterio.open(b4_path [0])as b4_src, \
    rasterio.open(b5_path [0])as b5_src, \
    rasterio.open(b7_path [0])as b7_src:  

#Copy b5 map coordinates into meta clone
    meta=b5_src.meta.copy()

    b4 = b4_src.read(1).astype('float32')
    b5 = b5_src.read(1).astype('float32')
    b7 = b7_src.read(1).astype('float32')

#NDVI calculation
    NDVI = (b5 - b4)/(b5 + b4)

#NBR calculation
    NBR = (b5 - b7)/(b5 + b7)


#Save as single layer map
meta.update(dtype=rasterio.float32, count=1)


#Save as TIF
with rasterio.open(f"{path}/output_NDVI.tif", 'w', **meta) as dst_NDVI:
        dst_NDVI.write(NDVI, 1)

with rasterio.open(f"{path}/output_NBR.tif", 'w', **meta) as dst_NBR:
        dst_NBR.write(NBR, 1)










