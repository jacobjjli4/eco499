/*******************************************************************************
Title:			Exploratory Data Analysis for Long-Run Highway Impacts
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	January 6, 2024
Date Modified:	Feb 6, 2024
*******************************************************************************/

clear all
set linesize 240

global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"
use "$root/data/derived/cz_kfr_growth50to00_dollars.dta", clear

*** HIGHWAY GROWTH AND HIGHWAY PLAN ***
* correlation between instrument and independent
capture graph drop *

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
capture graph close
capture graph drop *

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
twoway (scatter kfr_pooled_pooled_mean asinh_growth50to80, msize(tiny)) ///
    (lfit kfr_pooled_pooled_mean asinh_growth50to80), ///
    name(scatter_kfr_asinh_growth) legend(off) ytitle(`ytitle')

* same as above but log log
twoway (scatter log_kfr_pooled_pooled_mean asinh_growth50to80, msize(tiny)) ///
    (lfit log_kfr_pooled_pooled_mean asinh_growth50to80), ///
    name(scatter_log_kfr_asinh_growth) legend(off) ytitle(`logytitle')

* export graphs
graph dir
local mygraphs = r(list)
foreach i of local mygraphs {
    graph export "$root/output/exploratory/growth_outcomes/`i'.png", name(`i') replace
}
capture graph close
capture graph drop *

local xtitle: variable label growth50to80
local ytitle: variable label kfr_pooled_pooled_mean
local logytitle: variable label log_kfr_pooled_pooled_mean

* generate binscatters
binscatter kfr_pooled_pooled_mean growth50to80, ///
    name(binscatter_kfr_growth) xtitle(`xtitle') ytitle(`ytitle')
binscatter log_kfr_pooled_pooled_mean growth50to80, ///
    name(binscatter_log_kfr_growth) xtitle(`xtitle') ytitle(`ytitle')
binscatter kfr_pooled_pooled_mean asinh_growth50to80, ///
    name(binscatter_kfr_asinh_growth) xtitle(`xtitle') ytitle(`ytitle')
binscatter log_kfr_pooled_pooled_mean asinh_growth50to80, ///
    name(binscatter_log_kfr_asinh_growth) xtitle(`xtitle') ytitle(`ytitle')

graph dir
local mygraphs = r(list)
foreach i of local mygraphs {
    graph export "$root/output/exploratory/growth_outcomes/`i'.png", name(`i') replace
}
capture graph close
capture graph drop *

* generate combined graphs by race and income, by gender 

local genders "male female"
foreach gender of local genders {
    local graphs ""
    foreach v of varlist log_kfr_*_`gender'_* {
    binscatter `v' plan1947_length, ///
        name(g_`v', replace) xtitle("") ytitle("") title(`v')
    local graphs "`graphs' g_`v'"
    }

    graph combine `graphs', ycommon colfirst rows(3) cols(6) iscale(.25) ///
        l1("Log of mean child household income in 2015 dollars") b1("Miles of 1947 highway plan") ///
        name(combine_by_race_`gender'_pctile, replace)
}

capture graph close
graph display combine_by_race_male_pctile, xsize(10) ysize(15)
graph display combine_by_race_female_pctile, xsize(10) ysize(15)

graph export "$root/output/exploratory/combine_by_race_gender_pctile/combine_by_race_male_pctile.png", ///
    name(combine_by_race_male_pctile) replace
graph export "$root/output/exploratory/combine_by_race_gender_pctile/combine_by_race_female_pctile.png", ///
    name(combine_by_race_female_pctile) replace

capture graph close
capture graph drop *

* Generate asinh combined graphs by race and income, by gender 

local genders "male female"
foreach gender of local genders {
    local graphs ""
    foreach v of varlist log_kfr_*_`gender'_* {
    binscatter `v' asinh_plan1947_length, ///
        name(g_`v', replace) xtitle("") ytitle("") title(`v')
    local graphs "`graphs' g_`v'"
    }

    graph combine `graphs', ycommon colfirst rows(6) cols(6) iscale(.25) ///
        l1("Log of mean child household income in 2015 dollars") b1("Inverse hyperbolic sine of miles of 1947 highway plan") ///
        name(asinh_race_`gender'_pctile, replace)
}

capture graph close
graph display asinh_race_male_pctile, xsize(10) ysize(15)
graph display asinh_race_female_pctile, xsize(10) ysize(15)

graph export "$root/output/exploratory/combine_by_race_gender_pctile/asinh_combine_by_race_male_pctile.png", ///
    name(asinh_race_male_pctile) replace
graph export "$root/output/exploratory/combine_by_race_gender_pctile/asinh_combine_by_race_female_pctile.png", ///
    name(asinh_race_female_pctile) replace

capture graph close
capture graph drop *