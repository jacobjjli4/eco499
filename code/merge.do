/*******************************************************************************
Title:			Merge data at CZ level
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	October 23, 2023
Date Modified:	Jan 21, 2024
*******************************************************************************/

clear all
set linesize 240

* Start with OA data
use "$root/data/derived/cz_outcomes.dta", clear

* OA and observed highways: _merge==3 should have 25,525 obs (total 25,525)
merge 1:m cz using "$root/data/derived/hwy_allyr_cz_clean.dta"
drop _merge

* Master and highway instruments: _merge==3 should have 22,620 obs;
* _merge==1 should have 2,905 obs (CZs with no planned highways) (total 25,525)
merge m:1 cz using "$root/data/derived/highways_cz_clean.dta"
replace plan1947_length = 0 if _merge == 1
drop _merge

* Label and reorder variables
label variable plan1947_length "miles of 1947 planned Interstate"

order cz czname year lena lenb lenc lenp plan1947_length

save "$root/data/derived/cz_kfr_allyrs.dta", replace

* Generate a dataset using highway growth over time
keep if inlist(year, 50, 100)
drop lenb lenc lenp
reshape wide lena, i(cz) j(year)
gen growth50to00 = lena100 - lena50
label variable growth50to00 "Miles of highway added 1950 to 2000"
drop lena
order cz czname growth50to00 plan1947_length

save "$root/data/derived/cz_kfr_growth50to00.dta", replace