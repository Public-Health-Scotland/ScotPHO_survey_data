
# ============================================
# ===== Setting the variables to extract =====
# ============================================

# Scottish Health Survey

# SELECTION OF VARS IS A KEY ERROR PRONE STAGE THAT NEEDS FULL QA
# ENSURE MOST RECENT YEAR'S WEIGHTS ARE ADDED WHEN READING IN NEW DATA

vars_to_keep <- c(
  
  "age", 
  "ag16g10", # adult age groups (is this used?)
  
  "hb_code", "hbcode", "hlth_brd", "hlthbrd",   

  "la_code",
  
  "sex", "final_sex22",
  "eqv5_15", #equivalised income groups (OECD method)
  "urindsc2", "urbrur2a", "urbrur2a_16", "urbrur2a_20", # urban-rural classification (lots of overlap of these classifications: look into later) (2012 onwards)
  
  # identifiers needed to work out who are the legal parents of the interviewed child
  "par1", # person number of 1st legal parent
  "par2", # person number of 2nd legal parent
  # "person", # that individual's person number # now derived from cpserial (as not provided in 2023)
  
  "cpseriala", # serial number of individual (looks to be hhd serial number + 2 digit person number)
  "pserial_a",
  "cpserial_a",
  "cp_serial_a",

  "chh_serial_a", # serial number of the hhd 
  "chhserial_a",
  "chhseriala",
  "chserial_a",
  "hserial_a" ,
  
  #Use the SG harmonised SIMD instead of the report (rp) versions, as these are coded more intuitively
  "simd5_sg",# SIMD2009 used 08 to 11
  "simd5_s_ga", #SIMD2012 used 12 to 15 *
  "simd16_s_ga", #SIMD2016 used 13 to 18 * (* both used in 15161718 file, keep simd16)
  "simd20_s_ga", #SIMD2020 used 16 to 20
  "simd20_sga", #SIMD2020 used 19 to 21
  "simd20_r_pa", #needed for 2022 data, no SGA available
  
  "wemwbs", # mean score variable (FROM 2008)
  "gh_qg2", "ghqg2", 
  "depsymp", "dvg11", # dvg11 (2008 and 0809) = CISR - DEPRESSION Symptom score [from G5, G6, G7 and G9]
  "anxsymp", "dvj12", # dvj12 (2008 and 0809) = (D) CISR - ANXIETY Symptom score [from J6, J7, J8, J9 and J10]
  "porftvg3", #"porftvg5", #(last one used in 2003) # (D) Grouped portions of fruit (including fruit juice) & veg (5/less than 5/none)
  "porftvg3intake", "number_of_recalls", "numberofrecalls",#Intake used in 2021 and 2024 data: SG present this data in same timeseries as previous porftvg3 variable). Published intake24 data = only fom those with 2 recalls.
  # Healthy weight. BMI of higher than 18.5 and lower than 25. 
  "bmivg5", "bmivg5_adj", "combmivg5_adj",
  # During the last 12 months, was there a time when you were worried you would run out of food?
  "wrfood", #from 2017
  "drating", "dnnow", "dnany", "drkcat315", # used for Alcohol consumption (guidelines) and (mean weekly units) (dnnow and dnany only needed until ~ 2015)
  "olimlwb", "olim_l_wb", # (D) Drinking over  (6/8) units in day  (includes non-drinkers) (2008-2024)
  "genhelf2", # used for adults and children
  "limitill", # now called long-term conditions
  "involve", "involv19",
  "pcris19", "p_crisis",  
  "rg17a_new", "rg15a_new", "rg17anew", "rg15anew",# need rg15a_new to identify those who give no caring per week (0 hrs not included in rg17a_new)
  "str_work2", "strwork2",
  "work_bal", # mean score variable 
  "contrl", 
  "support1", "support1_19", 
  "suicide2", 
  "dsh5", "dsh5sc", # DSH Ever deliberately self-harmed (suicide not intended)
  "adt10gp_tw", "adt10gptw", 
  #"life_sat", # mean score variable
  "lifesat2", # grouped variable
  "mus_rec", #adults meeting the muscle strengthening guideline
  "musrec", #used in 2023 and 2024
  
  # children
  "cghq214", # (D) Child living with a parent with a GHQ12 score of 4+
  "sdq_totg", "sdq_pro", "sdq_emog", "sdq_cong", "sdq_hypg", "sdq_peeg", #child sdq variables 
  "spt1ch", #children participating in sport
  "ch30plyg", #children engaging in active play
  "cbm_ig5_new", "cbm_ig5_new_sr", "cbm_ig5_new_int", "cbmig5_new_int", "cbmig5_new", # children's BMI categories (-> at risk of obesity)
  
  # child physical activity
  "c00sum7s", # Summary classification activity levels - All activities, INCLUDING SCHOOL no lower limits
  
  # needed for CYP MHIs:
  "auditg", # banded AUDIT score (for CYP indicator) (every other year)
  
  #survey design
  "psu", 
  "strata"
  
)

## END
