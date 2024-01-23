/*******************************************************************************
Title:			Crosswalk HH income percentiles to 2015 dollars
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	January 23, 2024
Date Modified:	Jan 23, 2024
*******************************************************************************/

clear all
set linesize 240

global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

use "$root/data/raw/pctile_to_dollar_cw.dta"
keep percentile kid_hh_income