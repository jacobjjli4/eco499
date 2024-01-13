import pandas as pd
import geopandas as gpd
import os 

root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"
os.chdir(root)

highways = gpd.read_file("./data/raw/1947-Interstate-Highway-Plan/1947plan.shp")
highways.crs
highways = highways.to_crs(4326)

cz = gpd.read_file("./data/raw/cz1990_shapefile/cz1990.shp")
cz.crs

