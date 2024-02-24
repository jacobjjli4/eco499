/*******************************************************************************
Description:    Load urban population data at county level and merge at CZ level
Author:		    Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	February 24, 2024
Date Modified:	February 24, 2024
*******************************************************************************/

clear all
set linesize 240
global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

* Load data files for each year
local files : dir "$root/code/covariates/load_urban_population" files "*.do"
foreach file of local files {
    do "$root/code/covariates/load_urban_population/`file'"
    capture append using "$root/data/temp/urban_population.dta"
    save "$root/data/temp/urban_population.dta", replace
}
erase "$root/data/temp/urban_population.dta"

*