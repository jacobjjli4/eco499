/*******************************************************************************
Description:    Stack cleaned data on income
Author:		    Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	March 11, 2024
Date Modified:	March 11, 2024
*******************************************************************************/
clear all
set linesize 240
global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

* Stack models on income pctile
use "$root/data/derived/cz_kfr_growth50to00_dollars_covariates.dta", clear
keep cz-cen_div log_kfr_pooled_pooled_* kfr_pooled_pooled_*
drop log_kfr_*_mean kfr_*_mean
reshape long kfr_pooled_pooled_p log_kfr_pooled_pooled_p, i(cz) j(parent_income)
rename log_kfr_pooled_pooled_p log_kfr
rename kfr_pooled_pooled_p kfr

label variable parent_income "Parent income pctile"
label variable kfr "2015 family income"
label variable log_kfr "ln(2015 family income)"
label variable cen_div "Census division"

order cz czname kfr log_kfr parent_income