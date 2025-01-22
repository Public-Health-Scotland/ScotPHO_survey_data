# ============================================================================
# ===== Processing UKDS survey data files: SCOTTISH HOUSEHOLD SURVEY (shs) =====
# ============================================================================

# NB. Most of this script now not needed, as the SHoS team have agreed to provide the indicator data.
# But we still need to extract SIMD quintiles for linking to SHCS data....

# NOTES ON SHS

# 12 indicators
# volunteer: "Percentage of adults who have given any unpaid help to any groups, clubs or organisations in the last 12 months." (vars = voluntee or volunteer)
# rb1: "Percentage of adults who rate their neighbourhood as a very good place to live." (var = rb1)
# asb2a: "Percentage of adults who experienced noisy neighbours or regular loud parties in their neighbourhood in the last 12 months" (var = asb2/asb2a)
# serv1h: "Percentage of adults who strongly agree or agree that they can influence decisions affecting their local area." 
# commbel: "Percentage of adults who feel that they belong very or fairly strongly to their immediate neighbourhood" (var = commbel)
# greenuse13: "Percentage of adults who use or pass through a public green, blue, or open space in their local area every day or several times a week (within a five minute walk)." (var = greenuse13)
# social2: "Percentage of adults who reported feeling lonely some, most, almost all, or all of the time, in the last week." (var = social2)
# social3_02: "Percentage of adults who trust most people in their neighbourhood" (var = social3_02)
# hk2: "Percentage of households managing very or quite well financially these days." (var = hk2)
# loans: "Percentage of adults or their partners who have used a cash loan from a company that comes to the home to collect payments, a loan from a pawnbroker/cash converters or a loan from a pay day lender in the past year." (vars = credit309d, credit309e, and credit309l)
# harass_new: "Percentage of adults who have experienced harassment or abuse in Scotland in the past year due to discrimination." (vars = harass_01 to harass_17)
# discrim_new: "Percentage of adults who have been unfairly treated or discriminated against in Scotland in the past year." (vars = discrim_01 to discrim_17)
#
## Risky loans MHI ('loans'):
## This uses three variables asked in 2015, 2017 and 2019: "credit309d", "credit309e", and "credit309l"
## The code allocates a household to the risky loans group if they have had one of those loan types in the last 12 months.
## Older surveys asked 'do you/partner have this type of loan currently?" (cred209 and credit209 variables) so can't be combined to make a longer time series. 
#
# Denominators = Total number of respondents (all were 16+) answering the question. 
## Whether those answering ‘don’t know’ are included differed between the indicators: 
## don’t knows were excluded from the denominator for hk2* (managing ok financially), 
## but included for commbel*, greenuse13*, discrim_new, harass_new, social2 and social3_02. * = Confirmed by trying to match the results from the SHS dashboard.
# Survey weights = 
## la_wt = for household financial variables, and used here for indicators hk2 and loans. Grouping by sex not applicable here.
## ind_wt = for variables pertaining to the 'random adult' in the household,. Used for the other (non financial) indicators
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
#
# Availability = varies by indicator. Max = hk2 from 1999-2000 to 2022 by LA, HB, Scotland, and SIMD. 
#
# QA checks against data downloaded from the SHS dashboard are conducted in the script ukds_shs_checks.R
# Headline results of this QA:  
# 89% of the unweighted bases are identical (Differences seem to be largely due to rounding for small bases)
# 76% of the percentages are identical (and 90% are within 1%).
# Investigated some of the largest relative differences in the estimates: 
# again, looks like differences in the raw data (number of respondents) being processed for the SHS dashboard and that available to us through the UKDS. 
# SHS responded to an email* on 22 March 2024 saying that the UKDS data will have fewer respondents in them because of disclosure control.
# (*Prompted by discrim_new and harass_new indicators having 40-50 fewer respondents in the UKDS data)
# So now seeking all indicators to be calculated by SHoS.

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
# temporary functions:
source(here("functions", "temp_depr_analysis_updates.R")) # 22.1.25: sources some temporary functions needed until PR #97 is merged into the indicator production repo 


# 1. Find survey data files, extract variable names and labels (descriptions), and save this info to a spreadsheet
# =================================================================================================================

## Create a new workbook (first time only. don't run this now)
#wb <- createWorkbook()
#saveWorkbook(wb, file = here("data", "all_survey_var_info.xlsx"))

save_var_descriptions(survey = "shs", 
                      name_pattern = "\\/shs\\D*(\\d{4}-?\\d{0,4})") # the regular expression for this survey's filenames that identifies the survey year(s)
# takes ~ 3 mins

# 2. Manual bit: Look at the vars_'survey' tab of the spreadsheet all_survey_var_info.xlsx to work out which variables are required.
#    Manually store the relevant variables in the file vars_to_extract_'survey'
# =================================================================================================================
#    Added discrim and harass variables to vars_to_extract_shs in March 2024 after similar variables discontinued from SHeS. 

# 3. Extract the relevant survey data from the files 
# =================================================================================================================

extracted_survey_data_shs <- extract_survey_data("shs") 
# takes ~ 6 mins 

# keep only the survey files we are interested in

extracted_survey_data_shs <- extracted_survey_data_shs %>%
  filter(!grepl('_td_|0708_c_and_s', filename))  # don't need the travel diary files or the 0708_c_and_s file

# save the file
saveRDS(extracted_survey_data_shs, here("data", "extracted_survey_data_shs.rds"))


# 4. What are the possible responses?
# =================================================================================================================

# Read in data if not in memory:
# extracted_survey_data_shs <- readRDS(here("data", "extracted_survey_data_shs.rds"))


# get the responses recorded for each variable (combined over the years), and save to xlsx and rds

# 1st run through to see how to identify variables that can be excluded (and the unique characters that will identify these):
    # extract_responses(survey = "shs") 
    # responses_as_list_shs <- readRDS(here("data", paste0("responses_as_list_shs.rds")))
    # responses_as_list_shs  # examine the output

# 2nd run to exclude the numeric vars that don't need codings and/or muck up the output:

extract_responses(survey = "shs", #survey acronym
                  chars_to_exclude = c("_wt")) 

# read the responses back in and print out so we can work out how they should be coded
# (also useful to see how sex/geography/simd variables have been recorded, for later standardisation)

responses_as_list_shs <- readRDS(here("data", paste0("responses_as_list_shs.rds")))
responses_as_list_shs

# responses_as_list_shs printed out
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?
###################################

# $asb2a
# [1] "no"                                               NA                                                 "yes"                                             
# [4] "refused"                                          "No"                                               "Yes"                                             
# [7] "NOT A - Noisy neighbours or regular loud parties" "A - Noisy neighbours or regular loud parties"    
# 
# $commbel
# [1] "Fairly strongly"     "Very strongly"       "Not very strongly"   "Not at all strongly" NA                    "Don't know"         
# 
# $council
# [1] "aberdeen city"       "north ayrshire"      "aberdeenshire"       "dumfries & galloway" "fife"                "edinburgh, city of"  "south ayrshire"     
# [8] "clackmannanshire"    "falkirk"             "perth & kinross"     "west dunbartonshire" "argyll & bute"       "dundee city"         "north lanarkshire"  
# [15] "west lothian"        "eilean siar"         "east lothian"        "glasgow city"        "highland"            "shetland islands"    "orkney islands"     
# [22] "south lanarkshire"   "inverclyde"          "scottish borders"    "east renfrewshire"   "midlothian"          "renfrewshire"        "stirling"           
# [29] "angus"               "moray"               "east ayrshire"       "east dunbartonshire" "West Lothian"        "Edinburgh, City of"  "South Lanarkshire"  
# [36] "Glasgow City"        "Inverclyde"          "East Dunbartonshire" "23"                  "Midlothian"          "Angus"               "Perth & Kinross"    
# [43] "Stirling"            "Fife"                "1"                   "Aberdeenshire"       "Falkirk"             "16"                  "17"                 
# [50] "North Lanarkshire"   "Dumfries & Galloway" "Aberdeen City"       "Highland"            "East Renfrewshire"   "Dundee City"         "11"                 
# [57] "Clackmannanshire"    "East Ayrshire"       "East Lothian"        "Renfrewshire"        "Scottish Borders"    "North Ayrshire"      "Moray"              
# [64] "Orkney Islands"      "Argyll & Bute"       "Shetland Islands"    "14"                  "12"                  "10"                  "19"                 
# [71] "West Dunbartonshire" "Eilean Siar"         "South Ayrshire"      "15"                  "6"                   "27"                  "18"                 
# [78] "20"                  "2"                   "29"                  "13"                  "32"                  "30"                  "9"                  
# [85] "25"                  "5"                   "4"                   "28"                  "3"                   "31"                  "8"                  
# [92] "26"                  "22"                  "7"                   "24"                  "21"                  NA                    "R"                  
# [99] "Y"                   "L"                   "P"                   "B"                   "C"                   "no"                   "F"                  
# [106] "K"                   "E"                   "O"                   "H"                   "V"                   "A"                   "D"                  
# [113] "T"                   "X"                   "M"                   "yes"                   "U"                   "J"                   "S"                  
# [120] "W"                   "G"                   "Z"                   "I"                  
# 
# $cred209d
# [1] "Not"                                                          NA                                                            
# [3] "Cash loan from a company that comes to your home to collect"  "NOT D - Cash loan from a company that comes to your home to" 
# [5] "D - Cash loan from a company that comes to your home to coll"
# 
# $cred209e
# [1] "Not"                                            NA                                               "Loan from a pawnbroker/cash converters"        
# [4] "NOT E - Loan from a pawnbroker/cash converters" "E - Loan from a pawnbroker/cash converters"    
# 
# $cred209l
# [1] "Not"                                  NA                                     "A loan from a pay day lender"         "NOT L - A loan from a pay day lender"
# [5] "L - A loan from a pay day lender"    
# 
# $credit209d
# [1] "NOT D - Cash loan from a company that comes to your home to collect payments" NA                                                                            
# [3] "D - Cash loan from a company that comes to your home to collect payments"    
# 
# $credit209e
# [1] "NOT E - Loan from a pawnbroker/cash converters" NA                                               "E - Loan from a pawnbroker/cash converters"    
# 
# $credit209l
# [1] "NOT L - A loan from a pay day lender" NA                                     "L - A loan from a pay day lender"    
# 
# $credit309d
# [1] NA                                                                             "NOT D - Cash loan from a company that comes to your home to collect payments"
# [3] "D - Cash loan from a company that comes to your home to collect payments"     "No"                                                                          
# [5] "Yes"                                                                         
# 
# $credit309e
# [1] NA                                               "NOT E - Loan from a pawnbroker/cash converters" "E - Loan from a pawnbroker/cash converters"    
# [4] "No"                                             "Yes"                                           
# 
# $credit309l
# [1] NA                                     "NOT L - A loan from a pay day lender" "L - A loan from a pay day lender"     "No"                                  
# [5] "Yes"                                 
# 
# $discrim1
# [1] "No"  "Yes" NA   
# 
# $discrim_01
# [1] "No"  NA    "Yes"
# 
# $discrim_02
# [1] "No"  "Yes" NA   
# 
# $discrim_03
# [1] "No"  NA    "Yes"
# 
# $discrim_04
# [1] "No"  NA    "Yes"
# 
# $discrim_05
# [1] "No"  NA    "Yes"
# 
# $discrim_06
# [1] "No"  "Yes" NA   
# 
# $discrim_07
# [1] "No"  NA    "Yes"
# 
# $discrim_08
# [1] "No"  NA    "Yes"
# 
# $discrim_091015
# [1] "No"  "Yes"
# 
# $discrim_11
# [1] "No"  "Yes" NA   
# 
# $discrim_12
# [1] "No"  "Yes" NA   
# 
# $discrim_13
# [1] "No"  NA    "Yes"
# 
# $discrim_14
# [1] "No"  NA    "Yes"
# 
# $discrim_16
# [1] "Yes" "No"  NA   
# 
# $discrim_17
# [1] "No"  NA    "Yes"
# 
# $discrim_18
# [1] "No"  NA    "Yes"
#
# $greenuse13
# [1] "Once a month"          "Not at all"            "Every day"             "Several times a week"  "Several times a month" "Less often"            NA                     
# [8] "Once a week"           "Don't know"           
# 
# $harass1
# [1] "No"  "Yes" NA   
# 
# $harass_01
# [1] "No"  NA    "Yes"
# 
# $harass_02
# [1] "No"  "Yes" NA   
# 
# $harass_03
# [1] "No"  NA    "Yes"
# 
# $harass_04
# [1] "No"  NA    "Yes"
# 
# $harass_05
# [1] "No"  NA    "Yes"
# 
# $harass_06
# [1] "No"  "Yes" NA   
# 
# $harass_07
# [1] "No"  NA    "Yes"
# 
# $harass_08
# [1] "No"  NA    "Yes"
# 
# $harass_091015
# [1] "No"  "Yes"
# 
# $harass_11
# [1] "No"  NA    "Yes"
# 
# $harass_12
# [1] "No"  "Yes" NA   
# 
# $harass_13
# [1] "No"  NA    "Yes"
# 
# $harass_14
# [1] "No"  NA    "Yes"
# 
# $harass_16
# [1] "Yes" "No"  NA   
# 
# $harass_17
# [1] "No"  NA    "Yes"
# 
# $harass_18
# [1] "No"  NA    "Yes"
# 
# $hk2
# [1] "manage quite well"                    "manage very well"                     "have some financial difficulties"     "get by alright"                      
# [5] "don't manage very well"               "are in deep financial trouble"        "refused"                              "don't know"                          
# [9] NA                                     "dont manage very well"                "999999"                               "dont know"                           
# [13] "Get by alright"                       "Manage quite well"                    "Have some financial difficulties"     "Manage very well"                    
# [17] "Don't manage very well"               "8"                                    "Are in deep financial trouble"        "Refused"                             
# [21] "Don't know"                           "999998"                               "C - get by alright"                   "A - manage very well"                
# [25] "B - manage quite well"                "F - are in deep financial trouble"    "D - don't manage very well"           "E - have some financial difficulties"
# 
# $hlth06
# [1] "grampian"                "ayrshire & arran"        "dumfries & galloway"     "fife"                    "lothian"                 "forth valley"           
# [7] "tayside"                 "greater glasgow & clyde" "highland"                "lanarkshire"             "western isles"           "shetland"               
# [13] "orkney"                  "borders"                 "Lothian"                 "Lanarkshire"             "Greater Glasgow & Clyde" "Tayside"                
# [19] "Forth Valley"            "Fife"                    "Grampian"                "Dumfries & Galloway"     "Highland"                "Ayrshire & Arran"       
# [25] "Borders"                 "Orkney"                  "Shetland"                "Western Isles"           NA                       
# 
# $hlth14
# [1] "S08000022" "S08000024" "S08000021" "S08000017" "S08000023" "S08000015" "S08000018" "S08000027" "S08000019" "S08000025" "S08000020" "S08000026" "S08000016" "S08000028"
# [15] "13"        "16"        "7"         "3"         "11"        "2"         "5"         "6"         "14"        "17"        "10"        "12"        "15"        "4"        
# [29] NA         
# 
# $hlth19
# [1] NA
# 
# $hlthbd2014
# [1] "S08000023" "S08000021" "S08000020" "S08000024" "S08000027" "S08000022" "S08000019" "S08000015" "S08000016" "S08000018" "S08000028" "S08000025" "S08000017" "S08000026"
# [15] "S08000029" "S08000030"
# 
# $hlthbd2019
# [1] "S08000020" "S08000022" "S08000030" "S08000019" "S08000017" "S08000015" "S08000016" "S08000032" "S08000029" "S08000031" "S08000024" "S08000028" "S08000025" "S08000026"
# 
# $la
# [1] "P" "V" "O" "A" "yes" "1" "X" "B" "5" "D" "M" "G" "Z" "3" "F" "R" "2" "K" "Y" "J" "L" "T" "H" "U" "4" "E" "no" "C" "I" "S" "W" "6"
# 
# $la_code
# [1] "S12000029" "S12000018" "S12000038" "S12000011" "S12000046" "S12000034" "S12000040" "S12000041" "S12000017" "S12000030" "S12000039" "S12000005" "S12000010" "S12000028"
# [15] "S12000026" "S12000015" "S12000042" "S12000044" "S12000033" "S12000035" "S12000020" "S12000024" "S12000036" "S12000014" "S12000021" "S12000013" "S12000045" "S12000019"
# [29] "S12000023" "S12000006" "S12000027" "S12000008"
# 
# $md04dec
# [1] NA
# 
# $md04quin
# [1] NA
# 
# $md05dec
# [1] NA
# 
# $md05quin
# [1] NA
# 
# $md06dec
# [1] "3"                             "most deprived 10% data zones"  "2"                             "8"                             "9"                            
# [6] "7"                             "4"                             "6"                             "5"                             "least deprived 10% data zones"
# [11] NA                             
# 
# $md06quin
# [1] "2"                             "most deprived 20% data zones"  "4"                             "least deprived 20% data zones" "3"                            
# [6] NA                              "Least deprived 20% data zones" "Most deprived 20% data zones" 
# 
# $md09quin
# [1] "3"                             NA                              "4"                             "Most deprived 20% data zones"  "Least deprived 20% data zones"
# [6] "2"                            
# 
# $md12quin
# [1] "4"                      "2"                      "3"                      "5 - 20% least deprived" "1 - 20% most deprived" 
# 
# $md16quin
# [1] "3"                      "1 - 20% most deprived"  "4"                      "5 - 20% least deprived" "2"                     
# 
# $md20quin
# [1] "5 - 20% least deprived" "4"                      "3"                      "2"                      "1 - 20% most deprived" 
# 
# $randgender
# [1] "Man/Boy"    "Woman/Girl" NA      "Female"     "Male"     
# 
# $randsex
# [1] "female" "male"   NA       "Female" "Male"  
# 
# $rb1
# [1] "fairly good" "very good"   "very poor"   "fairly poor" "no opinion"  NA            "Very good"   "Fairly good" "Very poor"   "Fairly poor" "No opinion" 
# 
# $serv1h
# [1] "strongly agree"             "neither agree nor disagree" "tend to disagree"           "tend to agree"              NA                          
# [6] "strongly disagree"          "no opinion"                 "Strongly disagree"          "Tend to disagree"           "Tend to agree"             
# [11] "Neither agree nor disagree" "Strongly agree"             "No opinion"                
# 
# $social2
# [1] "Some of the time"                "None or almost none of the time" "Most of the time"                NA                                "All or almost all of the time"  
# [6] "Don\u0092t know"                
# 
# $social3_02
# [1] "Strongly agree"             "Neither agree nor disagree" "Tend to agree"              NA                           "Tend to disagree"          
# [6] "Don't know"                 "Strongly disagree"         
# 
# $voluntee
# [1] "No"  "Yes" "99" 
# 
# $volunteer
# [1] NA          "not asked" "no"        "yes"       "No"        "Not asked" "Yes"       "Missing"  

###################################



# 5. How should the responses be coded?
# =================================================================================================================
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?

# Create lookups to code the variables into the dichotomy needed for the indicators:

# lookups as lists (use after var names have been harmonised)
lookup_asb2a<- list(
  "A - Noisy neighbours or regular loud parties"="yes", 
  "Yes"="yes",
  "yes"="yes",
  "NOT A - Noisy neighbours or regular loud parties"="no", 
  "No"="no",
  "no"="no",
  "refused"=as.character(NA))

lookup_commbel<- list( #confirmed codings with SHS dashboard data
  "Very strongly"="yes", 
  "Fairly strongly"="yes",
  "Not at all strongly"="no", 
  "Not very strongly"="no", 
  "Don't know"="no")

lookup_loans <- list("Yes"="yes",
                     "Cash loan from a company that comes to your home to collect"="yes", 
                     "D - Cash loan from a company that comes to your home to coll"="yes",
                     "D - Cash loan from a company that comes to your home to collect payments"="yes",
                     "E - Loan from a pawnbroker/cash converters"="yes", 
                     "Loan from a pawnbroker/cash converters"="yes",
                     "L - A loan from a pay day lender"="yes",
                     "A loan from a pay day lender"="yes",
                     "Not"="no", 
                     "No"="no",
                     "NOT D - Cash loan from a company that comes to your home to"="no",
                     "NOT D - Cash loan from a company that comes to your home to collect payments"="no",
                     "NOT E - Loan from a pawnbroker/cash converters"="no",
                     "NOT L - A loan from a pay day lender"="no")

lookup_greenuse13<- list( #confirmed codings with SHS dashboard data
  "Every day"="yes", 
  "Several times a week"="yes",
  "Less often"="no", 
  "Not at all"="no", 
  "Once a month"="no", 
  "Once a week"="no", 
  "Several times a month"="no", 
  "Don't know"="no")

lookup_hk2<- list( #confirmed codings with SHS dashboard data
  "A - manage very well"="yes", 
  "B - manage quite well"="yes", 
  "Manage very well"="yes", 
  "Manage quite well"="yes",
  "manage quite well"="yes",                    
  "manage very well"="yes",    
  "Are in deep financial trouble"="no", 
  "Don't manage very well"="no", 
  "Get by alright"="no", 
  "Have some financial difficulties"="no",
  "C - get by alright"="no", 
  "D - don't manage very well"="no", 
  "E - have some financial difficulties"="no", 
  "F - are in deep financial trouble"="no", 
  "have some financial difficulties"="no",     
  "get by alright"="no",                      
  "don't manage very well"="no",               
  "are in deep financial trouble"="no",        
  "dont manage very well"="no",                
  "refused"=as.character(NA),                               
  "don't know"=as.character(NA),                           
  "dont know"=as.character(NA),                            
  "Refused"=as.character(NA), 
  "Don't know"=as.character(NA), 
  "999998"=as.character(NA), 
  "999999"=as.character(NA), 
  "8"=as.character(NA)) #999999 refusal, 999998 don't know, 8 refused (needed to exclude these to match published figures)

lookup_rb1<- list( #confirmed codings with SHS dashboard data
  "Very good"="yes",
  "very good"="yes",   
  "fairly good"="no",  
  "very poor"="no",    
  "fairly poor"="no",  
  "no opinion"="no",   
  "Fairly good"="no", 
  "Fairly poor"="no", 
  "No opinion"="no", 
  "Very poor"="no")

lookup_serv1h<- list( 
  "Strongly agree"="yes", 
  "Tend to agree"="yes",
  "strongly agree"="yes",
  "tend to agree"="yes",              
  "neither agree nor disagree"="no",  
  "tend to disagree"="no",            
  "strongly disagree"="no",           
  "no opinion"="no", 
  "Neither agree nor disagree"="no", 
  "No opinion"="no", 
  "Strongly disagree"="no", 
  "Tend to disagree"="no")

lookup_social2<- list(
  "Some of the time"="yes", 
  "Most of the time"="yes", 
  "All or almost all of the time"="yes",
  "Don’t know"="no", 
  "Don\u0092t know"="no",
  "None or almost none of the time"="no")

lookup_social3_02<- list(
  "Strongly agree"="yes", 
  "Tend to agree"="yes",
  "Don't know"="no", 
  "Neither agree nor disagree"="no", 
  "Strongly disagree"="no", 
  "Tend to disagree"="no")

lookup_volunteer<- list( #confirmed codings with SHS dashboard data
  "Yes"="yes",
  "yes"="yes",       
  "no"="no",        
  "No"="no",
  "Not asked"=as.character(NA), 
  "not asked"=as.character(NA), 
  "Missing"=as.character(NA), 
  "99"=as.character(NA))

lookup_discrim <- list( 
  "Yes"="yes",
  "No"="no")

lookup_harass <- list( 
  "Yes"="yes",
  "No"="no")

discrim_categories <- c("discrim_01", "discrim_02", "discrim_03", "discrim_04", "discrim_05", 
                        "discrim_06", "discrim_07", "discrim_08", "discrim_091015", 
                        "discrim_11", "discrim_12", "discrim_13", "discrim_14")
harass_categories <- c("harass_01", "harass_02", "harass_03", "harass_04", "harass_05", 
                       "harass_06", "harass_07", "harass_08", "harass_091015", "harass_11", 
                       "harass_12", "harass_13", "harass_14")


# 6. Process the survey data to produce the indicator(s)
# =================================================================================================================

# First: make sure there's only one of each grouping variable (geog/SIMD) for each survey file and that these are coded in a standard way

# cross tabulate years and variables, to see what's available when  
shs_years_vars <- extracted_survey_data_shs %>%
  transmute(year,
            var_label = map(survey_data, names)) %>%
  unnest(var_label) %>%
  arrange(var_label) %>%
  mutate(value=1) %>%
  pivot_wider(names_from=var_label, values_from = value)

# Geography codes: 

# Geographies are a mess in these data (see the possible codings printed out above).
# There should be 32 codes for LA/council, and 14 for health boards, but in reality:

# council: 123 unique, mix of names, numbers and letters. Massive jumble. 
# la = 32 unique, letters and numbers (1 to Z)
# la_code = 32 unique (correct), all S120000xx codes, from S12000005 to S12000046 (some numbers not used) 

# hlth06 = 29 unique, but all text, so could be standardised
# hlth14 = 29 unique, mix of S08 codes and numbers, and numbers don't correspond to the codes. 
# hlthbd2014 = 16 unique S08 codes, from S08000015 to S08000030
# hlth19 = 14 unique numbers, 2 to 17
# hlthbd2019 = 14 unique S080000xx codes.

# Which hb and la codes are used when (and when are they used together, and which ones should be kept)?
shs_years_vars %>% select(year, year, starts_with("hlth"), la, la_code, council) %>% arrange(year)

# # A tibble: 15 × 9
#    year      hlth06 hlth14 hlth19 hlthbd2014 hlthbd2019    la la_code council
#    <chr>      <dbl>  <dbl>  <dbl>      <dbl>      <dbl> <dbl>   <dbl>   <dbl>
#  1 0102          NA     NA     NA         NA         NA     1      NA      NA
#  2 0506          NA     NA     NA         NA         NA     1      NA      NA
#  3 0708           1     NA     NA         NA         NA     1      NA       1
#  4 19992000      NA     NA     NA         NA         NA     1      NA      NA
#  5 20032004      NA     NA     NA         NA         NA     1      NA      NA
#  6 2009-2010      1     NA     NA         NA         NA     1      NA       1
#  7 2011           1     NA     NA         NA         NA     1      NA      NA
#  8 2012          NA     NA     NA         NA         NA     1      NA      NA
#  9 2013          NA      1     NA         NA         NA     1      NA      NA
# 10 2014          NA      1     NA         NA         NA     1      NA      NA
# 11 2015          NA      1     NA         NA         NA     1      NA      NA
# 12 2016          NA      1     NA          1         NA    NA       1       1
# 13 2017          NA      1     NA          1         NA    NA       1       1
# 14 2018          NA      1     NA          1         NA    NA      NA       1
# 15 2019          NA     NA      1         NA          1    NA      NA       1
# 16 2022          NA     NA      1         NA          1    NA      NA       1

# No HB code = 19992000 to 0506, and then 2012 -> all have the la variable (1 to Z)
# 2 HB codes = 2016 to 2022: numbers 2 to 17 as hlth14 (or hlth19 in 2019 & 2022), and HB codes as hlthbd2014 (or hlthbd2019 in 2019 & 2022)
# The numeric hlth14 var is used in isolation in 2013-2015

# All years have an alphanumeric variable called la or council which contains 1 to Z.
# In 2009-10 though the code council is a mismash of names and numbers, and the 1 to Z la variable is also provided. 
# 2016 and 2017 have council (1 to Z) and la_code (S12..)

# Conclusion = total mess

# Most straightforward approach to consolidating and standardising codes and names: (I tried a lot)
la_code_to_council_code <- extracted_survey_data_shs %>%
  filter(year=="2016") %>%
  select(survey_data) %>% 
  unnest() %>%
  group_by(la_code, council) %>%
  summarise() %>%
  ungroup() 
# 32 obs, so correct. 
# council =  1 to Z here, 
# la_code = S12000005 to S12000046. Corresponds to CA2011 codes (found this in the datazone lookup here:
dz2011_lut <- read_csv("/conf/linkage/output/lookups/Unicode/Geography/DataZone2011/Datazone2011lookup.csv")
#arrow::write_parquet(dz2011_lut, here("data", "dz2011_lut.parquet"))
# read in from here if don't have access to the stats box lookups:
#dz2011_lut <- arrow::read_parquet(here("data", "dz2011_lut.parquet"))

# make a LUT for council and HB names, based on 2011 CA codes (S12000005 to S12000046)
ca2011_la_name_hb2019name <- dz2011_lut %>%
  group_by(LA_Name, CA2011, hb2019name) %>%
  summarise() %>%
  ungroup() %>%
  rename(la_code = CA2011, # S12000005 to S12000046
         la = LA_Name,
         hb = hb2019name)

# combine:
la_hb_lut <- ca2011_la_name_hb2019name %>%
  merge(y = la_code_to_council_code, by="la_code") %>%
  select(-la_code)
# Great! Can now link this LUT to la for survey files up to and including 2015, and link to council for 2016 to 2019.



# SIMD codes

# which simd codes used when (and when are they used together)?
shs_years_vars %>% select(year, year, ends_with("quin")) %>% arrange(year)

# # A tibble: 15 × 8
# year      md04quin md05quin md06quin md09quin md12quin md16quin md20quin
# <chr>        <dbl>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>
# 1  0102         NA        1       NA       NA       NA       NA       NA
# 2  0506         NA       NA        1       NA       NA       NA       NA
# 3  0708         NA       NA        1       NA       NA       NA       NA
# 4  19992000     NA        1       NA       NA       NA       NA       NA
# 5  20032004      1        1       NA       NA       NA       NA       NA
# 6  2009-2010    NA       NA        1        1       NA       NA       NA
# 7  2011         NA       NA        1        1       NA       NA       NA
# 8  2012         NA       NA       NA       NA        1       NA       NA
# 9  2013         NA       NA       NA       NA        1       NA       NA
# 10 2014         NA       NA       NA       NA        1       NA       NA
# 11 2015         NA       NA       NA       NA        1       NA       NA
# 12 2016         NA       NA       NA       NA       NA        1       NA
# 13 2017         NA       NA       NA       NA        1        1       NA
# 14 2018         NA       NA       NA       NA        1        1       NA
# 15 2019         NA       NA       NA       NA       NA       NA        1
# 16 2022         NA       NA       NA       NA       NA       NA        1

# 20032004 has md04 and md05 
# (don't know what 05 refers to as this wasn't an SIMD year. Data dictionary doesn't clarify. 
# md04quin and md05quin are identical when tabulated, so assume is SIMD2004. 11 missings from both) -> drop md04quin
# 2009-10 has md06 and md09 (09 = massively missing: don't use, though more current)
# 2011 has md06 and md09 (13 missings from both, so use SIMD2009, as more current)
# 2017 and 2018 have md12 and md16 (no missings: use SIMD2016)

# It's not clear from the variable labels what the SIMD numbers refer to for md04, md05, md06, and md09 (e.g., is 2 the 2nd most deprived or 2nd least deprived?)
# Use the relevant decile/most deprived 15% vars to work this out: 

#md04 in 20032004
table(extracted_survey_data_shs[[4]][[3]]$md04quin, extracted_survey_data_shs[[4]][[3]]$md04pc15, useNA = "always")
# 1 is most deprived

#md05 in 19992000
table(extracted_survey_data_shs[[4]][[1]]$md05quin, extracted_survey_data_shs[[4]][[1]]$md05pc15)
# 1 is most deprived

#md06 in 0506
table(extracted_survey_data_shs[[4]][[4]]$md06quin, extracted_survey_data_shs[[4]][[4]]$md06dec)
# 1 is most deprived

#md09 in 2011
table(extracted_survey_data_shs[[4]][[7]]$md06quin, extracted_survey_data_shs[[4]][[7]]$md09quin)
# 1 is most deprived

# Conclusion: 1 is most deprived quintile in all SIMD versions used in SHS

# Processing of these microdata before calculating indicator estimates:
# Produce a flat file by unnesting the list column
# Consolidate and standardise the relevant vars
# Apply the variable codings
# Add in SHS design effects

# design effects from Scottish Household Survey team
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
  mutate(volunteer = coalesce(volunteer, voluntee)) %>%
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
  mutate(simd5 = case_when(simd5 %in% c("1", "1 - 20% most deprived", "Most deprived 20% data zones", "most deprived 20% data zones") ~ "1st - Most deprived",
                           simd5 == "2" ~ "2nd",
                           simd5 == "3" ~ "3rd",
                           simd5 == "4" ~ "4th",
                           simd5 %in% c("5", "5 - 20% least deprived", "Least deprived 20% data zones", "least deprived 20% data zones") ~ "5th - Least deprived",
                           TRUE ~ as.character(NA))) %>%
  # now can recode the variables
  mutate(volunteer = recode(volunteer, !!!lookup_volunteer)) %>%
  mutate(commbel = recode(commbel, !!!lookup_commbel)) %>%
  mutate(greenuse13 = recode(greenuse13, !!!lookup_greenuse13)) %>%
  mutate(rb1 = recode(rb1, !!!lookup_rb1)) %>%
  mutate(asb2a = recode(asb2a, !!!lookup_asb2a)) %>%
  mutate(serv1h = recode(serv1h, !!!lookup_serv1h)) %>%
  mutate(social2 = recode(social2, !!!lookup_social2)) %>%
  mutate(social3_02 = recode(social3_02, !!!lookup_social3_02)) %>%
  mutate(hk2 = recode(hk2, !!!lookup_hk2)) %>%
  # recode the credit variables used to derived the risky loans MHI:
  mutate(credit309d = recode(credit309d, !!!lookup_loans)) %>%
  mutate(credit309e = recode(credit309e, !!!lookup_loans)) %>%
  mutate(credit309l = recode(credit309l, !!!lookup_loans)) %>%
  # risky loans calc: #limit to 2015+ Q wording (i.e., variables credit309)
  mutate(loans = case_when(if_any(starts_with("credit3"), ~ . == "yes") ~ "yes", #applied first, so not overwritten by second clause
                           if_any(starts_with("credit3"), ~ . == "no") ~ "no",
                           TRUE ~ as.character(NA))) %>% # for survey years with no relevant variables
  #recode the discrim variables
  mutate(across(starts_with("discrim"), ~ recode(., !!!lookup_discrim))) %>%
  mutate(discrim_new = case_when(if_any(all_of(discrim_categories), ~ . == "yes") ~ "yes", #applied first, so not overwritten by second clause
                             if_any(c(discrim_16, discrim_17), ~ . == "yes") ~ "no", # no discrim if answer yes to discrim_16 (not experienced) or discrim_17 (don't know). Excludes 'refused'.
                             TRUE ~ as.character(NA))) %>% # for survey years with no relevant variables
  #recode the harass variables
  mutate(across(starts_with("harass"), ~ recode(., !!!lookup_harass))) %>%
  mutate(harass_new = case_when(if_any(all_of(harass_categories), ~ . == "yes") ~ "yes", #applied first, so not overwritten by second clause
                                if_any(c(harass_16, harass_17), ~ . == "yes") ~ "no", # no harass if answer yes to harass_16 (not experienced) or harass_17 (don't know). Excludes 'refused'.
                                TRUE ~ as.character(NA))) %>% # for survey years with no relevant variables
  select(-contains(c("hlth", "rand", "pc15", "dec", "file", "quin", "cred")), -la_code, -md04quin, -council, -voluntee, -any_of(harass_categories), -any_of(discrim_categories), -harass_16, -harass_17, -discrim_16, -discrim_17 ) %>% #drop if not needed
  merge(y = shs_design_effects, by.x="year", by.y="Year", all.x=TRUE)

# save a uniqidnew lookup for use in SHCS analysis
uniqidnew_lut <- shs_data %>%
  select(year, uniqidnew, la_wt, ind_wt, simd5, la, hb, Design.Factor) %>%
  filter(!is.na(uniqidnew)) # halves the number of rows... 

# save the file
saveRDS(uniqidnew_lut, here("data", "uniqidnew_lut.rds"))

# data checks
table(shs_data$sex, useNA = "always") # Female/Male/Total
table(shs_data$simd5, useNA = "always") # 5 classes, plus a small number of NA
table(shs_data$hb, useNA = "always") # standard names, no NAs
table(shs_data$la, useNA = "always") # standard names, no NAs
table(shs_data$volunteer, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$commbel, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$greenuse13, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$rb1, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$asb2a, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$serv1h, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$social2, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$social3_02, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$hk2, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$loans, useNA = "always") # just yes, no and NA, so coding has worked
#table(shs_data$discrim1, useNA = "always") # just yes, no and NA, so coding has worked # old pre-2018 discrim var
table(shs_data$discrim_new, useNA = "always") # just yes, no and NA, so coding has worked
#table(shs_data$harass1, useNA = "always") # just yes, no and NA, so coding has worked # old pre-2018 harass var
table(shs_data$harass_new, useNA = "always") # just yes, no and NA, so coding has worked

# repeat the data with sex=="Total"
shs_data2 <- shs_data %>%
  filter(sex!="Total") %>% #remove those that were total in the first place
  mutate(sex="Total") %>% 
  rbind(shs_data)

# make long by geographical scale, to make aggregating and analysing easier:
shs_data3 <- shs_data2 %>%
  mutate(new_Scotland = "Scotland") %>%
  rename(new_LA = la,
         new_HB = hb,
         new_SIMD = simd5) %>%
  pivot_longer(cols = starts_with("new"), names_to = "spatial.scale", names_prefix = "new_", values_to = "spatial.unit") # should be 4x as long as original data, as respondents now repeated


# Function to aggregate the data for a single variable, with weightings and complex survey design effects applied
shs_percent_analysis <- function (df, var, wt) {
  
  df2 <- df %>% 
    rename(svy_var = var,
           svy_wt = wt) %>% # makes later calculations easier if starting variable and weight have standard name
    filter(!is.na(svy_wt)) %>%
    filter(svy_var!="NA") %>%
    filter(!is.na(svy_var)) %>%
    group_by(year, sex, spatial.unit, spatial.scale, Design.Factor) %>%
    summarise(yes_wted = sum(svy_wt[svy_var=="yes"]),
              no_wted = sum(svy_wt[svy_var=="no"]),
              yes_unwted = sum(svy_var=="yes"),
              no_unwted = sum(svy_var=="no"),
              Nuw = yes_unwted + no_unwted,
              Nw = yes_wted + no_wted) %>%
    ungroup() %>%
    mutate(proportion = yes_wted/Nw,
           percent = 100 * proportion,
          # lower_bound = 100 * (((2*yes_wted) + (1.96*1.96) - 1.96*sqrt((1.96*1.96) + (4*yes_wted*(1-proportion)))) / (2 * (Nw + (1.96*1.96)))), # Wilson's score method. 
          # upper_bound = 100 * (((2*yes_wted) + (1.96*1.96) + 1.96*sqrt((1.96*1.96) + (4*yes_wted*(1-proportion)))) / (2 * (Nw + (1.96*1.96)))),
          # lower_ci = percent - Design.Factor * (percent - lower_bound),
          # upper_ci = percent + Design.Factor * (upper_bound - percent),
           shs_ci = 100 * Design.Factor * 1.96 * sqrt((proportion * (1 - proportion))/Nw),
           lower_ci = percent - shs_ci, # produces some negative lower CIs, and upper CIs > 100, esp if Nw is small (too small for reliable estimates)
           upper_ci = percent + shs_ci) %>%
    select(-c(proportion, shs_ci, Design.Factor, no_wted, no_unwted)) %>%
    rename(nw = yes_wted, # renaming the positive counts to nw (weighted) and nuw (unweighted) at this point to avoid having got muddled with the no variables earlier
           nuw = yes_unwted) %>%
    pivot_longer(cols = c(nw, Nw, Nuw, nuw, percent, lower_ci, upper_ci), values_to = "value", names_to = "statistic") %>%
    mutate(var_label = var)
  
}

# Run the function:
aggd_volunteer <- shs_percent_analysis(shs_data3, "volunteer", "ind_wt")
aggd_rb1 <- shs_percent_analysis(shs_data3, "rb1", "ind_wt")
aggd_asb2a <- shs_percent_analysis(shs_data3, "asb2a", "ind_wt")
aggd_serv1h <- shs_percent_analysis(shs_data3, "serv1h", "ind_wt")
aggd_commbel <- shs_percent_analysis(shs_data3, "commbel", "ind_wt")
aggd_greenuse13 <- shs_percent_analysis(shs_data3, "greenuse13", "ind_wt")
aggd_social2 <- shs_percent_analysis(shs_data3, "social2", "ind_wt")
aggd_social3_02 <- shs_percent_analysis(shs_data3, "social3_02", "ind_wt")
aggd_discrim_new <- shs_percent_analysis(shs_data3, "discrim_new", "ind_wt")
aggd_harass_new <- shs_percent_analysis(shs_data3, "harass_new", "ind_wt")
#aggd_discrim1 <- shs_percent_analysis(shs_data3, "discrim1", "ind_wt")
#aggd_harass1 <- shs_percent_analysis(shs_data3, "harass1", "ind_wt")

aggd_loans <- shs_percent_analysis(shs_data3, "loans", "la_wt")
aggd_hk2 <- shs_percent_analysis(shs_data3, "hk2", "la_wt")

# Get all the resulting dataframes and rbind them
shs_results <- mget(ls(pattern = "^aggd_"), .GlobalEnv) %>%
  do.call(rbind.data.frame, .) %>%
  mutate(dataset = 'SHoS (UKDS data)',
         measure_type = "percent",
         year_label = case_when(year=="19992000" ~ "1999 to 2000",
                                year=="0102" ~ "2001 to 2002",
                                year=="20032004" ~ "2003 to 2004",
                                year=="0506" ~ "2005 to 2006",
                                year=="0708" ~ "2007 to 2008",
                                year=="2009-2010" ~ "2009 to 2010",
                                TRUE ~ year),
         year = as.numeric(substr(year_label, 1, 4))) %>%
  filter(!(spatial.scale=="SIMD" & is.na(spatial.unit))) %>% # some respondents didn't have SIMD data in early years (2009-2010 and 2011)
  # Some upper ci > 100 nd some lower_ci < 0.
  # Constrain these to be 100 and 0
  mutate(value = case_when(statistic=="upper_ci" & value>100 ~ 100,
                           statistic=="lower_ci" & value<0 ~ 0,
                           TRUE ~ value)) %>%
  filter(!(var_label %in% c("discrim1", "harass1"))) %>%
  filter(!(var_label %in% c("loans", "hk2") & sex %in% c("Female", "Male")))


# Save the indicator data

#arrow::write_parquet(shs_results, here("data", "shs_results.parquet"))
shs_results <- arrow::read_parquet(here("data", "shs_results.parquet"))


# 7. What are the smallest numbers? Any suppression issues?
# =================================================================================================================

# Unweighted bases
# =================================================================================================================
# SHS dashboard considerations on sample size:
# If base on which percentages are calculated is less than 50 = Such data are judged to be insufficiently reliable for publication. 
# Estimates with base numbers close to 50 should also be treated with caution.
# https://scotland.shinyapps.io/sg-scottish-household-survey-data-explorer/
# Check where bases <50
# 
shs_unweighted_bases <- shs_results %>%
  filter(statistic %in% c("Nuw"))

# National by sex
shs_unweighted_bases %>%
  filter(sex != "Total", spatial.scale == "Scotland") %>%
  ggplot(aes(year, value, group = sex, colour = sex, shape = sex)) +
  geom_point() + geom_line() +
  facet_wrap(~var_label, scales = "free_y")
# none <50

# SIMD by sex (male)
shs_unweighted_bases %>%
  filter(sex == "Male", spatial.scale == "SIMD") %>%
  ggplot(aes(year, value, group = spatial.unit, colour = spatial.unit, shape = spatial.unit)) +
  geom_point() + geom_line() +
  facet_wrap(~var_label, scales = "free_y")
# none <50

# HBs
shs_unweighted_bases %>%
  filter(sex == "Total", spatial.scale == "HB") %>%
  ggplot(aes(year, value, group = spatial.unit, colour = spatial.unit)) +
  geom_point() + geom_line() +
  facet_wrap(~var_label, scales = "free_y")
# none <50

# HBs by sex (male)
shs_unweighted_bases %>%
  filter(sex == "Male", spatial.scale == "HB") %>%
  ggplot(aes(year, value, group = spatial.unit, colour = spatial.unit)) +
  geom_point() + geom_line() +
  facet_wrap(~var_label, scales = "free_y")
# some HB in 2005 and 2011 have unweighted bases <50 (>=39) for the volunteer variable, males only.

# LAs by sex (male)
shs_unweighted_bases %>%
  filter(sex == "Male", spatial.scale == "LA") %>%
  ggplot(aes(year, value, group = spatial.unit, colour = spatial.unit)) +
  geom_point() + geom_line() +
  facet_wrap(~var_label, scales = "free_y")
# some LA in 2005 and 2011 have unweighted bases <50 (>=35) for the volunteer variable, males only.


# 8. Data amendments following data checks
# =================================================================================================================

# The data checks conducted in the script ukds_shs_checks confirmed very close agreement between the UKDS_derived indicators and data downloaded from the SHS dashboard.
# Data could be compared for 7 indicators: "commbel", "greenuse13", "hk2", "rb1", "volunteer", "harass_new", and "discrim_new" 
# Headline results of this QA:  
# 89% of the unweighted bases are identical (Differences seem to be largely due to rounding for small bases)
# 76% of the percentages are identical (and 90% are within 1%).
# Investigated some of the largest relative differences in the estimates: 
# again, looks like differences in the raw data (number of respondents) being processed for the SHS dashboard and that available to us through the UKDS. 
# SHS responded to an email* on 22 March 2024 saying that the UKDS data will have fewer respondents in them because of disclosure control.
# (*Prompted by discrim_new and harass_new indicators having 40-50 fewer respondents in the UKDS data)

# The close agreement confirms the accuracy of our data processing, but some very slight differences remain.
# We decided against replacing the UKDS data with SHS dashboard data, where available, as the dashboard only provided the % estimate and the unweighted base.
# A note will be needed to reflect the differences between the SHS dashboard and our calculations. 

# The unweighted base checks above also showed that Nuw for some breakdowns (HB/LA by sex) were below the SHS threshold of 50.
# For this reason we opted to remove HB/LA breakdowns by sex


# Conduct the suppression (remove HB/LA breakdowns by sex)
shs_results2 <- shs_results %>%
  # remove the breakdowns with sample sizes that are too small:
  filter(!(spatial.scale %in% c("HB", "LA") & !(sex=="Total")))  %>%
  # standardise year labels to match other data (e.g., 1999 to 2000 will become 1999-2000)
  mutate(year_label = case_when(nchar(year_label)>4 ~ gsub(" to ", "-", year_label),
                                TRUE ~ year_label),
         year = case_when(nchar(year_label)>4 ~ year+0.5,
                                TRUE ~ year))

# Save the indicator data

#arrow::write_parquet(shs_results2, here("data", "shs_results2.parquet"))
shs_results2 <- arrow::read_parquet(here("data", "shs_results2.parquet"))


# 9. Data availability
# =================================================================================================================

shs_percents <- shs_results2 %>% 
  filter(statistic=="percent") 

ftable(shs_percents$var_label, shs_percents$spatial.scale, shs_percents$sex , shs_percents$year_label)
# check that relevant year/sex combos have single Scotland estimates, 5 SIMD estimates, 32 LA estimates, and 14 HB estimates


# 10. Plot the indicator(s)
# =================================================================================================================
# Let's now see what the series and CIs look like:

# total
shs_results2 %>% 
  pivot_wider(names_from = statistic, values_from = value) %>%
  filter(sex == "Total", spatial.scale == "Scotland") %>% 
  ggplot(aes(year, percent, group = sex, colour = sex, shape = sex)) + 
  geom_point() + geom_line() +
  facet_wrap(~var_label, scales = "free_y") +
  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 

# sex
shs_results2 %>% 
  pivot_wider(names_from = statistic, values_from = value) %>%
  filter(sex != "Total", spatial.scale == "Scotland") %>% 
  ggplot(aes(year, percent, group = sex, colour = sex, shape = sex)) + 
  geom_point() + geom_line() +
  facet_wrap(~var_label, scales = "free_y") +
  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 

# simd
shs_results2 %>% 
  pivot_wider(names_from = statistic, values_from = value) %>%
  filter(sex == "Total", spatial.scale == "SIMD") %>% 
  ggplot(aes(year, percent, group = spatial.unit, colour = spatial.unit, shape = spatial.unit)) + 
  geom_point() + geom_line() +
  facet_wrap(~var_label, scales = "free_y") +
  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 

# hb, total pop
shs_results2 %>% 
  pivot_wider(names_from = statistic, values_from = value) %>%
  filter(sex == "Total", spatial.scale == "HB") %>% 
  ggplot(aes(year, percent, group = spatial.unit, colour = spatial.unit, shape = spatial.unit)) + 
  geom_point() + geom_line() +
  facet_wrap(~var_label, scales = "free_y") 
#+
#  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 

# la, total pop
shs_results2 %>% 
  pivot_wider(names_from = statistic, values_from = value) %>%
  filter(sex == "Total", spatial.scale == "LA") %>% 
  ggplot(aes(year, percent, group = spatial.unit, colour = spatial.unit, shape = spatial.unit)) + 
  geom_point() + geom_line() +
  facet_wrap(~var_label, scales = "free_y") 
#+
#  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 


# # CHECK THE DISCRIM AND HARASS VARS AGAINST THE SHES VERSIONS (DISCONTINUED):
# shes_vars <- arrow::read_parquet(here('data', 'shes_results2.parquet')) %>%
#   filter(var_label %in% c("haras_any", "disc_any"))
# shos_vars <- shs_results2 %>%
#   filter(var_label %in% c("discrim1", "discrim_new", "harass1", "harass_new"))
# discrim_and_harass <- rbind(shes_vars, shos_vars) %>%
#   pivot_wider(names_from = statistic, values_from = value)
# discrim_and_harass %>%
#   filter(spatial.unit == "Scotland" & sex=="Total" & var_label %in% c("discrim1", "discrim_new", "disc_any")) %>%
#   ggplot(aes(x=year, y=percent, colour = var_label, group = var_label)) +
#   geom_line() +
#   theme_bw() +
#   scale_y_continuous(limits=c(0, NA),
#                      expand = expansion(mult = c(0, 0.1)),
#                      labels = scales::comma)
# discrim_and_harass %>%
#   filter(spatial.unit == "Scotland" & sex=="Total" & var_label %in% c("harass1", "harass_new", "haras_any")) %>%
#   ggplot(aes(x=year, y=percent, colour = var_label, group = var_label)) +
#   geom_line() +
#   theme_bw() +
#   scale_y_continuous(limits=c(0, NA),
#                      expand = expansion(mult = c(0, 0.1)),
#                      labels = scales::comma)
