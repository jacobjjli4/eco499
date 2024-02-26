/*******************************************************************************
Description:    Merge covariates into master dataset
Author:		    Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	February 24, 2024
Date Modified:	February 26, 2024
*******************************************************************************/
clear all
set linesize 240
global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

use "$root/data/derived/cz_kfr_growth50to00_dollars.dta", clear

* 1900-1950 population
merge 1:1 cz using "$root/data/derived/covariates/population_1900_1950_cz.dta", ///
    assert(match) nogenerate

* 1910-1950 urban population
merge 1:1 cz using "$root/data/derived/covariates/urban_population_1910_1950_cz.dta", ///
    keep(match master)

foreach v of varlist urb_pop* {
    replace `v' = 0 if _merge == 1
}
drop _merge

* Generate percent urban in CZ
forvalues year = 1910(10)1950 {
    gen pct_urb_`year' = urb_pop_`year' / population_`year'
    label variable pct_urb_`year' "`year' percent urban"
}

* 1950 unemployment rate
merge 1:1 cz using "$root/data/derived/covariates/unemployment_1950_cz.dta", ///
    assert(match) nogenerate

* 1950 median school years
merge 1:1 cz using "$root/data/derived/covariates/education_1950_cz.dta", ///
    assert(match) nogenerate

* 1950 median income
merge 1:1 cz using "$root/data/derived/covariates/income_1950_cz.dta", ///
    assert(match) nogenerate

* Census division
merge 1:1 cz using "$root/data/derived/covariates/census_division.dta",

* reorder covariates to before dependent variables
order population_1900-cen_div, before(kfr_asian_female_mean)

save "$root/data/derived/cz_kfr_growth50to00_dollars_covariates.dta", replace