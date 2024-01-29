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
global exploratory = "$root/output/exploratory/"

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
twoway (scatter growth50to00 plan1947_length, msize(tiny)) ///
    (lfit growth50to00 plan1947_length), ///
    name(scatter_growth_plan) legend(rows(2) size(small))

* drop outlier (Los Angeles CZ, 38300)
twoway (scatter growth50to00 plan1947_length, msize(tiny)) ///
    (lfit growth50to00 plan1947_length)if plan1947_length < 600, ///
    name(scatter_growth_plan_noLA) legend(rows(2) size(small))

*** HIGHWAY GROWTH AND INTERGENERATIONAL MOBILITY ***
* how do changes in highway length affect LR outcomes?
twoway (scatter kfr_pooled_pooled_mean growth50to00, msize(tiny)) ///
    (lfit kfr_pooled_pooled_mean growth50to00), ///
    name(scatter_kfr_growth) legend(rows(2) size(small))

* drop outlier (Los Angeles CZ, 38300)
twoway (scatter kfr_pooled_pooled_mean growth50to00, msize(tiny)) ///
    (lfit kfr_pooled_pooled_mean growth50to00) if plan1947_length < 600, ///
    name(scatter_kfr_growth_noLA) legend(rows(2) size(small))

* same as above but logged outcomes
twoway (scatter log_kfr_pooled_pooled_mean growth50to00, msize(tiny)) ///
    (lfit log_kfr_pooled_pooled_mean growth50to00), ///
    name(scatter_log_kfr_growth) legend(rows(2) size(small))

twoway (scatter log_kfr_pooled_pooled_mean growth50to00, msize(tiny)) ///
    (lfit log_kfr_pooled_pooled_mean growth50to00) if plan1947_length < 600, ///
    name(scatter_log_kfr_growth_noLA) legend(rows(2) size(small))

* export graphs
graph dir
local mygraphs = r(list)
foreach i of local mygraphs {
    graph export "$root/output/`i'.png", name(`i') replace
}
graph close

* generate binscatters
binscatter growth50to00 plan1947_length
binscatter kfr_pooled_pooled_mean growth50to00

binscatter kfr_pooled_pooled_mean log_growth50to00
binscatter log_kfr_pooled_pooled_mean log_growth50to00
