/*******************************************************************************
Title:			Clean Data for Long-Run Highway Impacts
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	October 23, 2023
Date Modified:	Jan 21, 2024
*******************************************************************************/

clear all
set linesize 240

global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"
capture mkdir "$root/data/derived/"

* CLEAN HIGHWAYS DATA **********************************************************
use "$root/data/raw/hwy-allyr-cnty.dta", clear
keep statefips cntyfips year lena lenb lenc lenp
tostring statefips cntyfips, replace
replace statefips = "0" + statefips if strlen(statefips) < 2
replace cntyfips = "00" + cntyfips if strlen(cntyfips) == 1
replace cntyfips = "0" + cntyfips if strlen(cntyfips) == 2

* Recode data for merge with county-CZ crosswalk
* FIPS 51129 is Norfolk County VA --> now part of Chesapeake Coutny VA FIPS 51550
* FIPS 29193 is Genevieve County MO --> changed FIPS code to 29186
replace cntyfips = "550" if (cntyfips=="129")&(statefips=="51")
replace cntyfips = "186" if (cntyfips=="193")&(statefips=="29")

save "$root/data/derived/hwy_allyr_cnty_clean.dta", replace

* Pool highways data at the CZ level
import excel "$root/data/raw/czlma903.xls", firstrow clear
rename CountyFIPSCode cntyfips
rename CZ90 cz
gen statefips = substr(cntyfips, 1, 2)
replace cntyfips = substr(cntyfips, 3, 3)
keep cntyfips statefips cz
* _merge==3 captures counties without highways
merge m:m cntyfips statefips using "$root/data/derived/hwy_allyr_cnty_clean.dta"
drop cntyfips statefips _merge

collapse (sum) lena lenb lenc lenp, by(cz year)

save "$root/data/derived/hwy_allyr_cz_clean.dta", replace

* CLEAN HIGHWAY INSTRUMENT *****************************************************
import delimited "$root/data/derived/highways_cz.csv", clear
tostring cz, replace
replace cz = "00" + cz if strlen(cz) == 3
replace cz = "0" + cz if strlen(cz) == 4
collapse (sum) plan1947_length, by(cz)
* convert metres to miles
replace plan1947_length = plan1947_length / 1609.344

save "$root/data/derived/highways_cz_clean.dta", replace

* CLEAN OA DATA ****************************************************************
local vars = "cz czname kfr_pooled* kfr_natam* kfr_black* kfr_asian* kfr_white* kfr_hisp*"
use `vars' using "$root/data/raw/cz_outcomes.dta", clear

tostring cz, replace
replace cz = "00" + cz if strlen(cz) == 3
replace cz = "0" + cz if strlen(cz) == 4

save "$root/data/derived/cz_outcomes.dta", replace

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