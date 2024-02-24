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

* Data cleaning
drop if urban_population == .
drop if urban_population == 0

* Crosswalk to CZ level
rename statea statenh
rename countya countynh
destring(year), replace

merge 1:m year statenh countynh using ///
    "$root/data/derived/covariates/cnty_cz_crosswalk.dta", /// 
    assert(match using) keep(match) nogenerate

collapse (sum) urban_population [iw = weight], by(cz year)

* reshape urban population to wide to use as regression covariates
reshape wide urban_population, i(cz) j(year)

* recast CZ to str for merging with master dataset
tostring cz, replace
replace cz = "00" + cz if strlen(cz) == 3
replace cz = "0" + cz if strlen(cz) == 4

save "$root/data/derived/covariates/urban_population_1910_1950_cz.dta", replace
