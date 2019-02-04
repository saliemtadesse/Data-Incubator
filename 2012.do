

********************************************************************************
****************** Data cleaning for post planiting household survey ***********
********************************************************************************
clear all                                                                                            
set more off 
cd"/users/saliemhaile/Desktop/Wave-2 LSMS/2012/Post planting wave 2/"
***************** HOUSEHOLD VARIABLE DATA CLEANING *****************************
********************************************************************************
use "household/sect1_plantingw2.dta",clear
**duplicates report hhid indiv 
**tab1 s1q6
replace s1q6=. if s1q6==-1
assert s1q6==. if s1q6==-1
replace s1q6=. if s1q6==0
assert s1q6==. if s1q6==0
keep zone state lga sector ea hhid indiv s1q6
gen HM15=1*s1q6
gen HMA15=1 if HM15>=14 & HM15<=60
replace HMA15=0 if HM15<=14 & HM15>=60
bys hhid: egen HMAG15=sum(HMA15)
label var HMAG15 "Household member age greater than 15" 
keep if indiv==1
rename s1q6 HHAge
label var HHAge " Household Head Age "
drop indiv HM15 HMA15
save "HPP", replace

use "household/sect2_plantingw2.dta",clear
**duplicates report hhid indiv 
keep zone state lga sector ea hhid indiv s2q8
**tab1 s2q8
keep if indiv==1
rename s2q8 HHEdu
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

use "Household/sect3a_plantingw2.dta", clear
**duplicates report hhid indiv
**tab1 s3aq21a s3aq34a
keep zone state lga sector ea hhid indiv s3aq16 s3aq17 s3aq18 s3aq19 s3aq21a s3aq21b s3aq23 s3aq24a s3aq24b s3aq29 s3aq30 s3aq31 s3aq32 s3aq34a s3aq34b s3aq36 s3aq37a s3aq37b 

gen wage=1
replace wage=(7*s3aq21a*s3aq17)/s3aq18 if s3aq21b==2
replace wage=(s3aq21a/4)*(s3aq17/s3aq18) if s3aq21b==5
replace wage=(s3aq21a*s3aq17)/s3aq18 if s3aq21b==3
replace wage=(s3aq21a/2)*s3aq17 if s3aq21b==4
replace wage=(1*s3aq21a) if s3aq21b==1
replace wage=(s3aq21a/12)*(s3aq17/s3aq18) if s3aq21b==6
replace wage=(s3aq21a/24)*(s3aq17/s3aq18) if s3aq21b==7
replace wage=(s3aq21a/48)*(s3aq17/s3aq18) if s3aq21b==8
replace wage=0 if s3aq19==2
replace wage=0 if wage==1

gen wage1=1
replace wage1=(7*s3aq24a*s3aq17)/s3aq18 if s3aq24b==2
replace wage1=(s3aq24a/4)*(s3aq17/s3aq18) if s3aq24b==5
replace wage1=(s3aq24a*s3aq17)/s3aq18 if s3aq24b==3
replace wage1=(s3aq24a/2)*s3aq17 if s3aq24b==4
replace wage1=(1*s3aq24a) if s3aq24b==1
replace wage1=(s3aq24a/12)*(s3aq17/s3aq18) if s3aq24b==6
replace wage1=(s3aq24a/24)*(s3aq17/s3aq18) if s3aq24b==7
replace wage1=(s3aq24a/48)*(s3aq17/s3aq18) if s3aq24b==8
replace wage1=0 if s3aq23==2
replace wage1=0 if wage1==1


gen wage2=1
replace wage2=(7*s3aq34a*s3aq30)/s3aq31 if s3aq34b==2
replace wage2=(s3aq34a/4)*(s3aq30/s3aq31) if s3aq34b==5
replace wage2=(s3aq34a*s3aq30)/s3aq31 if s3aq34b==3
replace wage2=(s3aq34a/2)*s3aq30 if s3aq34b==4
replace wage2=(1*s3aq34a) if s3aq34b==1
replace wage2=(s3aq34a/12)*(s3aq30/s3aq31) if s3aq34b==6
replace wage2=(s3aq34a/24)*(s3aq30/s3aq31) if s3aq34b==7
replace wage2=(s3aq34a/48)*(s3aq30/s3aq31) if s3aq34b==8
replace wage2=0 if s3aq32==2
replace wage2=0 if wage2==1

gen wage3=1
replace wage3=(7*s3aq37a*s3aq30)/s3aq31 if s3aq37b==2
replace wage3=(s3aq37a/4)*(s3aq30/s3aq31) if s3aq37b==5
replace wage3=(s3aq37a*s3aq30)/s3aq31 if s3aq37b==3
replace wage3=(s3aq37a/2)*s3aq30 if s3aq37b==4
replace wage3=(1*s3aq37a) if s3aq21b==1
replace wage3=(s3aq37a/12)*(s3aq30/s3aq31) if s3aq37b==6
replace wage3=(s3aq37a/24)*(s3aq30/s3aq31) if s3aq37b==7
replace wage3=(s3aq37a/48)*(s3aq30/s3aq31) if s3aq37b==8
replace wage3=0 if s3aq36==2
replace wage3=0 if wage3==1
egen Wages=rowtotal(wage wage1 wage2 wage3)
bys hhid: egen OffWage=sum(Wages)
label var OffWage "Off farm wages"
bys hhid: keep if _n==1
drop indiv
merge 1:1 hhid using "HPP"
drop _m s3aq16 s3aq17 s3aq18 s3aq19 s3aq21a s3aq21b s3aq23 s3aq24a s3aq24b s3aq29 s3aq30 s3aq31 s3aq32 s3aq34a s3aq34b s3aq36 s3aq37a s3aq37b wage wage1 wage2 wage3 Wages
save "HPP", replace

use "household/sect4a_plantingw2.dta",clear
**tab1 s4aq7 s4aq10,m
**duplicates report hhid indiv 
keep zone state lga sector ea hhid indiv s4aq11 s4aq13 s4aq14
gen Credit=0 if s4aq11==2 |s4aq13==2|s4aq14==2
replace Credit=1 if s4aq11==1 |s4aq13==1|s4aq14==1
label var Credit " Credit from formal and informal institutions"
replace Credit=0 if Credit==.
drop s4aq11 s4aq13 s4aq14
bys hhid: keep if _n==1
drop indiv
merge 1:1 hhid using "HPP"
drop _m
save "HPP",replace


use "household/sect5b_plantingw2.dta",clear
**duplicates report hhid item_cd item_seq
**tab1 s5q4
gen AstVal=s5q4*item_seq
label var AstVal "Total asset value"
keep zone state lga sector ea hhid item_cd AstVal
bys hhid item_cd: egen TotAsset=sum(AstVal)
label var TotAsset "total household assets"
bys hhid item_cd: keep if _n==1
bys hhid: egen HHWealth=sum(TotAsset)
label var HHWealth"Total household Assets owned"
drop AstVal TotAsset item_cd
bys hhid: keep if _n==1
merge 1:1 hhid using "HPP"
drop _m
save "HPP",replace

************************** END OF HOUSEHOLD POST PLANTING **********************
********************************************************************************

********************* BEGINING OF HOUSEHOLD POST HARVESTING ********************
*******************************************************************************
cd"/users/saliemhaile/Desktop/Wave-2 LSMS/2012/Post harvest wave 2/"
********************************************************************************

use "household/sect9_Harvestw2.dta",clear
**duplicates report hhid entid
drop if entid==.
keep zone state lga sector ea hhid entid s9q3  s9q10 s9q24 s9q26 s9q27 s9q28a  s9q28b  s9q28c  s9q28d  s9q28e  s9q28f  s9q28g  s9q28h 
bys hhid: egen entcost=sum(s9q28a + s9q28b + s9q28c + s9q28d + s9q28e + s9q28f + s9q28g + s9q28h) 
gen Enterprofit=(s9q27-entcost)*s9q10
replace Enterprofit=0 if s9q3==2 |s9q3==3
label var Enterprofit  "Enterprise profit obtained owned"
drop entid entcost s9q3  s9q10 s9q24 s9q26 s9q27 s9q28a  s9q28b  s9q28c  s9q28d  s9q28e  s9q28f  s9q28g  s9q28h 
bys hhid: keep if _n==1
save "HPH", replace

use "Household/sect6_harvestw2.dta", clear
**duplicates report hhid indiv 
keep zone state lga sector ea hhid indiv s6q3  s6q4a s6q4b s6q7 s6q8a s6q8b 
**tab1 s6q3 s6q7,m
replace s6q3=0 if s6q3==.
replace s6q4a=0 if s6q4a==.
replace s6q8a=0 if s6q8a==.
replace s6q7=0 if s6q7==.
gen foreign=s6q4a*159 if s6q4b==1
replace foreign=s6q4a*203 if s6q4b==2
replace foreign=s6q4a*243 if s6q4b==3
gen foreigns=s6q8a*152 if s6q8b==1
replace foreigns=s6q8a*227 if s6q8b==2
replace foreigns=s6q8a*227 if s6q8b==3
bys hhid: egen Remittance=sum(foreign + foreigns + s6q3 + s6q7)
label var Remittance " Total amount of both cash and in-kind remittance per household"
drop s6q3  s6q4a s6q4b s6q7 s6q8a s6q8b foreign foreigns
bys hhid: keep if _n==1
merge 1:1 hhid using "HPH"
drop _m
save "HPH", replace

use "/Users/saliemhaile/Desktop/wave-2 LSMS/2012/cons_agg_w2.dta"
keep hhid hhsize_PH
rename hhsize_PH Hsize
label var Hsize "Number of household members"
merge 1:1 hhid using "HPH"
drop _m
save "HPH", replace

use "/users/saliemhaile/Desktop/Wave-2 LSMS/2012/Post planting wave 2/HPP"
merge 1:1 hhid using "/users/saliemhaile/Desktop/Wave-2 LSMS/2012/Post harvest wave 2/HPH"
drop _m
save "Households.dta", replace

cd "/Users/saliemhaile/Desktop/wave-2 LSMS/2012/Geodata Wave 2"

use "NGA_HouseholdGeovars_Y2.dta",clear
duplicates report hhid dist_road2 dist_market af_bio_12 sq1
keep zone state lga sector ea hhid dist_road2 dist_market af_bio_12 sq1 srtm_nga_5_15 dist_popcenter
rename dist_road2 Distroad
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
save "TeklalaHOUSEHOLD.dta", replace

************************* END OF HOUSEHOLD POST HARVEST ************************
********************************************************************************
********************************************************************************
********************** AGRICULTURE POST PLANTING *******************************
********************************************************************************
cd"/users/saliemhaile/Desktop/Wave-2 LSMS/2012/Post planting wave 2/"
********************************************************************************

use "Agriculture/sect11a1_plantingw2.dta", clear
***duplicates report hhid plotid
keep zone state lga sector ea hhid plotid s11aq4c
rename s11aq4c Plotsize
label var Plotsize "Plot size in square meters"
save "APP", replace

use "Agriculture/sect11b1_plantingw2.dta",clear
**duplicates report hhid plotid
keep zone state lga sector ea hhid plotid s11b1q5 s11b1q4  s11b1q13 s11b1q14 s11b1q31 s11b1q33 s11b1q41a s11b1q41b s11b1q40
**tab1 s11b1q5  s11b1q13 s11b1q14 s11b1q33 s11b1q31 s11b1q41a s11b1q41b s11b1q40,m
rename s11b1q5 Plotpurchprice
label var Plotpurchprice " In-kind and cash paid to aquire plot"
gen Plotpurchase=0 if s11b1q4==2|s11b1q4==3|s11b1q4==4
replace Plotpurchase=1 if s11b1q4==1
label var Plotpurchase "=1 if plot purchased"
gen Plotrented=0 if s11b1q4==1|s11b1q4==3|s11b1q4==4
replace Plotrented=1 if s11b1q4==2
label var Plotrented "=1 if plot rented"
gen Plotrnt=s11b1q13+s11b1q14
label var  Plotrnt " Plot rented in-kind and cash-Naira"
gen Plotrt=s11b1q31+s11b1q33 
label var  Plotrt " Plot rented in-kind and cash-Naira"
gen Plotrentprice=sum(Plotrt+Plotrnt)
label var  Plotrentprice " Total plot rented in-kind and cash-Naira"
drop s11b1q13 s11b1q14 s11b1q31 s11b1q33 s11b1q41a s11b1q41b s11b1q40 Plotrt Plotrnt s11b1q4 
merge 1:1 hhid plotid using "APP"
drop _m
save "APP",replace

use "Agriculture/sect11c2_plantingw2.dta",clear
**tab1 s11c1q1a1-s11c1q1d4,m
**duplicates report hhid plotid
keep zone state lga sector ea hhid plotid s11c2q29 s11c2q30b s11c2q30d s11c2q30f s11c2q23a s11c2q24a s11c2q32 s11c2q33
gen Machinery_rent=0 if s11c2q29==2 
replace Machinery_rent=1 if s11c2q29==1 
label var Machinery_rent " =1 if  machinery rented"
*egen All_machinery_used=max(Machinery_use)
*label var All_machinery_used " 1=yes if the household uses any machinery"
egen MachiRentprice=rowtotal(s11c2q32 s11c2q33)
label var MachiRentprice " Amount spent to rent machinery"
egen Animalrentprice=rowtotal(s11c2q23a s11c2q24a)
label var Animalrentprice " Amount spent in renting draft animals"
drop  s11c2q29 s11c2q30b s11c2q30d s11c2q30f s11c2q23a s11c2q24a s11c2q32 s11c2q33
merge 1:1 hhid plotid using "APP"
drop _m
save "APP",replace

use "Agriculture/sect11d_plantingw2.dta",clear
**duplicates report hhid plotid
keep hhid plotid state s11dq4 s11dq8 s11dq12 s11dq15 s11dq17 s11dq16 s11dq19 s11dq27 s11dq28 s11dq29 s11dq30
*gen PurFert2012=0 if s11dq12==2 & s11dq12<.
*replace PurFert2012=1 if s11dq12==1
*label var PurFert2012 "=1 if the household uses fertilizer"
rename s11dq4 LeftFert
label var LeftFert "Left over seed"
rename s11dq8 FreeFert
label var FreeFert "Free fertilizer obtained" 
gen Fertown=sum(LeftFert+FreeFert)
label var Fertown "Free fertilizer obtained and fertilizer from previous year"
/*gen NPK1Q1=(1*s11dq16) if s11dq15==1
gen NPK1Q2=(1*s11dq28) if s11dq27==1
egen NPKQ=rowtotal(NPK1Q1 NPK1Q2)
gen UREAQ1=(1*s11dq16) if s11dq15==2
gen UREA1Q2=(1*s11dq28) if s11dq27==2
egen UREAQ=rowtotal(UREAQ1 UREA1Q2)
replace UREAQ=. if UREAQ==0
gen OtherQ1=(1*s11dq16) if s11dq15==4
gen Other1Q2=(1*s11dq28) if s11dq27==4
egen OtherQ=rowtotal(OtherQ1 Other1Q2)
replace OtherQ=. if OtherQ==0
egen Fert_Qty1=rowtotal(NPKQ UREAQ OtherQ)
gen Fert_Qty=sum(Fert_Qty1)*/
egen PurFert= rowtotal(s11dq16 s11dq28)
label var PurFert "Total Fertilizer Quantity from first and second purchase"
egen fertValu= rowtotal(s11dq19 s11dq29)
label var fertValu "Total Fertilizer value of first and second purchase"
*bys hhid plotid: gen Fertprice1=(fertValu/PurFert)
gen Fertprice=1
replace Fertprice=108 if state==1
replace Fertprice=22 if state==2
replace Fertprice=8003 if state==3
replace Fertprice=80 if state==4
replace Fertprice=3051 if state==5
replace Fertprice=0 if state==6
replace Fertprice=2075 if state==7
replace Fertprice=266 if state==8
replace Fertprice=304 if state==9
replace Fertprice=84 if state==10
replace Fertprice=1634 if state==11
replace Fertprice=100 if state==12
replace Fertprice=81 if state==13
replace Fertprice=1160 if state==14
replace Fertprice=196 if state==15
replace Fertprice=2754 if state==16
replace Fertprice=266 if state==17
replace Fertprice=7052 if state==18
replace Fertprice=5158 if state==19
replace Fertprice=863 if state==20
replace Fertprice=146 if state==21
replace Fertprice=327 if state==22
replace Fertprice=313 if state==23
replace Fertprice=95 if state==24
replace Fertprice=656 if state==25
replace Fertprice=864 if state==26
replace Fertprice=100 if state==27
replace Fertprice=100 if state==28
replace Fertprice=171 if state==29
replace Fertprice=185 if state==30
replace Fertprice=172 if state==31
replace Fertprice=85 if state==32
replace Fertprice=69 if state==33
replace Fertprice=539 if state==34
replace Fertprice=252 if state==35
replace Fertprice=63 if state==36
label var Fertprice "Price Index of Fertilizers"
egen FertTrans_cost1= rowtotal(s11dq17 s11dq30) if s11dq17!=. | s11dq30!=.
gen FertTrans_cost=FertTrans_cost1/PurFert
label var FertTrans_cost "Transportation cost of purchased fertilizer"
drop s11dq12 s11dq17 s11dq16 s11dq19 s11dq28 s11dq29 s11dq30 fertValu  FreeFert LeftFert FertTrans_cost1 
merge 1:1 hhid plotid using "APP"
drop _m
drop   s11dq27  s11dq15
save "APP",replace

use "Agriculture/sect11e_plantingw2.dta",clear
**duplicates report hhid plotid cropid
keep zone state lga sector ea hhid plotid cropid cropcode cropname s11eq6a s11eq10a s11eq14 s11eq17 s11eq19 s11eq18a s11eq18b s11eq21 s11eq30a s11eq30b s11eq33 s11eq31
*gen SeedPur2012=0 if s11eq14==2 & s11eq14<.
*replace SeedPur2012=1 if s11eq14==1
*label var SeedPur2012 "=1 if the household purchases Seeds"
rename s11eq18b nscode
merge m:m cropcode nscode using  "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/New_AG_Conversion.dta"
drop _merge
replace conversion=1 if nscode==1
replace conversion=0.001 if nscode==2
gen seedQ1=conversion*s11eq18a
gen seedQ2=conversion*s11eq30a
egen Seed_Qty=rowtotal(seedQ1 seedQ2)
bys hhid plotid: egen PurSeed=sum(Seed_Qty)
label var PurSeed "Total quantity of seed purchased"
gen PrvHrseed=conversion*s11eq6a
label var PrvHrseed "Seed quantity from previous harvest"
gen Freeseed=conversion*s11eq10a
label var Freeseed " Free seed quantity"
gen Seedown=sum(PrvHrseed+Freeseed)
label var Seedown " Total Free seed and seed from previous harvest"
egen Seedvalue= rowtotal(s11eq21 s11eq33) if s11eq21!=. | s11eq33!=.
bys hhid plotid: egen Seed_Val=sum(Seedvalue)
*bys hhid plotid: gen price=(Seedvalue/PurSeed)
gen SeedPrice=1
replace SeedPrice=74 if state==1
replace SeedPrice=100 if state==2
replace SeedPrice=1 if state==3
replace SeedPrice=25 if state==4
replace SeedPrice=99 if state==5
replace SeedPrice=101 if state==6
replace SeedPrice=59 if state==7
replace SeedPrice=1 if state==8
replace SeedPrice=6 if state==9
replace SeedPrice=34 if state==10
replace SeedPrice=26 if state==11
replace SeedPrice=100 if state==12
replace SeedPrice=100 if state==13
replace SeedPrice=37 if state==14
replace SeedPrice=1 if state==15
replace SeedPrice=21 if state==16
replace SeedPrice=1 if state==17
replace SeedPrice=291 if state==18
replace SeedPrice=4 if state==19
replace SeedPrice=7 if state==20
replace SeedPrice=14 if state==21
replace SeedPrice=82 if state==22
replace SeedPrice=81 if state==23
replace SeedPrice=609 if state==24
replace SeedPrice=30 if state==25
replace SeedPrice=99 if state==26
replace SeedPrice=79 if state==27
replace SeedPrice=100 if state==28
replace SeedPrice=194 if state==29
replace SeedPrice=11 if state==30
replace SeedPrice=98 if state==31
replace SeedPrice=90 if state==32
replace SeedPrice=0 if state==33
replace SeedPrice=98 if state==34
replace SeedPrice=1 if state==35
replace SeedPrice=1 if state==36
label var SeedPrice"Price index of seed"
egen tran_cost= rowtotal(s11eq19 s11eq31) if s11eq19!=. | s11eq31!=.
label var tran_cost"Transportation cost of purchased purchased seed"
bys hhid plotid: egen SeedTrans_Cost1=sum(tran_cost)
gen SeedTrans_Cost=SeedTrans_Cost1/Seed_Qty
label var SeedTrans_Cost"Transportation cost to aquier seed"
drop s11eq14 s11eq19 s11eq18a  s11eq21 s11eq30a s11eq30b s11eq33 s11eq31
bys hhid plotid: keep if _n==1
drop cropid  cropname seedQ1 seedQ2 Seed_Qty  Seedvalue Seed_Val tran_cost s11eq6a s11eq10a PrvHrseed Freeseed SeedTrans_Cost1 
merge 1:1 hhid plotid using "APP"
drop _m
drop cropcode s11eq17 nscode conversion
save "APP",replace

/*use "Agriculture/sect11L1_Plantingw2.dta", clear
keep zone state lga sector ea hhid s11l1q1
rename s11l1q1 Extensionservice1
merge 1:1 hhid using "APP"
drop _m
save "APP", replace*/

********************************************************************************
************************** END OF AGRICULTURE POST PLANTING ********************
********************************************************************************
************************** BEGNING AGRICULTURE POST HARVEST ********************
********************************************************************************
cd"/users/saliemhaile/Desktop/Wave-2 LSMS/2012/Post harvest wave 2/"
********************************************************************************


use "Agriculture/secta3_Harvestw2.dta", clear
**duplicates report hhid plotid cropid
keep hhid plotid cropid cropcode sa3q3 sa3q4 sa3q6a1 sa3q6a2   
**tab1 sa3q3 sa3q4 sa3q6a sa3q6b,m
rename cropcode  agcropid
rename sa3q6a2 nscode
*gen ProdCons=0 if sa3q3==1
*replace ProdCons=1 if sa3q3==2
*label var ProdCons "constraints of production"
drop sa3q3 sa3q4 
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
gen Qharvst=conversion * sa3q6a1
label var Qharvst "Total amount of harvest"
bys hhid plotid: egen TotQharvst=sum(Qharvst)
label var TotQharvst "Total amount of harvest"
drop sa3q6a1 cropid agcropid nscode cropname conversion _merge Qharvst
bys hhid plotid: keep if _n==1
save "Adam-1", replace

use "Agriculture/secta3_Harvestw2.dta", clear
keep hhid plotid cropid cropcode sa3q11a sa3q11b sa3q12 sa3q17
rename cropcode agcropid
rename sa3q11b nscode
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
drop _merge
gen Qsale= conversion * sa3q11a
drop sa3q11a cropid agcropid nscode cropname conversion 
egen Hvsaleprice=rowtotal(sa3q12 sa3q17)
label var Hvsaleprice "Harvest sales price"
bys hhid plotid: keep if _n==1
merge 1:1 hhid plotid using "Adam-1"
drop _m
save "Adam-2", replace

use "Agriculture/secta3_Harvestw2.dta", clear
keep hhid plotid cropid cropcode sa3q16a sa3q16b   
rename cropcode agcropid
rename sa3q16b nscode
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
drop _merge
gen Qsale2= conversion * sa3q16a
drop sa3q16a cropid agcropid nscode cropname conversion 
bys hhid plotid: keep if _n==1
merge 1:1 hhid plotid using "Adam-2"
drop _m
save "Adam-3", replace

use "/Users/saliemhaile/Desktop/wave-2 LSMS/2012/Post Planting Wave 2/APP"
merge 1:1 hhid plotid using "/Users/saliemhaile/Desktop/wave-2 LSMS/2012/Post Harvest Wave 2/Adam-3"
drop _m
egen TQsale= rowtotal(Qsale2 Qsale)
label var TQsale "Total amount of sold harvest"
bys hhid plotid: egen TotQtsale=sum(TQsale)
label var TotQtsale "Total amount of sold harvest"
gen cons_quant=(TotQharvst-TotQtsale)
label var cons_quant "Total quantity consumed"
drop Qsale2 Qsale TQsale
drop sa3q12 sa3q17
save "Adu-agriculture", replace

cd "/Users/saliemhaile/Desktop/wave-2 LSMS/2012/Geodata Wave 2"

use "NGA_PlotGeovariables_Y2.dta"
keep hhid plotid dist_household
**duplicates report hhid dist_household
rename dist_household Disthousehold
label var Disthousehold " Distance of farm to household"
merge 1:1 hhid plotid using "Adu-agriculture"
drop _m
save "TeklalaAgriculture.dta", replace
********************************************************************************
********************************************************************************
use "/Users/saliemhaile/Desktop/wave-2 LSMS/2012/Geodata Wave 2/TeklalaAgriculture.dta"
merge m:1 hhid using "/Users/saliemhaile/Desktop/wave-2 LSMS/2012/Geodata Wave 2/TeklalaHOUSEHOLD.dta"
drop _merge 
gen year=2012
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
label var year"panel year 2012"
order state zone lga ea sector hhid plotid PurSeed PurFert Machinery_rent Plotrented Remittance Enterprofit OffWage  Credit HHWealth HHEdu HMAG15 HHAge Hsize SeedPrice Seedown SeedTrans_Cost Fertown Fertprice FertTrans_cost MachiRentprice Animalrentprice Plotpurchprice Plotrentprice Plotsize Hvsaleprice TotQharvst TotQtsale cons_quant Distroad Populatedarea Distmarket Rainfall Topography Soilnutrient Soilnutri1 Soilnutri2 Soilnutri3 Soilnutri4 Soilnutri5 Soilnutri6 Topogr1 Topogr2 Topogr3 Topogr4 Topogr5 Topogr6 Topogr7 Topogr8 Topogr9 Topogr10 
save "Asmir_wave_2.dta", replace
********************************************************************************
********************************************************************************
********************************************************************************
