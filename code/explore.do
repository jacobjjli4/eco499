/*******************************************************************************
Title:			Exploratory Data Analysis for Long-Run Highway Impacts
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	January 6, 2024
Date Modified:	Jan 7, 2024
*******************************************************************************/

clear all
set linesize 240

global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

use "$root/data/derived/cz_oa_kfr_pooled_pooled_mean.dta", clear

* lena - 2 digit (main) interstate highways
* lenb - 3 digit (auxiliary) interstate highways

capture mkdir "$root/output/exploratory/"
global exploratory = "$root/output/exploratory/"

* when were interstates constructed?
preserve
collapse (sum) lena, by(year)
twoway line lena year
graph export "$exploratory/highways_per_year.png", replace
restore

* relationship between highway length and long-run outcomes by year?
gen l_lena = log(lena)
scatter kfr lena, msize(tiny) by(year)
graph export "$exploratory/scatter_kfr_lena.png", replace
scatter kfr l_lena, msize(tiny) by(year)
graph export "$exploratory/scatter_kfr_log_lena.png", replace

* selected years?
twoway (scatter kfr lena, msize(tiny))(lfit kfr lena), by(year)
graph export "$exploratory/scatter_lfit_kfr_log_lena.png", replace
