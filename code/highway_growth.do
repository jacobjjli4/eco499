/*******************************************************************************
Title:			Generate dataset of highway growth over time
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	January 25, 2024
Date Modified:	Jan 25, 2024
*******************************************************************************/

clear all
set linesize 240

use "$root/data/derived/cz_kfr_allyrs.dta", clear

* Generate a dataset using highway growth over time
keep if inlist(year, 50, 80)
drop lena lenb lenp

* Generate growth for 1950-1980
reshape wide lenc, i(cz) j(year)
gen growth50to80 = lenc80 - lenc50
gen asinh_lenc50 = asinh(lenc50)
gen asinh_lenc80 = asinh(lenc80)
gen asinh_growth50to80 = asinh_lenc80 - asinh_lenc50
label variable growth50to80 "hwy growth 1950-1980"
label variable asinh_growth50to80 "asinh(hwy growth 1950-1980)"

drop asinh_lenc* lenc*
order cz czname growth* asinh_growth* plan1947_length

* Bring in CZs with no highways
merge 1:m cz using "$root/data/derived/cz_outcomes.dta"
replace growth50to80 = 0 if _merge==2
replace asinh_growth50to80 = 0 if _merge==2
replace plan1947_length = 0 if plan1947_length==.
replace asinh_plan1947_length = asinh(plan1947_length)
drop _merge

save "$root/data/derived/cz_kfr_growth50to00.dta", replace
