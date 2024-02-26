/*******************************************************************************
Description:    Load and clean 1950 education data and merge to CZ level
Author:		    Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	February 25, 2024
Date Modified:	February 25, 2024
*******************************************************************************/
clear all
set linesize 240
global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

use "$root/data/raw/covariates/cw_czone_division.dta", clear

* Clean data to match my conventions
rename czone cz
tostring cz, replace
replace cz = "00" + cz if strlen(cz) == 3
replace cz = "0" + cz if strlen(cz) == 4

* Generate one dummy to use with fvvarlist
reshape long reg, i(cz) j(reg_name) string
drop if reg == 0
drop reg

* Rename regions
replace reg_name = "East South Central" if reg_name == "_escen"
replace reg_name = "South Atlantic" if reg_name == "_satl"
replace reg_name = "West South Central" if reg_name == "_wscen"
replace reg_name = "Mid Atlantic" if reg_name == "_midatl"
replace reg_name = "Mountain" if reg_name == "_mount"
replace reg_name = "East North Central" if reg_name == "_encen"
replace reg_name = "New England" if reg_name == "_neweng"
replace reg_name = "Pacific" if reg_name == "_pacif"
replace reg_name = "West North Central" if reg_name == "_wncen"

encode reg_name, gen(cen_div)
drop reg_name

save "$root/data/derived/covariates/census_division.dta", replace

