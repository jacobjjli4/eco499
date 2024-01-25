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
keep if inlist(year, 50, 100)
drop lenb lenc lenp
gen log_lena = log(lena)
reshape wide lena log_lena, i(cz) j(year)
gen growth50to00 = lena100 - lena50
gen log_growth50to00 = log_lena100 - log_lena50
label variable growth50to00 "Highway growth 1950 to 2000 (miles)"
label variable log_growth50to00 "Log of highway growth 1950 to 2000 (miles)"
drop lena* log_lena*
order cz czname growth50to00 log_growth50to00 plan1947_length

save "$root/data/derived/cz_kfr_growth50to00.dta", replace