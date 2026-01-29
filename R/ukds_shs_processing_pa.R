# ============================================================================
# ===== Processing UKDS survey data files: SCOTTISH HOUSEHOLD SURVEY (SHoS) =====
# ============================================================================

# 5 indicators
# sprt3aa - adults participating in sport
# anysportnowalk - adults participating in recreational walking
# serv3a - satisfaction with local sports and leisure facilities
# serv3e - satisfaction with local parks and open spaces
# outdoor - adults visiting the outdoors at least once a week

# Denominators = Total number of respondents (all were 16+) answering the question. 
# Excluding don't knows
# Survey weight: ind_wt = for variables pertaining to the 'random adult' in the household.
# Survey design = 
## Design factors obtained from SG (John.Paterson3@gov.scot, SHS@gov.scot) for adjusting the CIs, as per guidance: 
## 2019 SHoS guidance: https://www.gov.scot/binaries/content/documents/govscot/publications/statistics/2020/09/scottish-hdata:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAWElEQVR42mNgGPTAxsZmJsVqQApgmGw1yApwKcQiT7phRBuCzzCSDSHGMKINIeDNmWQlA2IigKJwIssQkHdINgxfmBBtGDEBS3KCxBc7pMQgMYE5c/AXPwAwSX4lV3pTWwAAAABJRU5ErkJggg==ousehold-survey-2019-annual-report/documents/scottish-household-survey-annual-report-2019-confidence-intervals-statistical-significance/scottish-household-survey-annual-report-2019-confidence-intervals-statistical-significance/govscot%3Adocument/scottish-household-survey-annual-report-2019-confidence-intervals-statistical-significance.pdf
## Stored at "/conf/MHI_Data/big/big_mhi_data/unzipped/shs/SHoS design effects from SG.xlsx"
# Confidence intervals:
# Use the normal approximation, as advised by SHoS (see emails and their significance testing xlsx).
# CIs adjusted for design effects, that were provided by SHoS team.
## (Had previously used Wilson's Score CI calc method:
## Commonly used public health statistics and their confidence intervals
## https://fingertips.phe.org.uk/documents/APHO%20Tech%20Briefing%203%20Common%20PH%20Stats%20and%20CIs.pdf
## but this calculation now replaced by normal approximation, and Wilson's score method is commented out)

# Suppression: 
# SHS suppresses values if based on unweighted bases <50. Advises caution for estimates with unweighted base close to 50. 

# Packages and functions
# =================================================================================================================

## A. Load in the packages

pacman::p_load(
  here, # for file paths within project/repo folders
  haven, # importing .dta files from Stata
  openxlsx, # reading and creating spreadsheets
  arrow, # work with parquet files
  survey, # analysing data from a clustered survey design
  reactable, # required for the QA .Rmd file
  weights, #weighted percents
  stats #ftable (flat contingency tables)
)

## B. Source generic and specialist functions 

source(here("functions", "functions.R")) # sources the file "functions/functions.R" within this project/repo

# Source functions/packages from ScotPHO's scotpho-indicator-production repo 
# (works if you've stored the ScotPHO repo in same location as the current repo)
source("../scotpho-indicator-production/1.indicator_analysis.R")
source("../scotpho-indicator-production/2.deprivation_analysis.R")

## C. Path to the data derived by this script (absolute path in case your repo is stored outside of the MHI_Data folder)

derived_data <- "/conf/MHI_Data/derived data/"

# 1. Find survey data files, extract variable names and labels (descriptions), and save this info to a spreadsheet
# =================================================================================================================

## Create a new workbook (first time only. don't run this now)
#wb <- createWorkbook()
#saveWorkbook(wb, file = paste0(derived_data, "all_survey_var_info.xlsx"))

save_var_descriptions(survey = "shs", 
                      name_pattern = "\\/shs\\D*(\\d{4}-?\\d{0,4})") # the regular expression for this survey's filenames that identifies the survey year(s)
# takes ~ 3 mins

# 2. Manual bit: Look at the vars_'survey' tab of the spreadsheet all_survey_var_info.xlsx to work out which variables are required.
#    Manually store the relevant variables in the file vars_to_extract_'survey'
# =================================================================================================================

# 3. Extract the relevant survey data from the files 
# =================================================================================================================

extracted_survey_data_shs <- extract_survey_data("shs", pa = TRUE) 
# takes ~ 3 mins 

# keep only the survey files we are interested in

extracted_survey_data_shs <- extracted_survey_data_shs %>%
  filter(!grepl('_td_|0708_c_and_s', filename))  # don't need the travel diary files or the 0708_c_and_s file

# save the file
saveRDS(extracted_survey_data_shs, paste0(derived_data, "extracted_survey_data_shs_pa.rds"))

# 4. What are the possible responses?
# =================================================================================================================

# Read in data if not in memory:
extracted_survey_data_shs <- readRDS(paste0(derived_data, "extracted_survey_data_shs_pa.rds"))

# get the responses recorded for each variable (combined over the years), and save to xlsx and rds

# 1st run through to see how to identify variables that can be excluded (and the unique characters that will identify these):
# extract_responses(survey = "shs") 
# responses_as_list_shs <- readRDS(paste0(derived_data, "responses_as_list_shs.rds"))
# responses_as_list_shs  # examine the output

# 2nd run to exclude the numeric vars that don't need codings and/or muck up the output:

extract_responses(survey = "shs", #survey acronym
                  chars_to_exclude = c("_wt"), pa = TRUE) 

# read the responses back in and print out so we can work out how they should be coded
# (also useful to see how sex/geography/simd variables have been recorded, for later standardisation)

responses_as_list_shs <- readRDS(paste0(derived_data, "responses_as_list_shs_pa.rds"))
responses_as_list_shs

# responses_as_list_shs printed out
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?
###################################
# ============================================================================
# ===== Processing UKDS survey data files: SCOTTISH HOUSEHOLD SURVEY (SHoS) =====
# ============================================================================

# 5 indicators
# sprt3aa - adults participating in sport
# anysportnowalk - adults participating in recreational walking
# serv3a - satisfaction with local sports and leisure facilities
# serv3e - satisfaction with local parks and open spaces
# outdoor - adults visiting the outdoors at least once a week

# Denominators = Total number of respondents (all were 16+) answering the question. 
# Excluding don't knows
# Survey weight: ind_wt = for variables pertaining to the 'random adult' in the household.
# Survey design = 
## Design factors obtained from SG (John.Paterson3@gov.scot, SHS@gov.scot) for adjusting the CIs, as per guidance: 
## 2019 SHoS guidance: https://www.gov.scot/binaries/content/documents/govscot/publications/statistics/2020/09/scottish-hdata:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAWElEQVR42mNgGPTAxsZmJsVqQApgmGw1yApwKcQiT7phRBuCzzCSDSHGMKINIeDNmWQlA2IigKJwIssQkHdINgxfmBBtGDEBS3KCxBc7pMQgMYE5c/AXPwAwSX4lV3pTWwAAAABJRU5ErkJggg==ousehold-survey-2019-annual-report/documents/scottish-household-survey-annual-report-2019-confidence-intervals-statistical-significance/scottish-household-survey-annual-report-2019-confidence-intervals-statistical-significance/govscot%3Adocument/scottish-household-survey-annual-report-2019-confidence-intervals-statistical-significance.pdf
## Stored at "/conf/MHI_Data/big/big_mhi_data/unzipped/shs/SHoS design effects from SG.xlsx"
# Confidence intervals:
# Use the normal approximation, as advised by SHoS (see emails and their significance testing xlsx).
# CIs adjusted for design effects, that were provided by SHoS team.
## (Had previously used Wilson's Score CI calc method:
## Commonly used public health statistics and their confidence intervals
## https://fingertips.phe.org.uk/documents/APHO%20Tech%20Briefing%203%20Common%20PH%20Stats%20and%20CIs.pdf
## but this calculation now replaced by normal approximation, and Wilson's score method is commented out)

# Suppression: 
# SHS suppresses values if based on unweighted bases <50. Advises caution for estimates with unweighted base close to 50. 

# Packages and functions
# =================================================================================================================

## A. Load in the packages

pacman::p_load(
  here, # for file paths within project/repo folders
  haven, # importing .dta files from Stata
  openxlsx, # reading and creating spreadsheets
  arrow, # work with parquet files
  survey, # analysing data from a clustered survey design
  reactable, # required for the QA .Rmd file
  weights, #weighted percents
  stats #ftable (flat contingency tables)
)

## B. Source generic and specialist functions 

source(here("functions", "functions_pa.R")) # sources the file "functions/functions.R" within this project/repo

# Source functions/packages from ScotPHO's scotpho-indicator-production repo 
# (works if you've stored the ScotPHO repo in same location as the current repo)
source("../scotpho-indicator-production/1.indicator_analysis.R")
source("../scotpho-indicator-production/2.deprivation_analysis.R")
# temporary functions:
source(here("functions", "temp_depr_analysis_updates.R")) # 22.1.25: sources some temporary functions needed until PR #97 is merged into the indicator production repo 

## C. Path to the data derived by this script (absolute path in case your repo is stored outside of the MHI_Data folder)

derived_data <- "/conf/MHI_Data/derived data/"


# 1. Find survey data files, extract variable names and labels (descriptions), and save this info to a spreadsheet
# =================================================================================================================

## Create a new workbook (first time only. don't run this now)
#wb <- createWorkbook()
#saveWorkbook(wb, file = paste0(derived_data, "all_survey_var_info.xlsx"))

save_var_descriptions(survey = "shs", 
                      name_pattern = "\\/shs\\D*(\\d{4}-?\\d{0,4})") # the regular expression for this survey's filenames that identifies the survey year(s)
# takes ~ 3 mins

# 2. Manual bit: Look at the vars_'survey' tab of the spreadsheet all_survey_var_info.xlsx to work out which variables are required.
#    Manually store the relevant variables in the file vars_to_extract_'survey'
# =================================================================================================================

# 3. Extract the relevant survey data from the files 
# =================================================================================================================

extracted_survey_data_shs <- extract_survey_data("shs", pa = TRUE) 
# takes ~ 3 mins 

# keep only the survey files we are interested in

extracted_survey_data_shs <- extracted_survey_data_shs %>%
  filter(!grepl('_td_|0708_c_and_s', filename))  # don't need the travel diary files or the 0708_c_and_s file

# save the file
saveRDS(extracted_survey_data_shs, paste0(derived_data, "extracted_survey_data_shs_pa.rds"))

# 4. What are the possible responses?
# =================================================================================================================

# Read in data if not in memory:
extracted_survey_data_shs <- readRDS(paste0(derived_data, "extracted_survey_data_shs_pa.rds"))

# get the responses recorded for each variable (combined over the years), and save to xlsx and rds

# 1st run through to see how to identify variables that can be excluded (and the unique characters that will identify these):
# extract_responses(survey = "shs") 
# responses_as_list_shs <- readRDS(paste0(derived_data, "responses_as_list_shs.rds"))
# responses_as_list_shs  # examine the output

# 2nd run to exclude the numeric vars that don't need codings and/or muck up the output:

extract_responses(survey = "shs", #survey acronym
                  chars_to_exclude = c("_wt"), pa = TRUE) 

# read the responses back in and print out so we can work out how they should be coded
# (also useful to see how sex/geography/simd variables have been recorded, for later standardisation)

responses_as_list_shs <- readRDS(paste0(derived_data, "responses_as_list_shs_pa.rds"))
responses_as_list_shs

# responses_as_list_shs printed out
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?
###################################
# $anysportnowalk
# [1] "Yes" "No"  NA   
# 
# $council
# [1] "aberdeen city"       "north ayrshire"      "aberdeenshire"       "dumfries & galloway" "fife"               
# [6] "edinburgh, city of"  "south ayrshire"      "clackmannanshire"    "falkirk"             "perth & kinross"    
# [11] "west dunbartonshire" "argyll & bute"       "dundee city"         "north lanarkshire"   "west lothian"       
# [16] "eilean siar"         "east lothian"        "glasgow city"        "highland"            "shetland islands"   
# [21] "orkney islands"      "south lanarkshire"   "inverclyde"          "scottish borders"    "east renfrewshire"  
# [26] "midlothian"          "renfrewshire"        "stirling"            "angus"               "moray"              
# [31] "east ayrshire"       "east dunbartonshire" "West Lothian"        "Edinburgh, City of"  "South Lanarkshire"  
# [36] "Glasgow City"        "Inverclyde"          "East Dunbartonshire" "23"                  "Midlothian"         
# [41] "Angus"               "Perth & Kinross"     "Stirling"            "Fife"                "1"                  
# [46] "Aberdeenshire"       "Falkirk"             "16"                  "17"                  "North Lanarkshire"  
# [51] "Dumfries & Galloway" "Aberdeen City"       "Highland"            "East Renfrewshire"   "Dundee City"        
# [56] "11"                  "Clackmannanshire"    "East Ayrshire"       "East Lothian"        "Renfrewshire"       
# [61] "Scottish Borders"    "North Ayrshire"      "Moray"               "Orkney Islands"      "Argyll & Bute"      
# [66] "Shetland Islands"    "14"                  "12"                  "10"                  "19"                 
# [71] "West Dunbartonshire" "Eilean Siar"         "South Ayrshire"      "15"                  "6"                  
# [76] "27"                  "18"                  "20"                  "2"                   "29"                 
# [81] "13"                  "32"                  "30"                  "9"                   "25"                 
# [86] "5"                   "4"                   "28"                  "3"                   "31"                 
# [91] "8"                   "26"                  "22"                  "7"                   "24"                 
# [96] "21"                  NA                    "R"                   "Y"                   "L"                  
# [101] "P"                   "B"                   "C"                   "Q"                   "F"                  
# [106] "K"                   "E"                   "O"                   "H"                   "V"                  
# [111] "A"                   "D"                   "T"                   "X"                   "M"                  
# [116] "N"                   "U"                   "J"                   "S"                   "W"                  
# [121] "G"                   "Z"                   "I"                  
# 
# $hlth06
# [1] "grampian"                "ayrshire & arran"        "dumfries & galloway"     "fife"                   
# [5] "lothian"                 "forth valley"            "tayside"                 "greater glasgow & clyde"
# [9] "highland"                "lanarkshire"             "western isles"           "shetland"               
# [13] "orkney"                  "borders"                 "Lothian"                 "Lanarkshire"            
# [17] "Greater Glasgow & Clyde" "Tayside"                 "Forth Valley"            "Fife"                   
# [21] "Grampian"                "Dumfries & Galloway"     "Highland"                "Ayrshire & Arran"       
# [25] "Borders"                 "Orkney"                  "Shetland"                "Western Isles"          
# [29] NA                       
# 
# $hlth14
# [1] "S08000022" "S08000024" "S08000021" "S08000017" "S08000023" "S08000015" "S08000018" "S08000027" "S08000019"
# [10] "S08000025" "S08000020" "S08000026" "S08000016" "S08000028" "13"        "16"        "7"         "3"        
# [19] "11"        "2"         "5"         "6"         "14"        "17"        "10"        "12"        "15"       
# [28] "4"        
# 
# $hlthbd2014
# [1] "S08000023" "S08000021" "S08000020" "S08000024" "S08000027" "S08000022" "S08000019" "S08000015" "S08000016"
# [10] "S08000018" "S08000028" "S08000025" "S08000017" "S08000026" "S08000029" "S08000030"
# 
# $hlthbd2019
# [1] "S08000020" "S08000022" "S08000030" "S08000019" "S08000017" "S08000015" "S08000016" "S08000032" "S08000029"
# [10] "S08000031" "S08000024" "S08000028" "S08000025" "S08000026"
# 
# $la
# [1] "P" "V" "O" "A" "N" "1" "X" "B" "5" "D" "M" "G" "Z" "3" "F" "R" "2" "K" "Y" "J" "L" "T" "H" "U" "4" "E" "Q" "C"
# [29] "I" "S" "W" "6"
# 
# $la_code
# [1] "S12000029" "S12000018" "S12000038" "S12000011" "S12000046" "S12000034" "S12000040" "S12000041" "S12000017"
# [10] "S12000030" "S12000039" "S12000005" "S12000010" "S12000028" "S12000026" "S12000015" "S12000042" "S12000044"
# [19] "S12000033" "S12000035" "S12000020" "S12000024" "S12000036" "S12000014" "S12000021" "S12000013" "S12000045"
# [28] "S12000019" "S12000023" "S12000006" "S12000027" "S12000008"
# 
# $md04pc15
# [1] "most deprived 15%" "not"               NA                 
# 
# $md05pc15
# [1] "not"               "most deprived 15%" NA                 
# 
# $md06quin
# [1] "2"                             "most deprived 20% data zones"  "4"                            
# [4] "least deprived 20% data zones" "3"                             NA                             
# [7] "Least deprived 20% data zones" "Most deprived 20% data zones" 
# 
# $md09quin
# [1] "3"                             NA                              "4"                            
# [4] "Most deprived 20% data zones"  "Least deprived 20% data zones" "2"                            
# 
# $md12quin
# [1] "4"                      "2"                      "3"                      "5 - 20% least deprived"
# [5] "1 - 20% most deprived" 
# 
# $md16quin
# [1] "3"                      "1 - 20% most deprived"  "4"                      "5 - 20% least deprived"
# [5] "2"                     
# 
# $md20quin
# [1] "5 - 20% least deprived" "4"                      "3"                      "2"                     
# [5] "1 - 20% most deprived" 
# 
# $outdoor
# [1] "Not at all"             "Several times a week"   "Once or twice a month"  "Once every 2-3 months" 
# [5] "Every day"              NA                       "More than once per day" "Once or twice a year"  
# [9] "Once a week"           
# 
# $randgender
# [1] "Man/Boy"    "Woman/Girl" NA           "Female"     "Male"      
# 
# $randsex
# [1] "female" "male"   NA       "Female" "Male"  
# 
# $rg5a
# [1] NA           "Yes"        "No"         "Refused"    "Don't know" "Refusal"   
# 
# $serv3a
# [1] "very satisfied"                     "neither satisfied nor dissatisfied" "no opinion"                        
# [4] "fairly satisfied"                   "fairly dissatisfied"                NA                                  
# [7] "very dissatisfied"                  "No opinion"                         "Fairly dissatisfied"               
# [10] "Neither satisfied nor dissatisfied" "Fairly satisfied"                   "Very satisfied"                    
# [13] "Very dissatisfied"                 
# 
# $serv3e
# [1] "fairly satisfied"                   "neither satisfied nor dissatisfied" "no opinion"                        
# [4] NA                                   "very satisfied"                     "fairly dissatisfied"               
# [7] "very dissatisfied"                  "No opinion"                         "Very satisfied"                    
# [10] "Neither satisfied nor dissatisfied" "Fairly dissatisfied"                "Fairly satisfied"                  
# [13] "Very dissatisfied"                 
# 
# $sprt3aa
# [1] "no"                                                             
# [2] "yes"                                                            
# [3] NA                                                               
# [4] "refused"                                                        
# [5] "No"                                                             
# [6] "Yes"                                                            
# [7] "NOT A - Walking (at least 30 minutes for recreational purposes)"
# [8] "A - Walking (at least 30 minutes for recreational purposes)"    
# [9] "Walking"                                                        
# [10] "NOT Walking"     
###################################

# 5. How should the responses be coded?
# =================================================================================================================
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?

# Create lookups to code the variables into the dichotomy needed for the indicators:
lookup_anysportnowalk <- list(
  "Yes" = "yes",
  "No" = "no"
)

lookup_outdoor <- list(
  "More than once per day" = "yes",
  "Every day" = "yes",
  "Several times a week" = "yes",
  "Once a week" = "yes",
  "Once or twice a month" = "no",
  "Once every 2-3 months" = "no",
  "Once or twice a year" = "no",
  "Not at all" = "no"
)

lookup_serv3a <- list(
  "very satisfied" = "yes",
  "Very satisfied" = "yes",
  "fairly satisfied" = "yes",
  "Fairly satisfied" = "yes",
  "neither satisfied nor dissatisfied" = "no",
  "Neither satisfied nor dissatisfied" = "no",
  "no opinion" = "no",
  "No opinion" = "no",
  "fairly dissatisfied" = "no",
  "Fairly dissatisfied" = "no",
  "very dissatisfied" = "no",
  "Very dissatisfied" = "no"
)

lookup_serv3e <- list(
  "very satisfied" = "yes",
  "Very satisfied" = "yes",
  "fairly satisfied" = "yes",
  "Fairly satisfied" = "yes",
  "neither satisfied nor dissatisfied" = "no",
  "Neither satisfied nor dissatisfied" = "no",
  "no opinion" = "no",
  "No opinion" = "no",
  "fairly dissatisfied" = "no",
  "Fairly dissatisfied" = "no",
  "very dissatisfied" = "no",
  "Very dissatisfied" = "no")

lookup_sprt3aa <- list(
  "yes" = "yes",
  "Yes" = "yes",
  "A - Walking (at least 30 minutes for recreational purposes)" = "yes",
  "Walking" = "yes",
  "no" = "no",
  "No" = "no",
  "NOT A - Walking (at least 30 minutes for recreational purposes)" = "no",
  "NOT Walking" = "no",
  "refused" = "no"
)

lookup_rg5a <- list(
  "Yes" = "yes",
  "No" = "no",
  "Don't know" = "no",
  "Refusal" = "no",
  "Refused" = "no",
  "Don't know" = "no"
)

# Create a LUT for a person's uniqid to SIMD for the SHCS processing
# =================================================================================================================

# SIMD codes

# make a uniqidnew to SIMD quintile lookup, for use in SHCS processing:
uniqidnew_lut <- extracted_survey_data_shs %>%
  mutate(survey_data = map(survey_data, ~.x %>%
                             mutate(across(.cols = everything(), as.character)))) %>% # to deal with some incompatible formats that mucked up the unnest()
  unnest(cols = c(survey_data)) %>%
  mutate(md06quin = ifelse(year == "2011", as.character(NA), md06quin),
         md09quin = ifelse(year == "2009-2010", as.character(NA), md09quin),
         md12quin = ifelse(year %in% c("2017", "2018"), as.character(NA), md12quin)) %>%
  mutate(simd5 = coalesce(md05quin, md06quin, md09quin, md12quin, md16quin, md20quin)) %>%
  mutate(simd5 = case_when(simd5 %in% c("1 - 20% most deprived", "Most deprived 20% data zones", "most deprived 20% data zones") ~ "1",
                           simd5 %in% c("5 - 20% least deprived", "Least deprived 20% data zones", "least deprived 20% data zones") ~ "5",
                           TRUE ~ simd5)) %>%
  select(year, uniqidnew, simd5) %>%
  filter(!is.na(uniqidnew)) # halves the number of rows... 

# save the file
saveRDS(uniqidnew_lut, paste0(derived_data, "uniqidnew_lut_pa.rds"))

######################################################################################################
# Remainder of processing not required now that SHoS team are providing the indicator data for us:
######################################################################################################

# # 6. Process the survey data to produce the indicator(s)
# # =================================================================================================================
# 
# # First: make sure there's only one of each grouping variable (geog/SIMD) for each survey file and that these are coded in a standard way

# cross tabulate years and variables, to see what's available when
shs_years_vars <- extracted_survey_data_shs %>%
  transmute(year,
            var_label = map(survey_data, names)) %>%
  unnest(var_label) %>%
  arrange(var_label) %>%
  mutate(value=1) %>%
  pivot_wider(names_from=var_label, values_from = value)

# # Geography codes: 
# 
# # Geographies are a mess in these data (see the possible codings printed out above).
# # There should be 32 codes for LA/council, and 14 for health boards, but in reality:
# 
# # council: 123 unique, mix of names, numbers and letters. Massive jumble. 
# # la = 32 unique, letters and numbers (1 to Z)
# # la_code = 32 unique (correct), all S120000xx codes, from S12000005 to S12000046 (some numbers not used) 
# 
# # hlth06 = 29 unique, but all text, so could be standardised
# # hlth14 = 29 unique, mix of S08 codes and numbers, and numbers don't correspond to the codes. 
# # hlthbd2014 = 16 unique S08 codes, from S08000015 to S08000030
# # hlth19 = 14 unique numbers, 2 to 17
# # hlthbd2019 = 14 unique S080000xx codes.

# # Most straightforward approach to consolidating and standardising codes and names: (I tried a lot)
la_code_to_council_code <- extracted_survey_data_shs %>%
  filter(year=="2016") %>%
  select(survey_data) %>%
  unnest(cols = c(survey_data)) %>%
  group_by(la_code, council) %>%
  summarise() %>%
  ungroup()
# 32 obs, so correct.
# council =  1 to Z here,
# la_code = S12000005 to S12000046. Corresponds to CA2011 codes (found this in the datazone lookup here:
dz2011_lut <- read_csv("/conf/linkage/output/lookups/Unicode/Geography/DataZone2011/Datazone2011lookup.csv")
#arrow::write_parquet(dz2011_lut, paste0(derived_data, "dz2011_lut.parquet"))
# read in from here if don't have access to the stats box lookups:
#dz2011_lut <- arrow::read_parquet(paste0(derived_data, "dz2011_lut.parquet"))

# # make a LUT for council and HB names, based on 2011 CA codes (S12000005 to S12000046)
ca2011_la_name_hb2019name <- dz2011_lut %>%
  group_by(LA_Name, CA2011, hb2019name) %>%
  summarise() %>%
  ungroup() %>%
  rename(la_code = CA2011, # S12000005 to S12000046
         la = LA_Name,
         hb = hb2019name)

# # combine:
la_hb_lut <- ca2011_la_name_hb2019name %>%
  merge(y = la_code_to_council_code, by="la_code") %>%
  select(-la_code)

# # Processing of these microdata before calculating indicator estimates:
# # Produce a flat file by unnesting the list column
# # Consolidate and standardise the relevant vars
# # Apply the variable codings
# # Add in SHS design effects
# 
# # design effects from Scottish Household Survey team
shs_design_effects <- read.xlsx("/conf/MHI_Data/big/big_mhi_data/unzipped/shs/SHoS design effects from SG.xlsx",
                                sheet = "Design factors",
                                colNames = TRUE) %>%
  filter(!(Year %in% c("2021 v3s model", "2020 (televid v3 model)"))) %>% # these are for the housing data (not used here)
  mutate(Year = case_when(Year == "1999/2000" ~ "19992000",
                          Year == "2001/2002" ~ "0102",
                          Year == "2003/2004" ~ "20032004",
                          Year == "2005/2006" ~ "0506",
                          Year == "2007/2008" ~ "0708",
                          Year == "2009/2010" ~ "2009-2010",
                          Year == "2021 v2 model" ~ "2021",
                          Year == "2020 (televid v2 model)" ~ "2020",
                          TRUE ~ Year))


shs_data <- extracted_survey_data_shs %>%
  mutate(survey_data = map(survey_data, ~.x %>%
                             mutate(across(.cols = everything(), as.character)))) %>% # to deal with some incompatible formats that mucked up the unnest()
  unnest(cols = c(survey_data)) %>%
  mutate(sex = coalesce(randsex, randgender)) %>%
  mutate(across(c(ends_with("wt")), as.numeric)) %>%
  mutate(md06quin = ifelse(year == "2011", as.character(NA), md06quin),
         md09quin = ifelse(year == "2009-2010", as.character(NA), md09quin),
         md12quin = ifelse(year %in% c("2017", "2018"), as.character(NA), md12quin)) %>%
  mutate(simd5 = coalesce(md05quin, md06quin, md09quin, md12quin, md16quin, md20quin)) %>%
  mutate(council = ifelse(!is.na(la), la, council)) %>%
  select(-la) %>%
  merge(y = la_hb_lut, by = "council") %>%
  mutate(sex = case_when(sex %in% c("female", "Female",  "Woman/Girl") ~ "Female",
                         sex %in% c("male", "Male", "Man/Boy") ~ "Male",
                         is.na(sex) ~ "Total")) %>%
  mutate(simd5 = case_when(simd5 %in% c("1 - 20% most deprived", "Most deprived 20% data zones", "most deprived 20% data zones") ~ "1",
                           simd5 %in% c("5 - 20% least deprived", "Least deprived 20% data zones", "least deprived 20% data zones") ~ "5",
                           TRUE ~ simd5)) %>%
  mutate(randage = as.numeric(substr(randage, 1, 2)), #removing plus sign from 86+
         age_grp = case_when(randage < 65 ~ "16-64", #recoding into 16-64 and 65+ due to different guidelines. 
                             randage >= 65 ~ "65+", #Consider revisiting later and adding more granular groups
                             TRUE ~ as.character(randage))) %>% 
  mutate(outdoor = recode(outdoor, !!!lookup_outdoor)) %>%
  mutate(sprt3aa = recode(sprt3aa, !!!lookup_sprt3aa)) %>%
  mutate(serv3a = recode(serv3a, !!!lookup_serv3a)) %>%
  mutate(serv3e = recode(serv3e, !!!lookup_serv3e)) %>%
  mutate(anysportnowalk = recode(anysportnowalk, !!!lookup_anysportnowalk)) %>%
  mutate(rg5a = recode(rg5a, !!!lookup_rg5a)) %>%
  
  select(-contains(c("hlth", "rand", "pc15", "dec", "file", "quin", "cred")), -la_code, -md04quin, -council) %>% #drop if not needed
  merge(y = shs_design_effects, by.x="year", by.y="Year", all.x=TRUE) |> 
  filter(year >= 2012) #none of my variables have data from before 2012 so getting rid of unneeded data
#Some age rows were already NAs so during case_when refactoring cause NAs. 


# # save a uniqidnew lookup for use in SHCS analysis
uniqidnew_lut <- shs_data %>%
  select(year, uniqidnew, #la_wt, ind_wt,
         simd5#, la, hb, Design.Factor
  ) %>%
  filter(!is.na(uniqidnew)) # halves the number of rows...

# # save the file
saveRDS(uniqidnew_lut, paste0(derived_data, "uniqidnew_lut_pa.rds"))
# 
# # data checks
table(shs_data$sex, useNA = "always") # Female/Male/Total
table(shs_data$age_grp, useNA = "always") # 16-86+, 7442 NAs. Assume some people refused to say
table(shs_data$simd5, useNA = "always") # 5 classes, plus a small number of NA
table(shs_data$hb, useNA = "always") # standard names, no NAs
table(shs_data$la, useNA = "always") # standard names, no NAs
table(shs_data$outdoor, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$serv3a, useNA = "always")# just yes, no and NA, so coding has worked
table(shs_data$serv3e, useNA = "always")# just yes, no and NA, so coding has worked
table(shs_data$sprt3aa, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$anysportnowalk, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$rg5a, useNA = "always") # just yes, no and NA, so coding has worked

# # repeat the data with sex=="Total"
shs_data <- shs_data %>%
  filter(sex!="Total") #remove those that were total in the first place

# # make long by geographical scale, to make aggregating and analysing easier:
shs_data2 <- shs_data %>%
  mutate(hb = gsub(" and ", " & ", hb), # get areanames right for merging into lut
         hb = paste0 ("NHS ", hb)) %>%
  mutate(la = gsub(" and ", " & ", la)) %>%
  mutate(new_Scotland = "Scotland") %>%
  pivot_longer(cols = c("sex", "rg5a", "simd5", "age_grp"), names_to = "split_name", values_to = "split_value") |> #pivoting the 3x splits longer
  pivot_longer(cols = c("la", "hb", "new_Scotland"), names_to = "spatial.scale", values_to = "spatial.unit") #pivoting the areas longer

#Add on sex totals
sex_totals <- shs_data2 |> 
  filter(split_name == "sex") |> 
  mutate(split_value = "Total")

shs_data3 <- bind_rows(shs_data2, sex_totals)

lti_totals <- shs_data3 |> 
  filter(split_name == "rg5a") |> 
  mutate(split_value = "Total")

shs_data4 <- bind_rows(shs_data3, lti_totals)

simd_totals <- shs_data4 |> 
  filter(split_name == "simd5") |> 
  mutate(split_value = "Total") 

shs_data5 <- bind_rows(shs_data4, simd_totals)

age_totals <- shs_data5 |> 
  filter(split_name == "age_grp") |> 
  mutate(split_value = "All ages")

shs_data6 <- bind_rows(shs_data5, age_totals)

# # Function to aggregate the data for a single variable, with weightings and complex survey design effects applied
shs_percent_analysis <- function (df, var, wt) {
  
  df2 <- df %>%
    rename(svy_var = var,
           svy_wt = wt) %>% # makes later calculations easier if starting variable and weight have standard name
    filter(!is.na(svy_wt)) %>% #keep only rows with a valid weight
    filter(svy_var!="NA") %>% #keep only rows where the response was not NA
    filter(!is.na(svy_var)) %>%
    group_by(year, split_name, split_value, spatial.unit, spatial.scale, Design.Factor) %>%
    summarise(yes_wted = sum(svy_wt[svy_var=="yes"]),
              no_wted = sum(svy_wt[svy_var=="no"]),
              yes_unwted = sum(svy_var=="yes"),
              no_unwted = sum(svy_var=="no"),
              denominator = yes_unwted + no_unwted,
              denominator_wted = yes_wted + no_wted) %>%
    ungroup() %>%
    mutate(proportion = yes_wted/denominator_wted,
           rate = 100 * proportion,
           shs_ci = 100 * Design.Factor * 1.96 * sqrt((proportion * (1 - proportion))/denominator_wted),
           lowci = rate - shs_ci, # produces some negative lower CIs, and upper CIs > 100, esp if denominator is small (too small for reliable estimates)
           upci = rate + shs_ci) %>%
    mutate(lowci = ifelse(lowci<0, 0, lowci), #constrain the CIs
           upci = ifelse(upci>100, 100, upci)) %>%
    select(year, starts_with("spatial"), numerator = yes_unwted, denominator, rate, lowci, upci, split_name, split_value) %>%
    mutate(indicator = var) |> 
    filter(!is.na(split_value)) |> #filter out rows where the split variable is na
    mutate(split_name = case_when(split_name == "rg5a" ~ "Long-term Illness (LTI)",
                                  split_name == "sex" ~ "Sex", 
                                  split_name == "simd5" ~ "Deprivation",
                                  split_name == "age_grp" ~ "Age Group"))
  
}


# # Run the function:
aggd_outdoor <- shs_percent_analysis(shs_data6, "outdoor", "ind_wt")
aggd_anysportnowalk <- shs_percent_analysis(shs_data6, "anysportnowalk", "ind_wt")
aggd_sprt3aa <- shs_percent_analysis(shs_data6, "sprt3aa", "ind_wt")
aggd_serv3a <- shs_percent_analysis(shs_data6, "serv3a", "ind_wt")
aggd_serv3e <- shs_percent_analysis(shs_data6, "serv3e", "ind_wt")

# # Get all the resulting dataframes and rbind them
shs_results <- mget(ls(pattern = "^aggd_"), .GlobalEnv) %>%
  do.call(rbind.data.frame, .) %>%
  mutate(trend_axis = year,
         year = as.numeric(substr(trend_axis, 1, 4)),
         def_period = paste0("Survey year (", trend_axis, ")")) |> 
  rename(areaname = spatial.unit) |> 
  mutate(areaname = str_replace(areaname, "&", "and")) #replace ampersands w/ "and"


write.csv(shs_results, "/PHI_conf/ScotPHO/Profiles/Data/Received Data/Physical Activity/Scottish Household Survey/SHoS_PA.csv", row.names = F)


table(shs_results$split_name, shs_results$split_value, useNA="always") # confirms this has worked
table(shs_results$areaname, useNA="always") # confirms this has worked
table(shs_results$spatial.scale, useNA="always") # confirms this has worked


# ##########################################################
# ### 3. Prepare final files -----
# ##########################################################
# 
# # Eventually we'll use the analysis functions:
# 
# # # main dataset analysis functions ----
# # analyze_first(filename = "smoking_during_preg", geography = "datazone11", measure = "percent", 
# #               yearstart = 2020, yearend = 2023, time_agg = 3)
# # 
# # analyze_second(filename = "smoking_during_preg", measure = "percent", time_agg = 3, 
# #                ind_id = 30058, year_type = "calendar")
# # 
# # # deprivation analysis function ----
# # analyze_deprivation(filename="smoking_during_preg_depr", measure="percent", time_agg=3, 
# #                     yearstart= 2020, yearend=2023, year_type = "calendar", ind_id = 30058)
# 
# # But for now:
# 
# # Function to prepare final files: main_data and popgroup
# prepare_final_files <- function(ind){
#   
#   # 1 - main data (ie data behind summary/trend/rank tab)
#   
#   main_data <- jobsec %>% 
#     filter(indicator == ind,
#            split_value == "Total",
#            sex == "Total") %>% 
#     select(code, ind_id, year, 
#            numerator, rate, upci, lowci, 
#            def_period, trend_axis) %>%
#     unique() 
#   
#   # Save
#   # Including both rds and csv file for now
#   write_rds(main_data, file = paste0(data_folder, "Data to be checked/", ind, "_shiny.rds"))
#   write_csv(main_data, file = paste0(data_folder, "Data to be checked/", ind, "_shiny.csv"))
#   
#   # 2 - population groups data (ie data behind population groups tab)
#   
#   pop_grp_data <- jobsec %>% 
#     filter(indicator == ind,
#            split_value == "Total") %>% # split_value here refers to SIMD quintile
#     select(-split_value) %>% #... so drop and replace with sex
#     mutate(split_name = "Sex") %>%
#     rename(split_value = sex) %>%
#     select(code, ind_id, year, numerator, rate, upci, 
#            lowci, def_period, trend_axis, split_name, split_value) 
#   
#   # Save
#   # Including both rds and csv file for now
#   write_rds(pop_grp_data, file = paste0(data_folder, "Data to be checked/", ind, "_shiny_popgrp.rds"))
#   write_csv(pop_grp_data, file = paste0(data_folder, "Data to be checked/", ind, "_shiny_popgrp.csv"))
#   
#   
#   # 3 - SIMD data (ie data behind deprivation tab)
#   
#   # Process SIMD data
#   # NATIONAL LEVEL ONLY (BY SEX)
#   simd_data <- jobsec %>% 
#     filter(indicator == ind) %>% 
#     unique() %>%
#     mutate(quint_type = "sc_quin") %>%
#     select(code, ind_id, year, numerator, rate, upci, 
#            lowci, def_period, trend_axis, quintile, quint_type, sex) 
#   
#   # Save intermediate SIMD file
#   write_rds(simd_data, file = paste0(data_folder, "Prepared Data/", ind, "_shiny_depr_raw.rds"))
#   write.csv(simd_data, file = paste0(data_folder, "Prepared Data/", ind, "_shiny_depr_raw.csv"), row.names = FALSE)
#   
#   #get ind_id argument for the analysis function 
#   ind_id <- unique(simd_data$ind_id)
#   
#   # Run the deprivation analysis (saves the processed file to 'Data to be checked')
#   analyze_deprivation_aggregated(filename = paste0(ind, "_shiny_depr"), 
#                                  pop = "depr_pop_16+", # 16+ by sex (and age). The function aggregates over the age groups.
#                                  ind_id, 
#                                  ind
#   )
#   
#   # Make data created available outside of function so it can be visually inspected if required
#   main_data_result <<- main_data
#   pop_grp_data_result <<- pop_grp_data
#   simd_data_result <<- simd_data
#   
#   
# }
# 
# 
# # Run function to create final files
# prepare_final_files(ind = "job_insecurity")   
# 
# 
# # # Run QA reports 
# # These currently use local copies of the .Rmd files.
# # These can be deleted once PR #116 is merged into scotpho-indicator-production repo
# 
# # # main data: 
# run_qa(filename = "job_insecurity")    
# 
# # ineq data: 
# # get the run_ineq_qa to use full Rmd filepath so can be run from here
# run_ineq_qa(filename = "job_insecurity")
# 
# ## END
# 
# 
# 
# 
# 
# # Save the indicator data
# 
# #arrow::write_parquet(shs_results, paste0(derived_data, "shs_results.parquet"))
# shs_results <- arrow::read_parquet(paste0(derived_data, "shs_results.parquet"))
# 
# 
# # 7. What are the smallest numbers? Any suppression issues?
# # =================================================================================================================
# 
# # Unweighted bases
# # =================================================================================================================
# # SHS dashboard considerations on sample size:
# # If base on which percentages are calculated is less than 50 = Such data are judged to be insufficiently reliable for publication. 
# # Estimates with base numbers close to 50 should also be treated with caution.
# # https://scotland.shinyapps.io/sg-scottish-household-survey-data-explorer/
# # Check where bases <50
# # 
# shs_unweighted_bases <- shs_results %>%
#   filter(statistic %in% c("Nuw"))
# 
# # National by sex
# shs_unweighted_bases %>%
#   filter(sex != "Total", spatial.scale == "Scotland") %>%
#   ggplot(aes(year, value, group = sex, colour = sex, shape = sex)) +
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y")
# # none <50
# 
# # SIMD by sex (male)
# shs_unweighted_bases %>%
#   filter(sex == "Male", spatial.scale == "SIMD") %>%
#   ggplot(aes(year, value, group = spatial.unit, colour = spatial.unit, shape = spatial.unit)) +
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y")
# # none <50
# 
# # HBs
# shs_unweighted_bases %>%
#   filter(sex == "Total", spatial.scale == "HB") %>%
#   ggplot(aes(year, value, group = spatial.unit, colour = spatial.unit)) +
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y")
# # none <50
# 
# # HBs by sex (male)
# shs_unweighted_bases %>%
#   filter(sex == "Male", spatial.scale == "HB") %>%
#   ggplot(aes(year, value, group = spatial.unit, colour = spatial.unit)) +
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y")
# # some HB in 2005 and 2011 have unweighted bases <50 (>=39) for the volunteer variable, males only.
# 
# # LAs by sex (male)
# shs_unweighted_bases %>%
#   filter(sex == "Male", spatial.scale == "LA") %>%
#   ggplot(aes(year, value, group = spatial.unit, colour = spatial.unit)) +
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y")
# # some LA in 2005 and 2011 have unweighted bases <50 (>=35) for the volunteer variable, males only.
# 
# 
# # 8. Data amendments following data checks
# # =================================================================================================================
# 
# # The data checks conducted in the script ukds_shs_checks confirmed very close agreement between the UKDS_derived indicators and data downloaded from the SHS dashboard.
# # Data could be compared for 7 indicators: "commbel", "greenuse13", "hk2", "rb1", "volunteer", "harass_new", and "discrim_new" 
# # Headline results of this QA:  
# # 89% of the unweighted bases are identical (Differences seem to be largely due to rounding for small bases)
# # 76% of the percentages are identical (and 90% are within 1%).
# # Investigated some of the largest relative differences in the estimates: 
# # again, looks like differences in the raw data (number of respondents) being processed for the SHS dashboard and that available to us through the UKDS. 
# # SHS responded to an email* on 22 March 2024 saying that the UKDS data will have fewer respondents in them because of disclosure control.
# # (*Prompted by discrim_new and harass_new indicators having 40-50 fewer respondents in the UKDS data)
# 
# # The close agreement confirms the accuracy of our data processing, but some very slight differences remain.
# # We decided against replacing the UKDS data with SHS dashboard data, where available, as the dashboard only provided the % estimate and the unweighted base.
# # A note will be needed to reflect the differences between the SHS dashboard and our calculations. 
# 
# # The unweighted base checks above also showed that Nuw for some breakdowns (HB/LA by sex) were below the SHS threshold of 50.
# # For this reason we opted to remove HB/LA breakdowns by sex
# 
# 
# # Conduct the suppression (remove HB/LA breakdowns by sex)
# shs_results2 <- shs_results %>%
#   # remove the breakdowns with sample sizes that are too small:
#   filter(!(spatial.scale %in% c("HB", "LA") & !(sex=="Total")))  %>%
#   # standardise year labels to match other data (e.g., 1999 to 2000 will become 1999-2000)
#   mutate(year_label = case_when(nchar(year_label)>4 ~ gsub(" to ", "-", year_label),
#                                 TRUE ~ year_label),
#          year = case_when(nchar(year_label)>4 ~ year+0.5,
#                                 TRUE ~ year))
# 
# # Save the indicator data
# 
# #arrow::write_parquet(shs_results2, paste0(derived_data, "shs_results2.parquet"))
# shs_results2 <- arrow::read_parquet(paste0(derived_data, "shs_results2.parquet"))
# 
# 
# # 9. Data availability
# # =================================================================================================================
# 
# shs_percents <- shs_results2 %>% 
#   filter(statistic=="percent") 
# 
# ftable(shs_percents$var_label, shs_percents$spatial.scale, shs_percents$sex , shs_percents$year_label)
# # check that relevant year/sex combos have single Scotland estimates, 5 SIMD estimates, 32 LA estimates, and 14 HB estimates
# 
# 
# # 10. Plot the indicator(s)
# # =================================================================================================================
# # Let's now see what the series and CIs look like:
# 
# # total
# shs_results2 %>% 
#   pivot_wider(names_from = statistic, values_from = value) %>%
#   filter(sex == "Total", spatial.scale == "Scotland") %>% 
#   ggplot(aes(year, percent, group = sex, colour = sex, shape = sex)) + 
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y") +
#   geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 
# 
# # sex
# shs_results2 %>% 
#   pivot_wider(names_from = statistic, values_from = value) %>%
#   filter(sex != "Total", spatial.scale == "Scotland") %>% 
#   ggplot(aes(year, percent, group = sex, colour = sex, shape = sex)) + 
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y") +
#   geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 
# 
# # simd
# shs_results2 %>% 
#   pivot_wider(names_from = statistic, values_from = value) %>%
#   filter(sex == "Total", spatial.scale == "SIMD") %>% 
#   ggplot(aes(year, percent, group = spatial.unit, colour = spatial.unit, shape = spatial.unit)) + 
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y") +
#   geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 
# 
# # hb, total pop
# shs_results2 %>% 
#   pivot_wider(names_from = statistic, values_from = value) %>%
#   filter(sex == "Total", spatial.scale == "HB") %>% 
#   ggplot(aes(year, percent, group = spatial.unit, colour = spatial.unit, shape = spatial.unit)) + 
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y") 
# #+
# #  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 
# 
# # la, total pop
# shs_results2 %>% 
#   pivot_wider(names_from = statistic, values_from = value) %>%
#   filter(sex == "Total", spatial.scale == "LA") %>% 
#   ggplot(aes(year, percent, group = spatial.unit, colour = spatial.unit, shape = spatial.unit)) + 
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y") 
# #+
# #  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 
# 
# 
# 
# ## END   
###################################

# 5. How should the responses be coded?
# =================================================================================================================
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?

# Create lookups to code the variables into the dichotomy needed for the indicators:
lookup_anysportnowalk <- list(
  "Yes" = "yes",
  "No" = "no"
)

lookup_outdoor <- list(
  "More than once per day" = "yes",
  "Every day" = "yes",
  "Several times a week" = "yes",
  "Once a week" = "yes",
  "Once or twice a month" = "no",
  "Once every 2-3 months" = "no",
  "Once or twice a year" = "no",
  "Not at all" = "no"
)

lookup_serv3a <- list(
  "very satisfied" = "yes",
  "Very satisfied" = "yes",
  "fairly satisfied" = "yes",
  "Fairly satisfied" = "yes",
  "neither satisfied nor dissatisfied" = "no",
  "Neither satisfied nor dissatisfied" = "no",
  "no opinion" = "no",
  "No opinion" = "no",
  "fairly dissatisfied" = "no",
  "Fairly dissatisfied" = "no",
  "very dissatisfied" = "no",
  "Very dissatisfied" = "no"
)

lookup_serv3e <- list(
  "very satisfied" = "yes",
  "Very satisfied" = "yes",
  "fairly satisfied" = "yes",
  "Fairly satisfied" = "yes",
  "neither satisfied nor dissatisfied" = "no",
  "Neither satisfied nor dissatisfied" = "no",
  "no opinion" = "no",
  "No opinion" = "no",
  "fairly dissatisfied" = "no",
  "Fairly dissatisfied" = "no",
  "very dissatisfied" = "no",
  "Very dissatisfied" = "no")

lookup_sprt3aa <- list(
  "yes" = "yes",
  "Yes" = "yes",
  "A - Walking (at least 30 minutes for recreational purposes)" = "yes",
  "Walking" = "yes",
  "no" = "no",
  "No" = "no",
  "NOT A - Walking (at least 30 minutes for recreational purposes)" = "no",
  "NOT Walking" = "no",
  "refused" = "no"
)

lookup_rg5a <- list(
  "Yes" = "yes",
  "No" = "no",
  "Don't know" = "no",
  "Refusal" = "no",
  "Refused" = "no",
  "Don't know" = "no"
)

# Create a LUT for a person's uniqid to SIMD for the SHCS processing
# =================================================================================================================

# SIMD codes

# make a uniqidnew to SIMD quintile lookup, for use in SHCS processing:
uniqidnew_lut <- extracted_survey_data_shs %>%
  mutate(survey_data = map(survey_data, ~.x %>%
                             mutate(across(.cols = everything(), as.character)))) %>% # to deal with some incompatible formats that mucked up the unnest()
  unnest(cols = c(survey_data)) %>%
  mutate(md06quin = ifelse(year == "2011", as.character(NA), md06quin),
         md09quin = ifelse(year == "2009-2010", as.character(NA), md09quin),
         md12quin = ifelse(year %in% c("2017", "2018"), as.character(NA), md12quin)) %>%
  mutate(simd5 = coalesce(md05quin, md06quin, md09quin, md12quin, md16quin, md20quin)) %>%
  mutate(simd5 = case_when(simd5 %in% c("1 - 20% most deprived", "Most deprived 20% data zones", "most deprived 20% data zones") ~ "1",
                           simd5 %in% c("5 - 20% least deprived", "Least deprived 20% data zones", "least deprived 20% data zones") ~ "5",
                           TRUE ~ simd5)) %>%
  select(year, uniqidnew, simd5) %>%
  filter(!is.na(uniqidnew)) # halves the number of rows... 

# save the file
saveRDS(uniqidnew_lut, paste0(derived_data, "uniqidnew_lut_pa.rds"))

######################################################################################################
# Remainder of processing not required now that SHoS team are providing the indicator data for us:
######################################################################################################

# # 6. Process the survey data to produce the indicator(s)
# # =================================================================================================================
# 
# # First: make sure there's only one of each grouping variable (geog/SIMD) for each survey file and that these are coded in a standard way

# cross tabulate years and variables, to see what's available when
shs_years_vars <- extracted_survey_data_shs %>%
  transmute(year,
            var_label = map(survey_data, names)) %>%
  unnest(var_label) %>%
  arrange(var_label) %>%
  mutate(value=1) %>%
  pivot_wider(names_from=var_label, values_from = value)

# # Geography codes: 
# 
# # Geographies are a mess in these data (see the possible codings printed out above).
# # There should be 32 codes for LA/council, and 14 for health boards, but in reality:
# 
# # council: 123 unique, mix of names, numbers and letters. Massive jumble. 
# # la = 32 unique, letters and numbers (1 to Z)
# # la_code = 32 unique (correct), all S120000xx codes, from S12000005 to S12000046 (some numbers not used) 
# 
# # hlth06 = 29 unique, but all text, so could be standardised
# # hlth14 = 29 unique, mix of S08 codes and numbers, and numbers don't correspond to the codes. 
# # hlthbd2014 = 16 unique S08 codes, from S08000015 to S08000030
# # hlth19 = 14 unique numbers, 2 to 17
# # hlthbd2019 = 14 unique S080000xx codes.

# # Most straightforward approach to consolidating and standardising codes and names: (I tried a lot)
la_code_to_council_code <- extracted_survey_data_shs %>%
  filter(year=="2016") %>%
  select(survey_data) %>%
  unnest(cols = c(survey_data)) %>%
  group_by(la_code, council) %>%
  summarise() %>%
  ungroup()
# 32 obs, so correct.
# council =  1 to Z here,
# la_code = S12000005 to S12000046. Corresponds to CA2011 codes (found this in the datazone lookup here:
dz2011_lut <- read_csv("/conf/linkage/output/lookups/Unicode/Geography/DataZone2011/Datazone2011lookup.csv")
#arrow::write_parquet(dz2011_lut, paste0(derived_data, "dz2011_lut.parquet"))
# read in from here if don't have access to the stats box lookups:
#dz2011_lut <- arrow::read_parquet(paste0(derived_data, "dz2011_lut.parquet"))

# # make a LUT for council and HB names, based on 2011 CA codes (S12000005 to S12000046)
ca2011_la_name_hb2019name <- dz2011_lut %>%
  group_by(LA_Name, CA2011, hb2019name) %>%
  summarise() %>%
  ungroup() %>%
  rename(la_code = CA2011, # S12000005 to S12000046
         la = LA_Name,
         hb = hb2019name)

# # combine:
la_hb_lut <- ca2011_la_name_hb2019name %>%
  merge(y = la_code_to_council_code, by="la_code") %>%
  select(-la_code)

# # Processing of these microdata before calculating indicator estimates:
# # Produce a flat file by unnesting the list column
# # Consolidate and standardise the relevant vars
# # Apply the variable codings
# # Add in SHS design effects
# 
# # design effects from Scottish Household Survey team
shs_design_effects <- read.xlsx("/conf/MHI_Data/big/big_mhi_data/unzipped/shs/SHoS design effects from SG.xlsx",
                                sheet = "Design factors",
                                colNames = TRUE) %>%
  filter(!(Year %in% c("2021 v3s model", "2020 (televid v3 model)"))) %>% # these are for the housing data (not used here)
  mutate(Year = case_when(Year == "1999/2000" ~ "19992000",
                          Year == "2001/2002" ~ "0102",
                          Year == "2003/2004" ~ "20032004",
                          Year == "2005/2006" ~ "0506",
                          Year == "2007/2008" ~ "0708",
                          Year == "2009/2010" ~ "2009-2010",
                          Year == "2021 v2 model" ~ "2021",
                          Year == "2020 (televid v2 model)" ~ "2020",
                          TRUE ~ Year))


shs_data <- extracted_survey_data_shs %>%
  mutate(survey_data = map(survey_data, ~.x %>%
                             mutate(across(.cols = everything(), as.character)))) %>% # to deal with some incompatible formats that mucked up the unnest()
  unnest(cols = c(survey_data)) %>%
  mutate(sex = coalesce(randsex, randgender)) %>%
  mutate(across(c(ends_with("wt")), as.numeric)) %>%
  mutate(md06quin = ifelse(year == "2011", as.character(NA), md06quin),
         md09quin = ifelse(year == "2009-2010", as.character(NA), md09quin),
         md12quin = ifelse(year %in% c("2017", "2018"), as.character(NA), md12quin)) %>%
  mutate(simd5 = coalesce(md05quin, md06quin, md09quin, md12quin, md16quin, md20quin)) %>%
  mutate(council = ifelse(!is.na(la), la, council)) %>%
  select(-la) %>%
  merge(y = la_hb_lut, by = "council") %>%
  mutate(sex = case_when(sex %in% c("female", "Female",  "Woman/Girl") ~ "Female",
                         sex %in% c("male", "Male", "Man/Boy") ~ "Male",
                         is.na(sex) ~ "Total")) %>%
  mutate(simd5 = case_when(simd5 %in% c("1 - 20% most deprived", "Most deprived 20% data zones", "most deprived 20% data zones") ~ "1",
                           simd5 %in% c("5 - 20% least deprived", "Least deprived 20% data zones", "least deprived 20% data zones") ~ "5",
                           TRUE ~ simd5)) %>%
  # now can recode the variables
  mutate(outdoor = recode(outdoor, !!!lookup_outdoor)) %>%
  mutate(sprt3aa = recode(sprt3aa, !!!lookup_sprt3aa)) %>%
  mutate(serv3a = recode(serv3a, !!!lookup_serv3a)) %>%
  mutate(serv3e = recode(serv3e, !!!lookup_serv3e)) %>%
  mutate(anysportnowalk = recode(anysportnowalk, !!!lookup_anysportnowalk)) %>%
  mutate(rg5a = recode(rg5a, !!!lookup_rg5a)) %>%
  
  select(-contains(c("hlth", "rand", "pc15", "dec", "file", "quin", "cred")), -la_code, -md04quin, -council) %>% #drop if not needed
  merge(y = shs_design_effects, by.x="year", by.y="Year", all.x=TRUE) |> 
  filter(year >= 2012) #none of my variables have data from before 2012 so getting rid of unneeded data

# # save a uniqidnew lookup for use in SHCS analysis
uniqidnew_lut <- shs_data %>%
  select(year, uniqidnew, #la_wt, ind_wt,
         simd5#, la, hb, Design.Factor
  ) %>%
  filter(!is.na(uniqidnew)) # halves the number of rows...

# # save the file
saveRDS(uniqidnew_lut, paste0(derived_data, "uniqidnew_lut_pa.rds"))
# 
# # data checks
table(shs_data$sex, useNA = "always") # Female/Male/Total
table(shs_data$simd5, useNA = "always") # 5 classes, plus a small number of NA
table(shs_data$hb, useNA = "always") # standard names, no NAs
table(shs_data$la, useNA = "always") # standard names, no NAs
table(shs_data$outdoor, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$serv3a, useNA = "always")# just yes, no and NA, so coding has worked
table(shs_data$serv3e, useNA = "always")# just yes, no and NA, so coding has worked
table(shs_data$sprt3aa, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$anysportnowalk, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$rg5a, useNA = "always") # just yes, no and NA, so coding has worked

# # repeat the data with sex=="Total"
shs_data <- shs_data %>%
  filter(sex!="Total") #remove those that were total in the first place

# # make long by geographical scale, to make aggregating and analysing easier:
shs_data2 <- shs_data %>%
  mutate(hb = gsub(" and ", " & ", hb), # get areanames right for merging into lut
         hb = paste0 ("NHS ", hb)) %>%
  mutate(la = gsub(" and ", " & ", la)) %>%
  mutate(new_Scotland = "Scotland") %>%
  pivot_longer(cols = c("sex", "rg5a", "simd5"), names_to = "split_name", values_to = "split_value") |> #pivoting the 3x splits longer
  pivot_longer(cols = c("la", "hb", "new_Scotland"), names_to = "spatial.scale", values_to = "spatial.unit") #pivoting the areas longer

#Add on sex totals
sex_totals <- shs_data2 |> 
  filter(split_name == "sex") |> 
  mutate(split_value = "Total")

shs_data3 <- bind_rows(shs_data2, sex_totals)

lti_totals <- shs_data3 |> 
  filter(split_name == "rg5a") |> 
  mutate(split_value = "Total")

shs_data4 <- bind_rows(shs_data3, lti_totals)

simd_totals <- shs_data4 |> 
  filter(split_name == "simd5") |> 
  mutate(split_value = "Total") 

shs_data5 <- bind_rows(shs_data4, simd_totals)

# # Function to aggregate the data for a single variable, with weightings and complex survey design effects applied
shs_percent_analysis <- function (df, var, wt) {
  
  df2 <- df %>%
    rename(svy_var = var,
           svy_wt = wt) %>% # makes later calculations easier if starting variable and weight have standard name
    filter(!is.na(svy_wt)) %>% #keep only rows with a valid weight
    filter(svy_var!="NA") %>% #keep only rows where the response was not NA
    filter(!is.na(svy_var)) %>%
    group_by(year, split_name, split_value, spatial.unit, spatial.scale, Design.Factor) %>%
    summarise(yes_wted = sum(svy_wt[svy_var=="yes"]),
              no_wted = sum(svy_wt[svy_var=="no"]),
              yes_unwted = sum(svy_var=="yes"),
              no_unwted = sum(svy_var=="no"),
              denominator = yes_unwted + no_unwted,
              denominator_wted = yes_wted + no_wted) %>%
    ungroup() %>%
    mutate(proportion = yes_wted/denominator_wted,
           rate = 100 * proportion,
           shs_ci = 100 * Design.Factor * 1.96 * sqrt((proportion * (1 - proportion))/denominator_wted),
           lowci = rate - shs_ci, # produces some negative lower CIs, and upper CIs > 100, esp if denominator is small (too small for reliable estimates)
           upci = rate + shs_ci) %>%
    mutate(lowci = ifelse(lowci<0, 0, lowci), #constrain the CIs
           upci = ifelse(upci>100, 100, upci)) %>%
    select(year, starts_with("spatial"), numerator = yes_unwted, denominator, rate, lowci, upci, split_name, split_value) %>%
    mutate(indicator = var) |> 
    filter(!is.na(split_value)) |> #filter out rows where the split variable is na
    mutate(split_name = case_when(split_name == "rg5a" ~ "Long-term Illness (LTI)",
                                  split_name == "sex" ~ "Sex", 
                                  split_name == "simd5" ~ "Deprivation"))
  
}


# # Run the function:
aggd_outdoor <- shs_percent_analysis(shs_data5, "outdoor", "ind_wt")
aggd_anysportnowalk <- shs_percent_analysis(shs_data5, "anysportnowalk", "ind_wt")
aggd_sprt3aa <- shs_percent_analysis(shs_data5, "sprt3aa", "ind_wt")
aggd_serv3a <- shs_percent_analysis(shs_data5, "serv3a", "ind_wt")
aggd_serv3e <- shs_percent_analysis(shs_data5, "serv3e", "ind_wt")

# # Get all the resulting dataframes and rbind them
shs_results <- mget(ls(pattern = "^aggd_"), .GlobalEnv) %>%
  do.call(rbind.data.frame, .) %>%
  mutate(trend_axis = year,
         year = as.numeric(substr(trend_axis, 1, 4)),
         def_period = paste0("Survey year (", trend_axis, ")")) |> 
  rename(areaname = spatial.unit) |> 
  mutate(areaname = str_replace(areaname, "&", "and")) #replace ampersands w/ "and"


write.csv(shs_results, "/PHI_conf/ScotPHO/Profiles/Data/Received Data/Physical Activity/Scottish Household Survey/SHoS_PA.csv", row.names = F)


table(shs_results$split_name, shs_results$split_value, useNA="always") # confirms this has worked
table(shs_results$spatial.unit, useNA="always") # confirms this has worked
table(shs_results$spatial.scale, useNA="always") # confirms this has worked

write.csv(shs_results, "/PHI_conf/ScotPHO/Profiles/Data/Received Data/Physical Activity/Scottish Household Survey/SHoS_PA.csv")


# ##########################################################
# ### 3. Prepare final files -----
# ##########################################################
# 
# # Eventually we'll use the analysis functions:
# 
# # # main dataset analysis functions ----
# # analyze_first(filename = "smoking_during_preg", geography = "datazone11", measure = "percent", 
# #               yearstart = 2020, yearend = 2023, time_agg = 3)
# # 
# # analyze_second(filename = "smoking_during_preg", measure = "percent", time_agg = 3, 
# #                ind_id = 30058, year_type = "calendar")
# # 
# # # deprivation analysis function ----
# # analyze_deprivation(filename="smoking_during_preg_depr", measure="percent", time_agg=3, 
# #                     yearstart= 2020, yearend=2023, year_type = "calendar", ind_id = 30058)
# 
# # But for now:
# 
# # Function to prepare final files: main_data and popgroup
# prepare_final_files <- function(ind){
#   
#   # 1 - main data (ie data behind summary/trend/rank tab)
#   
#   main_data <- jobsec %>% 
#     filter(indicator == ind,
#            split_value == "Total",
#            sex == "Total") %>% 
#     select(code, ind_id, year, 
#            numerator, rate, upci, lowci, 
#            def_period, trend_axis) %>%
#     unique() 
#   
#   # Save
#   # Including both rds and csv file for now
#   write_rds(main_data, file = paste0(data_folder, "Data to be checked/", ind, "_shiny.rds"))
#   write_csv(main_data, file = paste0(data_folder, "Data to be checked/", ind, "_shiny.csv"))
#   
#   # 2 - population groups data (ie data behind population groups tab)
#   
#   pop_grp_data <- jobsec %>% 
#     filter(indicator == ind,
#            split_value == "Total") %>% # split_value here refers to SIMD quintile
#     select(-split_value) %>% #... so drop and replace with sex
#     mutate(split_name = "Sex") %>%
#     rename(split_value = sex) %>%
#     select(code, ind_id, year, numerator, rate, upci, 
#            lowci, def_period, trend_axis, split_name, split_value) 
#   
#   # Save
#   # Including both rds and csv file for now
#   write_rds(pop_grp_data, file = paste0(data_folder, "Data to be checked/", ind, "_shiny_popgrp.rds"))
#   write_csv(pop_grp_data, file = paste0(data_folder, "Data to be checked/", ind, "_shiny_popgrp.csv"))
#   
#   
#   # 3 - SIMD data (ie data behind deprivation tab)
#   
#   # Process SIMD data
#   # NATIONAL LEVEL ONLY (BY SEX)
#   simd_data <- jobsec %>% 
#     filter(indicator == ind) %>% 
#     unique() %>%
#     mutate(quint_type = "sc_quin") %>%
#     select(code, ind_id, year, numerator, rate, upci, 
#            lowci, def_period, trend_axis, quintile, quint_type, sex) 
#   
#   # Save intermediate SIMD file
#   write_rds(simd_data, file = paste0(data_folder, "Prepared Data/", ind, "_shiny_depr_raw.rds"))
#   write.csv(simd_data, file = paste0(data_folder, "Prepared Data/", ind, "_shiny_depr_raw.csv"), row.names = FALSE)
#   
#   #get ind_id argument for the analysis function 
#   ind_id <- unique(simd_data$ind_id)
#   
#   # Run the deprivation analysis (saves the processed file to 'Data to be checked')
#   analyze_deprivation_aggregated(filename = paste0(ind, "_shiny_depr"), 
#                                  pop = "depr_pop_16+", # 16+ by sex (and age). The function aggregates over the age groups.
#                                  ind_id, 
#                                  ind
#   )
#   
#   # Make data created available outside of function so it can be visually inspected if required
#   main_data_result <<- main_data
#   pop_grp_data_result <<- pop_grp_data
#   simd_data_result <<- simd_data
#   
#   
# }
# 
# 
# # Run function to create final files
# prepare_final_files(ind = "job_insecurity")   
# 
# 
# # # Run QA reports 
# # These currently use local copies of the .Rmd files.
# # These can be deleted once PR #116 is merged into scotpho-indicator-production repo
# 
# # # main data: 
# run_qa(filename = "job_insecurity")    
# 
# # ineq data: 
# # get the run_ineq_qa to use full Rmd filepath so can be run from here
# run_ineq_qa(filename = "job_insecurity")
# 
# ## END
# 
# 
# 
# 
# 
# # Save the indicator data
# 
# #arrow::write_parquet(shs_results, paste0(derived_data, "shs_results.parquet"))
# shs_results <- arrow::read_parquet(paste0(derived_data, "shs_results.parquet"))
# 
# 
# # 7. What are the smallest numbers? Any suppression issues?
# # =================================================================================================================
# 
# # Unweighted bases
# # =================================================================================================================
# # SHS dashboard considerations on sample size:
# # If base on which percentages are calculated is less than 50 = Such data are judged to be insufficiently reliable for publication. 
# # Estimates with base numbers close to 50 should also be treated with caution.
# # https://scotland.shinyapps.io/sg-scottish-household-survey-data-explorer/
# # Check where bases <50
# # 
# shs_unweighted_bases <- shs_results %>%
#   filter(statistic %in% c("Nuw"))
# 
# # National by sex
# shs_unweighted_bases %>%
#   filter(sex != "Total", spatial.scale == "Scotland") %>%
#   ggplot(aes(year, value, group = sex, colour = sex, shape = sex)) +
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y")
# # none <50
# 
# # SIMD by sex (male)
# shs_unweighted_bases %>%
#   filter(sex == "Male", spatial.scale == "SIMD") %>%
#   ggplot(aes(year, value, group = spatial.unit, colour = spatial.unit, shape = spatial.unit)) +
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y")
# # none <50
# 
# # HBs
# shs_unweighted_bases %>%
#   filter(sex == "Total", spatial.scale == "HB") %>%
#   ggplot(aes(year, value, group = spatial.unit, colour = spatial.unit)) +
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y")
# # none <50
# 
# # HBs by sex (male)
# shs_unweighted_bases %>%
#   filter(sex == "Male", spatial.scale == "HB") %>%
#   ggplot(aes(year, value, group = spatial.unit, colour = spatial.unit)) +
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y")
# # some HB in 2005 and 2011 have unweighted bases <50 (>=39) for the volunteer variable, males only.
# 
# # LAs by sex (male)
# shs_unweighted_bases %>%
#   filter(sex == "Male", spatial.scale == "LA") %>%
#   ggplot(aes(year, value, group = spatial.unit, colour = spatial.unit)) +
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y")
# # some LA in 2005 and 2011 have unweighted bases <50 (>=35) for the volunteer variable, males only.
# 
# 
# # 8. Data amendments following data checks
# # =================================================================================================================
# 
# # The data checks conducted in the script ukds_shs_checks confirmed very close agreement between the UKDS_derived indicators and data downloaded from the SHS dashboard.
# # Data could be compared for 7 indicators: "commbel", "greenuse13", "hk2", "rb1", "volunteer", "harass_new", and "discrim_new" 
# # Headline results of this QA:  
# # 89% of the unweighted bases are identical (Differences seem to be largely due to rounding for small bases)
# # 76% of the percentages are identical (and 90% are within 1%).
# # Investigated some of the largest relative differences in the estimates: 
# # again, looks like differences in the raw data (number of respondents) being processed for the SHS dashboard and that available to us through the UKDS. 
# # SHS responded to an email* on 22 March 2024 saying that the UKDS data will have fewer respondents in them because of disclosure control.
# # (*Prompted by discrim_new and harass_new indicators having 40-50 fewer respondents in the UKDS data)
# 
# # The close agreement confirms the accuracy of our data processing, but some very slight differences remain.
# # We decided against replacing the UKDS data with SHS dashboard data, where available, as the dashboard only provided the % estimate and the unweighted base.
# # A note will be needed to reflect the differences between the SHS dashboard and our calculations. 
# 
# # The unweighted base checks above also showed that Nuw for some breakdowns (HB/LA by sex) were below the SHS threshold of 50.
# # For this reason we opted to remove HB/LA breakdowns by sex
# 
# 
# # Conduct the suppression (remove HB/LA breakdowns by sex)
# shs_results2 <- shs_results %>%
#   # remove the breakdowns with sample sizes that are too small:
#   filter(!(spatial.scale %in% c("HB", "LA") & !(sex=="Total")))  %>%
#   # standardise year labels to match other data (e.g., 1999 to 2000 will become 1999-2000)
#   mutate(year_label = case_when(nchar(year_label)>4 ~ gsub(" to ", "-", year_label),
#                                 TRUE ~ year_label),
#          year = case_when(nchar(year_label)>4 ~ year+0.5,
#                                 TRUE ~ year))
# 
# # Save the indicator data
# 
# #arrow::write_parquet(shs_results2, paste0(derived_data, "shs_results2.parquet"))
# shs_results2 <- arrow::read_parquet(paste0(derived_data, "shs_results2.parquet"))
# 
# 
# # 9. Data availability
# # =================================================================================================================
# 
# shs_percents <- shs_results2 %>% 
#   filter(statistic=="percent") 
# 
# ftable(shs_percents$var_label, shs_percents$spatial.scale, shs_percents$sex , shs_percents$year_label)
# # check that relevant year/sex combos have single Scotland estimates, 5 SIMD estimates, 32 LA estimates, and 14 HB estimates
# 
# 
# # 10. Plot the indicator(s)
# # =================================================================================================================
# # Let's now see what the series and CIs look like:
# 
# # total
# shs_results2 %>% 
#   pivot_wider(names_from = statistic, values_from = value) %>%
#   filter(sex == "Total", spatial.scale == "Scotland") %>% 
#   ggplot(aes(year, percent, group = sex, colour = sex, shape = sex)) + 
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y") +
#   geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 
# 
# # sex
# shs_results2 %>% 
#   pivot_wider(names_from = statistic, values_from = value) %>%
#   filter(sex != "Total", spatial.scale == "Scotland") %>% 
#   ggplot(aes(year, percent, group = sex, colour = sex, shape = sex)) + 
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y") +
#   geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 
# 
# # simd
# shs_results2 %>% 
#   pivot_wider(names_from = statistic, values_from = value) %>%
#   filter(sex == "Total", spatial.scale == "SIMD") %>% 
#   ggplot(aes(year, percent, group = spatial.unit, colour = spatial.unit, shape = spatial.unit)) + 
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y") +
#   geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 
# 
# # hb, total pop
# shs_results2 %>% 
#   pivot_wider(names_from = statistic, values_from = value) %>%
#   filter(sex == "Total", spatial.scale == "HB") %>% 
#   ggplot(aes(year, percent, group = spatial.unit, colour = spatial.unit, shape = spatial.unit)) + 
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y") 
# #+
# #  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 
# 
# # la, total pop
# shs_results2 %>% 
#   pivot_wider(names_from = statistic, values_from = value) %>%
#   filter(sex == "Total", spatial.scale == "LA") %>% 
#   ggplot(aes(year, percent, group = spatial.unit, colour = spatial.unit, shape = spatial.unit)) + 
#   geom_point() + geom_line() +
#   facet_wrap(~var_label, scales = "free_y") 
# #+
# #  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 
# 
# 
# 
# ## END

