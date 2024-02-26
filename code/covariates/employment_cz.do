/*******************************************************************************
Description:    Load and clean 1950 employment data and merge to CZ level
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
  double  b2r001     166-174  ///
  double  b2r002     175-183  ///
  double  b2u001     184-192  ///
  double  b2u002     193-201  ///
  double  b2u003     202-210  ///
  double  b2u004     211-219  ///
  using `"$root/data/raw/covariates/employment_1950_cnty.dat"'


format b2r001    %9.0f
format b2r002    %9.0f
format b2u001    %9.0f
format b2u002    %9.0f
format b2u003    %9.0f
format b2u004    %9.0f

label var year      `"Data File Year"'
label var state     `"State Name"'
label var statea    `"State Code"'
label var county    `"County Name"'
label var countya   `"County Code"'
label var areaname  `"Area name"'
label var stateicp  `"ICPSR State Code"'
label var countyicp `"ICPSR County Code"'
label var b2r001    `"Male"'
label var b2r002    `"Female"'
label var b2u001    `"Employed >> Male"'
label var b2u002    `"Employed >> Female"'
label var b2u003    `"Unemployed >> Male"'
label var b2u004    `"Unemployed >> Female"'

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

gen lab_force = b2r001 + b2r002 + b2u003 + b2u004
gen unemployed = b2u003 + b2u004

collapse (sum) lab_force unemployed [iw = weight], by(cz year)
gen unemp_rate = unemployed / lab_force
drop unemployed lab_force year

* Recast CZ as str for merging with master dataset
tostring cz, replace
replace cz = "00" + cz if strlen(cz) == 3
replace cz = "0" + cz if strlen(cz) == 4

* Label variable
label variable unemp_rate "1950 unemployment rate" 

save "$root/data/derived/covariates/unemployment_1950_cz.dta", replace
