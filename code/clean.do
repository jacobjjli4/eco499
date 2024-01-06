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

keep state county kfr_pooled_pooled*
tostring state county, replace
replace state = "0" + state if strlen(state) < 2
replace county = "00" + county if strlen(county) == 1
replace county = "0" + county if strlen(county) == 2

capture mkdir "$root/data/derived/"
save "$root/data/derived/county_outcomes_slim.dta", replace

* Pool OA data at the MSA level
* Load 1999 MSA to county crosswalk
infix 22 first str msa 1-4 str pmsa 9-12 str state 25-26 str county 27-29 using "$root/data/raw/msa_crosswalk/99mfips.txt", clear
drop if _n > 2150
drop if (msa == "")|(state == "")|(county == "")
* CMSAs consist of PMSAs: I treat PMSAs as MSAs and do not use CMSAs in analysis
replace msa = pmsa if pmsa != ""
drop pmsa

* Drop all New England MSAs (I use NECMAs instead since they are county-based)
drop if inlist(state, "23", "50", "33", "25", "44", "09")
duplicates drop

save "$root/data/derived/msa_crosswalk.dta", replace

* Load 1999 New England County MAs to county crosswalk
infix 14 first str msa 1-4 str state 6-7 str county 9-11 using "$root/data/raw/msa_crosswalk/99nfips.txt", clear
drop if _n > 54
drop if (msa == "")|(state == "")|(county == "")
duplicates drop

append using "$root/data/derived/msa_crosswalk.dta"
save "$root/data/derived/msa_crosswalk.dta", replace

use "$root/data/derived/county_outcomes_slim.dta", clear
merge m:1 state county using "$root/data/derived/msa_crosswalk.dta"
keep if _merge==3
* Merge explanation: Bedford city (FIPS 51515) was an independent city in VA but merged into Bedford County in 2013

* Collapse OA data to MSA level
collapse (mean) kfr_pooled_pooled_mean [fw=kfr_pooled_pooled_n], by(msa)

* Load highways data
/* From Baum-Snow, CD-ROM/programs/make-roads.do:
Create variables that have the miles of federally funded highway 
within each msa.  Variables created are as follows:
lenaX - all long-distance interstates in data based on d_open
lenbX - all short-distance interstates in data based on d_open
lencX - all fedfunded interstates (w/ no short distance) based on d_open
lenpX - all interstates in 1947 plan
firaX - all long-distance interstates in data based on d_first
firbX - all short-distance interstates in data based on d_first
for each census year 50, 60, 70, 80, 90
and then later for each year individually.
*/
use "$root/data/raw/hwy-allyr-msa.dta", clear
keep msa year lena lenb lenc lenp 