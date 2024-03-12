/*******************************************************************************
Description:    Stacked regression analysis
Author:		    Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	March 11, 2024
Date Modified:	March 11, 2024
*******************************************************************************/
clear all
set linesize 240
global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"
use "$root/data/derived/stacked_race_income.dta", clear

* only interact with highway growth
local l_pop "l_population_1900 l_population_1910 l_population_1920 l_population_1930 l_population_1940 l_population_1950"
local pct_urb "pct_urb_1910 pct_urb_1920 pct_urb_1930 pct_urb_1940 pct_urb_1950"
local socioeco "unemp_rate med_educ_yrs med_income"

#delimit ;
eststo iv_stack_pool: ivregress 2sls 
    log_kfr (asinh_growth50to80 = asinh_plan1947_length) 
    `l_pop' `pct_urb' `socioeco' 
    i.cen_div i.parent_income i.parent_income#c.asinh_growth50to80 
    if race=="pooled", robust;
#delimit cr

* interact with literally everything
local l_pop "i.parent_income#c.l_population_1900 i.parent_income#c.l_population_1910 i.parent_income#c.l_population_1920 i.parent_income#c.l_population_1930 i.parent_income#c.l_population_1940 i.parent_income#c.l_population_1950"
local pct_urb "i.parent_income#c.pct_urb_1910 i.parent_income#c.pct_urb_1920 i.parent_income#c.pct_urb_1930 i.parent_income#c.pct_urb_1940 i.parent_income#c.pct_urb_1950"
local socioeco "i.parent_income#c.unemp_rate i.parent_income#c.med_educ_yrs i.parent_income#c.med_income"

#delimit ;
eststo iv_stack_pool: ivregress 2sls 
    log_kfr (asinh_growth50to80 = asinh_plan1947_length) 
    `l_pop' `pct_urb' `socioeco' 
    i.parent_income#i.cen_div i.parent_income i.parent_income#c.asinh_growth50to80 
    if race=="pooled", robust;
#delimit cr

estadd local population "Y": iv*
estadd local percent_urban "Y": iv*
estadd local cen_div "Y": iv*
estadd local socioeco "Y": iv*

esttab iv_stack_pool using "$root/output/exploratory/tables/iv_stack_pool.tex", ///
    booktabs replace mtitles("ln(2015 family income)") label ///
    keep(asinh* *.parent_income *.parent_income#*asinh*) drop(1.parent_income 1.parent_income#*) ///
    stats(population percent_urban socioeco cen_div r2_a N, label("1900-1950 population" "1910-1950 \% urban" "1950 Socioeconomic characteristics" "Census Division" "Adj. R-squared" "N" )) ///
    se star(* 0.10 ** 0.05 *** 0.01)

