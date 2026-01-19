# ============================================
# ===== Setting the variables to extract =====
# ============================================

# Scottish Household Survey - PA profile

# SELECTION OF VARS IS A KEY ERROR PRONE STAGE THAT NEEDS FULL QA

vars_to_keep <- c(
  # Asked of SHS Random Adult:
  "sprt3aa", #adults participating in recreational walking
  "anysportnowalk", #adults participating in sport
  "outdoor", #adults visiting the outdoors at least once a week
  "serv3a", #satisfaction with local sports and leisure facilities
  "serv3e", #satisaction with local parks and open spaces
  "rg5a", #disability or long term illness
  
  # weights
  "ind_wt", # data in derived vars about random adult or collected from random adult. Incorporates stratum selection weights.
  
  #sex (only needed for the random adult questions, as the others are about hhd finances)
  "randsex",
  "randgender",
  
  # spatial units
  "hlth06", #some years have 2 hb/la variables (usually code and name): need both because of some unclear coding from the data dictionary
  "hlth14",
  "hlth19",
  "hlthbd2014",
  "hlthbd2019",
  "la",
  "council",
  "la_code",
  "md04quin",
  "md04pc15", # needed because directionality not clear from var labelling
  "md05quin",
  "md05pc15", # needed because directionality not clear from var labelling
  "md06quin", # some years use two SIMD years: watch out for this
  "md09quin",
  "md12quin",
  "md16quin",
  "md20quin",
  
  # ID variable for linking to SHCS data file
  "uniqidnew"
)

