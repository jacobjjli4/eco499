/*******************************************************************************
Description:    Stacked regression analysis
Author:		    Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	March 11, 2024
Date Modified:	March 12, 2024
*******************************************************************************/
clear all
set linesize 240
global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"
use "$root/data/derived/stacked_race_income.dta", clear

label variable parent_income "PIP"
label variable asinh_growth50to80 "hwy"

* only interact with highway growth
local l_pop "l_population_1900 l_population_1910 l_population_1920 l_population_1930 l_population_1940 l_population_1950"
local pct_urb "pct_urb_1910 pct_urb_1920 pct_urb_1930 pct_urb_1940 pct_urb_1950"
local socioeco "unemp_rate med_educ_yrs med_income"

#delimit ;
eststo iv_stack_pool_some: ivregress 2sls 
    log_kfr (asinh_growth50to80 = asinh_plan1947_length) 
    `l_pop' `pct_urb' `socioeco' 
    i.cen_div i.parent_income i.parent_income#c.asinh_growth50to80 
    if race==2, robust;

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

ivregress 2sls
    log_kfr (asinh_growth50to80 = asinh_plan1947_length) 
    `l_pop' `pct_urb' `socioeco' `cen_div'
    i.parent_income i.parent_income#c.asinh_growth50to80 c.asinh_growth50to80#c.asinh_growth50to80 i.parent_income#c.asinh_growth50to80#c.asinh_growth50to80
    if race==3, robust;

eststo iv_stack_pool: ivregress 2sls 
    log_kfr (asinh_growth50to80 = asinh_plan1947_length) 
    `l_pop' `pct_urb' `socioeco' `cen_div' 
    i.parent_income i.parent_income#c.asinh_growth50to80 
    if race==3, robust;

/* same regression for white */
eststo iv_stack_white: ivregress 2sls 
    log_kfr (asinh_growth50to80 = asinh_plan1947_length) 
    `l_pop' `pct_urb' `socioeco' `cen_div' 
    i.parent_income i.parent_income#c.asinh_growth50to80 
    if race==1, robust;

/* same regression for black */
eststo iv_stack_black: ivregress 2sls 
    log_kfr (asinh_growth50to80 = asinh_plan1947_length) 
    `l_pop' `pct_urb' `socioeco' `cen_div' 
    i.parent_income i.parent_income#c.asinh_growth50to80 
    if race==2, robust;

* regression stacked on race
local l_pop 
    "i.parent_income#c.l_population_1900#i.race 
    i.parent_income#c.l_population_1910#i.race 
    i.parent_income#c.l_population_1920#i.race 
    i.parent_income#c.l_population_1930#i.race 
    i.parent_income#c.l_population_1940#i.race 
    i.parent_income#c.l_population_1950#i.race";
local pct_urb 
    "i.parent_income#c.pct_urb_1910#i.race 
    i.parent_income#c.pct_urb_1920#i.race 
    i.parent_income#c.pct_urb_1930#i.race 
    i.parent_income#c.pct_urb_1940#i.race 
    i.parent_income#c.pct_urb_1950#i.race";
local socioeco 
    "i.parent_income#c.unemp_rate#i.race 
    i.parent_income#c.med_educ_yrs#i.race 
    i.parent_income#c.med_income#i.race";
local cen_div
    "i.parent_income#i.cen_div#i.race";

eststo iv_stack_black_white: ivregress 2sls 
    log_kfr (asinh_growth50to80 = asinh_plan1947_length) 
    `l_pop' `pct_urb' `socioeco' `cen_div'
    i.parent_income 
    i.parent_income#c.asinh_growth50to80 
    i.parent_income#c.asinh_growth50to80#i.race
    if inlist(race, 1, 2), robust;
#delimit cr

estadd local population "Y": iv*
estadd local percent_urban "Y": iv*
estadd local cen_div "Y": iv*
estadd local socioeco "Y": iv*

* export regressions
#delimit ;
esttab iv_stack_pool_some iv_stack_pool iv_stack_white iv_stack_black iv_stack_black_white
    using "$root/output/exploratory/tables/iv_stack_pool.tex",
    booktabs replace label noomitted nobaselevels
    keep(asinh* 
        *.parent_income#c.asinh_growth50to80 
        *.parent_income#*.race#c.asinh_growth50to80)
    stats(population percent_urban socioeco cen_div r2_a N, 
        label("1900-1950 population" "1910-1950 \% urban" 
            "1950 SE characteristics" "Census Division" "Adj. R-squared" "N" ))
    mtitles("Pooled some int." "Pooled all int." "White only" "Black only" "White \& Black")
    mgroups("ln(2015 mean family income)", pattern(1 0 0 0 0) 
        prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
    se star(* 0.10 ** 0.05 *** 0.01);
#delimit cr
