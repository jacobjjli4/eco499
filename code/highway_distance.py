import pandas as pd
import geopandas as gpd
from shapely.geometry import Point, LineString
from shapely.validation import make_valid, explain_validity
import matplotlib.pyplot as plt

import os
os.chdir("/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/")

# highway dataset
highways = pd.read_csv("./data/raw/highways.csv")
highways["from"] = [Point(point) for point in zip(highways['x1'], highways['y1'])]
highways["to"] = [Point(point) for point in zip(highways['x2'], highways['y2'])]
highways['line'] = highways.apply(lambda row: LineString([row['from'], row['to']]), axis=1)

# used projfinder to find the CRS of the highway dataset (NAD27)
highways_gdf = gpd.GeoDataFrame(highways, geometry=highways['line'], crs=4267)

# county dataset
counties = gpd.read_file("./data/raw/nhgis_tl2010_counties/US_county_2010.shp")
counties = counties.to_crs(4267)

# deal with invalid geometries
highways_gdf_invalid = highways_gdf[~highways_gdf.is_valid]
highways_gdf = highways_gdf[highways_gdf.is_valid] # delete invalid highway geometries
explain_validity(counties[~counties.is_valid]['geometry']) # check for invalid geometries
counties['geometry'] = counties['geometry'].apply(make_valid)
explain_validity(counties[~counties.is_valid]['geometry']) # should be empty

# overlay to get highways per county
counties2 = counties.loc[counties['NAME10'] == "Cook"]
gpd.overlay(highways_gdf, counties)


distances = gpd.sjoin_nearest(tracts, highways, how = 'left', distance_col = 'distance')
distances = distances.drop_duplicates(subset=['STATEFP', 'COUNTYFP', 'TRACTCE'])