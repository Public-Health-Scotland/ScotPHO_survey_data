# ============================================
# ===== Setting the variables to extract =====
# ============================================

# Scottish Health Survey - PA profile

# SELECTION OF VARS IS A KEY ERROR PRONE STAGE THAT NEEDS FULL QA
# ENSURE MOST RECENT YEAR'S WEIGHTS ARE ADDED WHEN READING IN NEW DATA

vars_to_keep <- c(
  
  "age",
  
  "hb_code", "hbcode", "hlth_brd", "hlthbrd",
  
  "sex", "final_sex22",
  
  "cpseriala", # serial number of individual (looks to be hhd serial number + 2 digit person number)
  "cpserial_a",
  "cp_serial_a",
  
  "chh_serial_a", # serial number of the hhd 
  "chhserial_a",
  "chhseriala",
  "chserial_a",
  
  #Use the SG harmonised SIMD instead of the report (rp) versions, as these are coded more intuitively
  "simd5_s_ga", #SIMD2012 used 12 to 15 *
  "simd16_s_ga", #SIMD2016 used 13 to 18 * (* both used in 15161718 file, keep simd16)
  "simd20_s_ga", #SIMD2020 used 16 to 20
  "simd20_sga", #SIMD2020 used 19 to 21
  "simd20_r_pa", #needed for 2022 data, no SGA available
  
  #indicator nuemrator variables
  "mus_rec", #adults meeting the muscle strengthening guideline
  "musrec", #used in 2023
  "adt10gp_tw", "adt10gptw", #adults with very low activity (summary activity levels), 
  "c00sum7s", #children with very low activity (summary activity levels),
  "spt1ch", #children participating in sport
  "ch30plyg", #children engaging in active play
  "limitill", #life limiting illness
  
  #survey design
  "psu", 
  "strata", 
  
  # weights
  # main sample weights (35 survey files, excluding 0810, 0911, 1214):
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
  
  # child weights
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
  "cint19212223wt",
  "cint1921wt",
  "cint19wt",
  "cint21wt",
  "cint22wt",
  "cint23wt"
  
)

## END

