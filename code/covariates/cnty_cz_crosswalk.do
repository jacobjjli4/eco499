/*******************************************************************************
Title:          Load county to CZ crosswalk data
Author:         Jia Jun (Jacob) Li
Contact:        li.jiajun@hotmail.com
Date Created:   February 24, 2024
Date Modified:  February 24, 2024
*******************************************************************************/

clear all
set linesize 240
global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

import delimited using "$root/data/raw/eglp_cz_crosswalk_endyr_1990.csv", ///
    stringcols(2/3) clear

keep year nhgisst nhgiscty cz weight
* rename for consistency with IPUMS NHGIS data for merging purposes
rename nhgisst statenh
rename nhgiscty countynh

save "$root/data/derived/covariates/cnty_cz_crosswalk.dta", replace