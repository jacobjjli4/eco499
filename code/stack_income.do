/*******************************************************************************
Description:    Stack cleaned data on income
Author:		    Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	March 11, 2024
Date Modified:	March 11, 2024
*******************************************************************************/
clear all
set linesize 240
global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"
use "$root/data/derived/cz_kfr_growth50to00_dollars_covariates.dta", clear

* Check how many obs have missing black outcomes
hist l_population_1950, name(hist_all)
hist l_population_1950 if kfr_black_pooled_mean == ., name(hist_black_missing)

* Stack models on income pctile
keep cz-cen_div kfr_black_pooled_* kfr_white_pooled_* ///
    log_kfr_black_pooled_* log_kfr_white_pooled_* ///
    kfr_pooled_pooled_* log_kfr_pooled_pooled_*
drop log_kfr_*_mean kfr_*_mean
reshape long kfr_black_pooled_p log_kfr_black_pooled_p ///
    kfr_white_pooled_p log_kfr_white_pooled_p ///
    kfr_pooled_pooled_p log_kfr_pooled_pooled_p, i(cz) j(parent_income)
rename log_kfr_white_pooled_p log_kfrwhite
rename log_kfr_black_pooled_p log_kfrblack
rename log_kfr_pooled_pooled_p log_kfrpooled
rename kfr_white_pooled_p kfrwhite
rename kfr_black_pooled_p kfrblack
rename kfr_pooled_pooled_p kfrpooled

* Stack models on race
reshape long kfr log_kfr, i(cz parent_income) j(race) string

* Tests
count if (race=="black")&(kfr==.)

* Dataset management
label variable parent_income "Parent income pctile"
label variable kfr "2015 family income"
label variable log_kfr "ln(2015 family income)"
label variable cen_div "Census division"
label variable race "Race"

order cz czname kfr log_kfr parent_income race

save "$root/data/derived/stacked_race_income.dta", replace