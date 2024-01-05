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

capture mkdir "$root/data/derived/"
save "$root/data/derived/county_outcomes_slim.dta", replace

* Pool OA data at the MSA level
* Load 1999 MSA to county crosswalk
infix 22 first str msa 1-4 str state 25-26 str county 27-29 using "$root/data/raw/msa_crosswalk/99mfips.txt", clear
drop if _n > 918
drop if (msa == "")|(state == "")|(county == "")
duplicates drop

save "$root/data/derived/msa_crosswalk.dta", replace

use "$root/data/derived/county_outcomes_slim.dta", clear
merge m:1 state county using "$root/data/derived/msa_crosswalk.dta"

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