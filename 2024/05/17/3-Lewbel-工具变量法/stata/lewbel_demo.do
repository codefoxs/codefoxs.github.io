cd "C:\Users\24350\Desktop\Lewbel command"
global controls = "x2-x9"

use "lewbel test.dta", clear

xtset id year
gen Ind_year = string(Industry) + " $ " + string(year)

* Use lewbel command
lewbel y x1 $controls , a(Country Ind_year) cl(Ind_year) keep first
est store m3

* First stage
reghdfe x1 x2_g-x9_g x2-x9, a(Country Ind_year) cl(Ind_year)
est store m1

* Predict
qui predict x1_p

* Second stage
reghdfe y x1_p x2-x9, a(Country Ind_year) cl(Ind_year)
est store m2

reg2docx m1 m2 m3 using "lewbel.docx", replace ///
                 b(%20.4f) t(%20.4f) ///
                 scalars(N(%20.0fc) r2_a(%20.4f) HetLM(%20.4f) HetLMp(%20.4f) ///
                 Kleibergen_Paap_rk_LM(%20.4f) Kleibergen_Paap_rk_LM_p(%20.4f) ///
                 Cragg_Donald_Wald_F(%20.4f) Kleibergen_Paap_rk_Wald_F(%20.4f) ///
                 Hansen_J(%20.4f) Hansen_J_p(%20.4f)) ///
                 order(x1 x1_p) ///
                 addfe("Country=YES" "Industry*Year=YES") ///
                 mtitles() ///
                 font("Times New Roman", 6.5) ///
                 margin(top, 3.17cm) margin(bottom, 3.17cm)

