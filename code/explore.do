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

use "$root/data/derived/oa_kfr_pooled_pooled_mean.dta", clear

* lena - 2 digit (main) interstate highways
* lenb - 3 digit (auxiliary) interstate highways

* when were interstates constructed?
preserve
collapse (sum) lena, by(year)
twoway line lena year
restore

* relationship between highway length and long-run outcomes by year?
keep if year<60
scatter kfr lena, by(year)

bysort year: 