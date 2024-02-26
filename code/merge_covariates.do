/*******************************************************************************
Description:    Merge covariates into master dataset
Author:		    Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	February 24, 2024
Date Modified:	February 24, 2024
*******************************************************************************/
clear all
set linesize 240
global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

use "$root/data/derived/cz_kfr_growth50to00_dollars.dta", clear

merge 1:1 cz using "$root/data/derived/covariates/population_1900_1950_cz.dta", ///
    assert(match) nogenerate

merge 1:1 cz using "$root/data/derived/covariates/urban_population_1910_1950_cz.dta", ///
    keep(match master)

foreach v of varlist urb_pop* {
    replace `v' = 0 if _merge == 1
}
drop _merge

merge 1:1 cz using "$root/data/derived/covariates/unemployment_1950_cz.dta", ///
    assert(match) nogenerate

merge 1:1 cz using "$root/data/derived/covariates/education_1950_cz.dta", ///
    assert(match) nogenerate

merge 1:1 cz using "$root/data/derived/covariates/income_1950_cz.dta", ///
    assert(match) nogenerate

* reorder covariates to before dependent variables
order population1910-med_income, before(kfr_asian_female_mean)

save "$root/data/derived/cz_kfr_growth50to00_dollars_covariates.dta", replace