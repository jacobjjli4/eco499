/*******************************************************************************
Title:			Merge data at CZ level
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	October 23, 2023
Date Modified:	Jan 21, 2024
*******************************************************************************/

clear all
set linesize 240

* MERGE HIGHWAY AND OA DATA ****************************************************
* OA and observed highways: _merge==3 should have 25,525 obs (total 25,525)
merge 1:m cz using "$root/data/derived/hwy_allyr_cz_clean.dta"
drop _merge

* Master and highway instruments: _merge==3 should have 22,620 obs;
* _merge==1 should have 2,905 obs (CZs with no planned highways) (total 25,525)
merge m:1 cz using "$root/data/derived/highways_cz_clean.dta"
replace plan1947_length = 0 if _merge == 1
drop _merge

save "$root/data/derived/cz_oa_kfr_pooled_pooled_mean.dta", replace