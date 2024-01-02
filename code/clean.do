 /*******************************************************************************
Title:			Clean Data for Long-Run Highway Impacts
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	October 23, 2023
Date Modified:	October 23, 2023
*******************************************************************************/

clear all
set linesize 240

global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

* Load OA data
local vars = "state county kfr_pooled* kfr_natam* kfr_black* kfr_asian* kfr_white* kfr_hisp*"
use `vars' using "$root/data/raw/county_outcomes_dta.dta", clear

* exploratory analysis
keep state county kfr_pooled_pooled*

use "$data_raw/form500.dta", clear
