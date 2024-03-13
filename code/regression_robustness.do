/*******************************************************************************
Description:    Robustness checks for stacked regression analysis
Author:		    Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	March 11, 2024
Date Modified:	March 12, 2024
*******************************************************************************/
clear all
set linesize 240
global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"
use "$root/data/derived/stacked_race_income.dta", clear

* Check log, log + 1, and asinh in metres specifications
gen log_growth50to80 = log(growth50to80)
gen restricted_asinh = asinh_growth50to80 if asinh_growth50to80 > 0
gen log1_growth50to80 = log(growth50to80 + 1)
gen metres_growth50to80 = growth50to80 * 1609.34
gen metres_asinh_growth50to80 = asinh(metres_growth50to80)

foreach v of varlist asinh_growth50to80 log_growth50to80 restricted_asinh log1_growth50to80 metres_asinh_growth50to80 {
    #delimit ;
* interact with literally everything
local l_pop 
    "i.parent_income#c.l_population_1900 i.parent_income#c.l_population_1910 
    i.parent_income#c.l_population_1920 i.parent_income#c.l_population_1930 
    i.parent_income#c.l_population_1940 i.parent_income#c.l_population_1950";
local pct_urb 
    "i.parent_income#c.pct_urb_1910 i.parent_income#c.pct_urb_1920 
    i.parent_income#c.pct_urb_1930 i.parent_income#c.pct_urb_1940 
    i.parent_income#c.pct_urb_1950";
local socioeco 
    "i.parent_income#c.unemp_rate i.parent_income#c.med_educ_yrs 
    i.parent_income#c.med_income";
local cen_div
    "i.parent_income#i.cen_div";

eststo `v': ivregress 2sls 
    log_kfr (`v' = asinh_plan1947_length) 
    `l_pop' `pct_urb' `socioeco' `cen_div' 
    i.parent_income i.parent_income#c.`v' 
    if race==3, robust;
#delimit cr
}

estadd local population "Y": *
estadd local percent_urban "Y": *
estadd local cen_div "Y": *
estadd local socioeco "Y": *

* export regressions
#delimit ;
esttab
    using "$root/output/exploratory/tables/asinh_log_log1_robustness.tex",
    booktabs replace label noomitted nobaselevels
    rename(
        restricted_asinh hwy
        log1_growth50to80 hwy 
        log_growth50to80 hwy
        asinh_growth50to80 hwy
        metres_asinh_growth50to80 hwy
        1.parent_income#c.log1_growth50to80 p1
        10.parent_income#c.log1_growth50to80 p10
        25.parent_income#c.log1_growth50to80 p25
        50.parent_income#c.log1_growth50to80 p50
        75.parent_income#c.log1_growth50to80 p75
        100.parent_income#c.log1_growth50to80 p100
        1.parent_income#c.log_growth50to80 p1
        10.parent_income#c.log_growth50to80 p10
        25.parent_income#c.log_growth50to80 p25
        50.parent_income#c.log_growth50to80 p50
        75.parent_income#c.log_growth50to80 p75
        100.parent_income#c.log_growth50to80 p100
        1.parent_income#c.restricted_asinh p1
        10.parent_income#c.restricted_asinh p10
        25.parent_income#c.restricted_asinh p25
        50.parent_income#c.restricted_asinh p50
        75.parent_income#c.restricted_asinh p75
        100.parent_income#c.restricted_asinh p100
        1.parent_income#c.metres_asinh_growth50to80 p1
        10.parent_income#c.metres_asinh_growth50to80 p10
        25.parent_income#c.metres_asinh_growth50to80 p25
        50.parent_income#c.metres_asinh_growth50to80 p50
        75.parent_income#c.metres_asinh_growth50to80 p75
        100.parent_income#c.metres_asinh_growth50to80 p100
        1.parent_income#c.asinh_growth50to80 p1
        10.parent_income#c.asinh_growth50to80 p10
        25.parent_income#c.asinh_growth50to80 p25
        50.parent_income#c.asinh_growth50to80 p50
        75.parent_income#c.asinh_growth50to80 p75
        100.parent_income#c.asinh_growth50to80 p100)
    varlabels(p10 "p10 $\times$ hwy"
        p25 "p25 $\times$ hwy"
        p50 "p50 $\times$ hwy"
        p75 "p75 $\times$ hwy"
        p100 "p100 $\times$ hwy")
    keep(hwy p*)
    stats(population percent_urban socioeco cen_div r2_a N, 
        label("1900-1950 population" "1910-1950 \% urban" 
            "1950 SE characteristics" "Census Division" "Adj. R-squared" "N" ))
    mtitles("asinh" "asinh (restricted)""ln" "ln + 1" "asinh (metres)")
    mgroups("ln(2015 mean family income)", pattern(1 0 0 0 0) 
        prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
    se star(* 0.10 ** 0.05 *** 0.01);
#delimit cr