
# ============================================
# ===== Setting the variables to extract =====
# ============================================

# Scottish Household Survey

# SELECTION OF VARS IS A KEY ERROR PRONE STAGE THAT NEEDS FULL QA

vars_to_keep <- c(
  # Asked of SHS Random Adult:
  "voluntee", # Percentage of adults who have given any unpaid help to any groups, clubs or organisations in the last 12 months
  "volunteer", 
  "commbel", # Percentage of adults who feel that they belong very or fairly strongly to their immediate neighbourhood
  "rb1", #Percentage of adults who rate their neighbourhood as a very good place to live
  "greenuse13", # Percentage of adults who use/pass through a public green blue or open space in their local area every day or several times a week (within a five minute walk)
  "asb2a", # Percentage of adults who experienced noisy neighbours or regular loud parties in their neighbourhood in the last 12 months 
  "serv1h", # Percentage of adults who strongly agree or agree that they can influence decisions affecting their local area
  "social2", # Percentage of adults who reported feeling lonely some, most, almost all or all of the time in the last week
  "social3_02", # Percentage of adults who trust most people in their neighbourhood
  
  # new vars: harass and discrim (due to being discontinued in SHeS)
  "harass1", # 2013 to 2017
  "harass_01", "harass_02", "harass_03", "harass_04", "harass_05", "harass_06", "harass_07", #2018 onwards (yes to experienced this type of harass)
  "harass_08", "harass_091015", "harass_11", "harass_12", "harass_13", "harass_14", 
  "harass_16", # not experienced
  "harass_17", # don't know?
  "harass_18", # refused?
  
  "discrim1", # 2013 to 2017
  "discrim_01", "discrim_02", "discrim_03", "discrim_04", "discrim_05", "discrim_06", "discrim_07", #2018 onwards (yes to experienced this type of discim)
  "discrim_08", "discrim_091015", "discrim_11", "discrim_12", "discrim_13", "discrim_14", 
  "discrim_16", # not experienced
  "discrim_17", # don't know?
  "discrim_18", # refused?
  
  # Asked of Highest Income Householder / partner (do not aggregate these vars by sex)
  "hk2", # Percentage of households managing very or quite well financially these days
    # Percentage of adults or their partners who have used a cash loan from a company that comes to the home to collect payments, a loan from a pawnbroker/cash converters or a loan from a pay day lender in the past year"
  "credit309d", # - a cash loan from a company that comes to the home to collect payments, 
  "credit309e", # - a loan from a pawnbroker/cash converters or 
  "credit309l", # - a loan from a pay day lender in the past year
  # These older versions of the variables refer to loans the hhd currently has (so may not include some they had and paid off in last year).
  # Import and check these, in case can be combined with later timeseries (credit309).
  # credit209 = 2012
  "credit209d", 
  "credit209e",
  "credit209l",
  # cred209 = 2009-10 and 2011
  "cred209d", 
  "cred209e",
  "cred209l",

  # weights
  "la_wt", # data about hh and collected from highest-income householder and spouse (1st part of interview). Incorporates stratum selection weights.
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
  
  # age not needed as all respondents are 16+
  
  # ID variable for linking to SHCS data file
  "uniqidnew"
)








