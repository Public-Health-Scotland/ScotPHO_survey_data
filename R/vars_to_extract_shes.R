
# ============================================
# ===== Setting the variables to extract =====
# ============================================

# Scottish Health Survey

# SELECTION OF VARS IS A KEY ERROR PRONE STAGE THAT NEEDS FULL QA
# ENSURE MOST RECENT YEAR'S WEIGHTS ARE ADDED WHEN READING IN NEW DATA

vars_to_keep <- c(

  "age", "age90", "respage",
  
  "hb_code", "hbcode", "hlth_brd", "hlthbrd",   
  "hboard", #98 and 03
  
  "sex", "respsex", "final_sex22",
  
  # identifiers needed to work out who are the legal parents of the interviewed child
  "par1", # person number of 1st legal parent
  "par2", # person number of 2nd legal parent
  "person", # that individual's person number
  
  "cpseriala", # serial number of individual (looks to be hhd serial number + 2 digit person number)
  "pserial",
  "pserial_a",
  "cpserial_a",
  "cp_serial_a",
  "serialx",
  
  "chh_serial_a", # serial number of the hhd 
  "chhserial_a",
  "chhseriala",
  "chserial_a",
  "hhserial",
  "hserial_a" ,

  #Use the SG harmonised SIMD instead of the report (rp) versions, as these are coded more intuitively
  "simd5", #simd2004 used in 03: CHECK CODING. NO 95/98 SIMD.
  "simd5_sg",# SIMD2009 used 08 to 11
  "simd5_s_ga", #SIMD2012 used 12 to 15 *
  "simd16_s_ga", #SIMD2016 used 13 to 18 * (* both used in 15161718 file, keep simd16)
  "simd20_s_ga", #SIMD2020 used 16 to 20
  "simd20_sga", #SIMD2020 used 19 to 21
  "simd20_r_pa", #needed for 2022 data, no SGA available

  "wemwbs", "wemwbs_t20", # mean score variable (FROM 2008)
  "gh_qg2", "gh_qg2_t20", "ghqg2", "ghq2", #(last 2 in 95, 98 and 03)
  "depsymp", "depsymp_t20", "dvg11", 
  "anxsymp", "anxsymp_t20", "dvj12", 
  "porftvg3", #"porftvg5", #(last one used in 2003)
  "porftvg3intake", "number_of_recalls", #Intake used in 2021 data: might not be comparable (though SG present in same timeseries). Published intake24 data = only fom those with 2 recalls.
  "gen_helf", "genhelf",
  "limitill",
  "involve", "involv19",
  "pcris19", "p_crisis",  
  "rg17a_new", "rg15a_new", # need rg15a_new to identify those who give no caring per week (0 hrs not included in rg17a_new)
  "str_work2",
  "work_bal", # mean score variable 
  "contrl", 
  "support1", "support1_19", 
  "suicide2", 
  "dsh5", "dsh5sc", 
  "adt10gp_tw", "adt10gptw", 
  "life_sat", # mean score variable
  "sdq_totg", "sdq_pro", "sdq_emog", "sdq_cong", "sdq_hypg", "sdq_peeg", #child sdq variables 
  
  # child physical activity
  "c00sum7s", # Summary classification activity levels - All activities, INCLUDING SCHOOL no lower limits

 # needed for CYP MHIs:
  "auditg", # banded AUDIT score (for CYP indicator)

  #survey design
  "psu", 
  "strata", 
  "region", #use for strata in 98
  
  # weights
  # main sample weights (35 survey files, excluding 0810, 0911, 1214):
  "int08wt",
  "int0809_wt", 
  "int08091011_wt", 
  "int09wt", 
  "int1011_wt", 
  "int10wt", 
  "int11wt", 
  "int12131415wt", 
  "int121314wt", 
  "int1213wt", 
  "int12wt", 
  "int13141516wt", 
  "int1315wt", 
  "int13wt", 
  "int14151617wt", 
  "int1415wt", 
  "int1416wt", 
  "int14wt", 
  "int15161718wt", 
  "int1516wt", 
  "int1517wt", 
  "int15wt", 
  "int16171819wt", 
  "int1617wt", 
  "int1618wt", 
  "int16wt", 
  "int17181921wt", 
  "int1718wt", 
  "int1719wt", 
  "int17wt", 
  "int18192122wt",
  "int1819wt", 
  "int18wt", 
  "int1921wt", 
  "int19wt", 
  "int20wt", 
  "int21wt", 
  "int22wt",
 "int19212223wt",
 "int23wt",
  # version a (vera) weights (22 files have vera weights: annual and ~3yr)
  "vera08wt", 
  "vera0810wt", 
  "vera0911wt", 
  "vera09wt", 
  "vera10wt", 
  "vera11wt", 
  "vera1213wt", 
  "vera1214wt", 
  "vera12wt", 
  "vera1315wt", 
  "vera13wt", 
  "vera1416wt", 
  "vera14wt", 
  "vera1517wt", 
  "vera15wt", 
  "vera1618wt", 
  "vera16wt", 
  "vera1719wt", 
  "vera17wt", 
  "vera18192122wt",
  "vera18wt", 
  "vera1921wt", 
  "vera19wt", 
  "vera21wt",
  "vera22wt",
 "vera23wt",
 # version b (verb) biol module weights (22 files have bio weights: annual, ~3yr and ~4yr, from 1213)
  "bio12131415wt",
  "bio121314wt",
  "bio1213wt",
  "bio13141516wt",
  "bio13wt",
  "bio14151617wt",
  "bio1415wt",
  "bio14wt",
  "bio15161718wt",
  "bio1516wt",
  "bio15wt",
  "bio16171819wt",
  "bio1617wt",
  "bio16wt",
  "bio17181921wt",
  "bio1718wt",
  "bio17wt",
  "bio18192122wt",
  "bio1819wt",
  "bio18wt",
  "bio1921wt",
  "bio19wt",
  "bio21wt",
  "bio22wt",
 "bio19212223wt",
 "bio23wt",
 
  #nurse weights: (pre-dated introduction of bioweights, 2008-11, and are used for self-harm/suicide/anxiety/depression questions)
  "nurs08wt",
  "nurs0809_wt",
  "nurs09wt",
  "nurs10wt",
  "nurs08091011_wt",
  "nurs1011_wt",
  "nurs11wt",
  # Intake24 weight (only in 2021 so far)
  "s_he_s_intake24_wt_sc",
  # early surveys:
  "weighta", #93 and 98
  "int_wt", #03
  # child weights
 "cint_wt",
 "cint0809_wt",
 "cint08091011_wt",
 "cint08wt",
 "cint09wt",
 "cint1011_wt",
 "cint10wt",
 "cint11wt",
 "cint12131415wt",
 "cint121314wt",
 "cint1213wt",
 "cint12wt",
 "cint13141516wt",
 "cint13wt",
 "cint14151617wt",
 "cint1415wt",
 "cint14wt",
 "cint15161718wt",
 "cint1516wt",
 "cint15wt",
 "cint16171819wt",
 "cint1617wt",
 "cint16wt",
 "cint17181921wt",
 "cint1718wt",
 "cint1719wt",
 "cint17wt",
 "cint18192122wt",
 "cint1819wt",
 "cint18wt",
 "cint1921wt",
 "cint19wt",
 "cint21wt",
 "cint22wt",
 "cint19212223wt",
 "cint23wt"
 
 
 
  
)

## END
