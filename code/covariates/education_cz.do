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

quietly infix                 ///
  str     year       1-4      ///
  str     state      5-28     ///
  str     statea     29-31    ///
  str     county     32-88    ///
  str     countya    89-92    ///
  str     areaname   93-158   ///
  str     stateicp   159-161  ///
  str     countyicp  162-165  ///
  str     b24001     166-182  ///
  using `"$root/data/raw/covariates/education_1950_cnty.dat"'

label var year      `"Data File Year"'
label var state     `"State Name"'
label var statea    `"State Code"'
label var county    `"County Name"'
label var countya   `"County Code"'
label var areaname  `"Area name"'
label var stateicp  `"ICPSR State Code"'
label var countyicp `"ICPSR County Code"'
label var b24001    `"Median school years"'

* Code the data
gen med_educ_yrs = 2.5 if b24001 == "4.9 years or less"
replace med_educ_yrs = 5.5 if b24001 == "5 to 5.9 years"
replace med_educ_yrs = 6.5 if b24001 == "6 to 6.9 years"
replace med_educ_yrs = 7.5 if b24001 == "7 to 7.9 years"
replace med_educ_yrs = 8.5 if b24001 == "8 to 8.9 years"
replace med_educ_yrs = 9.5 if b24001 == "9 to 9.9 years"
replace med_educ_yrs = 10.5 if b24001 == "10 to 10.9 years"
replace med_educ_yrs = 11.5 if b24001 == "11 to 11.9 years"
replace med_educ_yrs = 12.5 if b24001 == "12 to 12.9 years"

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

collapse (mean) med_educ_yrs [iw = weight], by(cz year)
label variable med_educ_yrs "Median years of education"

* Recast CZ as str for merging with master dataset
tostring cz, replace
replace cz = "00" + cz if strlen(cz) == 3
replace cz = "0" + cz if strlen(cz) == 4

save "$root/data/derived/covariates/education_1950_cz.dta", replace
