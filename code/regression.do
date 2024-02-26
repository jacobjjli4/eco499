/*******************************************************************************
Description:    Regression analysis
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	February 26, 2024
Date Modified:	February 26, 2024
*******************************************************************************/

clear all
set linesize 240

global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"
use "$root/data/derived/cz_kfr_growth50to00_dollars_covariates.dta", clear

* OLS Regressions on pooled data adding covariates
capture eststo drop *

local l_pop "l_population_1900 l_population_1910 l_population_1920 l_population_1930 l_population_1940 l_population_1950"
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