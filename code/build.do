/*******************************************************************************
Title:          Master build file
Author:			Jia Jun (Jacob) Li
Contact:		li.jiajun@hotmail.com
Date Created:	January 24, 2024
Date Modified:	Jan 24, 2024
*******************************************************************************/

clear all
set linesize 240
global root = "/Users/jacobjjli/Library/CloudStorage/OneDrive-UniversityofToronto/Documents/School/1-5 ECO499/eco499/"

do "$root/code/clean.do"
do "$root/code/merge.do"
do "$root/code/pctiles_to_dollar.do"