/*******************************************************************************
Title:			Exploratory Data Analysis for Long-Run Highway Impacts
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	January 6, 2024
Date Modified:	February 26, 2024
*******************************************************************************/

clear all
set linesize 240

global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"
use "$root/data/derived/cz_kfr_growth50to00_dollars_covariates.dta", clear

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

* OLS Regressions
reg log_kfr_pooled_pooled_mean asinh_growth50to80
reg log_kfr_white_pooled_mean asinh_growth50to80
reg log_kfr_black_pooled_mean asinh_growth50to80
reg log_kfr_asian_pooled_mean asinh_growth50to80
reg log_kfr_natam_pooled_mean asinh_growth50to80
reg log_kfr_hisp_pooled_mean asinh_growth50to80

capture eststo drop *
local races "pooled white black asian natam hisp"
local pctiles = "mean p1 p10 p25 p50 p75 p100"
foreach r of local races {
    foreach p of local pctiles {
        eststo ols_`r'_`p': reg kfr_`r'_pooled_`p' asinh_growth50to80, robust
    }
}

foreach r of local races {
    esttab ols_`r'_* using "$root/output/exploratory/tables/reg_`r'_`p'.tex", ///
    booktabs replace mtitles nonotes ///
    star(* 0.10 ** 0.05 *** 0.01)
}

eststo dir

* IV Regressions
capture eststo drop *
local races "pooled white black asian natam hisp"
local pctiles = "mean p1 p10 p25 p50 p75 p100"
foreach r of local races {
    foreach p of local pctiles {
        eststo iv_`r'_`p': ivregress 2sls kfr_`r'_pooled_`p' (asinh_growth50to80 = asinh_plan1947_length), robust
    }
}

foreach r of local races {
    esttab iv_`r'_* using "$root/output/exploratory/tables/iv_`r'_`p'.tex", ///
    booktabs replace mtitles label nonotes ///
    star(* 0.10 ** 0.05 *** 0.01)
}

* IV First stage
capture eststo drop *
eststo first_stage: reg asinh_growth50to00 asinh_plan1947_length, robust

esttab first_stage using "$root/output/exploratory/tables/first_stage.tex", ///
    booktabs replace mtitles label nonotes ///
    star(* 0.10 ** 0.05 *** 0.01)

* OLS Regressions on pooled data adding covariates
capture eststo drop *
foreach v of varlist l_pop* {
    cap gen `v'_2 = `v'^2
}
local l_pop "l_population_1900 l_population_1910 l_population_1920 l_population_1930 l_population_1940 l_population_1950"
local l_pop2 "l_population_1900_2 l_population_1910_2 l_population_1920_2 l_population_1930_2 l_population_1940_2 l_population_1950_2"
local pct_urb "pct_urb_1910 pct_urb_1920 pct_urb_1930 pct_urb_1940 pct_urb_1950"
eststo ols_1: reg log_kfr_pooled_pooled_mean asinh_growth50to00, robust
eststo ols_2: reg log_kfr_pooled_pooled_mean asinh_growth50to00 `l_pop', robust
eststo ols_3: reg log_kfr_pooled_pooled_mean asinh_growth50to00 `l_pop' `pct_urb', robust
eststo ols_4: reg log_kfr_pooled_pooled_mean asinh_growth50to00 `l_pop' `pct_urb' unemp_rate med_income med_educ_yrs, robust
eststo ols_5: reg log_kfr_pooled_pooled_mean asinh_growth50to00 `l_pop' `pct_urb' unemp_rate med_income med_educ_yrs i.cen_div, robust

* IV Regressions on pooled data adding covariates
eststo iv_1: ivregress 2sls log_kfr_pooled_pooled_mean (asinh_growth50to00 = asinh_plan1947_length), robust
eststo iv_2: ivregress 2sls log_kfr_pooled_pooled_mean (asinh_growth50to00 = asinh_plan1947_length) `l_pop', robust
eststo iv_3: ivregress 2sls log_kfr_pooled_pooled_mean (asinh_growth50to00 = asinh_plan1947_length) `l_pop' `pct_urb', robust
eststo iv_4: ivregress 2sls log_kfr_pooled_pooled_mean (asinh_growth50to00 = asinh_plan1947_length) `l_pop' `pct_urb' unemp_rate med_educ_yrs med_income, robust
eststo iv_5: ivregress 2sls log_kfr_pooled_pooled_mean (asinh_growth50to00 = asinh_plan1947_length) `l_pop' `pct_urb' unemp_rate med_educ_yrs med_income i.cen_div, robust
eststo iv_6: ivregress 2sls log_kfr_pooled_pooled_mean (asinh_growth50to00 = asinh_plan1947_length) `l_pop' `l_pop2' `pct_urb' unemp_rate med_educ_yrs med_income i.cen_div, robust

* Check first stage
reg asinh_growth50to00 asinh_plan1947_length `l_pop' `l_urban_pop' unemp_rate med_educ_yrs med_income, robust

* Export regressions
estadd local population "Y": ols_2 ols_3 ols_4 ols_5 iv_2 iv_3 iv_4 iv_5
estadd local population "N": ols_1 iv_1

estadd local percent_urban "Y": ols_3 ols_4 ols_5 iv_3 iv_4 iv_5
estadd local percent_urban "N": ols_1 ols_2 iv_1 iv_2

estadd local cen_div "Y": ols_5 iv_5
estadd local cen_div "N": ols_1 ols_2 ols_3 ols_4 iv_1 iv_2 iv_3 iv_4

#delimit ;
esttab ols* using "$root/output/exploratory/tables/ols_cov.tex",
    booktabs replace label nonotes mtitles
    keep(asinh* unemp_rate med_educ_yrs med_income)
    stats(population percent_urban cen_div r2_a N , 
        label("1900-1950 population" "1910-1950 \% urban" "Census Division"
            "Adj. R-squared" "N" ))
    star(* 0.10 ** 0.05 *** 0.01);

esttab iv* using "$root/output/exploratory/tables/iv_cov.tex",
    booktabs replace label nonotes nomtitles
    keep(asinh* unemp_rate med_educ_yrs med_income)
    stats(population percent_urban cen_div r2_a N , 
        label("1900-1950 population" "1910-1950 \% urban" "Census Division"
            "Adj. R-squared" "N" ))
    star(* 0.10 ** 0.05 *** 0.01);
#delimit cr