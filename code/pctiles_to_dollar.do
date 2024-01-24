/*******************************************************************************
Title:			Crosswalk HH income percentiles to 2015 dollars
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	January 23, 2024
Date Modified:	Jan 23, 2024
*******************************************************************************/

clear all
set linesize 240

global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

use "$root/data/raw/pctile_to_dollar_cw.dta", clear
keep percentile kid_hh_income

save "$root/data/derived/pctile_to_dollars_cw_clean.dta", replace

use "$root/data/derived/cz_kfr_growth50to00.dta", clear

foreach v of varlist kfr*{
    replace `v' = ceil(`v' * 100)
    rename `v' percentile
    merge m:1 percentile using "$root/data/derived/pctile_to_dollars_cw_clean.dta"
    drop if _merge==2
    rename kid_hh_income `v'_new
    drop percentile _merge
}

save "$root/data/derived/cz_kfr_growth50to00_dollars.dta", replace