# README for code files
The `code` directory contains all code to clean, merge, and analyze the data. `code/build.do` will automatically run the files in the following order:
* `clean.do`: Clean the major datasets for the project (highway openings, highway plan, and Opportunity Atlas) and prepare them for merge.
* `merge.do`: Merge the three datasets on the commuting zone level.
* `highway_growth.do`: Generates measures of highway growth over time for a long difference regression (instead of having observations for every year).
* `pctile_to_dollar.do`: Crosswalk the Opportunity Atlas's reported income percentiles to 2015 dollars.
* `summary_statistics.do`: Generate summary statistics.
* `explore.do`: Exploratory data analysis.