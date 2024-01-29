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