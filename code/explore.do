/*******************************************************************************
Title:			Exploratory Data Analysis for Long-Run Highway Impacts
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	January 6, 2024
Date Modified:	Jan 29, 2024
*******************************************************************************/

clear all
set linesize 240

global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

use "$root/data/derived/cz_oa_allyrs.dta", clear
gen l_lena = log(lena)
local pooled_gender = "kfr_*_pooled_*"
local main_percentiles = "*p25 *p50 *p75"
keep cz czname year lena l_lena plan1947_length `pooled_gender' `main_percentiles'

* lena - 2 digit (main) interstate highways
* lenb - 3 digit (auxiliary) interstate highways

capture mkdir "$root/output/exploratory/"
capture mkdir "$root/output/exploratory/plan_growth/"
capture mkdir "$root/output/exploratory/growth_outcomes/"
capture mkdir "$root/output/exploratory/combine_by_race_gender_pctile/"

* when were interstates constructed?
preserve
collapse (sum) lena, by(year)
twoway line lena year
graph export "$exploratory/highways_per_year.png", replace
restore

* changes in highway length from 1950 to 2000
use "$root/data/derived/cz_kfr_growth50to00_dollars.dta", clear

*** HIGHWAY GROWTH AND HIGHWAY PLAN ***
* correlation between instrument and independent
graph drop *

foreach v of varlist growth* {
    twoway (scatter `v' plan1947_length, msize(tiny)) ///
    (lfit `v' plan1947_length), ///
    name(scatter_`v'_plan) legend(rows(2) size(small))

    * drop outlier (Los Angeles CZ, 38300)
    twoway (scatter `v' plan1947_length, msize(tiny)) ///
        (lfit `v' plan1947_length)if plan1947_length < 600, ///
        name(scatter_`v'_plan_noLA) legend(rows(2) size(small))
}

graph dir
local mygraphs = r(list)
foreach i of local mygraphs {
    graph export "$root/output/exploratory/plan_growth/`i'.png", name(`i') replace
}
graph close
graph drop *

local xtitle: variable label growth50to80
local ytitle: variable label kfr_pooled_pooled_mean
local logytitle: variable label log_kfr_pooled_pooled_mean

*** HIGHWAY GROWTH AND INTERGENERATIONAL MOBILITY ***
* how do changes in highway length affect LR outcomes?
twoway (scatter kfr_pooled_pooled_mean growth50to80, msize(tiny)) ///
    (lfit kfr_pooled_pooled_mean growth50to80), ///
    name(scatter_kfr_growth) legend(off) ytitle(`ytitle')

* drop outlier (Los Angeles CZ, 38300)
twoway (scatter kfr_pooled_pooled_mean growth50to80, msize(tiny)) ///
    (lfit kfr_pooled_pooled_mean growth50to80) if plan1947_length < 600, ///
    name(scatter_kfr_growth_noLA) legend(off) ytitle(`ytitle')

* same as above but logged outcomes
twoway (scatter log_kfr_pooled_pooled_mean growth50to80, msize(tiny)) ///
    (lfit log_kfr_pooled_pooled_mean growth50to80), ///
    name(scatter_log_kfr_growth) legend(off) ytitle(`logytitle')

twoway (scatter log_kfr_pooled_pooled_mean growth50to80, msize(tiny)) ///
    (lfit log_kfr_pooled_pooled_mean growth50to80) if plan1947_length < 600, ///
    name(scatter_log_kfr_growth_noLA) legend(off) ytitle(`logytitle')

* same as above but logged growth
twoway (scatter kfr_pooled_pooled_mean log_growth50to80, msize(tiny)) ///
    (lfit kfr_pooled_pooled_mean log_growth50to80), ///
    name(scatter_kfr_log_growth) legend(off) ytitle(`ytitle')

* same as above but log log
twoway (scatter log_kfr_pooled_pooled_mean log_growth50to80, msize(tiny)) ///
    (lfit log_kfr_pooled_pooled_mean log_growth50to80), ///
    name(scatter_log_kfr_log_growth) legend(off) ytitle(`logytitle')

* export graphs
graph dir
local mygraphs = r(list)
foreach i of local mygraphs {
    graph export "$root/output/exploratory/growth_outcomes/`i'.png", name(`i') replace
}
graph close
graph drop *

local xtitle: variable label growth50to80
local ytitle: variable label kfr_pooled_pooled_mean
local logytitle: variable label log_kfr_pooled_pooled_mean

* generate binscatters
binscatter kfr_pooled_pooled_mean growth50to80, ///
    name(binscatter_kfr_growth) xtitle(`xtitle') ytitle(`ytitle')
binscatter kfr_pooled_pooled_mean log_growth50to80, ///
    name(binscatter_kfr_log_growth) xtitle(`xtitle') ytitle(`ytitle')
binscatter log_kfr_pooled_pooled_mean log_growth50to80, ///
    name(binscatter_log_kfr_log_growth) xtitle(`xtitle') ytitle(`ytitle')

graph dir
local mygraphs = r(list)
foreach i of local mygraphs {
    graph export "$root/output/exploratory/growth_outcomes/`i'.png", name(`i') replace
}
graph close
graph drop *

* generate combined graphs by race and income, by gender 
/* local pooled_gender = "log_kfr_*_pooled_* kfr_*_pooled_*" */
local main_percentiles = "*_p25 *_p50 *_p75 log_*_p25 log_*_p50 log_*_p75"
/* keep cz czname growth* log_growth* plan1947_length `pooled_gender' */
keep cz czname growth* log_growth* plan1947_length `main_percentiles'

local genders "male female"
foreach gender of local genders {
    local graphs ""
    foreach v of varlist log_kfr_*_`gender'_* {
    binscatter `v' log_growth50to80, ///
        name(g_`v', replace) xtitle("") ytitle("") title(`v')
    local graphs "`graphs' g_`v'"
    }

    graph combine `graphs', ycommon colfirst rows(3) cols(6) iscale(.25) ///
        l1("Log of mean child household income in 2015 dollars") b1("Highway growth 1950-1980 (miles)") ///
        name(combine_by_race_`gender'_pctile, replace)
}

graph close
graph display combine_by_race_male_pctile
graph display combine_by_race_female_pctile

graph export "$root/output/exploratory/combine_by_race_gender_pctile/combine_by_race_male_pctile.png", ///
    name(combine_by_race_male_pctile) replace
graph export "$root/output/exploratory/combine_by_race_gender_pctile/combine_by_race_female_pctile.png", ///
    name(combine_by_race_female_pctile) replace
    
graph close
graph drop *