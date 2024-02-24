/*******************************************************************************
Description:    Load 1950 1% census income data and convert to CZ medians.
Author:		    Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	February 24, 2024
Date Modified:	February 24, 2024
*******************************************************************************/
clear all
set linesize 240
global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

set more off

clear
quietly infix               ///
  int     year       1-4    ///
  long    sample     5-10   ///
  double  serial     11-18  ///
  double  hhwt       19-28  ///
  byte    stateicp   29-30  ///
  int     countyicp  31-34  ///
  double  perwt      35-44  ///
  long    inctot     45-51  ///
  long    ftotinc    52-58  ///
  using `"$root/data/raw/covariates/income_1950_1pct.dat"'

replace hhwt      = hhwt      / 100
replace perwt     = perwt     / 100

format serial    %8.0f
format hhwt      %10.2f
format perwt     %10.2f

label var year      `"Census year"'
label var sample    `"IPUMS sample identifier"'
label var serial    `"Household serial number"'
label var hhwt      `"Household weight"'
label var stateicp  `"State (ICPSR code)"'
label var countyicp `"County (ICPSR code, identifiable counties only)"'
label var perwt     `"Person weight"'
label var inctot    `"Total personal income"'
label var ftotinc   `"Total family income"'

label define year_lbl 1850 `"1850"'
label define year_lbl 1860 `"1860"', add
label define year_lbl 1870 `"1870"', add
label define year_lbl 1880 `"1880"', add
label define year_lbl 1900 `"1900"', add
label define year_lbl 1910 `"1910"', add
label define year_lbl 1920 `"1920"', add
label define year_lbl 1930 `"1930"', add
label define year_lbl 1940 `"1940"', add
label define year_lbl 1950 `"1950"', add
label define year_lbl 1960 `"1960"', add
label define year_lbl 1970 `"1970"', add
label define year_lbl 1980 `"1980"', add
label define year_lbl 1990 `"1990"', add
label define year_lbl 2000 `"2000"', add
label define year_lbl 2001 `"2001"', add
label define year_lbl 2002 `"2002"', add
label define year_lbl 2003 `"2003"', add
label define year_lbl 2004 `"2004"', add
label define year_lbl 2005 `"2005"', add
label define year_lbl 2006 `"2006"', add
label define year_lbl 2007 `"2007"', add
label define year_lbl 2008 `"2008"', add
label define year_lbl 2009 `"2009"', add
label define year_lbl 2010 `"2010"', add
label define year_lbl 2011 `"2011"', add
label define year_lbl 2012 `"2012"', add
label define year_lbl 2013 `"2013"', add
label define year_lbl 2014 `"2014"', add
label define year_lbl 2015 `"2015"', add
label define year_lbl 2016 `"2016"', add
label define year_lbl 2017 `"2017"', add
label define year_lbl 2018 `"2018"', add
label define year_lbl 2019 `"2019"', add
label define year_lbl 2020 `"2020"', add
label define year_lbl 2021 `"2021"', add
label define year_lbl 2022 `"2022"', add
label values year year_lbl

label define sample_lbl 202204 `"2018-2022, PRCS 5-year"'
label define sample_lbl 202203 `"2018-2022, ACS 5-year"', add
label define sample_lbl 202202 `"2022 PRCS"', add
label define sample_lbl 202201 `"2022 ACS"', add
label define sample_lbl 202104 `"2017-2021, PRCS 5-year"', add
label define sample_lbl 202103 `"2017-2021, ACS 5-year"', add
label define sample_lbl 202102 `"2021 PRCS"', add
label define sample_lbl 202101 `"2021 ACS"', add
label define sample_lbl 202004 `"2016-2020, PRCS 5-year"', add
label define sample_lbl 202003 `"2016-2020, ACS 5-year"', add
label define sample_lbl 202001 `"2020 ACS"', add
label define sample_lbl 201904 `"2015-2019, PRCS 5-year"', add
label define sample_lbl 201903 `"2015-2019, ACS 5-year"', add
label define sample_lbl 201902 `"2019 PRCS"', add
label define sample_lbl 201901 `"2019 ACS"', add
label define sample_lbl 201804 `"2014-2018, PRCS 5-year"', add
label define sample_lbl 201803 `"2014-2018, ACS 5-year"', add
label define sample_lbl 201802 `"2018 PRCS"', add
label define sample_lbl 201801 `"2018 ACS"', add
label define sample_lbl 201704 `"2013-2017, PRCS 5-year"', add
label define sample_lbl 201703 `"2013-2017, ACS 5-year"', add
label define sample_lbl 201702 `"2017 PRCS"', add
label define sample_lbl 201701 `"2017 ACS"', add
label define sample_lbl 201604 `"2012-2016, PRCS 5-year"', add
label define sample_lbl 201603 `"2012-2016, ACS 5-year"', add
label define sample_lbl 201602 `"2016 PRCS"', add
label define sample_lbl 201601 `"2016 ACS"', add
label define sample_lbl 201504 `"2011-2015, PRCS 5-year"', add
label define sample_lbl 201503 `"2011-2015, ACS 5-year"', add
label define sample_lbl 201502 `"2015 PRCS"', add
label define sample_lbl 201501 `"2015 ACS"', add
label define sample_lbl 201404 `"2010-2014, PRCS 5-year"', add
label define sample_lbl 201403 `"2010-2014, ACS 5-year"', add
label define sample_lbl 201402 `"2014 PRCS"', add
label define sample_lbl 201401 `"2014 ACS"', add
label define sample_lbl 201306 `"2009-2013, PRCS 5-year"', add
label define sample_lbl 201305 `"2009-2013, ACS 5-year"', add
label define sample_lbl 201304 `"2011-2013, PRCS 3-year"', add
label define sample_lbl 201303 `"2011-2013, ACS 3-year"', add
label define sample_lbl 201302 `"2013 PRCS"', add
label define sample_lbl 201301 `"2013 ACS"', add
label define sample_lbl 201206 `"2008-2012, PRCS 5-year"', add
label define sample_lbl 201205 `"2008-2012, ACS 5-year"', add
label define sample_lbl 201204 `"2010-2012, PRCS 3-year"', add
label define sample_lbl 201203 `"2010-2012, ACS 3-year"', add
label define sample_lbl 201202 `"2012 PRCS"', add
label define sample_lbl 201201 `"2012 ACS"', add
label define sample_lbl 201106 `"2007-2011, PRCS 5-year"', add
label define sample_lbl 201105 `"2007-2011, ACS 5-year"', add
label define sample_lbl 201104 `"2009-2011, PRCS 3-year"', add
label define sample_lbl 201103 `"2009-2011, ACS 3-year"', add
label define sample_lbl 201102 `"2011 PRCS"', add
label define sample_lbl 201101 `"2011 ACS"', add
label define sample_lbl 201008 `"2010 Puerto Rico 10%"', add
label define sample_lbl 201007 `"2010 10%"', add
label define sample_lbl 201006 `"2006-2010, PRCS 5-year"', add
label define sample_lbl 201005 `"2006-2010, ACS 5-year"', add
label define sample_lbl 201004 `"2008-2010, PRCS 3-year"', add
label define sample_lbl 201003 `"2008-2010, ACS 3-year"', add
label define sample_lbl 201002 `"2010 PRCS"', add
label define sample_lbl 201001 `"2010 ACS"', add
label define sample_lbl 200906 `"2005-2009, PRCS 5-year"', add
label define sample_lbl 200905 `"2005-2009, ACS 5-year"', add
label define sample_lbl 200904 `"2007-2009, PRCS 3-year"', add
label define sample_lbl 200903 `"2007-2009, ACS 3-year"', add
label define sample_lbl 200902 `"2009 PRCS"', add
label define sample_lbl 200901 `"2009 ACS"', add
label define sample_lbl 200804 `"2006-2008, PRCS 3-year"', add
label define sample_lbl 200803 `"2006-2008, ACS 3-year"', add
label define sample_lbl 200802 `"2008 PRCS"', add
label define sample_lbl 200801 `"2008 ACS"', add
label define sample_lbl 200704 `"2005-2007, PRCS 3-year"', add
label define sample_lbl 200703 `"2005-2007, ACS 3-year"', add
label define sample_lbl 200702 `"2007 PRCS"', add
label define sample_lbl 200701 `"2007 ACS"', add
label define sample_lbl 200602 `"2006 PRCS"', add
label define sample_lbl 200601 `"2006 ACS"', add
label define sample_lbl 200502 `"2005 PRCS"', add
label define sample_lbl 200501 `"2005 ACS"', add
label define sample_lbl 200401 `"2004 ACS"', add
label define sample_lbl 200301 `"2003 ACS"', add
label define sample_lbl 200201 `"2002 ACS"', add
label define sample_lbl 200101 `"2001 ACS"', add
label define sample_lbl 200008 `"2000 Puerto Rico 1%"', add
label define sample_lbl 200007 `"2000 1%"', add
label define sample_lbl 200006 `"2000 Puerto Rico 1% sample (old version)"', add
label define sample_lbl 200005 `"2000 Puerto Rico 5%"', add
label define sample_lbl 200004 `"2000 ACS"', add
label define sample_lbl 200003 `"2000 Unweighted 1%"', add
label define sample_lbl 200002 `"2000 1% sample (old version)"', add
label define sample_lbl 200001 `"2000 5%"', add
label define sample_lbl 199007 `"1990 Puerto Rico 1%"', add
label define sample_lbl 199006 `"1990 Puerto Rico 5%"', add
label define sample_lbl 199005 `"1990 Labor Market Area"', add
label define sample_lbl 199004 `"1990 Elderly"', add
label define sample_lbl 199003 `"1990 Unweighted 1%"', add
label define sample_lbl 199002 `"1990 1%"', add
label define sample_lbl 199001 `"1990 5%"', add
label define sample_lbl 198007 `"1980 Puerto Rico 1%"', add
label define sample_lbl 198006 `"1980 Puerto Rico 5%"', add
label define sample_lbl 198005 `"1980 Detailed metro/non-metro"', add
label define sample_lbl 198004 `"1980 Labor Market Area"', add
label define sample_lbl 198003 `"1980 Urban/Rural"', add
label define sample_lbl 198002 `"1980 1%"', add
label define sample_lbl 198001 `"1980 5%"', add
label define sample_lbl 197009 `"1970 Puerto Rico Neighborhood"', add
label define sample_lbl 197008 `"1970 Puerto Rico Municipio"', add
label define sample_lbl 197007 `"1970 Puerto Rico State"', add
label define sample_lbl 197006 `"1970 Form 2 Neighborhood"', add
label define sample_lbl 197005 `"1970 Form 1 Neighborhood"', add
label define sample_lbl 197004 `"1970 Form 2 Metro"', add
label define sample_lbl 197003 `"1970 Form 1 Metro"', add
label define sample_lbl 197002 `"1970 Form 2 State"', add
label define sample_lbl 197001 `"1970 Form 1 State"', add
label define sample_lbl 196002 `"1960 5%"', add
label define sample_lbl 196001 `"1960 1%"', add
label define sample_lbl 195002 `"1950 100% database"', add
label define sample_lbl 195001 `"1950 1%"', add
label define sample_lbl 194002 `"1940 100% database"', add
label define sample_lbl 194001 `"1940 1%"', add
label define sample_lbl 193004 `"1930 100% database"', add
label define sample_lbl 193003 `"1930 Puerto Rico"', add
label define sample_lbl 193002 `"1930 5%"', add
label define sample_lbl 193001 `"1930 1%"', add
label define sample_lbl 192003 `"1920 100% database"', add
label define sample_lbl 192002 `"1920 Puerto Rico sample"', add
label define sample_lbl 192001 `"1920 1%"', add
label define sample_lbl 191004 `"1910 100% database"', add
label define sample_lbl 191003 `"1910 1.4% sample with oversamples"', add
label define sample_lbl 191002 `"1910 1%"', add
label define sample_lbl 191001 `"1910 Puerto Rico"', add
label define sample_lbl 190004 `"1900 100% database"', add
label define sample_lbl 190003 `"1900 1% sample with oversamples"', add
label define sample_lbl 190002 `"1900 1%"', add
label define sample_lbl 190001 `"1900 5%"', add
label define sample_lbl 188003 `"1880 100% database"', add
label define sample_lbl 188002 `"1880 10%"', add
label define sample_lbl 188001 `"1880 1%"', add
label define sample_lbl 187003 `"1870 100% database"', add
label define sample_lbl 187002 `"1870 1% sample with black oversample"', add
label define sample_lbl 187001 `"1870 1%"', add
label define sample_lbl 186003 `"1860 100% database"', add
label define sample_lbl 186002 `"1860 1% sample with black oversample"', add
label define sample_lbl 186001 `"1860 1%"', add
label define sample_lbl 185002 `"1850 100% database"', add
label define sample_lbl 185001 `"1850 1%"', add
label values sample sample_lbl

label define stateicp_lbl 01 `"Connecticut"'
label define stateicp_lbl 02 `"Maine"', add
label define stateicp_lbl 03 `"Massachusetts"', add
label define stateicp_lbl 04 `"New Hampshire"', add
label define stateicp_lbl 05 `"Rhode Island"', add
label define stateicp_lbl 06 `"Vermont"', add
label define stateicp_lbl 11 `"Delaware"', add
label define stateicp_lbl 12 `"New Jersey"', add
label define stateicp_lbl 13 `"New York"', add
label define stateicp_lbl 14 `"Pennsylvania"', add
label define stateicp_lbl 21 `"Illinois"', add
label define stateicp_lbl 22 `"Indiana"', add
label define stateicp_lbl 23 `"Michigan"', add
label define stateicp_lbl 24 `"Ohio"', add
label define stateicp_lbl 25 `"Wisconsin"', add
label define stateicp_lbl 31 `"Iowa"', add
label define stateicp_lbl 32 `"Kansas"', add
label define stateicp_lbl 33 `"Minnesota"', add
label define stateicp_lbl 34 `"Missouri"', add
label define stateicp_lbl 35 `"Nebraska"', add
label define stateicp_lbl 36 `"North Dakota"', add
label define stateicp_lbl 37 `"South Dakota"', add
label define stateicp_lbl 40 `"Virginia"', add
label define stateicp_lbl 41 `"Alabama"', add
label define stateicp_lbl 42 `"Arkansas"', add
label define stateicp_lbl 43 `"Florida"', add
label define stateicp_lbl 44 `"Georgia"', add
label define stateicp_lbl 45 `"Louisiana"', add
label define stateicp_lbl 46 `"Mississippi"', add
label define stateicp_lbl 47 `"North Carolina"', add
label define stateicp_lbl 48 `"South Carolina"', add
label define stateicp_lbl 49 `"Texas"', add
label define stateicp_lbl 51 `"Kentucky"', add
label define stateicp_lbl 52 `"Maryland"', add
label define stateicp_lbl 53 `"Oklahoma"', add
label define stateicp_lbl 54 `"Tennessee"', add
label define stateicp_lbl 56 `"West Virginia"', add
label define stateicp_lbl 61 `"Arizona"', add
label define stateicp_lbl 62 `"Colorado"', add
label define stateicp_lbl 63 `"Idaho"', add
label define stateicp_lbl 64 `"Montana"', add
label define stateicp_lbl 65 `"Nevada"', add
label define stateicp_lbl 66 `"New Mexico"', add
label define stateicp_lbl 67 `"Utah"', add
label define stateicp_lbl 68 `"Wyoming"', add
label define stateicp_lbl 71 `"California"', add
label define stateicp_lbl 72 `"Oregon"', add
label define stateicp_lbl 73 `"Washington"', add
label define stateicp_lbl 81 `"Alaska"', add
label define stateicp_lbl 82 `"Hawaii"', add
label define stateicp_lbl 83 `"Puerto Rico"', add
label define stateicp_lbl 96 `"State groupings (1980 Urban/rural sample)"', add
label define stateicp_lbl 97 `"Military/Mil. Reservations"', add
label define stateicp_lbl 98 `"District of Columbia"', add
label define stateicp_lbl 99 `"State not identified"', add
label values stateicp stateicp_lbl

label define countyicp_lbl 0010 `"0010"'
label define countyicp_lbl 0030 `"0030"', add
label define countyicp_lbl 0050 `"0050"', add
label define countyicp_lbl 0070 `"0070"', add
label define countyicp_lbl 0090 `"0090"', add
label define countyicp_lbl 0110 `"0110"', add
label define countyicp_lbl 0130 `"0130"', add
label define countyicp_lbl 0150 `"0150"', add
label define countyicp_lbl 0170 `"0170"', add
label define countyicp_lbl 0190 `"0190"', add
label define countyicp_lbl 0200 `"0200"', add
label define countyicp_lbl 0205 `"0205"', add
label define countyicp_lbl 0210 `"0210"', add
label define countyicp_lbl 0230 `"0230"', add
label define countyicp_lbl 0250 `"0250"', add
label define countyicp_lbl 0270 `"0270"', add
label define countyicp_lbl 0290 `"0290"', add
label define countyicp_lbl 0310 `"0310"', add
label define countyicp_lbl 0330 `"0330"', add
label define countyicp_lbl 0350 `"0350"', add
label define countyicp_lbl 0360 `"0360"', add
label define countyicp_lbl 0370 `"0370"', add
label define countyicp_lbl 0390 `"0390"', add
label define countyicp_lbl 0410 `"0410"', add
label define countyicp_lbl 0430 `"0430"', add
label define countyicp_lbl 0450 `"0450"', add
label define countyicp_lbl 0455 `"0455"', add
label define countyicp_lbl 0470 `"0470"', add
label define countyicp_lbl 0490 `"0490"', add
label define countyicp_lbl 0510 `"0510"', add
label define countyicp_lbl 0530 `"0530"', add
label define countyicp_lbl 0550 `"0550"', add
label define countyicp_lbl 0570 `"0570"', add
label define countyicp_lbl 0590 `"0590"', add
label define countyicp_lbl 0605 `"0605"', add
label define countyicp_lbl 0610 `"0610"', add
label define countyicp_lbl 0630 `"0630"', add
label define countyicp_lbl 0650 `"0650"', add
label define countyicp_lbl 0670 `"0670"', add
label define countyicp_lbl 0690 `"0690"', add
label define countyicp_lbl 0710 `"0710"', add
label define countyicp_lbl 0730 `"0730"', add
label define countyicp_lbl 0750 `"0750"', add
label define countyicp_lbl 0770 `"0770"', add
label define countyicp_lbl 0790 `"0790"', add
label define countyicp_lbl 0810 `"0810"', add
label define countyicp_lbl 0830 `"0830"', add
label define countyicp_lbl 0850 `"0850"', add
label define countyicp_lbl 0870 `"0870"', add
label define countyicp_lbl 0890 `"0890"', add
label define countyicp_lbl 0910 `"0910"', add
label define countyicp_lbl 0930 `"0930"', add
label define countyicp_lbl 0950 `"0950"', add
label define countyicp_lbl 0970 `"0970"', add
label define countyicp_lbl 0990 `"0990"', add
label define countyicp_lbl 1010 `"1010"', add
label define countyicp_lbl 1030 `"1030"', add
label define countyicp_lbl 1050 `"1050"', add
label define countyicp_lbl 1070 `"1070"', add
label define countyicp_lbl 1090 `"1090"', add
label define countyicp_lbl 1110 `"1110"', add
label define countyicp_lbl 1130 `"1130"', add
label define countyicp_lbl 1150 `"1150"', add
label define countyicp_lbl 1170 `"1170"', add
label define countyicp_lbl 1190 `"1190"', add
label define countyicp_lbl 1210 `"1210"', add
label define countyicp_lbl 1230 `"1230"', add
label define countyicp_lbl 1250 `"1250"', add
label define countyicp_lbl 1270 `"1270"', add
label define countyicp_lbl 1290 `"1290"', add
label define countyicp_lbl 1310 `"1310"', add
label define countyicp_lbl 1330 `"1330"', add
label define countyicp_lbl 1350 `"1350"', add
label define countyicp_lbl 1370 `"1370"', add
label define countyicp_lbl 1390 `"1390"', add
label define countyicp_lbl 1410 `"1410"', add
label define countyicp_lbl 1430 `"1430"', add
label define countyicp_lbl 1450 `"1450"', add
label define countyicp_lbl 1470 `"1470"', add
label define countyicp_lbl 1490 `"1490"', add
label define countyicp_lbl 1510 `"1510"', add
label define countyicp_lbl 1530 `"1530"', add
label define countyicp_lbl 1550 `"1550"', add
label define countyicp_lbl 1570 `"1570"', add
label define countyicp_lbl 1590 `"1590"', add
label define countyicp_lbl 1610 `"1610"', add
label define countyicp_lbl 1630 `"1630"', add
label define countyicp_lbl 1650 `"1650"', add
label define countyicp_lbl 1670 `"1670"', add
label define countyicp_lbl 1690 `"1690"', add
label define countyicp_lbl 1710 `"1710"', add
label define countyicp_lbl 1730 `"1730"', add
label define countyicp_lbl 1750 `"1750"', add
label define countyicp_lbl 1770 `"1770"', add
label define countyicp_lbl 1790 `"1790"', add
label define countyicp_lbl 1810 `"1810"', add
label define countyicp_lbl 1830 `"1830"', add
label define countyicp_lbl 1850 `"1850"', add
label define countyicp_lbl 1870 `"1870"', add
label define countyicp_lbl 1875 `"1875"', add
label define countyicp_lbl 1890 `"1890"', add
label define countyicp_lbl 1910 `"1910"', add
label define countyicp_lbl 1930 `"1930"', add
label define countyicp_lbl 1950 `"1950"', add
label define countyicp_lbl 1970 `"1970"', add
label define countyicp_lbl 1990 `"1990"', add
label define countyicp_lbl 2010 `"2010"', add
label define countyicp_lbl 2030 `"2030"', add
label define countyicp_lbl 2050 `"2050"', add
label define countyicp_lbl 2070 `"2070"', add
label define countyicp_lbl 2090 `"2090"', add
label define countyicp_lbl 2110 `"2110"', add
label define countyicp_lbl 2130 `"2130"', add
label define countyicp_lbl 2150 `"2150"', add
label define countyicp_lbl 2170 `"2170"', add
label define countyicp_lbl 2190 `"2190"', add
label define countyicp_lbl 2210 `"2210"', add
label define countyicp_lbl 2230 `"2230"', add
label define countyicp_lbl 2250 `"2250"', add
label define countyicp_lbl 2270 `"2270"', add
label define countyicp_lbl 2290 `"2290"', add
label define countyicp_lbl 2310 `"2310"', add
label define countyicp_lbl 2330 `"2330"', add
label define countyicp_lbl 2350 `"2350"', add
label define countyicp_lbl 2370 `"2370"', add
label define countyicp_lbl 2390 `"2390"', add
label define countyicp_lbl 2410 `"2410"', add
label define countyicp_lbl 2430 `"2430"', add
label define countyicp_lbl 2450 `"2450"', add
label define countyicp_lbl 2470 `"2470"', add
label define countyicp_lbl 2490 `"2490"', add
label define countyicp_lbl 2510 `"2510"', add
label define countyicp_lbl 2530 `"2530"', add
label define countyicp_lbl 2550 `"2550"', add
label define countyicp_lbl 2570 `"2570"', add
label define countyicp_lbl 2590 `"2590"', add
label define countyicp_lbl 2610 `"2610"', add
label define countyicp_lbl 2630 `"2630"', add
label define countyicp_lbl 2650 `"2650"', add
label define countyicp_lbl 2670 `"2670"', add
label define countyicp_lbl 2690 `"2690"', add
label define countyicp_lbl 2710 `"2710"', add
label define countyicp_lbl 2730 `"2730"', add
label define countyicp_lbl 2750 `"2750"', add
label define countyicp_lbl 2770 `"2770"', add
label define countyicp_lbl 2790 `"2790"', add
label define countyicp_lbl 2810 `"2810"', add
label define countyicp_lbl 2830 `"2830"', add
label define countyicp_lbl 2850 `"2850"', add
label define countyicp_lbl 2870 `"2870"', add
label define countyicp_lbl 2890 `"2890"', add
label define countyicp_lbl 2910 `"2910"', add
label define countyicp_lbl 2930 `"2930"', add
label define countyicp_lbl 2950 `"2950"', add
label define countyicp_lbl 2970 `"2970"', add
label define countyicp_lbl 2990 `"2990"', add
label define countyicp_lbl 3010 `"3010"', add
label define countyicp_lbl 3030 `"3030"', add
label define countyicp_lbl 3050 `"3050"', add
label define countyicp_lbl 3070 `"3070"', add
label define countyicp_lbl 3090 `"3090"', add
label define countyicp_lbl 3110 `"3110"', add
label define countyicp_lbl 3130 `"3130"', add
label define countyicp_lbl 3150 `"3150"', add
label define countyicp_lbl 3170 `"3170"', add
label define countyicp_lbl 3190 `"3190"', add
label define countyicp_lbl 3210 `"3210"', add
label define countyicp_lbl 3230 `"3230"', add
label define countyicp_lbl 3250 `"3250"', add
label define countyicp_lbl 3270 `"3270"', add
label define countyicp_lbl 3290 `"3290"', add
label define countyicp_lbl 3310 `"3310"', add
label define countyicp_lbl 3330 `"3330"', add
label define countyicp_lbl 3350 `"3350"', add
label define countyicp_lbl 3370 `"3370"', add
label define countyicp_lbl 3390 `"3390"', add
label define countyicp_lbl 3410 `"3410"', add
label define countyicp_lbl 3430 `"3430"', add
label define countyicp_lbl 3450 `"3450"', add
label define countyicp_lbl 3470 `"3470"', add
label define countyicp_lbl 3490 `"3490"', add
label define countyicp_lbl 3510 `"3510"', add
label define countyicp_lbl 3530 `"3530"', add
label define countyicp_lbl 3550 `"3550"', add
label define countyicp_lbl 3570 `"3570"', add
label define countyicp_lbl 3590 `"3590"', add
label define countyicp_lbl 3610 `"3610"', add
label define countyicp_lbl 3630 `"3630"', add
label define countyicp_lbl 3650 `"3650"', add
label define countyicp_lbl 3670 `"3670"', add
label define countyicp_lbl 3690 `"3690"', add
label define countyicp_lbl 3710 `"3710"', add
label define countyicp_lbl 3730 `"3730"', add
label define countyicp_lbl 3750 `"3750"', add
label define countyicp_lbl 3770 `"3770"', add
label define countyicp_lbl 3790 `"3790"', add
label define countyicp_lbl 3810 `"3810"', add
label define countyicp_lbl 3830 `"3830"', add
label define countyicp_lbl 3850 `"3850"', add
label define countyicp_lbl 3870 `"3870"', add
label define countyicp_lbl 3890 `"3890"', add
label define countyicp_lbl 3910 `"3910"', add
label define countyicp_lbl 3930 `"3930"', add
label define countyicp_lbl 3950 `"3950"', add
label define countyicp_lbl 3970 `"3970"', add
label define countyicp_lbl 3990 `"3990"', add
label define countyicp_lbl 4010 `"4010"', add
label define countyicp_lbl 4030 `"4030"', add
label define countyicp_lbl 4050 `"4050"', add
label define countyicp_lbl 4070 `"4070"', add
label define countyicp_lbl 4090 `"4090"', add
label define countyicp_lbl 4110 `"4110"', add
label define countyicp_lbl 4130 `"4130"', add
label define countyicp_lbl 4150 `"4150"', add
label define countyicp_lbl 4170 `"4170"', add
label define countyicp_lbl 4190 `"4190"', add
label define countyicp_lbl 4210 `"4210"', add
label define countyicp_lbl 4230 `"4230"', add
label define countyicp_lbl 4250 `"4250"', add
label define countyicp_lbl 4270 `"4270"', add
label define countyicp_lbl 4290 `"4290"', add
label define countyicp_lbl 4310 `"4310"', add
label define countyicp_lbl 4330 `"4330"', add
label define countyicp_lbl 4350 `"4350"', add
label define countyicp_lbl 4370 `"4370"', add
label define countyicp_lbl 4390 `"4390"', add
label define countyicp_lbl 4410 `"4410"', add
label define countyicp_lbl 4430 `"4430"', add
label define countyicp_lbl 4450 `"4450"', add
label define countyicp_lbl 4470 `"4470"', add
label define countyicp_lbl 4490 `"4490"', add
label define countyicp_lbl 4510 `"4510"', add
label define countyicp_lbl 4530 `"4530"', add
label define countyicp_lbl 4550 `"4550"', add
label define countyicp_lbl 4570 `"4570"', add
label define countyicp_lbl 4590 `"4590"', add
label define countyicp_lbl 4610 `"4610"', add
label define countyicp_lbl 4630 `"4630"', add
label define countyicp_lbl 4650 `"4650"', add
label define countyicp_lbl 4670 `"4670"', add
label define countyicp_lbl 4690 `"4690"', add
label define countyicp_lbl 4710 `"4710"', add
label define countyicp_lbl 4730 `"4730"', add
label define countyicp_lbl 4750 `"4750"', add
label define countyicp_lbl 4770 `"4770"', add
label define countyicp_lbl 4790 `"4790"', add
label define countyicp_lbl 4810 `"4810"', add
label define countyicp_lbl 4830 `"4830"', add
label define countyicp_lbl 4850 `"4850"', add
label define countyicp_lbl 4870 `"4870"', add
label define countyicp_lbl 4890 `"4890"', add
label define countyicp_lbl 4910 `"4910"', add
label define countyicp_lbl 4930 `"4930"', add
label define countyicp_lbl 4950 `"4950"', add
label define countyicp_lbl 4970 `"4970"', add
label define countyicp_lbl 4990 `"4990"', add
label define countyicp_lbl 5010 `"5010"', add
label define countyicp_lbl 5030 `"5030"', add
label define countyicp_lbl 5050 `"5050"', add
label define countyicp_lbl 5070 `"5070"', add
label define countyicp_lbl 5100 `"5100"', add
label define countyicp_lbl 5200 `"5200"', add
label define countyicp_lbl 5300 `"5300"', add
label define countyicp_lbl 5400 `"5400"', add
label define countyicp_lbl 5500 `"5500"', add
label define countyicp_lbl 5600 `"5600"', add
label define countyicp_lbl 5700 `"5700"', add
label define countyicp_lbl 5800 `"5800"', add
label define countyicp_lbl 5900 `"5900"', add
label define countyicp_lbl 6100 `"6100"', add
label define countyicp_lbl 6300 `"6300"', add
label define countyicp_lbl 6400 `"6400"', add
label define countyicp_lbl 6500 `"6500"', add
label define countyicp_lbl 6600 `"6600"', add
label define countyicp_lbl 6700 `"6700"', add
label define countyicp_lbl 6800 `"6800"', add
label define countyicp_lbl 6900 `"6900"', add
label define countyicp_lbl 7000 `"7000"', add
label define countyicp_lbl 7100 `"7100"', add
label define countyicp_lbl 7200 `"7200"', add
label define countyicp_lbl 7300 `"7300"', add
label define countyicp_lbl 7400 `"7400"', add
label define countyicp_lbl 7500 `"7500"', add
label define countyicp_lbl 7600 `"7600"', add
label define countyicp_lbl 7700 `"7700"', add
label define countyicp_lbl 7800 `"7800"', add
label define countyicp_lbl 7850 `"7850"', add
label define countyicp_lbl 7900 `"7900"', add
label define countyicp_lbl 8000 `"8000"', add
label define countyicp_lbl 8100 `"8100"', add
label define countyicp_lbl 8200 `"8200"', add
label define countyicp_lbl 8300 `"8300"', add
label define countyicp_lbl 8400 `"8400"', add
label values countyicp countyicp_lbl
