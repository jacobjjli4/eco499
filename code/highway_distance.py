import pandas as pd
import geopandas as gpd
from shapely.geometry import Point, LineString
import matplotlib.pyplot as plt

import os
os.chdir("/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/")

df = pd.read_csv("./data/raw/highways.csv")
df["from"] = [Point(point) for point in zip(df['x1'], df['y1'])]
df["to"] = [Point(point) for point in zip(df['x2'], df['y2'])]
df['line'] = df.apply(lambda row: LineString([row['from'], row['to']]), axis=1)

# use projfinder to find the CRS of the Baum-Snow dataset (NAD27)
gdf = gpd.GeoDataFrame(df, geometry=df['line'], crs=4267)

distances = gpd.sjoin_nearest(tracts, highways, how = 'left', distance_col = 'distance')
distances = distances.drop_duplicates(subset=['STATEFP', 'COUNTYFP', 'TRACTCE'])