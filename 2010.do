********************************************************************************
****************** Data cleaning for post planiting household survey ***********
********************************************************************************
clear all                                                                                            
set more off 
cd  "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/Post Planting Wave 1/"
********************************************************************************
********************************************************************************

use "Household/sect1_plantingw1.dta", clear 
**duplicates report hhid indiv 
**tab1 s1q5_year
keep zone state lga sector ea hhid indiv s1q5_year s1q4
rename s1q4 HM15
gen HMA15=1 if HM15>=14 & HM15<=60
replace HMA15=0 if HM15<=14 & HM15>=60
bys hhid: egen HMAG15=sum(HMA15)
label var HMAG15 "Household member age greater than 15"
keep if indiv==1
gen current=2011
bys hhid: gen HHH_A=(current-s1q5_year)
bys hhid: egen HHAge=max(HHH_A)
label var HHAge " Household Head Age "
drop HHH_A current s1q5_year
replace HHAge=0 if HHAge<=0
bys hhid: keep if _n==1
drop indiv HM15 HMA15
replace  HHAge=. if  HHAge==0
replace HHAge=. if  HHAge==151
save "HPP", replace

use "Household/sect2_plantingw1.dta", clear 
**duplicates report hhid indiv 
**tab1 s2q7
keep zone state lga sector ea hhid indiv s2q7
rename s2q7 HHEdu
recode HHEdu 0=1 1=1 2=1 11=1 12=1 13=1 14=1 15=1 16=1 27=1 21=2 22=2 23=2 24=2 25=2 26=2 28=2 31=3 32=3 33=3 51=3 52=3 61=3 34=4 41=4 42=4 43=4
replace HHEdu=. if HHEdu==0
keep if indiv==1
tabulate HHEdu, gen(Edu)
rename Edu1 PrimaryEdu
label var PrimaryEdu "Primary education level"
rename Edu2 SecondaryEdu
label var SecondaryEdu "Secondary education level"
rename Edu3 Training
label var Training "Trainings with certificate"
rename Edu4 HigherEdu
label var HigherEdu "Higher Education level"
label var HHEdu " household head has attained any formal education "
drop indiv 
merge 1:1 hhid using "HPP"
drop _m  
save "HPP", replace

use "Household/sect3_plantingw1.dta", clear
**duplicates report hhid indiv
**tab1 s3q21a s3q33a
keep zone state lga sector ea hhid indiv s3q16 s3q17 s3q18 s3q19 s3q21a s3q21b s3q22 s3q23a s3q23b s3q28 s3q29 s3q30 s3q31 s3q33a s3q33b s3q34 s3q35a s3q35b 
gen wage=1
replace wage=(7*s3q21a*s3q17)/s3q18 if s3q21b==2
replace wage=(s3q21a/4)*(s3q17/s3q18) if s3q21b==5
replace wage=(s3q21a*s3q17)/s3q18 if s3q21b==3
replace wage=(s3q21a/2)*s3q17 if s3q21b==4
replace wage=(1*s3q21a) if s3q21b==1
replace wage=(s3q21a/12)*(s3q17/s3q18) if s3q21b==6
replace wage=(s3q21a/24)*(s3q17/s3q18) if s3q21b==7
replace wage=(s3q21a/48)*(s3q17/s3q18) if s3q21b==8
replace wage=0 if s3q19==2
replace wage=0 if wage==1

gen wage1=1
replace wage1=(7*s3q23a*s3q17)/s3q18 if s3q23b==2
replace wage1=(s3q23a/4)*(s3q17/s3q18) if s3q23b==5
replace wage1=(s3q23a*s3q17)/s3q18 if s3q23b==3
replace wage1=(s3q23a/2)*s3q17 if s3q23b==4
replace wage1=(1*s3q23a) if s3q21b==1
replace wage1=(s3q23a/12)*(s3q17/s3q18) if s3q23b==6
replace wage1=(s3q23a/24)*(s3q17/s3q18) if s3q23b==7
replace wage1=(s3q23a/48)*(s3q17/s3q18) if s3q23b==8
replace wage1=0 if s3q22==2
replace wage1=0 if wage1==1


gen wage2=1
replace wage2=(7*s3q33a*s3q29)/s3q30 if s3q33b==2
replace wage2=(s3q33a/4)*(s3q29/s3q30) if s3q33b==5
replace wage2=(s3q33a*s3q29)/s3q30 if s3q33b==3
replace wage2=(s3q33a/2)*s3q29 if s3q33b==4
replace wage2=(1*s3q33a) if s3q21b==1
replace wage2=(s3q33a/12)*(s3q29/s3q30) if s3q33b==6
replace wage2=(s3q33a/24)*(s3q29/s3q30) if s3q33b==7
replace wage2=(s3q33a/48)*(s3q29/s3q30) if s3q33b==8
replace wage2=0 if s3q31==2
replace wage2=0 if wage2==1

gen wage3=1
replace wage3=(7*s3q35a*s3q29)/s3q30 if s3q35b==2
replace wage3=(s3q35a/4)*(s3q29/s3q30) if s3q35b==5
replace wage3=(s3q35a*s3q29)/s3q30 if s3q35b==3
replace wage3=(s3q35a/2)*s3q29 if s3q35b==4
replace wage3=(1*s3q35a) if s3q21b==1
replace wage3=(s3q35a/12)*(s3q29/s3q30) if s3q35b==6
replace wage3=(s3q35a/24)*(s3q29/s3q30) if s3q35b==7
replace wage3=(s3q35a/48)*(s3q29/s3q30) if s3q35b==8
replace wage3=0 if s3q34==2
replace wage3=0 if wage3==1
egen Wages=rowtotal(wage wage1 wage2 wage3)
bys hhid: egen OffWage=sum(Wages)
label var OffWage "Off farm wages"
bys hhid: keep if _n==1
drop indiv
merge 1:1 hhid using "HPP"
drop _m s3q16 s3q17 s3q18 s3q19 s3q21a s3q21b s3q22 s3q23a s3q23b s3q28 s3q29 s3q30 s3q31 s3q33a s3q33b s3q34 s3q35a s3q35b wage wage1 wage2 wage3 Wages
save "HPP", replace

use "Household/sect4_plantingw1.dta", clear 
**tab1 s4q7,m
**tab1 s4q9,m
**tab1 s4q10,m
**duplicates report hhid indiv 
keep zone state lga sector ea hhid indiv s4q7  s4q9 s4q10
gen Credit=0 if s4q7==2 |s4q9==2|s4q10==2
replace Credit=1 if s4q7==1 |s4q9==1|s4q10==1
label var Credit " Credit from formal and informal institutions"
replace Credit=0 if Credit==.
drop s4q7  s4q9 s4q10
bys hhid: keep if _n==1
drop indiv
merge 1:1 hhid using "HPP"
drop _m
save "HPP", replace

use "Household/sect5b_plantingw1.dta", clear
**duplicates report hhid item_cd item_number
gen AstVal=s5q4*item_number
label var AstVal "Total asset value"
keep zone state lga sector ea hhid item_cd AstVal
bys hhid item_cd: egen TotAsset=sum(AstVal)
label var TotAsset "total household assets"
bys hhid item_cd: keep if _n==1
bys hhid: egen HHWealth=sum(TotAsset)
label var HHWealth "Total household Assets owned"
replace HHWealth=0 if HHWealth==.
drop AstVal TotAsset item_cd
bys hhid: keep if _n==1
merge 1:1 hhid using "HPP"
drop _m
save "HPP", replace


********************************************************************************
********************* HOUSEHOLD POST HARVEST ***********************************
********************************************************************************
cd  "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/Post Harvest Wave 1/"
********************************************************************************

use "Household/sect9_harvestw1.dta", clear
**duplicates report hhid entid
drop if entid==.
keep zone state lga sector ea hhid entid s9q3 s9q10 s9q24 s9q26 s9q27 s9q28a  s9q28b  s9q28c  s9q28d  s9q28e  s9q28f  s9q28g  s9q28h 
bys hhid: egen entcost=sum(s9q28a + s9q28b + s9q28c + s9q28d + s9q28e + s9q28f + s9q28g + s9q28h) 
gen Enterprofit=(s9q27-entcost)*s9q10
replace Enterprofit=0 if s9q3==2 |s9q3==3
label var Enterprofit "Enterprise profit obtained owned"
drop entid entcost s9q3 s9q10 s9q24 s9q26 s9q27 s9q28a  s9q28b  s9q28c  s9q28d  s9q28e  s9q28f  s9q28g  s9q28h 
bys hhid: keep if _n==1
save "HPH", replace

use "Household/sect6_harvestw1.dta", clear
**duplicates report hhid indiv 
keep zone state lga sector ea hhid indiv s6q3 s6q4 s6q5 s6q8 s6q9 s6q10
**tab1 s6q3 s6q9,m
replace s6q3=0 if s6q3==.
replace s6q4=0 if s6q4==.
replace s6q8=0 if s6q8==.
replace s6q9=0 if s6q9==.
gen foreign=s6q4*152 if s6q5==1
replace foreign=s6q4*227 if s6q5==2
replace foreign=s6q4*227 if s6q5==3
gen foreigns=s6q9*152 if s6q10==1
replace foreigns=s6q9*227 if s6q10==2
replace foreigns=s6q9*227 if s6q10==3
egen Remittance=sum(foreign + foreigns + s6q3 + s6q8)
bys hhid: egen Remittance=sum(foreign + foreigns + s6q3 + s6q8)
label var Remittance " Total amount of both cash and in-kind remittance per household"
drop s6q3 s6q4 s6q5 s6q8 s6q9 s6q10 foreign foreigns
bys hhid: keep if _n==1
merge 1:1 hhid using "HPH"
drop _m
save "HPH", replace

use "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/cons_agg_w1.dta"
keep hhid hhsize_PH
rename hhsize_PH Hsize
label var Hsize "Number of household members"
merge 1:1 hhid using "HPH"
drop _m
save "HPH", replace

use "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/Post Planting Wave 1/HPP"
merge 1:1 hhid using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/Post Harvest Wave 1/HPH"
drop _merge
save "Households.dta", replace


cd "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/Geodata"

use "NGA_HouseholdGeovariables_Y1.dta", clear
duplicates report hhid dist_road dist_market af_bio_12 sq1 srtm_nga_5_15
keep hhid dist_road dist_market af_bio_12 sq1 srtm_nga_5_15 dist_popcenter
rename dist_road Distroad
label var Distroad "nearest distance to road"
rename dist_market Distmarket
label var Distmarket "Nearest distance to market"
rename  af_bio_12 Rainfall
label var Rainfall " Amount of rainfall (mm)"
rename sq1 Soilnutrient
tabulate Soilnutrient, gen(Soilnutri)
label var Soilnutrient " Soil fertility"
rename srtm_nga_5_15 Topography
tabulate Topography, gen(Topogr)
label var Topography " Terrain roughness" 
rename dist_popcenter Populatedarea
label var Populatedarea " Nearest highly populated area +20000"
merge 1:1 hhid using "Households.dta"
drop _m
save "TEKLALAHOUSEHOLD", replace

********************************************************************************
************************** AGRICULTURE PSOT-PLANTING ***************************
********************************************************************************
cd "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/Post Planting Wave 1"
********************************************************************************
********************************************************************************

use "Agriculture/sect11a1_plantingw1.dta", clear
***duplicates report hhid plotid
keep zone state lga sector  ea hhid plotid s11aq4d
rename s11aq4d Plotsize
label var Plotsize "Plot size in square meters"
save "APP", replace

use "Agriculture/sect11b_plantingw1.dta", clear
**duplicates report hhid plotid
keep zone state lga sector ea hhid plotid s11bq5 s11bq4 s11bq9 s11bq10 s11bq25 s11bq26a s11bq26b
**tab1 s11bq5 s11bq9 s11bq10 s11bq25 s11bq26a s11bq26b,m
gen Plotpurchase=0 if  s11bq4==2 |s11bq4==3 |s11bq4==4
replace Plotpurchase=1 if s11bq4==1
label var Plotpurchase "=1 if plot purchased"
gen Plotrented=0 if s11bq4==1 |s11bq4==3 |s11bq4==4
replace Plotrented=1 if s11bq4==2
replace Plotrented=0 if Plotrented==.
label var Plotrented "=1 if plot rented"
rename s11bq5 Plotpurchprice
label var Plotpurchprice " In-kind and cash paid to aquire plot"
gen Plotrentprice=s11bq9+s11bq10
label var  Plotrentprice " Plot rented in-kind and cash-Naira"
drop s11bq9 s11bq10 s11bq25 s11bq26a s11bq26b s11bq4 
merge 1:1 hhid plotid using "APP"
drop _m
save "APP", replace

use "Agriculture/sect11c_plantingw1.dta", clear
**duplicates report hhid plotid
keep zone state lga sector ea hhid plotid s11cq29 s11cq30b s11cq30d s11cq30f s11cq23a s11cq24a s11cq32 s11cq33
gen Machinery_rent=0 if s11cq29==2 
replace Machinery_rent=1 if s11cq29==1 
label var Machinery_rent " =1 if machinery rented"
*egen All_machinery_used=max(Machinery_use)
*label var All_machinery_used " 1=yes if the household uses any machinery"
egen MachiRentprice=rowtotal(s11cq32 s11cq33)
label var MachiRentprice " Amount spent to rent machinery"
egen Animalrentprice=rowtotal(s11cq23a s11cq24a)
label var Animalrentprice " Amount spent in renting draft animals"
drop  s11cq30b s11cq30d s11cq30f s11cq29 s11cq23a s11cq24a s11cq32 s11cq33
merge 1:1 hhid plotid using "APP"
drop _m
save "APP", replace

use "Agriculture/sect11d_Plantingw1.dta", clear
**duplicates report hhid plotid
keep zone state lga sector ea hhid plotid s11dq4 s11dq8 s11dq12 s11dq14 s11dq15 s11dq16 s11dq18 s11dq26 s11dq25 s11dq29 s11dq27
*gen PurFert2010=0 if s11dq12==2 & s11dq12<.
*replace PurFert2010=1 if s11dq12==1
*label var PurFert2010 "=1 if the household uses fertilizer"
rename s11dq4 LeftFert
label var LeftFert "Left over fertilizer"
rename s11dq8 FreeFert 
gen Fertown=sum(LeftFert+FreeFert)
label var Fertown "Free fertilizer obtained and fertilizer from previous year"
/*gen NPK1Q1=(1*s11dq15) if s11dq14==1
gen NPK1Q2=(1*s11dq25) if s11dq25==1
egen NPKQ=rowtotal(NPK1Q1 NPK1Q2)
gen UREAQ1=(1*s11dq15) if s11dq14==2
gen UREA1Q2=(1*s11dq25) if s11dq25==2
egen UREAQ=rowtotal(UREAQ1 UREA1Q2)
replace UREAQ=. if UREAQ==0
gen OtherQ1=(1*s11dq15) if s11dq14==4
gen Other1Q2=(1*s11dq25) if s11dq25==4
egen OtherQ=rowtotal(OtherQ1 Other1Q2)
replace OtherQ=. if OtherQ==0
egen Fert_Qty1=rowtotal(NPKQ UREAQ OtherQ)
gen Fert_Qty=sum(Fert_Qty1)*/
egen PurFert= rowtotal(s11dq15 s11dq26)
egen fertValu= rowtotal(s11dq18 s11dq29)
label var PurFert "Total Fertilizer Quantity from first and second purchase"
bys hhid plotid: gen Fertprice1=(fertValu/PurFert)  
gen Fertprice=100
label var Fertprice " Price Index of Fertilizer value"
*egen fertValu= rowtotal(s11dq18 s11dq29)
*label var fertValu "Total Fertilizer value of first and second purchase"
egen FertTrans_cost1= rowtotal(s11dq16 s11dq27) if s11dq16!=. | s11dq27!=.
gen FertTrans_cost=FertTrans_cost1/PurFert
label var FertTrans_cost "Transportation cost of purchased fertilizer"
drop s11dq12 s11dq15 s11dq16 s11dq18 s11dq26 s11dq29 s11dq27 s11dq25 LeftFert FreeFert  FertTrans_cost1
merge 1:1 hhid plotid using "APP"
drop _m
drop fertValu Fertprice1 s11dq14
save "APP", replace

use "Agriculture/sect11e_Plantingw1.dta", clear
**duplicates report hhid plotid cropid
keep zone state lga sector ea hhid plotid cropid s11eq2 s11eq5 s11eq6a s11eq10a s11eq14 s11eq16 s11eq17a s11eq17b s11eq17c s11eq18  s11eq20 s11eq28a s11eq28b s11eq28c s11eq29 s11eq31
rename s11eq2 cropcode
encode s11eq17c,gen(nscode)
merge m:m cropcode nscode using New_AG_Conversion
drop _merge
replace conversion=1 if s11eq17b==2
replace conversion=0.001 if s11eq17b==1
gen seedQ1=conversion*s11eq17a
gen seedQ2=conversion*s11eq28a
gen PrvHrseed=s11eq6a*conversion
label var PrvHrseed "Seed quantity from previous harvest"
gen Freeseed=s11eq10a*conversion
label var Freeseed " Free seed quantity"
gen Seedown=sum(PrvHrseed+Freeseed)
label var Seedown " Total Free seed and seed from previous harvest"
egen Seed_Qty=rowtotal(seedQ1 seedQ2)
bys hhid plotid: egen PurSeed=sum(Seed_Qty)
label var PurSeed "Total quantity of seed purchased"
egen Seedvalue= rowtotal(s11eq20 s11eq31) if s11eq20!=. | s11eq31!=.
bys hhid plotid: egen Seed_Val=sum(Seedvalue)
gen SeedPrice=100
label var SeedPrice "Price Index of seeds"
*gen price=Seed_Val/PurSeed
*gen Seedprice=100
egen tran_cost= rowtotal(s11eq29 s11eq18) if s11eq29!=. | s11eq18!=.
label var tran_cost "transportation cost of purchased purchased seed"
drop s11eq14 s11eq16 s11eq17a s11eq17b s11eq18 s11eq20 s11eq28a s11eq28b s11eq29 s11eq31  seedQ1 seedQ2  Seedvalue 
bys hhid plotid: egen SeedTrans_Cost1=sum(tran_cost)
gen SeedTrans_Cost=SeedTrans_Cost1/Seed_Qty
label var SeedTrans_Cost "Transportation cost to aquier seed"
bys hhid plotid: keep if _n==1
drop s11eq5 PrvHrseed Freeseed s11eq17c s11eq28c nscode cropname conversion Seed_Qty SeedTrans_Cost1 tran_cost Seed_Val
merge 1:1 hhid plotid using "APP"
drop _m
drop cropid cropcode s11eq6a s11eq10a
save "APP", replace

********************************************************************************
********************** AGRICULTURE POST HARVESTING *****************************
********************************************************************************
cd  "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/Post Harvest Wave 1"
********************************************************************************
********************************************************************************

use "Agriculture/secta3_Harvestw1.dta", clear
**duplicates report hhid plotid cropid
keep zone state lga sector ea hhid plotid cropid sa3q2 sa3q3 sa3q4 sa3q6a sa3q6b  
**tab1 sa3q3 sa3q4 sa3q6a sa3q6b,m
rename sa3q2 agcropid
rename sa3q6b nscode
*gen ProdCons=0 if sa3q3==1
*replace ProdCons=1 if sa3q3==2
*label var ProdCons "constraints of production"
drop sa3q3 sa3q4 
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
gen Qharvst=conversion * sa3q6a
label var Qharvst "Total amount of harvest"
bys hhid plotid: egen TotQharvst=sum(Qharvst)
label var TotQharvst "Total amount of harvest"
drop sa3q6a cropid agcropid nscode cropname conversion _merge Qharvst
bys hhid plotid: keep if _n==1
save "Adam-1", replace

use "Agriculture/secta3_Harvestw1.dta", clear
keep zone state lga sector ea hhid plotid cropid sa3q2 sa3q11a sa3q11b
rename sa3q2 agcropid
rename sa3q11b nscode
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
drop _merge
gen Qsale= conversion * sa3q11a
drop sa3q11a cropid agcropid nscode cropname conversion 
bys hhid plotid: keep if _n==1
merge 1:1 hhid plotid using "Adam-1"
drop _m
save "Adam-2", replace

use "Agriculture/secta3_Harvestw1.dta", clear
keep zone state lga sector ea hhid plotid cropid sa3q2 sa3q16a sa3q12 sa3q17 sa3q16b   
rename sa3q2 agcropid
rename sa3q16b nscode
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
drop _merge
gen Qsale2= conversion * sa3q16a
egen Hvsaleprice=rowtotal(sa3q12 sa3q17)
label var Hvsaleprice "Harvest sales price"
drop sa3q16a cropid agcropid nscode cropname conversion 
bys hhid plotid: keep if _n==1
merge 1:1 hhid plotid using "Adam-2"
drop _m
drop sa3q12 sa3q17
save "Adam-3", replace

use "Agriculture/secta3_Harvestw1.dta", clear
keep zone state lga sector ea hhid plotid cropid sa3q2 sa3q20a sa3q20b   
rename sa3q2 agcropid
rename sa3q20b nscode
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
drop _merge
gen Storseed= conversion*sa3q20a
label var Storseed "Total seeds stored for next plantation"
bys hhid plotid: egen TStorseed=sum(Storseed)
drop sa3q20a cropid agcropid nscode cropname conversion 
bys hhid plotid: keep if _n==1
merge 1:1 hhid plotid using "Adam-3"
drop _m
save "Adam-4", replace

use "Agriculture/secta3_Harvestw1.dta", clear
keep zone state lga sector ea hhid plotid cropid sa3q2 sa3q21a sa3q21b   
rename sa3q2 agcropid
rename sa3q21b nscode
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
drop _merge
gen Paylabseed= conversion*sa3q21a
label var Paylabseed "Seeds used as mechanism of payment"
bys hhid plotid: egen TPaylabseed=sum(Paylabseed)
drop sa3q21a cropid agcropid nscode cropname conversion 
bys hhid plotid: keep if _n==1
merge 1:1 hhid plotid using "Adam-4"
drop _m
save "Adam-5", replace

use "Agriculture/secta3_Harvestw1.dta", clear
keep zone state lga sector ea hhid plotid cropid sa3q2 sa3q22a sa3q22b   
rename sa3q2 agcropid
rename sa3q22b nscode
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
drop _merge
gen Gseed= conversion*sa3q22a
label var Gseed "Seeds used as a gift to others"
bys hhid plotid: egen TGseed=sum(Gseed)
drop sa3q22a cropid agcropid nscode cropname conversion 
bys hhid plotid: keep if _n==1
merge 1:1 hhid plotid using "Adam-5"
drop _m
save "Adam-6", replace



use "Agriculture/secta3_Harvestw1.dta", clear
keep zone state lga sector ea hhid plotid cropid sa3q2 sa3q23a sa3q23b zone state lga sector ea  
rename sa3q2 agcropid
rename sa3q23b nscode
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
drop _merge
gen PHlossseed= conversion*sa3q23a
label var PHlossseed "Post harvest lost seeds"
bys hhid plotid: egen TPHlossseed=sum(PHlossseed)
drop sa3q23a cropid agcropid nscode cropname conversion 
bys hhid plotid: keep if _n==1 
merge 1:1 hhid plotid using "Adam-6"
drop _m
drop if hhid==.
save "APH", replace

use "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/Post Planting Wave 1/APP"
merge 1:1 hhid plotid using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/Post Harvest Wave 1/APH"
drop _m
egen TQsale= rowtotal(Qsale2 Qsale)
label var TQsale "Total amount of sold harvest"
bys hhid plotid: egen TotQtsale=sum(TQsale)
label var TotQtsale "Total amount of sold harvest"
gen cons_quant=(TotQharvst-TotQtsale-TStorseed-TPaylabseed-TGseed-TPHlossseed)
label var cons_quant "Total quantity consumed"
drop PHlossseed TPHlossseed Gseed TGseed Paylabseed TPaylabseed Storseed TStorseed Qsale2 Qsale TQsale
save "Adu-agriculture", replace

cd "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/Geodata"

use "NGA_PlotGeovariables_Y1.dta"
keep hhid plotid  dist_household
**duplicates report hhid dist_household
rename dist_household Disthousehold
label var Disthousehold " Distance of farm to household"
merge 1:1 hhid plotid using "Adu-agriculture"
drop _m
save "TeklalaAgriculture.dta", replace
********************************************************************************
**************************** END OF CLEANING ***********************************
********************************************************************************
********************************************************************************
use "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/Geodata/TeklalaAgriculture.dta"
merge m:1 hhid using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/Geodata/TEKLALAHOUSEHOLD"
drop _merge
gen year=2010
replace Seedown=0 if Seedown==.
replace PurSeed=0 if PurSeed==.
replace SeedPrice=0 if SeedPrice==.
replace SeedTrans_Cost=0 if SeedTrans_Cost==.
replace Fertown=0 if Fertown==.
replace PurFert=0 if PurFert==.
replace Fertprice=0 if Fertprice==.
replace FertTrans_cost=0 if FertTrans_cost==.
replace Machinery_rent=0 if Machinery_rent==.
replace MachiRentprice=0 if MachiRentprice==.
replace Animalrentprice=0 if Animalrentprice==.
replace Plotpurchprice=0 if Plotpurchprice==.
replace Plotpurchase=0 if Plotpurchase==.
replace Plotrented=0 if Plotrented==.
replace Plotrentprice=0 if Plotrentprice==.
replace Plotsize=0 if Plotsize==.
replace Hvsaleprice=0 if Hvsaleprice==.
replace TotQharvst=0 if TotQharvst==.
replace TotQtsale=0 if TotQtsale==.
replace cons_quant=0 if cons_quant==.
replace HMAG15=0 if HMAG15==.
replace Hsize=0 if Hsize==.
replace Remittance=0 if Remittance==.
replace Enterprofi=0 if Enterprofi==.
replace OffWage=0 if OffWage==.
replace plotid=0 if plotid==.
replace PrimaryEdu=0 if PrimaryEdu==.
replace SecondaryEdu=0 if SecondaryEdu==.
replace HigherEdu=0 if HigherEdu==.
replace Training=0 if Training==.
label var year"panel year 2010"
order state zone lga ea sector hhid plotid PurSeed PurFert Machinery_rent Plotrented Remittance Enterprofi OffWage Credit HHWealth HHEdu PrimaryEdu SecondaryEdu Training HigherEdu HMAG15 HHAge Hsize SeedPrice Seedown SeedTrans_Cost Fertown Fertprice FertTrans_cost MachiRentprice Animalrentprice Plotpurchprice Plotrentprice Plotsize Hvsaleprice TotQharvst TotQtsale cons_quant Distroad Populatedarea Distmarket Rainfall Topography Soilnutrient Soilnutri1 Soilnutri2 Soilnutri3 Soilnutri4 Soilnutri5 Soilnutri6 Topogr1 Topogr2 Topogr3 Topogr4 Topogr5 Topogr6 Topogr7 Topogr8 Topogr9 Topogr10 Topogr11
save "Asmir_wave_1.dta", replace
********************************************************************************
********************************************************************************
***************************** Do File 2010-2015*********************************

use "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/Geodata/Asmir_wave_1.dta"
app using "/Users/saliemhaile/Desktop/wave-2 LSMS/2012/Geodata Wave 2/Asmir_wave_2.dta"
app using "/Users/saliemhaile/Desktop/wave-3 LSMS /2015/Post harvest wave 3/Asmir_wave_3.dta"
egen hhplo= group(hhid plotid),label
drop indiv 
egen id_hhplot = group(hhplo)
drop if hhplo ==.
xtset id_hhplo year
order state zone lga ea sector hhid plotid PurSeed PurFert Machinery_rent Plotrented Remittance Enterprofi OffWage Credit HHWealth HHEdu PrimaryEdu SecondaryEdu Training HigherEdu HMAG15 HHAge Hsize SeedPrice Seedown SeedTrans_Cost Fertown Fertprice FertTrans_cost MachiRentprice Animalrentprice Plotpurchprice Plotrentprice Plotsize Hvsaleprice TotQharvst TotQtsale cons_quant Distroad Populatedarea Distmarket Rainfall Topography Soilnutrient Soilnutri1 Soilnutri2 Soilnutri3 Soilnutri4 Soilnutri5 Soilnutri6 Topogr1 Topogr2 Topogr3 Topogr4 Topogr5 Topogr6 Topogr7 Topogr8 Topogr9 Topogr10 Topogr11
gen Productivity=TotQharvst/Plotsize
replace Productivity=0 if Productivity==.
label var Productivity "Productivity of plot"
gen Plotperhh=Plotsize/Hsize
label var  Plotperhh "Plot per household members"
gen lnFertprice=log(Fertprice)
replace lnFertprice=0 if lnFertprice==.
gen lnFertTrans_cost=log(FertTrans_cost)
replace lnFertTrans_cost=0 if lnFertTrans_cost==.
gen lnSeedPrice=log(SeedPrice)
replace lnSeedPrice=0 if lnSeedPrice==.
gen lnHHWealth=log(HHWealth)
replace lnHHWealth=0 if lnHHWealth==.
gen lnSeedTrans_Cost=log(SeedTrans_Cost)
replace lnSeedTrans_Cost=0 if lnSeedTrans_Cost==.
gen lnProductivity=log(Productivity)
replace lnProductivity=0 if lnProductivity==.
replace PrimaryEdu=0 if PrimaryEdu==.
replace SecondaryEdu=0 if SecondaryEdu==.
replace Training=0 if Training==.
replace HigherEdu=0 if HigherEdu==.
rename Soilnutri1 Saline
rename Soilnutri2 Slightconst
rename Soilnutri3 Moderateconst
rename Soilnutri4 Severconst
rename Soilnutri5 Veryseverconst
rename Soilnutri6 Water
replace plotid=. if plotid==0
bys hhid plotid: drop if plotid==.
save "Nigeria",replace
********************************************************************************
********************************************************************************
********************************************************************************

