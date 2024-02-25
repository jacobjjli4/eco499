/*******************************************************************************
Title:          Master build file
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	January 24, 2024
Date Modified:	February 24, 2024
*******************************************************************************/

clear all
set linesize 240
global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

* Merge and clean data
capture mkdir "$root/data/derived/"
do "$root/code/clean.do"
do "$root/code/merge.do"
do "$root/code/highway_growth.do"
do "$root/code/pctiles_to_dollar.do"

* Make covariates
capture mkdir "$root/data/derived/covariates/"
do "$root/code/covariates/cnty_cz_crosswalk.do"
do "$root/code/covariates/population_cz.do"
do "$root/code/covariates/employment_cz.do"
do "$root/code/covariates/education_cz.do"

* Merge covariates into master data
do "$root/code/merge_covariates.do"

* Analysis
capture mkdir "$root/output/exploratory/"
capture mkdir "$root/output/exploratory/plan_growth/"
capture mkdir "$root/output/exploratory/growth_outcomes/"
capture mkdir "$root/output/exploratory/combine_by_race_gender_pctile/"
capture mkdir "$root/output/exploratory/tables/"

do "$root/code/summary_statistics.do"
do "$root/code/explore.do"