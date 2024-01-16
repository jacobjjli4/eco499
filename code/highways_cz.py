import pandas as pd
import geopandas as gpd
import os 
import matplotlib.pyplot as plt
from geopy import distance

root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"
os.chdir(root)

# read highway plan
highways = gpd.read_file("./data/raw/1947-Interstate-Highway-Plan/1947plan.shp")
highways.crs
highways = highways.to_crs(4326)
highways.plot(aspect=1)

# read commuting zones
cz = gpd.read_file("./data/raw/cz1990_shapefile/cz1990.shp")
cz.crs
cz.plot()

# plot highway and cz together
fig, ax = plt.subplots(1, 1)
cz.plot(ax=ax)
highways.plot(ax=ax, edgecolor='red', aspect=1)
plt.show()

# break up highway into cz
overlay = gpd.overlay(highways,cz,how="intersection")
overlay = overlay.drop(columns = 'Shape_Leng')

# calculate length of highway using Vincenty's formula
def line_length(myline):
    """Calculate length of a line in meters, given in geographic coordinates.
    Args:
        line: a shapely LineString object with WGS 84 coordinates
    Returns:
        Length of line in meters
    
    Source:
        https://gis.stackexchange.com/a/115285
    """
    # Swap shapely (lonlat) to geopy (latlon) points
    latlon = lambda lonlat: (lonlat[1], lonlat[0])
    total_length = sum(distance.distance(latlon(a), latlon(b)).meters
                    for (a, b) in pairs(myline.coords))
    return round(total_length, 0)

def pairs(lst):
    """Iterate over a list in overlapping pairs without wrap-around.

    Args:
        lst: an iterable/list

    Returns:
        Yields a pair of consecutive elements (lst[k], lst[k+1]) of lst. Last 
        call yields the last two elements.

    Example:
        lst = [4, 7, 11, 2]
        pairs(lst) yields (4, 7), (7, 11), (11, 2)

    Source:
        https://stackoverflow.com/questions/1257413/1257446#1257446
    """
    i = iter(lst)
    prev = next(i)
    for item in i:
        yield prev, item
        prev = item

# measure length by cz
overlay_exploded = overlay.explode() # explode MultiLineStrings into LineStrings
overlay_exploded = overlay_exploded.loc[~overlay_exploded.is_empty]
overlay_exploded['length'] = overlay_exploded['geometry'].apply(line_length)
overlay_exploded.plot()

# export to CSV
overlay_exploded = overlay_exploded[['cz', 'length']]
overlay_exploded = overlay_exploded.reset_index(drop = True)

overlay_exploded.to_csv("./data/derived/highways_cz.csv")
