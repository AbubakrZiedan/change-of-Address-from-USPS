

// The data used in this do file can be found in 2018-2022.rar



clear all
// genearte a new variable 
gen ZIPCODE = .
// save an empty file to combine data from different years
save 2018_2022.dta , replace

// loop from 2018 - 2022. This loop immport the data from csv and generate  
foreach i in 2018 2019 2020 2021 2022 {
clear all

import delimited `i'.csv , case(preserve) 
gen day = 01
// generate date 
egen date = concat(YYYYMM day), punct(0)
//genearte month of the date in STATA format
gen month = mofd(date(date, "YMD"))
// detstring ZIPCODE
destring ZIPCODE, replace ignore(`""=" """"')
// genearte the net number of change of address (Net_NOA)
gen Net_COA = TOTALFROMZIP - TOTALTOZIP
// keep only permant 
keep ZIPCODE YYYYMM CITY STATE TOTALFROMZIP TOTALBUSINESS TOTALFAMILY TOTALINDIVIDUAL TOTALPERM TOTALTEMP TOTALTOZIP date month Net_COA
// save the file for year i
save `i'.dta , replace
	use 2018_2022.dta , replace
	// append year i to prior years
	append using `i'.dta , force
    save 2018_2022.dta , replace 
	
}
// format month
format %tmMonth_CCYY month

// Aggergate data by City

collapse (sum) TOTALFROMZIP TOTALBUSINESS TOTALFAMILY TOTALINDIVIDUAL TOTALPERM TOTALTEMP TOTALTOZIP Net_COA (firstnm) STATE, by(CITY month)
save City_COA_2018_2022.dta , replace

// Aggergate data by State

collapse (sum) TOTALFROMZIP TOTALBUSINESS TOTALFAMILY TOTALINDIVIDUAL TOTALPERM TOTALTEMP TOTALTOZIP Net_COA , by(STATE month)
save State_COA_2018_2022.dta , replace

