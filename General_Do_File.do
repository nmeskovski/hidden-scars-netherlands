********************************************************************************
* Project: Determinants of Self-Reported General Health
* Data:    Netherlands EU-SILC 2013 (NL_2013p_EUSILC.csv)
* Model:   Ordered Logistic Regression (ologit)
* Author:  [Nikola Meshkovski]
* Date:    [14.05.2024]
********************************************************************************


********************************************************************************
* 1. DATA IMPORT & VARIABLE SELECTION
********************************************************************************

clear
import delimited "Your directory goes here /data.csv"

* Retain only variables relevant to the analysis
keep pb150 ph010 pl051 pb140 pl060 pb190


********************************************************************************
* 2. DATA CLEANING
********************************************************************************

* Derive age from year of birth (survey year: 2013)
gen age = 2013 - pb140

* Drop observations with missing values on key analysis variables
* (Reduces sample from 18,157 to 5,071)
drop if pl051 == .
drop if pl060 == .
drop if ph010 == .


********************************************************************************
* 3. VARIABLE RENAMING & LABELLING
********************************************************************************

rename pb190 marriage
rename pb150 sex
rename pb140 year_born
rename pl051 occp
rename pl060 h_worked
rename ph010 gen_health

* Recode sex: original 1 = Male → 0, original 2 = Female → 1
replace sex = 0 if sex == 1
replace sex = 1 if sex == 2

notes sex:        0 = Male, 1 = Female
notes gen_health: 1 = Very Good, 2 = Good, 3 = Fair, 4 = Bad, 5 = Very Bad


********************************************************************************
* 4. PRELIMINARY MODEL & PARALLEL LINES ASSUMPTION CHECK
********************************************************************************

* Install spost13 if not already installed:
* search spost13

* Initial ologit model including weekly hours worked
ologit gen_health sex marriage occp h_worked age

* Brant test for the parallel lines (proportional odds) assumption
brant, detail

* Average marginal effects (occupation excluded due to categorical coding concerns)
margins, dydx(sex marriage h_worked age)

* h_worked dropped: violates the parallel lines assumption per Brant test
drop h_worked


********************************************************************************
* 5. SAMPLE RESTRICTION TO FIVE OCCUPATION GROUPS
********************************************************************************

* Inspect occupation distribution before subsetting
tab occp, sort

* Retain the five most prevalent occupations
keep if inlist(occp, 33, 23, 52, 24, 41)

* Apply descriptive labels to occupation codes (ISCO-08)
label define occupation_labels  ///
    23 "Teaching Prof."          ///
    24 "Business Prof."          ///
    33 "Business Associate Prof." ///
    41 "General and Keyboard Clerks" ///
    52 "Sales Workers"
label values occp occupation_labels


********************************************************************************
* 6. DUMMY VARIABLE CONSTRUCTION
********************************************************************************

* Occupation dummies (reference category: occp == 41, dropped due to collinearity)
gen dummy_occp33 = (occp == 33)
gen dummy_occp23 = (occp == 23)
gen dummy_occp52 = (occp == 52)
gen dummy_occp24 = (occp == 24)

* Marital status dummies
* Categories 3 and 5 dropped: caused collinearity
* Category 4 dropped: prevented Brant test computation
gen dummy_marriage1 = (marriage == 1)
gen dummy_marriage2 = (marriage == 2)


********************************************************************************
* 7. FINAL VARIABLE SETUP
********************************************************************************

* Rename for interpretability in output
rename sex    female
rename dummy_marriage1 not_married


********************************************************************************
* 8. FINAL MODEL
********************************************************************************

ologit gen_health female not_married i.occp age

* Verify the parallel lines assumption
brant

* Average marginal effects for all predictors
margins, dydx(female not_married i.occp age)


********************************************************************************
* 9. EXPORT RESULTS
********************************************************************************

* Requires outreg2: ssc install outreg2
outreg2 using myreg.doc, replace
