
# ============================================
# ===== Setting the variables to extract =====
# ============================================

# Annual Population Survey

vars_to_keep <- c(
  "inecac05", # a 'CORE' variable
  "govtof", "age", "sex", 
  "stucur", #whether a current full time student
  
  #weights
  "pwta14", "pwta18", "pwta22",
  "pwapsa14" #Person Weight for lfssamp 1,2,6 combined: use for CORE variables. 
  # explained here: https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/methodologies/labourforcesurveyuserguidance/volume62022.pdf

)


## END





