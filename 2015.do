

********************************************************************************
************** DATA CLEANING FOR POST PLANTING HOUSEHOLD SURVEY ****************
********************************************************************************
clear all
set more off
cd "/Users/saliemhaile/Desktop/Wave-3 LSMS /2015/Post Planting wave 3/"
********************************* HOUSEHOLD VARIABLE DATA CLEANING *************
********************************************************************************
****************************** HOUAEHOLD DATA SET AT AN INDIVIDUAL LEVEL *******

use "Household/sect1_plantingw3.dta",clear
**duplicates report hhid indiv 
**tab1 s1q6 
replace s1q6=. if s1q6==0
assert s1q6==. if s1q6==0
keep zone lga sector ea hhid indiv s1q6 
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

use "Household/sect3_plantingw3.dta",clear
**duplicates report hhid indiv
**tab1 s3q21a s3q34a
keep zone state lga sector ea hhid indiv s3q16 s3q17 s3q18 s3q21a s3q21b s3q23 s3q24a s3q24b s3q25 s3q29 s3q30 s3q31 s3q34a s3q34b s3q36 s3q37a s3q37b 
gen wage=1
replace wage=(7*s3q21a*s3q17)/s3q18 if s3q21b==2
replace wage=(s3q21a/4)*(s3q17/s3q18) if s3q21b==5
replace wage=(s3q21a*s3q17)/s3q18 if s3q21b==3
replace wage=(s3q21a/2)*s3q17 if s3q21b==4
replace wage=(1*s3q21a) if s3q21b==1
replace wage=(s3q21a/12)*(s3q17/s3q18) if s3q21b==6
replace wage=(s3q21a/24)*(s3q17/s3q18) if s3q21b==7
replace wage=(s3q21a/48)*(s3q17/s3q18) if s3q21b==8
replace wage=0 if wage==1

gen wage1=1
replace wage1=(7*s3q24a*s3q17)/s3q18 if s3q24b==2
replace wage1=(s3q24a/4)*(s3q17/s3q18) if s3q24b==5
replace wage1=(s3q24a*s3q17)/s3q18 if s3q24b==3
replace wage1=(s3q24a/2)*s3q17 if s3q24b==4
replace wage1=(1*s3q24a) if s3q24b==1
replace wage1=(s3q24a/12)*(s3q17/s3q18) if s3q24b==6
replace wage1=(s3q24a/24)*(s3q17/s3q18) if s3q24b==7
replace wage1=(s3q24a/48)*(s3q17/s3q18) if s3q24b==8
replace wage1=0 if s3q23==2
replace wage1=0 if wage1==1


gen wage2=1
replace wage2=(7*s3q34a*s3q30)/s3q31 if s3q34b==2
replace wage2=(s3q34a/4)*(s3q30/s3q31) if s3q34b==5
replace wage2=(s3q34a*s3q30)/s3q31 if s3q34b==3
replace wage2=(s3q34a/2)*s3q30 if s3q34b==4
replace wage2=(1*s3q34a) if s3q34b==1
replace wage2=(s3q34a/12)*(s3q30/s3q31) if s3q34b==6
replace wage2=(s3q34a/24)*(s3q30/s3q31) if s3q34b==7
replace wage2=(s3q34a/48)*(s3q30/s3q31) if s3q34b==8
replace wage2=0 if s3q25==2
replace wage2=0 if wage2==1

gen wage3=1
replace wage3=(7*s3q37a*s3q30)/s3q31 if s3q37b==2
replace wage3=(s3q37a/4)*(s3q30/s3q31) if s3q37b==5
replace wage3=(s3q37a*s3q30)/s3q31 if s3q37b==3
replace wage3=(s3q37a/2)*s3q30 if s3q37b==4
replace wage3=(1*s3q37a) if s3q37b==1
replace wage3=(s3q37a/12)*(s3q30/s3q31) if s3q37b==6
replace wage3=(s3q37a/24)*(s3q30/s3q31) if s3q37b==7
replace wage3=(s3q37a/48)*(s3q30/s3q31) if s3q37b==8
replace wage3=0 if s3q36==2
replace wage3=0 if wage3==1
egen Wages=rowtotal(wage wage1 wage2 wage3)
bys hhid: egen OffWage=sum(Wages)
label var OffWage "Off farm wages"
bys hhid: keep if _n==1
drop indiv
merge 1:1 hhid using "HPP"
drop _m s3q16 s3q17 s3q18 s3q21a s3q21b s3q23 s3q24a s3q24b s3q25 s3q29 s3q30 s3q31 s3q34a s3q34b s3q36 s3q37a s3q37b wage wage1 wage2 wage3 Wages
save "HPP", replace

use "Household/sect4c1_plantingw3.dta",clear
**tab1 s4c1q1,m
**duplicates report hhid  
keep zone state lga sector ea hhid s4cq1
gen Credit=0 if s4cq1==2
replace  Credit=1 if s4cq1==1
label var Credit " Credit from formal and informal institutions"
replace Credit=0 if Credit==.
drop s4cq1
merge 1:1 hhid using "HPP"
drop _m
save "HPP", replace

use "household/sect5_plantingw3.dta",clear
**duplicates report hhid item_cd s5q1
**tab1 s5q4
gen AstVal=s5q4*s5q1
label var AstVal "Total asset value"
keep zone state lga sector ea hhid item_cd AstVal
bys hhid item_cd: egen TotAsset=sum(AstVal)
label var TotAsset "total household assets"
bys hhid item_cd: keep if _n==1
bys hhid: egen HHWealth=sum(TotAsset)
label var HHWealth "Total household Assets owned"
drop AstVal TotAsset item_cd
bys hhid: keep if _n==1
merge 1:1 hhid using "HPP"
drop _m
save "HPP",replace



********************************************************************************
*************************** END OF HOUSEHOLD POST PLANTING *********************
********************************************************************************
cd "/Users/saliemhaile/Desktop/Wave-3 LSMS /2015/Post Harvest wave 3/"
************************* BEGNING OF HOUSEHOLD POST HARVEST ********************
********************************************************************************

use "household/sect2_harvestw3.dta",clear
**duplicates report hhid indiv 
keep zone state lga sector ea hhid indiv s2aq9
**tab1 s2aq9
keep if indiv==1
rename s2aq9 HHEdu
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
save "HPH", replace

use "household/sect9_harvestw3.dta",clear
**duplicates report hhid entid
tab1 s9q24
replace s9q24=. if  s9q24==2
assert s9q24==. if  s9q24==2
replace s9q24=. if  s9q24==0
assert s9q24==. if  s9q24==0
replace s9q24=. if  s9q24==5
assert s9q24==. if  s9q24==5
drop if ent_id==.
keep zone state lga sector ea hhid ent_id s9q3 s9q24 s9q10a s9q10b s9q10c s9q10d s9q10e s9q10f s9q10g s9q10h s9q10i s9q10j s9q10k s9q10l s9q10m s9q10n s9q10o s9q27a
encode s9q10a, gen(s9q10anum)
encode s9q10b, gen(s9q10bnum)
encode s9q10c, gen(s9q10cnum)
encode s9q10d, gen(s9q10dnum)
encode s9q10e, gen(s9q10enum)
encode s9q10f, gen(s9q10fnum)
encode s9q10g, gen(s9q10gnum)
encode s9q10h, gen(s9q10hnum)
encode s9q10i, gen(s9q10inum)
encode s9q10j, gen(s9q10jnum)
encode s9q10k, gen(s9q10knum)
encode s9q10l, gen(s9q10lnum)
encode s9q10m, gen(s9q10mnum)
encode s9q10n, gen(s9q10nnum)
encode s9q10o, gen(s9q10onum)
replace s9q10anum=0 if s9q10anum!=1
replace s9q10bnum=0 if s9q10bnum!=1
replace s9q10cnum=0 if s9q10cnum!=1
replace s9q10dnum=0 if s9q10dnum!=1
replace s9q10enum=0 if s9q10enum!=1
replace s9q10fnum=0 if s9q10fnum!=1
replace s9q10gnum=0 if s9q10gnum!=1
replace s9q10hnum=0 if s9q10hnum!=1
replace s9q10inum=0 if s9q10inum!=1
replace s9q10jnum=0 if s9q10jnum!=1
replace s9q10knum=0 if s9q10knum!=1
replace s9q10lnum=0 if s9q10lnum!=1
replace s9q10mnum=0 if s9q10mnum!=1
replace s9q10nnum=0 if s9q10nnum!=1
replace s9q10onum=0 if s9q10onum!=1
bys hhid: egen month=sum((s9q10anum*1) + (s9q10bnum*1) + (s9q10cnum*1) + (s9q10dnum*1) + (s9q10enum*1) + (s9q10fnum*1) + (s9q10gnum*1) + (s9q10hnum*1) + (s9q10inum*1) + (s9q10jnum*1) + (s9q10knum*1) + (s9q10lnum*1) + (s9q10mnum*1) + (s9q10nnum*1) + (s9q10onum*1))
gen Enterprofit=(s9q27a*month)
replace Enterprofit=0 if s9q3==2 |s9q3==3| s9q3==4
label var Enterprofit  "Enterprise profit obtained owned"
drop ent_id s9q27a s9q3 s9q24 s9q10a s9q10b s9q10c s9q10d s9q10e s9q10f s9q10g s9q10h s9q10i s9q10j s9q10k s9q10l s9q10m s9q10n s9q10o s9q27a s9q10anum s9q10bnum s9q10cnum s9q10dnum s9q10enum s9q10fnum s9q10gnum s9q10hnum s9q10inum s9q10jnum s9q10knum s9q10lnum s9q10mnum s9q10nnum s9q10onum month
bys hhid: keep if _n==1
merge 1:1 hhid using "HPH"
drop _m
save "HPH", replace

use "Household/sect6_harvestw3.dta", clear
**duplicates report hhid indiv 
keep zone state lga sector ea hhid indiv s6q4a s6q8a s6q4b s6q8b
**tab1 s6q4a s6q8a,m
gen Rem1=s6q4a*199.245 if s6q4b==1
replace Rem1=s6q4a*217.684 if s6q4b==2
replace Rem1=s6q4a*293.74 if s6q4b==3
replace Rem1=1*s6q4a if s6q4b!=1 |s6q4b!=2 |s6q4b!=3 |s6q4b!=4 
gen Rem2=s6q8a*199.245 if  s6q8b==1
replace Rem2=s6q8a*217.684 if  s6q8b==2
replace Rem2=s6q8a*293.74 if  s6q8b==3
replace Rem2=1*s6q8a if  s6q8b!=1 | s6q8b!=2 | s6q8b!=3 | s6q8b!=4 
egen Rem_SubTota= rowtotal(Rem2 Rem1)
bys hhid: egen Remittance=sum(Rem_SubTota)
label var  Remittance " Total amount of both cash and in-kind remittance per household"
drop s6q4a s6q8a s6q4b s6q8b Rem2 Rem1  Rem_SubTota
replace indiv=1
bys hhid: egen Hsize=sum(indiv)
label var Hsize "Number of household members"
bys hhid: keep if _n==1
drop indiv
merge 1:1 hhid using "HPH"
drop _m
save "HPH", replace

use "/Users/saliemhaile/Desktop/Wave-3 LSMS /2015/Post Planting wave 3/HPP"
merge 1:1 hhid using  "/Users/saliemhaile/Desktop/Wave-3 LSMS /2015/Post Harvest wave 3/HPH"
drop _merge
save "Households.dta", replace

use "/Users/saliemhaile/Desktop/wave-3 LSMS /2015/NGA_HouseholdGeovars_Y3.dta"
duplicates report hhid dist_road2 dist_market af_bio_12 sq1
keep hhid dist_road2 dist_market af_bio_12 sq1 srtm_nga_5_15 dist_popcenter
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

********************************************************************************
******************* END OF HOUSEHOLD POST HARVEST ******************************
********************************************************************************
************** BEGINING OF AGRICULTURE POST PLANTING ***************************
********************************************************************************
cd"/Users/saliemhaile/Desktop/Wave-3 LSMS /2015/Post planting wave 3/"
********************************************************************************

use "Agriculture/sect11a1_plantingw3.dta", clear  
***duplicates report hhid plotid
keep zone state lga sector ea hhid plotid s11aq4c
rename s11aq4c Plotsize
label var Plotsize  "Plot size in square meters"
save "APP", replace


use "Agriculture/sect11b1_plantingw3.dta", clear
**duplicates report hhid plotid
keep zone state lga sector ea hhid plotid s11b1q5 s11b1q4 s11b1q13 s11b1q14 s11b1q40 s11b1q41a s11b1q41b
**tab1 s11bq5 s11bq9 s11bq10 s11bq25 s11bq26a s11bq26b,m
rename s11b1q5 Plotpurchprice
label var Plotpurchprice" In-kind and cash paid to aquire plot"
gen Plotpurchase=0 if s11b1q4==2|s11b1q4==3|s11b1q4==4
replace Plotpurchase=1 if s11b1q4==1
label var Plotpurchase "=1 if plot purchased"
gen Plotrented=0 if s11b1q4==1|s11b1q4==3|s11b1q4==4
replace Plotrented=1 if s11b1q4==2
label var Plotrented "=1 if plot rented"
gen Plotrentprice=s11b1q13+s11b1q14
label var  Plotrentprice " Plot rented in-kind and cash-Naira"
drop s11b1q13 s11b1q14 s11b1q40 s11b1q41a s11b1q41b s11b1q4 
merge 1:1 hhid plotid using "APP"
drop _m
save "APP", replace

use "Agriculture/sect11e_plantingw3.dta", clear
**duplicates report hhid plotid cropid
keep zone state lga sector ea hhid plotid cropid cropcode s11eq6a s11eq10a s11eq14 s11eq17 s11eq19 s11eq18a s11eq18b s11eq21 s11eq30a s11eq30b s11eq33 s11eq31
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
label var Freeseed" Free seed quantity"
gen Seedown=sum(PrvHrseed+Freeseed)
label var Seedown " Total Free seed and seed from previous harvest"
egen Seedvalue= rowtotal(s11eq21 s11eq33) if s11eq21!=. | s11eq33!=.
bys hhid plotid: egen Seed_Val=sum(Seedvalue)
*bys hhid plotid: gen price=(Seedvalue/PurSeed)
gen SeedPrice=1
replace SeedPrice=66 if state==1
replace SeedPrice=0 if state==2
replace SeedPrice=4 if state==3
replace SeedPrice=268 if state==4
replace SeedPrice=51 if state==5
replace SeedPrice=119 if state==6
replace SeedPrice=32 if state==7
replace SeedPrice=9 if state==8
replace SeedPrice=1261 if state==9
replace SeedPrice=149 if state==10
replace SeedPrice=80 if state==11
replace SeedPrice=2 if state==12
replace SeedPrice=97 if state==13
replace SeedPrice=48 if state==14
replace SeedPrice=14 if state==15
replace SeedPrice=1029 if state==16
replace SeedPrice=28 if state==17
replace SeedPrice=10 if state==18
replace SeedPrice=26 if state==19
replace SeedPrice=40 if state==20
replace SeedPrice=59 if state==21
replace SeedPrice=35 if state==22
replace SeedPrice=42 if state==23
replace SeedPrice=0 if state==24
replace SeedPrice=38 if state==25
replace SeedPrice=85 if state==26
replace SeedPrice=79 if state==27
replace SeedPrice=92 if state==28
replace SeedPrice=73 if state==29
replace SeedPrice=22 if state==30
replace SeedPrice=25 if state==31
replace SeedPrice=118 if state==32
replace SeedPrice=5 if state==33
replace SeedPrice=67 if state==34
replace SeedPrice=30 if state==35
replace SeedPrice=18 if state==36
label var SeedPrice"Price index of seed"
egen tran_cost= rowtotal(s11eq19 s11eq31) if s11eq19!=. | s11eq31!=.
label var tran_cost "transportation cost of purchased purchased seed"
bys hhid plotid: egen SeedTrans_Cost1=sum(tran_cost)
gen SeedTrans_Cost=SeedTrans_Cost1/Seed_Qty
label var SeedTrans_Cost "Transportation cost to aquier seed"
drop s11eq14 s11eq19 s11eq18a  s11eq21 s11eq30a s11eq30b s11eq33 s11eq31 s11eq6a s11eq10a 
bys hhid plotid: keep if _n==1
drop cropid seedQ1 seedQ2 Seed_Qty  Seedvalue Seed_Val tran_cost PrvHrseed Freeseed SeedTrans_Cost1
merge 1:1 hhid plotid using "APP"
drop _m cropcode s11eq17 nscode cropname conversion
save "APP",replace

/*use "Agriculture/sect11L1_Plantingw3.dta", clear
keep zone state lga sector ea hhid s11lq1
rename s11lq1 Extensionservice1
merge 1:1 hhid using "APP"
drop _m
save "APP", replace*/

************** END OF AGRICULTURE POST PLANTING ********************************
********************************************************************************
************* BEGINING AGRICULTURE POST HARVEST ********************************
********************************************************************************
cd"/Users/saliemhaile/Desktop/wave-3 LSMS /2015/Post harvest wave 3/"

use "Agriculture/secta11c2_harvestw3.dta", clear
**duplicates report hhid plotid
keep zone state lga sector ea hhid plotid s11c2q29 s11c2q30b s11c2q30d s11c2q30f s11c2q23a s11c2q24a s11c2q32 s11c2q33
gen Machinery_rent=0 if s11c2q29==2 
replace Machinery_rent=1 if s11c2q29==1 
label var Machinery_rent " =1 if machinery used"
*egen All_machinery_used=max(Machinery_use)
*label var All_machinery_used " 1=yes if the household uses any machinery"
egen MachiRentprice=rowtotal(s11c2q32 s11c2q33)
label var MachiRentprice " Amount spent to rent machinery"
egen Animalrentprice=rowtotal(s11c2q23a s11c2q24a)
label var Animalrentprice " Amount spent in renting draft animals"
drop  s11c2q29 s11c2q30b s11c2q30d s11c2q30f s11c2q23a s11c2q24a s11c2q32 s11c2q33
save "APH", replace

use "Agriculture/secta11d_harvestw3.dta", clear
**duplicates report hhid plotid
keep zone state lga sector ea hhid plotid s11dq4a s11dq3 s11dq4b sect11dq8a sect11dq8b s11dq12 s11dq17 s11dq16a s11dq16b s11dq19 s11dq28a s11dq28b s11dq29 s11dq30
*gen PurFert2015=0 if s11dq12==2 & s11dq12<.
*replace PurFert2015=1 if s11dq12==1
*label var PurFert2015 "=1 if the household uses fertilizer"
rename s11dq4a LeftFert
label var LeftFert "Left over seed"
rename sect11dq8a FreeFert
label var FreeFert "Free fertilizer obtained" 
gen fert1=s11dq16a*1 if s11dq16b==1 |s11dq16b==3
gen fert2=s11dq28a*1 if s11dq28b==1 |s11dq28b==3
gen fert3=s11dq16a*0.001 if s11dq16b==2 
gen fert4=s11dq28a*0.001 if s11dq16b==2
gen fert5=s11dq16a*0.01 if s11dq16b==4
gen fert6=s11dq16a*0.01 if s11dq16b==4
gen Fertown=sum(LeftFert+FreeFert)
label var Fertown "Free fertilizer obtained and fertilizer from previous year"
egen PurFert= rowtotal(fert1 fert2 fert3 fert4 fert5 fert6)
label var PurFert "Total Fertilizer Quantity from first and second purchase"
egen fertValu= rowtotal(s11dq19 s11dq29)
label var fertValu "Total Fertilizer value of first and second purchase"
*bys hhid plotid: gen Fertprice1=(fertValu/PurFert)
gen Fertprice=1
replace Fertprice=2771 if state==1
replace Fertprice=66 if state==2
replace Fertprice=4432 if state==3
replace Fertprice=79 if state==4
replace Fertprice=2820 if state==5
replace Fertprice=0 if state==6
replace Fertprice=2040 if state==7
replace Fertprice=158 if state==8
replace Fertprice=340 if state==9
replace Fertprice=89 if state==10
replace Fertprice=1412 if state==11
replace Fertprice=100 if state==12
replace Fertprice=81 if state==13
replace Fertprice=779 if state==14
replace Fertprice=201 if state==15
replace Fertprice=2577 if state==16
replace Fertprice=255 if state==17
replace Fertprice=7176 if state==18
replace Fertprice=5263 if state==19
replace Fertprice=672 if state==20
replace Fertprice=149 if state==21
replace Fertprice=298 if state==22
replace Fertprice=315 if state==23
replace Fertprice=95 if state==24
replace Fertprice=659 if state==25
replace Fertprice=830 if state==26
replace Fertprice=100 if state==27
replace Fertprice=100 if state==28
replace Fertprice=188 if state==29
replace Fertprice=185 if state==30
replace Fertprice=172 if state==31
replace Fertprice=84 if state==32
replace Fertprice=110 if state==33
replace Fertprice=331 if state==34
replace Fertprice=297 if state==35
replace Fertprice=57 if state==36
label var Fertprice "Price Index of Fertilizers"
egen FertTrans_cost1= rowtotal(s11dq17 s11dq30) if s11dq17!=. | s11dq30!=.
gen FertTrans_cost=FertTrans_cost1/PurFert
label var FertTrans_cost"Transportation cost of purchased fertilizer"
drop s11dq12 s11dq17 s11dq16a s11dq19 s11dq28a s11dq29 s11dq30 fertValu s11dq4b sect11dq8b s11dq28b  FreeFert LeftFert 
merge 1:1 hhid plotid using "APH"
drop _m s11dq3  FertTrans_cost1 s11dq16b fert1 fert2 fert3 fert4 fert5 fert6
save "APH", replace

use "Agriculture/secta3i_harvestw3.dta", clear
**duplicates report hhid plotid cropid
keep zone state lga sector ea hhid plotid cropid cropcode sa3iq3 sa3iq4 sa3iq6i sa3iq6ii 
**tab1 sa3iq3 sa3iq4 sa3iq6i sa3iq6ii ,m
rename cropcode agcropid
rename sa3iq6ii nscode
*gen ProdCons=0 if sa3iq3==1
*replace ProdCons=1 if sa3iq3==2
*label var ProdCons "constraints of production"
drop sa3iq3 sa3iq4 
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
gen Qharvst=conversion * sa3iq6i
label var Qharvst "Total amount of harvest"
bys hhid plotid: egen TotQharvst=sum(Qharvst)
label var TotQharvst "Total amount of harvest"
drop sa3iq6i nscode agcropid _merge Qharvst cropname conversion cropid
bys hhid plotid: keep if _n==1
merge 1:1 hhid plotid using "APH"
drop _m
save "APH", replace

use "/Users/saliemhaile/Desktop/Wave-3 LSMS /2015/Post planting wave 3/APP"
merge 1:1 hhid plotid using "/Users/saliemhaile/Desktop/wave-3 LSMS /2015/Post harvest wave 3/APH"
drop _m
save "GiduAgriculture.dta", replace

use "/Users/saliemhaile/Desktop/Wave-3 LSMS /2015/Post harvest wave 3/TeklalaHOUSEHOLD.dta"
merge 1:m hhid using "/Users/saliemhaile/Desktop/wave-3 LSMS /2015/Post harvest wave 3/GiduAgriculture.dta"
drop _merge 
save "Mitu_w-3", replace

use "Agriculture/secta3ii_harvestw3.dta", clear
keep zone state lga sector ea hhid crop_number cropcode sa3iiq5a sa3iiq5b sa3iiq6
rename cropcode agcropid
rename sa3iiq5b nscode
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
drop _merge
gen TQsale= conversion * sa3iiq5a
label var TQsale "Total amount of sold harvest"
bys hhid: egen TotQtsale=sum(TQsale)
label var TotQtsale "Total amount of sold harvest"
rename sa3iiq6 Hvsaleprice
label var Hvsaleprice "Harvest sales price"
drop sa3iiq5a crop_number agcropid nscode cropname conversion 
bys hhid: keep if _n==1
save "Adam-1", replace

use "Agriculture/secta3ii_Harvestw3.dta", clear
keep zone state lga sector ea hhid crop_number cropcode sa3iiq11a sa3iiq11b   
rename cropcode agcropid
rename sa3iiq11b  nscode
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
drop _merge
gen Storseed= conversion*sa3iiq11a
label var Storseed "Total seeds stored for next plantation"
bys hhid: egen TStorseed=sum(Storseed)
drop sa3iiq11a crop_number agcropid nscode cropname conversion  
bys hhid: keep if _n==1
merge 1:1 hhid using "Adam-1"
drop _m
save "Adam-2", replace

use "Agriculture/secta3ii_Harvestw3.dta", clear
keep zone state lga sector ea hhid crop_number cropcode sa3iiq14a sa3iiq14b  
rename cropcode agcropid
rename sa3iiq14b  nscode
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
drop _merge
gen Paylabseed= conversion*sa3iiq14a
label var Paylabseed "Seeds used as mechanism of payment"
bys hhid: egen TPaylabseed=sum(Paylabseed)
drop sa3iiq14a crop_number agcropid nscode cropname conversion 
bys hhid: keep if _n==1
merge 1:1 hhid using "Adam-2"
drop _m
save "Adam-3", replace

use "Agriculture/secta3ii_Harvestw3.dta", clear
keep zone state lga sector ea hhid crop_number cropcode sa3iiq17a sa3iiq17b    
rename cropcode agcropid
rename sa3iiq17b  nscode
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
drop _merge
gen Gseed= conversion*sa3iiq17a
label var Gseed "Seeds used as a gift to others"
bys hhid: egen TGseed=sum(Gseed)
drop sa3iiq17a crop_number agcropid nscode cropname conversion 
bys hhid: keep if _n==1
merge 1:1 hhid using "Adam-3"
drop _m
save "Adam-4", replace

use "Agriculture/secta3ii_Harvestw3.dta", clear
keep zone state lga sector ea hhid crop_number cropcode sa3iiq13a sa3iiq13b    
rename cropcode agcropid
rename sa3iiq13b  nscode
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
drop _merge
gen cons_qut= conversion*sa3iiq
bys hhid: egen cons_quant=sum(cons_qut)
label var cons_quant "Total quantity consumed"
drop sa3iiq13a crop_number agcropid nscode cropname conversion cons_qut
bys hhid: keep if _n==1
merge 1:1 hhid using "Adam-4"
drop _m
save "Adam-5", replace

use "Agriculture/secta3ii_Harvestw3.dta", clear
keep zone state lga sector ea hhid crop_number cropcode sa3iiq18a sa3iiq18b    
rename cropcode agcropid
rename sa3iiq18b  nscode
merge m:m agcropid nscode using "/Users/saliemhaile/Desktop/Wave-1 LSMS /2010/w1agnsconversion.dta"
sort hhid
replace conversion=1 if nscode==1|nscode==3
replace conversion=0.001 if nscode==2
drop _merge
gen PHlossseed= conversion*sa3iiq18a
label var PHlossseed "Post harvest lost seeds"
bys hhid: egen TPHlossseed=sum(PHlossseed)
drop sa3iiq18a crop_number agcropid nscode cropname conversion 
bys hhid: keep if _n==1 
merge 1:1 hhid using "Adam-5"
drop _m
drop if hhid==.
save "Adam-6", replace

********************************************************************************
use "/Users/saliemhaile/Desktop/Wave-3 LSMS /2015/Post harvest wave 3/Mitu_w-3"
merge m:m hhid using "/Users/saliemhaile/Desktop/wave-3 LSMS /2015/Post harvest wave 3/Adam-6"
drop _m
gen year=2015
label var year"panel year 2015"
drop PHlossseed TPHlossseed Gseed TGseed Paylabseed TPaylabseed Storseed TQsale TStorseed
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
order state zone lga ea sector hhid plotid PurSeed PurFert Machinery_rent Plotrented Remittance  Enterprofi OffWage Credit HHWealth HHEdu HMAG15 HHAge Hsize SeedPrice Seedown SeedTrans_Cost Fertown Fertprice FertTrans_cost MachiRentprice Animalrentprice Plotpurchprice Plotrentprice Plotsize Hvsaleprice TotQharvst TotQtsale cons_quant Distroad Populatedarea Distmarket Rainfall Topography Soilnutrient Soilnutri1 Soilnutri2 Soilnutri3 Soilnutri4 Soilnutri5 Soilnutri6 Topogr1 Topogr2 Topogr3 Topogr4 Topogr5 Topogr6 Topogr7 Topogr8 Topogr9 
save "Asmir_wave_3.dta", replace
********************************************************************************
********************************************************************************
********************************************************************************

