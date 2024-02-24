/*******************************************************************************
Title:          Load population data at county level and merge at CZ level
Author:         Jia Jun (Jacob) Li
Contact:        li.jiajun@hotmail.com
Date Created:   February 14, 2024
Date Modified:  February 24, 2024
*******************************************************************************/

clear all
set linesize 240
global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

* Load raw data
quietly infix                 ///
    str     gisjoin    1-8      ///
    str     state      9-31     ///
    str     statefp    32-33    ///
    str     statenh    34-36    ///
    str     county     37-90    ///
    str     countyfp   91-93    ///
    str     countynh   94-97    ///
    double  a00aa1900  98-108   ///
    double  a00aa1910  109-119  ///
    double  a00aa1920  120-130  ///
    double  a00aa1930  131-141  ///
    double  a00aa1940  142-152  ///
    double  a00aa1950  153-163  ///
    double  a00aa1960  164-174  ///
    using "$root/data/raw/ts_nominal_county.dat"


format a00aa1900 %11.0f
format a00aa1910 %11.0f
format a00aa1920 %11.0f
format a00aa1930 %11.0f
format a00aa1940 %11.0f
format a00aa1950 %11.0f
format a00aa1960 %11.0f

label var gisjoin   `"GIS Join Match Code"'
label var state     `"NHGIS Integrated State Name"'
label var statefp   `"FIPS State Code"'
label var statenh   `"NHGIS Integrated State Code"'
label var county    `"NHGIS Integrated County Name"'
label var countyfp  `"FIPS County Code"'
label var countynh  `"NHGIS Integrated County Code"'
label var a00aa1900 `"1900: Persons: Total"'
label var a00aa1910 `"1910: Persons: Total"'
label var a00aa1920 `"1920: Persons: Total"'
label var a00aa1930 `"1930: Persons: Total"'
label var a00aa1940 `"1940: Persons: Total"'
label var a00aa1950 `"1950: Persons: Total"'
label var a00aa1960 `"1960: Persons: Total"'

* reshape data to long format for merge
reshape long a00aa, i(statenh countynh) j(year) 

* DATA CLEANING
* drop population counts after 1950
keep if year <= 1950

* drop county-years with no population counts
drop if a00aa == .

* remove Alaska and Hawaii
drop if (state == "Alaska")|(state == "Hawaii")| ///
    (state == "Alaska Territory")|(state == "Hawaii Territory")

* crosswalk to CZ level
merge 1:m year statenh countynh using ///
    "$root/data/derived/covariates/cnty_cz_crosswalk.dta", ///
    keep(match) nogenerate

collapse (sum) a00aa [iw = weight], by(cz year)

* clean up the data format for file size
replace a00aa = round(a00aa)
recast long a00aa
rename a00aa population
label variable population ""

* reshape population to wide to use as regression covariates
reshape wide population, i(cz) j(year)

* Recast CZ as str for merging with master dataset
tostring cz, replace
replace cz = "00" + cz if strlen(cz) == 3
replace cz = "0" + cz if strlen(cz) == 4

save "$root/data/derived/covariates/population_1900_1950_cz.dta", replace
