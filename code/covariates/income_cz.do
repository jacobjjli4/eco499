/*******************************************************************************
Description:    Load and clean 1950 income data and merge to CZ level
Author:		    Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	February 25, 2024
Date Modified:	February 25, 2024
*******************************************************************************/
clear all
set linesize 240
global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

quietly infix                 ///
  str     year       1-4      ///
  str     state      5-28     ///
  str     statea     29-31    ///
  str     county     32-88    ///
  str     countya    89-92    ///
  str     areaname   93-158   ///
  str     stateicp   159-161  ///
  str     countyicp  162-165  ///
  str     b22001     166-181  ///
  using `"$root/data/raw/covariates/income_1950_cnty.dat"'

label var year      `"Data File Year"'
label var state     `"State Name"'
label var statea    `"State Code"'
label var county    `"County Name"'
label var countya   `"County Code"'
label var areaname  `"Area name"'
label var stateicp  `"ICPSR State Code"'
label var countyicp `"ICPSR County Code"'
label var b22001    `"Median family income, 1949"'

* Code the data
gen med_income = 250 if b22001 == "$499 or less"
replace med_income = 750 if b22001 == "$500 to $999"
replace med_income = 1250 if b22001 == "$1,000 to $1,499"
replace med_income = 1750 if b22001 == "$1,500 to $1,999"
replace med_income = 2250 if b22001 == "$2,000 to $2,499"
replace med_income = 2750 if b22001 == "$2,500 to $2,999"
replace med_income = 3250 if b22001 == "$3,000 to $3,499"
replace med_income = 3750 if b22001 == "$3,500 to $3,999"
replace med_income = 4750 if b22001 == "$4,000 to $4,999"

* remove Alaska and Hawaii
drop if (state == "Alaska")|(state == "Hawaii")| ///
    (state == "Alaska Territory")|(state == "Hawaii Territory")

* Prepare data for merge
rename statea statenh
rename countya countynh
destring(year), replace
drop if county == "Independent Cities [multi-city reporting area]"

* Crosswalk to CZ level
merge 1:m year statenh countynh using ///
    "$root/data/derived/covariates/cnty_cz_crosswalk.dta", ///
    assert(match using) keep(match) nogenerate

collapse (mean) med_income [iw = weight], by(cz year)
label variable med_income "1950 median family income"

* Recast CZ as str for merging with master dataset
tostring cz, replace
replace cz = "00" + cz if strlen(cz) == 3
replace cz = "0" + cz if strlen(cz) == 4

* Drop year (all years are 1950)
drop year

save "$root/data/derived/covariates/income_1950_cz.dta", replace
