/*******************************************************************************
Title:			Clean Data for Long-Run Highway Impacts
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	October 23, 2023
Date Modified:	Jan 6, 2024
*******************************************************************************/

clear all
set linesize 240

global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

* CLEAN HIGHWAYS DATA **********************************************************
use "$root/data/raw/hwy-allyr-msa.dta", clear
keep msa year lena lenb lenc lenp
tostring msa, replace
replace msa = "00" + msa if strlen(msa) == 2
replace msa = "0" + msa if strlen(msa) == 3
save "$root/data/derived/hwy_allyr_msa_clean.dta", replace

* CLEAN OA DATA ****************************************************************
local vars = "state county kfr_pooled* kfr_natam* kfr_black* kfr_asian* kfr_white* kfr_hisp*"
use `vars' using "$root/data/raw/county_outcomes_dta.dta", clear

keep state county kfr_pooled_pooled*
tostring state county, replace
replace state = "0" + state if strlen(state) < 2
replace county = "00" + county if strlen(county) == 1
replace county = "0" + county if strlen(county) == 2

capture mkdir "$root/data/derived/"
save "$root/data/derived/county_outcomes_slim.dta", replace

* Pool OA data at the MSA level
* Load 1999 MSA to county crosswalk
infix 22 first ///
    str msa 1-4 ///
    str pmsa 9-12 ///
    str state 25-26 ///
    str county 27-29 ///
    using "$root/data/raw/msa_crosswalk/99mfips.txt", clear
drop if _n > 2150
drop if (msa == "")|(state == "")|(county == "")
* CMSAs consist of PMSAs: I treat PMSAs as MSAs and do not use CMSAs in analysis
replace msa = pmsa if pmsa != ""
drop pmsa

* Drop all New England MSAs (I use NECMAs instead since they are county-based)
drop if inlist(state, "23", "50", "33", "25", "44", "09")
duplicates drop

save "$root/data/derived/msa_crosswalk_temp.dta", replace

* Load 1999 New England County MAs to county crosswalk
infix 14 first ///
    str msa 1-4 ///
    str state 6-7 ///
    str county 9-11 ///
    using "$root/data/raw/msa_crosswalk/99nfips.txt", clear
drop if _n > 54
drop if (msa == "")|(state == "")|(county == "")
duplicates drop

append using "$root/data/derived/msa_crosswalk.dta"
save "$root/data/derived/msa_crosswalk.dta", replace
rm "$root/data/derived/msa_crosswalk_temp.dta"

use "$root/data/derived/county_outcomes_slim.dta", clear
merge m:1 state county using "$root/data/derived/msa_crosswalk.dta"
* Merge explanation: Bedford city (FIPS 51515) was an independent city in VA but
* merged into Bedford County in 2013
keep if _merge==3
drop _merge

* Collapse OA data to MSA level
collapse (mean) kfr_pooled_pooled_mean [fw=kfr_pooled_pooled_n], by(msa)

* MERGE HIGHWAY AND OA DATA ****************************************************
merge 1:m msa using "$root/data/derived/hwy_allyr_msa_clean.dta"
* _merge == 2: 4760 (Manchester NH) and 9360 (Yuma, AZ) are not merged for some reason
drop if _merge == 2
* _merge == 1: MSAs without highways in the Baum-Snow dataset
drop if _merge == 1
drop _merge

save "$root/data/derived/oa_kfr_pooled_pooled_mean.dta", replace