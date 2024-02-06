/*******************************************************************************
Title:			Summary Statistics for Highways and Intergenerational Mobility
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	February 6, 2024
Date Modified:	Feb 6, 2024
*******************************************************************************/

clear all
set linesize 240

global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

*** YEAR BY YEAR HIGHWAY DATA ***
use "$root/data/derived/cz_kfr_allyrs.dta", clear
gen l_lenc = log(lenc)
local pooled_gender = "kfr_*_pooled_*"
local main_percentiles = "*p25 *p50 *p75"
keep cz czname year lenc l_lenc plan1947_length `pooled_gender' `main_percentiles'

* when were interstates constructed?
preserve
collapse (sum) lenc, by(year)
twoway line lenc year
graph export "$root/output/exploratory/highways_per_year.png", replace
restore

*** LONG DIFFERENCE HIGHWAY DATA (GROWTH) ***
use "$root/data/derived/cz_kfr_growth50to00_dollars.dta", clear
/* local pooled_gender = "log_kfr_*_pooled_* kfr_*_pooled_*" */
local main_pctiles = "*_p25 *_p50 *_p75 *_mean log_*_p25 log_*_p50 log_*_p75 log_*_mean"
local secondary_pctiles = "*_p1 *_p10 *_p100"
/* keep cz czname growth* asinh_growth* plan1947_length `pooled_gender' */
keep cz czname growth* asinh_growth* plan1947_length `main_pctiles' `secondary_pctiles'

* summary statistics
estpost sum growth50to80 asinh_growth50to80
eststo sum_stat_growth
estpost sum kfr_natam*
eststo sum_stat_natam
estpost sum kfr_white*
eststo sum_stat_white
estpost sum kfr_asian*
eststo sum_stat_asian
estpost sum kfr_black*
eststo sum_stat_black
estpost sum kfr_hisp*
eststo sum_stat_hisp
estpost sum kfr_pooled*
eststo sum_stat_pooled

eststo dir
foreach name in `r(names)' {
    esttab `name' using "$root/output/exploratory/tables/`name'.tex", ///
    booktabs cells("count mean sd") replace mtitle("`name'") nonumber
}

* boxplot of outcomes
preserve
foreach v of varlist kfr_*_pooled_p* {
    local race = substr("`v'", 5, 5)
    local pctile = substr("`v'", -3, 3)
    label variable `v' "`race' `pctile'"
}
graph hbox kfr_*_pooled_p* if kfr_natam_pooled_p75 < 100000 ///
    , asyvars showyvars legend(off) ///
    title("Mean child hh income in 2015 by race" "and parent income pctile")
graph export "$root/output/exploratory/sum_stat_kfr.png", replace
sum kfr_natam_pooled_p75
restore