/*******************************************************************************
Title:			Clean highway (observed and instrument) and OA data
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

* keep labels before collapse
foreach v of var * {
    local l`v' : variable label `v'
        if `"`l`v''"' == "" {
		local l`v' "`v'"
 	}
 }
collapse (sum) lena lenb lenc lenp, by(cz year)
foreach v of var * {
    label var `v' `"`l`v''"'
}

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
drop *_se *_n

* Change order dataset for plotting
order kfr*, sequential
order kfr_pooled*, last
order cz czname

tostring cz, replace
replace cz = "00" + cz if strlen(cz) == 3
replace cz = "0" + cz if strlen(cz) == 4

save "$root/data/derived/cz_outcomes.dta", replace