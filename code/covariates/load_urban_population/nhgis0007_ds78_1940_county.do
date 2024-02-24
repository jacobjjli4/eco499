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
  double  bw1001     166-174  ///
  using `"$root/data/raw/urban_population/nhgis0007_ds78_1940_county.dat"'


format bw1001    %9.0f

label var year      `"Data File Year"'
label var state     `"State Name"'
label var statea    `"State Code"'
label var county    `"County Name"'
label var countya   `"County Code"'
label var areaname  `"Area name"'
label var stateicp  `"ICPSR State Code"'
label var countyicp `"ICPSR County Code"'
label var bw1001    `"Total"'


