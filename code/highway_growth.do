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
gen log_growth50to00 = log(growth50to00)
gen log_growth50to80 = log(growth50to80)
gen log_growth80to00 = log(growth80to00)

label variable growth50to00 "Highway growth 1950 to 2000 (miles)"
label variable growth50to80 "Highway growth 1950 to 1980 (miles)"
label variable growth80to00 "Highway growth 1980 to 2000 (miles)"
label variable log_growth50to00 "Log of highway growth 1950 to 2000 (miles)"
label variable log_growth50to80 "Log of highway growth 1950 to 1980 (miles)"
label variable log_growth80to00 "Log of highway growth 1980 to 2000 (miles)"

drop lenc*

order cz czname growth* log_growth* plan1947_length
save "$root/data/derived/cz_kfr_growth50to00.dta", replace
