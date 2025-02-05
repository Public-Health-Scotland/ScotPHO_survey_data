
# ============================================
# ===== Setting the variables to extract =====
# ============================================

# Understanding Society

# SELECTION OF VARS IS A KEY ERROR PRONE STAGE THAT NEEDS FULL QA

# for each wave the same variables are needed (but each take the wave's letter as a prefix)
waves <- c("b", "d", "f", "h", "j", "l", "n")
vars <- c("jbsec", # the variable of interest
          "strata", # survey design strata
          "psu", # survey design primary sampling unit
          "age_dv", # age
          "sex", # sex
          "sex_dv", # sex, derived
          "gor_dv", # govt office region
          "imd2016qs_dv",
          "imd2020qs_dv") 
combo <- paste(rep(waves, each = length(vars)), vars, sep = "_")

vars_to_keep <- c(
  # identifier
  "pidp",

  # weights (wave_individual-interview-ub(wavesB-D)/ui(wavesF-L)/g2(wavesN+)_cross-sectional
  "b_indinub_xw",
  "d_indinub_xw",
  "f_indinui_xw",
  "h_indinui_xw",
  "j_indinui_xw",
  "l_indinui_xw",
  "n_inding2_xw",
  
  combo
)



