clear

import delimited "/Users/nikolameskovski/Downloads/NL_PUF_EUSILC/NL_2013p_EUSILC.csv"

//keep pb150 pl020 pl025 pl031 pe030 pe040 ph010 pl040 pl051 pl080 pl087 pl200 py010g py010n pb190 pl060 pl100 pl089

keep pb150 ph010 pl051 pb140 pl060 pb190

gen age = 2013 - pb140

drop if pl051 ==.
drop if pl060 ==.
drop if ph010 ==.

//sample size reduced from 18157 to 5071 after dropping missing values

label values pl051 Occupation
label values pb190 MaritalStatus
label values pb150 Sex
label values pb140 YearOfBirth
label values pl060 No_WeeklyHours_Worked
label values ph010 GeneralHealth

rename pb190 marriage
rename pb150 sex
rename pb140 year_born
rename pl051 occp
rename pl060 h_worked
rename ph010 gen_health

replace sex = 0 if sex == 1
replace sex = 1 if sex == 2

notes sex: 0-Male, 1-Female
notes gen_health: 1 very good, 2 good, 3 fair, 4 bad, 5 very bad

ologit gen_health sex marriage occp h_worked age

//search spost13 //download if not downloaded
brant, detail

ologit gen_health sex marriage occp h_worked age
margins, dydx(sex marriage h_worked age)	//I don't know wether or not to include occupation in this model since its code names

drop h_worked //dropped cause it didn't satisfy the parralel line assumption

tab occp
tab occp, sort
keep if inlist(occp, 33, 23, 52, 24, 41)

gen dummy_occp33 = (occp == 33)
gen dummy_occp23 = (occp == 23)
gen dummy_occp52 = (occp == 52)
gen dummy_occp24 = (occp == 24)
gen dummy_occp41 = (occp == 41)

gen dummy_marriage1 = (marriage == 1)
gen dummy_marriage2 = (marriage == 2)
gen dummy_marriage3 = (marriage == 3)
gen dummy_marriage4 = (marriage == 4)
gen dummy_marriage5 = (marriage == 5)

ologit gen_health sex age dummy_occp33 dummy_occp23 dummy_occp52 dummy_occp24 dummy_occp41 dummy_marriage1 dummy_marriage2 dummy_marriage3 dummy_marriage4 dummy_marriage5
//dropped occupation 41 from model due to collinearity as well as marriage 3 and 5 //

ologit gen_health sex age dummy_occp33 dummy_occp23 dummy_occp52 dummy_occp24 dummy_marriage1 dummy_marriage2 dummy_marriage4
//dummy_marriage4 removed because "not all independent variables can be retained in binary logits, brant test cannot be computed" //


//new model// //not final
ologit gen_health sex age dummy_occp33 dummy_occp23 dummy_occp52 dummy_occp24 dummy_marriage1 dummy_marriage2

brant, detail

margins, dydx(sex age dummy_occp33 dummy_occp23 dummy_occp52 dummy_occp24 dummy_marriage1 dummy_marriage2)


//old model//
ologit gen_health sex marriage occp age
brant
margins, dydx(sex marriage occp age)



ssc install outreg2

ologit gen_health sex age dummy_occp33 dummy_occp23 dummy_occp52 dummy_occp24 dummy_marriage1 dummy_marriage2

outreg2 using myreg.doc, replace

drop dummy_marriage5 dummy_marriage4 dummy_marriage3 dummy_marriage2

label define occupation_labels 23 "Teaching Prof." 24 "Business Prof." 33 "Business Associate Prof." 41 "General and Keyboard Clerks" 52 "Sales Workers"
label values occp occupation_labels

rename sex female
rename dummy_marriage1 not_married


//final ologit model
ologit gen_health female not_married i.occp age
brant
margins, dydx(female not_married i.occp age)

