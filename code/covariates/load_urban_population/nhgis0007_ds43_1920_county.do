* NOTE: You need to set the Stata working directory to the path
* where the data file is located.

set more off

clear
quietly infix                 ///
  str     year       1-4      ///
  str     state      5-28     ///
  str     statea     29-31    ///
  str     county     32-88    ///
  str     countya    89-92    ///
  str     areaname   93-158   ///
  str     stateicp   159-161  ///
  str     countyicp  162-165  ///
  double  a7t001     166-174  ///
  double  a7t002     175-183  ///
  using `"$root/data/raw/urban_population/nhgis0007_ds43_1920_county.dat"'


format a7t001    %9.0f
format a7t002    %9.0f

label var year      `"Data File Year"'
label var state     `"State Name"'
label var statea    `"State Code"'
label var county    `"County Name"'
label var countya   `"County Code"'
label var areaname  `"Area name"'
label var stateicp  `"ICPSR State Code"'
label var countyicp `"ICPSR County Code"'
label var a7t001    `"Urban"'
label var a7t002    `"Rural"'


