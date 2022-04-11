clear all
set more off
capture log close
cd "L:\EC2228"
log using Metrics_project.log, text replace
use crime.dta, clear
*dropping other events than dwelling robbery
keep if event_cd == 11
*dropping irrelevant variables
keep hhid sector zone state lga ea s17q00 s17q01
*saving as new dataset
save robbery.dta, replace
*checking infrastructure dataset
use infra.dta, clear
*keeping only police station availability
keep if inf_cd == 221
save infra_police.dta, replace
use robbery.dta, clear
*merging to get police station availability
merge m:1 lga ea using infra_police.dta, keepusing(c02q01)
*changing some names for clarity
rename c02q01 police
rename s17q01 robbed
*dropping merged column
drop _merge
save robbery.dta, replace
*checking community organization dataset
use org.dta, clear
*keeping only community police
keep if org_cd==313
save com_police.dta, replace
use robbery.dta
merge m:1 lga ea using com_police.dta, keepusing (c03q01 c03q03)
rename c03q01 comunity_police
rename c03q03 num_comunity_pocice
replace num_comunity_pocice=0 if comunity_police==2
save robbery.dta, replace
regress robbed num_comunity_pocice
use robbery.dta, clear
merge 1:1 hhid using housing.dta, keepusing(s14q02 s14q09)
drop _merge
rename s14q02 dwtype
rename s14q09 walltype
gen bungalow = 1 if dwtype == 1
replace bungalow = 0 if dwtype != 1 & dwtype !=.
gen smdetatched = 1 if dwtype == 2
replace smdetatched = 0 if dwtype != 2 & dwtype !=.
gen apart = 1 if dwtype == 3
replace apart = 0 if dwtype != 3 & dwtype !=.
gen compound = 1 if dwtype == 4
replace compound = 0 if dwtype != 4 & dwtype !=.
gen huts = 1 if dwtype == 5
replace huts = 0 if dwtype != 5 & dwtype !=.
gen huts2 = 1 if dwtype == 6
replace huts = 0 if dwtype != 6 & dwtype !=.
gen other = (dwtype !=1 & dwtype !=2 & dwtype !=3 & dwtype !=4 & dwtype !=5 & dwtype !=6 &dwtype!=.)
regress robbed apart