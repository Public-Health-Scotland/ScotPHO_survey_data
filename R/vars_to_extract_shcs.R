
# ============================================
# ===== Setting the variables to extract =====
# ============================================

# Scottish House Condition Survey

# SELECTION OF VARS IS A KEY ERROR PRONE STAGE THAT NEEDS FULL QA

vars_to_keep <- c(
  "critany",
  "extany_vp",
  "urgany",
  # "criturgext", #this is critical AND urgent AND extensive, so is too restrictive.

  # weights
  "la_wght_p", # 3-year paired grossing weight
  "ts_wght_p_n", # paired sampling weight

  # spatial units
  "la",
 
  #ID for matching with SIMD info in main SHoS file
  "uniqidnew",
  "uniqidnew_shs_social",
  
  # whether any children <16y in the household
  "any_kids"
  
)

## END






