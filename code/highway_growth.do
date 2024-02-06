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
keep if inlist(year, 50, 80, 100)
drop lena lenb lenp

* Generate growth for three periods: 1950-2000, 1950-1980, 1980-2000
reshape wide lenc, i(cz) j(year)
gen growth50to00 = lenc100 - lenc50
gen growth50to80 = lenc80 - lenc50
gen growth80to00 = lenc100 - lenc80
gen asinh_lenc50 = asinh(lenc50)
gen asinh_lenc80 = asinh(lenc80)
gen asinh_lenc100 = asinh(lenc100)
gen asinh_growth50to00 = asinh_lenc100 - asinh_lenc50
gen asinh_growth50to80 = asinh_lenc80 - asinh_lenc50
gen asinh_growth80to00 = asinh_lenc100 - asinh_lenc80

label variable growth50to00 "Highway growth 1950 to 2000 (miles)"
label variable growth50to80 "Highway growth 1950 to 1980 (miles)"
label variable growth80to00 "Highway growth 1980 to 2000 (miles)"
label variable asinh_growth50to00 "Inverse hyperbolic sine of highway growth 1950 to 2000 (miles)"
label variable asinh_growth50to80 "Inverse hyperbolic sine of highway growth 1950 to 1980 (miles)"
label variable asinh_growth80to00 "Inverse hyperbolic sine of highway growth 1980 to 2000 (miles)"

drop lenc*
order cz czname growth* asinh_growth* plan1947_length

* Bring in CZs with no highways
merge 1:m cz using "$root/data/derived/cz_outcomes.dta"
replace growth50to00 = 0 if _merge==2
replace growth80to00 = 0 if _merge==2
replace growth50to80 = 0 if _merge==2
replace asinh_growth50to00 = 0 if _merge==2
replace asinh_growth80to00 = 0 if _merge==2
replace asinh_growth50to80 = 0 if _merge==2
replace plan1947_length = 0 if plan1947_length==.
drop _merge

save "$root/data/derived/cz_kfr_growth50to00.dta", replace
