# ============================================================================
# ===== Processing UKDS survey data files: SCOTTISH HEALTH SURVEY (shes) =====
# ============================================================================

## NB. THE PROCESSING CAN TAKE A LOT OF MEMORY. IF THE SCRIPT FAILS, OPEN IT IN A SESSION WITH MORE MEMORY.

# Notes on SHeS

# 18 adult indicators: 

# 99107 = adt10gp_tw	(also in CWB and PA profiles) Percentage of adults who met the recommended moderate or vigorous physical activity guideline in the previous four weeks. In July 2011, the Chief Medical Officers of each of the four UK countries agreed and introduced revised guidelines on physical activity. Adults are recommended to accumulate 150 minutes of moderate activity or 75 minutes of vigorous activity per week, or an equivalent combination of both, in bouts of 10 minutes or more. The variable used was adt10gpTW. This bandings used for this variable include the new walking definition for those aged 65 years and over. 
# 99108 = gen_helf	(also in CWB profile) Percentage of adults who, when asked "How good is your health in general?", selected "good" or "very good". The five possible options ranged from very good to very bad, and the variable was GenHelf. 
# 99109 = limitill	(also in CWB profile) Percentage of adults who have a limiting long-term illness. Long-term conditions are defined as a physical or mental health condition or illness lasting, or expected to last, 12 months or more. A long-term condition is defined as limiting if the respondent reported that it limited their activities in any way. The variable used was limitill. 
# 30001 = wemwbs	Mean score on the WEMWBS scale (adults). WEMWBS stands for Warwick-Edinburgh Mental Wellbeing Scale. N.B. This indicator is also available from the ScotPHO Online Profiles (national, health board, and council area level, but not by SIMD). The questionnaire consists of 14 positively worded items designed to assess: positive affect (optimism, cheerfulness, relaxation) and satisfying interpersonal relationships and positive functioning (energy, clear thinking, self-acceptance, personal development, mastery and autonomy). It is scored by summing the response to each item answered on a 1 to 5 Likert scale ('none of the time', 'rarely', 'some of the time', often', 'all of the time'). The total score ranges from 14 to 70 with higher scores indicating greater wellbeing. The variable used was WEMWBS. 
# 30002 = life_sat	Mean score on the question "All things considered, how satisfied are you with your life as a whole nowadays?" (variable LifeSat).  N.B. This indicator is also available from the ScotPHO Online Profiles (national and council area level, but not by SIMD). Life satisfaction is measured by asking participants to rate, on a scale of 0 to 10, how satisfied they are with their life in general. On the scale, 0 represented 'extremely dissatisfied' and 10 'extremely satisfied' (the intervening scale points were numbered but not labelled). 
# 30052 = work_bal	Mean score for how satisfied adults are with their work-life balance (paid work). Respondents were asked "How satisfied are you with the balance between the time you spend on your paid work and the time you spend on other aspects of your life?" on a scale between 0 (extremely dissatisfied) and 10 (extremely satisfied). The intervening scale points were numbered but not labelled. The variable was WorkBal. 
# 30003 = gh_qg2	Percentage of adults with a possible common mental health problem. N.B. This indicator is also available from the ScotPHO Online Profiles (national, health board, and council area level, but not by SIMD). A score of four or more on the General Health Questionnaire-12 (GHQ-12) indicates a possible mental health problem over the past few weeks. GHQ-12 is a standardised scale which measures mental distress and mental ill-health. There are 12 questions which cover concentration abilities, sleeping patterns, self-esteem, stress, despair, depression, and confidence in the past few weeks. For each of the 12 questions one point is given if the participant responded 'more than usual' or 'much more than usual'. Scores are then totalled to create an overall score of zero to twelve. A score of four or more (described as a high GHQ-12 score) is indicative of a potential psychiatric disorder. Conversely a score of zero is indicative of psychological wellbeing. As GHQ-12 measures only recent changes to someone's typical functioning it cannot be used to detect chronic conditions. The variable used was GHQg2. 
# 30013 = porftvg3	Percentage of adults who met the daily fruit and vegetable consumption recommendation - five or more portions - in the previous day (survey variables porftvg3Intake and porftvg3). According to the guidelines, it is recommended for adults to consume at least five varied portions of fruit and vegetables per day. The module includes questions on consumption of the following food types in the 24 hours to midnight preceding the interview: vegetables (fresh, frozen or canned); salads; pulses; vegetables in composites (e.g. vegetable chilli); fruit (fresh, frozen or canned); dried fruit; fruit in composites (e.g. apple pie); fresh fruit juice. Fruit and vegetable consumption figures for 2021 have been calculated from online dietary recalls using INTAKE24. In 2021, less than half a portion of fruit and vegetables is defined as none. This is due to the inclusion of fruit and vegetables from composite dishes which has led to a decrease in the proportion consuming no fruit or vegetables. Data from earlier years were taken from the fruit and vegetable module. Fruit and vegetable consumption data for NHS health boards and council area areas for 2017-2021 combined are not available, as due to the different method of data collection, it was not possible to combine data for these years. Respondents to the INTAKE24 food diary were included if they had provided data for two days. 
# 30004 = depsymp	Percentage of adults who had a symptom score of two or more on the depression section of the Revised Clinical Interview Schedule (CIS-R). A score of two or more indicates symptoms of moderate to high severity experienced in the previous week. The variable used was depsymp (or dvg11 in 2008). 
# 30005 = anxsymp	Percentage of adults who had a symptom score of two or more on the anxiety section of the Revised Clinical Interview Schedule (CIS-R). A score of two or more indicates symptoms of moderate to high severity experienced in the previous week. The variable used was anxsymp (or dvj12 in 2008). 
# 30009 = suicide2	Percentage of adults who made an attempt to take their own life, by taking an overdose of tablets or in some other way, in the past year. The variable used was suicide2. 
# 30010 = dsh5sc	Percentage of adults who deliberately harmed themselves but not with the intention of killing themselves in the past year. The variable used was DSH5 from 2008 to 2011, or DSH5SC from 2013 onwards. 
# 30021 = involve	Percentage of adults who, when asked "How involved do you feel in the local community?", responded "a great deal" or "a fair amount". The four possible options ranged from "a great deal" to "not at all". The variables used were Involve and INVOLV19. 
# 30023 = p_crisis	Percentage of adults with a primary support group of three or more to rely on for comfort and support in a personal crisis. Respondents were asked "If you had a serious personal crisis, how many people, if any, do you feel you could turn to for comfort and support?", and the variables were PCrisis or PCRIS19. 
# 30051 = str_work2	Percentage of adults who find their job "very stressful" or "extremely stressful". Respondents were asked "In general, how do you find your job?" and were given options from "not at all stressful" to "extremely stressful". The variable was StrWork2. 
# 30053 = contrl	Percentage of adults who often or always have a choice in deciding how they do their work, in their current main job. The five possible responses ranged from "always" to "never". The variable was Contrl. 
# 30054 = support1	Percentage of adults who "strongly agree" or "tend to agree" that their line manager encourages them at work. The five options ranged from "strongly agree" to "strongly disagree". The variables used were Support1 and Support1_19. 
# 30026 = rg17a_new	Percentage of adults who provide 20 or more hours of care per week to a member of their household or to someone not living with them, excluding help provided in the course of employment. Participants were asked whether they look after, or give any regular help or support to, family members, friends, neighbours or others because of a long-term physical condition, mental ill-health or disability; or problems related to old age. Caring which is done as part of any paid employment is not asked about. From 2014 onwards, this question explicitly instructed respondents to exclude caring as part of paid employment. The variables used to construc this indicator were RG15aNew (Do you provide any regular help or care for any sick, disabled, or frail people?) and RG17aNew (How many hours do you spend each week providing help or unpaid care for him/her/them?). 

# 9 child indicators:
# 30130 = ch_ghq  Percentage of children aged 15 years or under who have a parent/carer who scores 4 or more on the General Health Questionnaire-12 (GHQ-12)
# 30129 = ch_audit  Percentage of children aged 15 years or under with a parent/carer who reports consuming alcohol at hazardous or harmful levels (AUDIT questionnaire score 8+)
# 30170	Peer relationship problems - Percentage of children with a 'slightly raised', 'high' or 'very high' score (a score of 3-10) on the peer relationship problems scale of the Strengths and Difficulties Questionnaire (SDQ)
# 99117	Total difficulties - Percentage of children with a 'slightly raised', 'high' or 'very high' total difficulties score (a score of 14-40) on the Strengths and Difficulties Questionnaire (SDQ). A total difficulties score of 14 or over is also referred to as borderline (14-16) or abnormal (17-40).
# 30172	Emotional symptoms - Percentage of children with a 'slightly raised', 'high' or 'very high' score (a score of 4-10) on the emotional symptoms scale of the Strengths and Difficulties Questionnaire (SDQ)
# 30173	Conduct problems - Percentage of children with a 'slightly raised', 'high' or 'very high' score (a score of 3-10) on the conduct problems scale of the Strengths and Difficulties Questionnaire (SDQ)
# 30174	Hyperactivity/inattention - Percentage of children with a 'slightly raised', 'high' or 'very high' score (a score of 6-10) on the hyperactivity/inattention scale of the Strengths and Difficulties Questionnaire (SDQ)
# 30175	Prosocial behaviour - Percentage of children with a 'close to average' score (a score of 8-10) on the prosocial scale of the Strengths and Difficulties Questionnaire (SDQ)
# 30111 % children meeting 1 hour PA per day


# Denominators = Total number of respondents answering the question. 'Don't know' is omitted, except for in the case of the caring hours indicator rg17a_new (where it is included in the denominator, on the assumption that people giving this response probably don't give more than 20 hours of care a week) 

# Survey weights = 
# 4 different types of weights need to be used, depending on the variable being analysed:
# main sample weights of the form int...wt
# VERA weights of the form vera...wt
# biological/nurse sample weights of the form bio...wt or nurs...wt
# child interview weights of the form cint..wt
# And from 2021 the fruit/veg indicator comes from a food diary, so uses intake24 weights. 

# The adult SIMD figures are age-standardised to the population of Scotland (in private households) to aid comparison between the quintiles. 
# This is the SHeS team approach, who advised on this calculation. The standardisation is achieved by adjusting the weights before the calculation is done.
# Note from SHeS dashboard re: age-standardisation:
# Age-standardisation was undertaken separately within each sex and it was carried out using the age groups: 
# 16-24, 25-34, 35-44, 45-54, 55-64, 65-74 and 75 and over. The standard population to which the age distribution of sub-groups was adjusted was the 
# mid-year private household population estimates for Scotland. The estimates used for each report can be found here:
# https://scotland.shinyapps.io/sg-scottish-health-survey/_w_df4c62c7/Private%20household%20population%20estimates,%202008-2021,%20Scotland.xlsx

# Survey design = psu and strata variables are used in the analysis (R package 'survey') to account for clustered survey design.

# Confidence intervals:
## CI calc uses Wilson's Score method:
## Commonly used public health statistics and their confidence intervals
## https://fingertips.phe.org.uk/documents/APHO%20Tech%20Briefing%203%20Common%20PH%20Stats%20and%20CIs.pdf

# Availability = varies by indicator. 

# Suppression: 
# On SHeS dashboard SG say: "To ensure the robustness of published findings, results are not presented where the unweighted bases are below 30 participants. 
#                                 Estimates with bases between 30 and 50 should also be treated with caution."
# We follow these suppression rules.

# More information:
# SHeS dashboard: https://scotland.shinyapps.io/sg-scottish-health-survey/
# SHeS web pages: https://www.gov.scot/collections/scottish-health-survey/
# =================================================================================================================


# WHAT DO YOU WANT TO DO?
# Reading in new SHeS data? Go through steps 1 to 7.
# If just needing previously processed data you can read in the processed adult and child data using the code at around lines 903 and 936.
# Or the raw data from the Prepared Data folder (ready to run prepare_final_files() ) at around line 1120



# Packages and functions
# =================================================================================================================

## A. Load in the packages

pacman::p_load(
  here, # for file paths within project/repo folders
  haven, # importing .dta files from Stata
  openxlsx, # reading and creating spreadsheets
  arrow, # work with parquet files
  survey, # analysing data from a clustered survey design
  reactable # required for the QA .Rmd file
)

## B. Source generic and specialist functions 

source(here("functions", "functions.R")) # sources the file "functions/functions.R" within this project/repo

# Source functions/packages from ScotPHO's scotpho-indicator-production repo 
# (works if you've stored the ScotPHO repo in same location as the current repo)
#source("../scotpho-indicator-production/1.indicator_analysis.R")
#source("../scotpho-indicator-production/2.deprivation_analysis.R")
# change wd first
setwd("../scotpho-indicator-production/")
source("functions/main_analysis.R") # for packages and QA function 
source("functions/deprivation_analysis.R") # for packages and QA function (and path to lookups)

# move back to the ScotPHO_survey_data repo
setwd("/conf/MHI_Data/Liz/repos/ScotPHO_survey_data")

## C. Path to the data derived by this script

derived_data <- "/conf/MHI_Data/derived data/"


# 1. Find survey data files, extract variable names and labels (descriptions), and save this info to a spreadsheet
# =================================================================================================================
# THIS STEP IS ONLY NEEDED WHEN NEW DATA ARE AVAILABLE (AND HAVE BEEN ADDED TO THE MHI_DATA FOLDERS). OTHERWISE MOVE TO STEP 2.

## A. Create a new workbook in this repo (only run this the first time)
#wb <- createWorkbook()
#saveWorkbook(wb, file = paste0(derived_data, "all_survey_var_info.xlsx"))

## B. Get all the variable names and their descriptions from the survey data files
# N.B. RUNNING THIS WILL TAKE ~5 MINS AND WILL MODIFY THE EXISTING SPREADSHEET:
save_var_descriptions(survey = "shes", # looks in this folder 
                       name_pattern = "\\/she?s\\D?(\\d{2,10})") # the regular expression for this survey's filenames that identifies the survey year(s)
# Unpicking the regular expression:
#    for shes this has to recognise filenames with either shes or shs in them (hence she?s, meaning the e is optional).
#    the year can be from 2 digits (e.g. 08) to many digits (e.g., 08091011) hence d{2,10}.
#    the year part is in brackets so that it gets extracted from the name for storage as a year field in the results

# What this function is doing:
#    Looks in the "shes" folder of "/conf/MHI_Data/big/big_mhi_data/unzipped/".
#    It's recursive so looks in all the sub-folders here too.
#    Finds any file matching the name pattern.
#    Runs the function extract_var_desc() to read in each file in turn (read_and_clean_dta() function) and extract all the variable names and variable descriptions from the file (get_var_desc() function).
#    Stores the information from all files, along with their year and file location, into a single dataframe.
#    Saves the dataframe to the workbook created in step A, as worksheet vars_shes. 
#    N.B. this will overwrite this worksheet if it already exists. 



# 2. Manual bit: which variables do we want to extract data for?
# =================================================================================================================

#    Look at the vars_'survey' tab of the spreadsheet all_survey_var_info.xlsx to work out which variables are required.
#    Manually store the relevant variables in the file R/vars_to_extract_'survey'.R
#    N.B. Important to identify grouping/analytical variables, as well as the variable(s) used for the indicator.
#    E.g., sex, health board, weights, survey design (psu and strata), age, simd.
#    Also important to see if the variable has different names in different years.


# 3. Extract the relevant survey data from the files 
# =================================================================================================================

## A. Extract the data we want:
# N.B. RUNNING THIS WILL OVERWRITE EXISTING DATA AND WILL TAKE ~5 MINS.
# LAST RUN 12 JAN 2026 (ADDITION OF CHILD SDQ VARS)
extracted_survey_data_shes <- extract_survey_data("shes") 
# What this function is doing:
#   Uses the file locations saved in the spreadsheet, and opens each file in turn.
#   Runs the function read_select() to read in the data for any variable listed in the vars_to_extract_xxx file.
#   Stores all the required data from a single file in a list in a dataframe.
#   The resulting dataframe contains the same number of rows as there are data files. 
#   All the required data are stored in the survey_data list column.
#   Further processing (below) is needed to standardise the variable names and convert to a flat file that is easier to use. 


## B. Keep only the survey files we are interested in (individual level (i) rather than household level (h))
# (These files could probably be avoided initially using a more complex reg expression in the save_var_descriptions() function call above)
extracted_survey_data_shes <- extracted_survey_data_shes %>%
  filter(!str_detect(filename, "she?s\\D?\\d{2,10}h")) %>% # this drops the shes household files ("h" follows the year for these files)
  filter(!str_detect(filename, "intake24"))  # this drops the shes intake24 files (the derived var we need is already in the individual file)
  

## C. Save the file (do this if new variables/data have been read in)
# saveRDS(extracted_survey_data_shes, paste0(derived_data, "extracted_survey_data_shes.rds"))


# 4. What are the possible responses? (needed so we can decide how to code each variable)
# =================================================================================================================

## A. Read the data back in if not in memory:
# extracted_survey_data_shes <- readRDS(paste0(derived_data, "extracted_survey_data_shes.rds"))

## B. Get all the possible responses that have been recorded for each variable (combined over the years), and save to xlsx and rds
# Running extract_responses() will modify existing spreadsheet and overwrite existing rds file

# 1st run through to see how to identify any variables that can be excluded (e.g., weights) (and the unique characters that will identify these):
# extract_responses(survey = "shes") 
# responses_as_list_shes <- readRDS(paste0(derived_data, "responses_as_list_shes.rds")))
# responses_as_list_shes  # examine the output
# 2nd run to exclude the numeric vars that don't need codings and/or muck up the output:
extract_responses(survey = "shes", #survey acronym
                  chars_to_exclude = c("wt", "age", "psu", "strata", "weighta", "par", "serial")) #we don't need to work out codings for these numeric vars (and they muck up the output)
# What this function does: 
#   Runs get_valid_responses() function for each variable in each survey file.
#   This extracts any character/factor data, converts to character, stores in a dataframe.
#   Variables containing any of the chars_to_exclude are dropped from the dataframe.
#   The dataframe containing all the unique variable-response pairs is saved as "responses_as_list_shes.rds" and 
#   also to a worksheet called responses_shes in the same spreadsheet as the original variables were. 

## C. Read the responses back in and print out so we can work out how they should be coded
# (also useful to see how sex/geography/simd variables have been recorded, for later standardisation)

responses_as_list_shes <- readRDS(paste0(derived_data, "responses_as_list_shes.rds"))

## D. Print out this list to the console and copy into this script for reference:
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?
responses_as_list_shes

###################################

# $adt10gp_tw
# [1] "Meets recommendations"   "Schedule not applicable" "Very low activity"       "Some activity"           "Low activity"            "Don't know"             
# [7] "Refused"                 "Not answered"            "Refused/ not answered"   "Refused\\ not answered"  "Refused/not answered"   
# 
# $anxsymp
# [1] "0"                       "Schedule not applicable" "Item not applicable"     "1"                       "4"                       "2"                      
# [7] "3"                       "schedule not applicable" "item not applicable"     "Refusal"                 NA                        "Don't know"             
# [13] "schedule not obtained"   "don't know"              "refused"                 "Not applicable"          "Refused"                 "Schedule not obtained"  
# 
# $anxsymp_t20
# [1] "0"          "1"          "4"          "3"          "2"          "Don't know" "Refused"   
# 
# $auditg
# [1] "0-7"                                      "8 or more (hazardous/harmful drinking"    "Schedule not applicable"                 
# [4] "Refused"                                  "Schedule not obtained"                    "Refusal"                                 
# [7] "Refused/not answered"                     "8 or more (hazardous / harmful drinking)" "Not applicable"                          
# 
# $c00sum7s
# [1] "Schedule not applicable"          "Group 1:60+min on all 7 days"     "Group 2:30-59min on all 7 days"   "Group 3:Lower level of activity" 
# [5] "Don't know"                       "Item not applicable"              "schedule not applicable"          "item not applicable"             
# [9] "don't know"                       "Dont know"                        NA                                 "Age 16+"                         
# [13] "Age 0-1"                          "Not applicable"                   "Group 1: 60+min on all 7 days"    "Group 2: 30-59min on all 7 days" 
# [17] "Group 3: Lower level of activity"
# 
# $contrl
# [1] "schedule not applicable" "Sometimes"               "Often"                   "Always"                  "Never"                   "don't know"             
# [7] "Seldom"                  "refused"                 NA                        "Item not applicable"     "Schedule not applicable" "Dont know"              
# [13] "Don't Know"              "Refusal"                 "Don't know"              "Refused"                 "Not applicable"         
# 
# $depsymp
# [1] "0"                       "Schedule not applicable" "Item not applicable"     "3"                       "1"                       "2"                      
# [7] "4"                       "schedule not applicable" "item not applicable"     "refused"                 "don't know"              "Don't know"             
# [13] "Refusal"                 "Dont know"               NA                        "schdule not obtained"    "Not applicable"          "Refused"                
# [19] "Schedule not obtained"  
# 
# $depsymp_t20
# [1] "0"          "3"          "2"          "1"          "Refused"    "4"          "Don't know"
# 
# $dsh5
# [1] "No"                      "Schedule not applicable" "Item not applicable"     "Yes"                     "Don't know"              "Don't Know"             
# [7] "Refusal"                 "item not applicable"     "refused"                 "Refused"                 NA                       
# 
# $dsh5sc
# [1] "Item not applicable"     "No"                      "Schedule not obtained"   "Yes"                     "Not applicable"          "Refusal"                
# [7] "Schedule not applicable" "Refused"                
# 
# $dvg11
# [1] "0"                       "Schedule not applicable" "Item not applicable"     "3"                       "1"                       "2"                      
# [7] "4"                      
# 
# $final_sex22
# [1] "Male"              "Female"            "Refused"           "Prefer not to say"
#
# $dvj12
# [1] "0"                       "Schedule not applicable" "Item not applicable"     "1"                       "4"                       "2"                      
# [7] "3"                      
# 
# $gen_helf
# [1] "Very good"     "Good"          "Bad"           "Fair"          "Very bad"      "Don't know"    "Refused"       "Don't Know"    "Refusal"       "refused"      
# [11] "don't know"    NA              "Dont know"     "...very good," "good,"         "bad, or"       "fair,"         "very bad?"    
# 
# $genhelf
# [1] "Very good"     "Fair"          "Good"          "Bad"           "Very bad"      "good,"         "...very good," "fair,"         "bad, or"       "very bad?"    
# 
# $gh_qg2
# [1] "Score 1-3"               "Schedule not applicable" "Score 0"                 "Score 4+"                "Schedule not obtained"   "Refused"                
# [7] "schedule not applicable" "refused"                 "schedule not obtained"   "Refusal"                 "Refused/not answered"    NA                       
# [13] "Don't know"              "Not applicable"         
# 
# $gh_qg2_t20
# [1] "Score 1-3"  "Score 0"    "Score 4+"   "Don't know" "Refused"   
# 
# $ghq2
# [1] "0"                     "1-3"                   "4 or more"             "Schedule not obtained" "Not answered"         
# 
# $ghqg2
# [1] "Score 0"                 "Score 1-3"               "not applicable"          "Score 4+"                "schedule not obtained"   "Schedule not applicable"
# [7] "No answer/refused"      
# 
# $hb_code
# [1] NA                            "Forth Valley"                "Fife"                        "Western Isles"               "Greater Glasgow and Clyde"  
# [6] "Grampian"                    "Lothian"                     "Ayrshire and Arran"          "Lanarkshire"                 "Tayside"                    
# [11] "Dumfries and Galloway"       "Highland"                    "Shetland"                    "Borders"                     "Orkney"                     
# [16] "SJ9 Greater Glasgow & Clyde" "SW9 Western Isles"           "SR9 Orkney"                  "ST9 Tayside"                 "SK9 Highland"               
# [21] "SA9 Ayrshire & Arran"        "SS9 Lothian"                 "SY9 Dumfries & Galloway"     "SV9 Forth Valley"            "SF9 Fife"                   
# [26] "SN9 Grampian"                "SL9 Lanarkshire"             "SZ9 Shetland"                "SB9 Borders"                 "10"                         
# [31] "7"                           "9"                           "11"                          "5"                           "2"                          
# [36] "3"                           "12"                          "8"                           "13"                          "6"                          
# [41] "1"                           "4"                           "14"                         
# 
# $hbcode
# [1] "Forth Valley"              "Fife"                      "Western Isles"             "Greater Glasgow"           "Grampian"                 
# [6] "Lothian"                   "Ayrshire and Arran"        "Lanarkshire"               "Tayside"                   "Dumfries and Galloway"    
# [11] "Highland"                  "Shetland"                  "Borders"                   "Orkney"                    NA                         
# [16] "7"                         "10"                        "5"                         "9"                         "12"                       
# [21] "4"                         "2"                         "1"                         "6"                         "3"                        
# [26] "13"                        "8"                         "14"                        "11"                        "Greater Glasgow and Clyde"
# 
# $hboard
# [1] "Dumfries & Galloway" "Fife"                "Greater Glasgow"     "Ayreshire & Arran"   "Borders"             "Tayside"             "Grampian"           
# [8] "Orkney"              "Forth Valley"        "Lothian"             "Argyll & Clyde"      "Highland"            "Lanarkshire"         "Western Isles"      
# [15] "Shetland"            "SF9"                 "SH9"                 "SC9"                 "SG9"                 "SS9"                 "SL9"                
# [22] "SV9"                 "SZ9"                 "SA9"                 "ST9"                 "SN9"                 "SB9"                 "SY9"                
# [29] "SW9"                 "SR9"                
# 
# $hlth_brd
# [1] "Fife"                    "Forth Valley"            "Lothian"                 "Borders"                 "Orkney"                  "Greater Glasgow & Clyde"
# [7] "Tayside"                 "Grampian"                "Ayrshire & Arran"        "Western Isles"           "Highland"                "Lanarkshire"            
# [13] "Dumfries & Galloway"     "Shetland"                "Greater"                 "Ayrshire and Arran"      "Dumfries and Galloway"  
# 
# $hlthbrd
# [1] "Lothian"                 "Lanark"                  "Forth Valley"            "Fife"                    "Ayrshire & Arran"        "Glasgow"                
# [7] "Argyll & Clyde"          "Highland & Islands"      "D & G"                   "Grampian"                "Tayside"                 "Borders"                
# [13] "Highland"                "Greater Glasgow"         "Lanarkshire"             "Shetland"                "Dumfries & Galloway"     "Western Isles"          
# [19] "Orkney"                  "Greater Glasgow & Clyde" NA                        "Greater"                 "Ayrshire and Arran"      "Dumfries and Galloway"  
# 
# $involv19
# [1] "Not applicable"          "A fair amount"           "Not very much"           "Schedule not applicable" "A great deal"            "Not at all"             
# [7] "Schedule not obtained"   "Refused"                 "Don't know"             
# 
# $involve
# [1] "Not very much"           "schedule not applicable" "A great deal"            "A fair amount"           "Not at all"              "refused"                
# [7] "item not applicable"     "don't know"              NA                        "Schedule not applicable" "Refusal"                 "Item not applicable"    
# [13] "Dont know"               "Don't Know"              "Don't know"              "Refused"                 "Not applicable"         
# 
# $life_sat
# [1] "8"                          "Schedule not applicable"    "9"                          "5"                          "6"                         
# [6] "10 - Extremely satisfied"   "7"                          "3"                          "0 - Extremely dissatisfied" "4"                         
# [11] "2"                          "1"                          "Don't know"                 "Refused"                    "Don't Know"                
# [16] "Refusal"                    "schedule not applicable"    "don't know"                 "refused"                    NA                          
# [21] "Dont know"                  "Item not applicable"       
# 
# $limitill
# [1] "No LI"           "Non limiting LI" "Limiting LI"     "Don't know"      "Refused"         "refused"         "don't know"      "Refusal"         "Don't Know"     
# [10] "-9"              NA                "Dont know"       "Not answered"   "No answer/refused"
# 
# $number_of_recalls
# [1] "2"              "Not applicable" "1"             
# 
# $p_crisis
# [1] "12"                      "schedule not applicable" "4"                       "10"                      "5"                       "6"                      
# [7] "7"                       "2"                       "15"                      "1"                       "8"                       "3"                      
# [13] "14"                      "0"                       "refused"                 "9"                       "item not applicable"     "don't know"             
# [19] "11"                      "13"                      NA                        "Schedule not applicable" "Refusal"                 "Item not applicable"    
# [25] "Dont know"               "not applicable"          "Don't Know"              "Don't know"              "Not applicable"          "Refused"                
# 
# $pcris19
# [1] "Not applicable"          "7"                       "5"                       "Schedule not applicable" "4"                       "3"                      
# [7] "10"                      "6"                       "20"                      "8"                       "Schedule not obtained"   "1"                      
# [13] "Refused"                 "12"                      "16"                      "2"                       "0"                       "11"                     
# [19] "35"                      "30"                      "15"                      "14"                      "9"                       "13"                     
# [25] "40"                      "32"                      "18"                      "25"                      "415"                     "50"                     
# [31] "70"                      "100"                     "23"                      "28"                      "410"                     "24"                     
# [37] "19"                      "22"                      "Don't know"              "200"                     "17"                      "29"                     
# [43] "49"                      "73"                      "37"                     
# 
# $person
# [1] "2"  "1"  "3"  "4"  "5"  "6"  "7"  "10" "11" "12" "8"  "9"  NA  
# 
# $porftvg3
# [1] "5 portions or more"      "Less than 5 portions"    "None"                    "Schedule not applicable" "Refused"                 "schedule not applicable"
# [7] "refused"                 "Refusal"                 "Refused/not answered"    NA                       
# 
# $porftvg3intake
# [1] "5 portions or more"          "0.5 to less than 5 portions" "Not applicable"              "None/less than 0.5"         
# 
# $region
# [1] "Lothian & Fife"               "Lanark etc"                   "Argyll etc"                   "Glasgow"                      "Highland & Islands"          
# [6] "Borders/D & G"                "Grampian & Tayside"           "Borders, Dumfries & Galloway" "Glagow"                       "Lanarkshire,Ayrshire & Arran"
# [11] "Highlands & Islands"          "Forth Valley, Argyll & Clyde"
# 
# $rg15a_new
# [1] "Item not applicable"     "No"                      "Schedule not applicable" "Yes"                     "Don't Know"              "Not applicable"         
# [7] "Don't know"              "Refused"                 "Refusal"                
# 
# $rg17a_new
# [1] "Item not applicable"                    "Schedule not applicable"                "Up to 4 hours a week"                   "5 - 19 hours a week"                   
# [5] "50 or more hours a week"                "20 - 34 hours a week"                   "Varies (spontaneous - not on showcard)" "35 - 49 hours a week"                  
# [9] "Not applicable"                         "Don't Know"                             "Varies"                                 "Don't know"                            
# 
# $sdq_cong
# [1] "Schedule not applicable" "0-2"                     "4-10"                    "3"                       "No answer/refused"       "Schedule not obtained"  
# [7] "Refused"                 "schedule not applicable" "schedule not obtained"   "Refusal"                 "Refused/not answered"    NA                       
# [13] "Not applicable"         
# 
# $sdq_emog
# [1] "Schedule not applicable" "0-3"                     "5-10"                    "4"                       "No answer/refused"       "Schedule not obtained"  
# [7] "Refused"                 "schedule not applicable" "schedule not obtained"   "Refusal"                 "Refused/not answered"    NA                       
# [13] "Not applicable"         
# 
# $sdq_hypg
# [1] "Schedule not applicable" "0-5"                     "7-10"                    "6"                       "No answer/refused"       "Schedule not obtained"  
# [7] "Refused"                 "schedule not applicable" "schedule not obtained"   "Refusal"                 "Refused/not answered"    NA                       
# [13] "Not applicable"         
# 
# $sdq_peeg
# [1] "Schedule not applicable" "0-2"                     "4-10"                    "3"                       "No answer/refused"       "Schedule not obtained"  
# [7] "Refused"                 "schedule not applicable" "schedule not obtained"   "Refusal"                 "Refused/not answered"    NA                       
# [13] "Not applicable"         
# 
# $sdq_pro
# [1] "Schedule not applicable" "10"                      "9"                       "2"                       "4"                       "8"                      
# [7] "5"                       "7"                       "6"                       "8.75"                    "1"                       "6.25"                   
# [13] "No answer/refused"       "7.5"                     "3"                       "1.25"                    "8.33333333333333"        "Schedule not obtained"  
# [19] "0"                       "Refused"                 "3.75"                    "1.66666666666667"        "schedule not applicable" "schedule not obtained"  
# [25] "2.5"                     "Refusal"                 "Refused/not answered"    NA                        "6.66666666666667"        "Not applicable"         
# 
# $sdq_totg
# [1] "Schedule not applicable" "0-13"                    "17-40"                   "14-16"                   "No answer/refused"       "Schedule not obtained"  
# [7] "Refused"                 "schedule not applicable" "schedule not obtained"   NA                        "Not applicable"         
# 
# $sex
# [1] "Female" "Male"  NA      
# 
# $simd16_s_ga
# [1] "Most deprived"  "4"              "3"              "2"              "Least deprived" "Not applicable"
# 
# $simd20_r_pa
# [1] "4th"            "3rd"            "Most deprived"  "2nd"            "Least deprived"
# 
# $simd20_s_ga
# [1] "4"              "3"              "Most deprived"  "2"              "Least deprived"
# 
# $simd20_sga
# [1] "4"              "3"              "Most deprived"  "2"              "Least deprived"
# 
# $simd5
# [1] "Least deprived (0.5393 - 7.7347)"  "(7.7354 - 13.5231)"                "(13.5303 - 21.0301)"               "(21.0421 - 33.5214)"              
# [5] "(33.5277 - 87.5665) most deprived"
# 
# $simd5_s_ga
# [1] "3rd"                   "2nd"                   " 5th - least deprived" "4th"                   "1st - most deprived"   "3"                    
# [7] "2"                     "Least deprived"        "4"                     "Most deprived"         "most deprived"         "least deprived"       
# [13] "Not applicable"       
# 
# $simd5_sg
# [1] "3rd"                  "5th - least deprived" "2nd"                  "4th"                  "1st - most deprived"  NA                     "3"                   
# [8] "4"                    "1"                    "2"                    "5"                   
# 
# $str_work2
# [1] "schedule not applicable"       "moderately stressful"          "not at all/mildly stressful"   "don't know"                    "very/extremely stressful"     
# [6] "refused"                       NA                              "Item not applicable"           "Schedule not applicable"       "Refusal"                      
# [11] "Don't know"                    "Moderately stressful"          "Very/extremely stressful"      "Not at all/mildly stressful"   "Refused"                      
# [16] "Not at all / Mildly stressful" "Very / Extremely stressful"    "Not applicable"                "Not at all / mildly stressful" "Very / extremely stressful"   
# 
# $suicide2
# [1] "No"                                      "Schedule not applicable"                 "Item not applicable"                    
# [4] "Yes longer than year"                    "-5"                                      "Yes in last year (inc last week)"       
# [7] "schedule not applicable"                 "item not applicable"                     "refused"                                
# [10] "Don't know"                              "Refusal"                                 "Dont know"                              
# [13] NA                                        "Not applicable"                          "Refused"                                
# [16] "Yes in last year (including last week)"  "Never"                                   "Yes, in last year (including last week)"
# [19] "Yes, longer than year"                   "Schedule not obtained"                  
# 
# $support1
# [1] "schedule not applicable" "Tend to agree"           "Tend to disagree"        "Not_Apply"               "Strongly agree"          "Neutral"                
# [7] "don't know"              "Strongly disagree"       "refused"                 NA                        "Item not applicable"     "Schedule not applicable"
# [13] "Dont know"               "Don't Know"              "Don't know"              "Refusal"                 "Does not apply"          "Refused"                
# [19] "Not applicable"         
# 
# $support1_19
# [1] "Not applicable"          "Schedule not applicable" "Tend to agree"           "Strongly agree"          "Tend to disagree"        "Strongly disagree"      
# [7] "Neutral"                 "Does not apply"          "CAPI routing error"      "Refused"                 "Don't know"             
# 
# $wemwbs
# [1] "39"                      "Schedule not applicable" "50"                      "57"                      "41"                      "56"                     
# [7] "53"                      "58"                      "33"                      "46"                      "59"                      "54"                     
# [13] "52"                      "42"                      "49"                      "35"                      "60"                      "51"                     
# [19] "Refused"                 "63"                      "45"                      "31"                      "48"                      "38"                     
# [25] "30"                      "20"                      "66"                      "43"                      "47"                      "62"                     
# [31] "28"                      "40"                      "Schedule not obtained"   "44"                      "55"                      "68"                     
# [37] "65"                      "64"                      "25"                      "32"                      "36"                      "37"                     
# [43] "26"                      "34"                      "70"                      "17"                      "27"                      "61"                     
# [49] "67"                      "22"                      "69"                      "16"                      "24"                      "29"                     
# [55] "23"                      "14"                      "18"                      "21"                      "19"                      "15"                     
# [61] "schedule not applicable" "refused"                 "Refusal"                 NA                        "Don't know"              "Not applicable"         
# 
# $wemwbs_t20
# [1] "44"         "49"         "48"         "51"         "Don't know" "65"         "54"         "53"         "57"         "43"         "64"         "56"        
# [13] "47"         "66"         "24"         "38"         "55"         "35"         "61"         "Refused"    "60"         "39"         "52"         "63"        
# [25] "23"         "42"         "59"         "69"         "45"         "58"         "67"         "70"         "62"         "41"         "50"         "26"        
# [37] "68"         "40"         "29"         "37"         "34"         "20"         "36"         "46"         "14"         "28"         "33"         "27"        
# [49] "21"         "31"         "32"         "22"         "30"         "19"        
# 
# $work_bal
# [1] "schedule not applicable"    "6"                          "5"                          "8"                          "10 - Extremely satisfied"  
# [6] "7"                          "don't know"                 "4"                          "3"                          "2"                         
# [11] "0 - Extremely dissatisfied" "9"                          "1"                          "refused"                    NA                          
# [16] "Item not applicable"        "Schedule not applicable"    "Dont know"                  "Don't Know"                 "Refusal"                   
# [21] "Don't know"                 "Refused"                    "Not applicable"   

###################################



# 5. How should the responses be coded?
# =================================================================================================================
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?

# Create lookups to code the variables into the dichotomy needed for the indicators:
# (each lookup needs to contain all response versions including the range of punctuation and capitalisation used)

# Lookups as lists: 
# "yes" indicates a case (summed later to give numerator)
# "no" indicates an alternative response (not a case) that should be included in the denominator

# physical activity indicator
lookup_adt10gp_tw <- list(
  "Meets recommendations"="yes",
  "Low activity"="no", 
  "Some activity"="no", 
  "Very low activity"="no")

# For recoding anxsymp and dvj12
lookup_anxsymp<- list(
  "2"="yes", 
  "3"="yes", 
  "4"="yes",
  "0"="no", 
  "1"="no" 
)

# For recoding child PA (c00sum7s)
lookup_childpa1hr <- list(
  "Group 1:60+min on all 7 days" ="yes",    
  "Group 1: 60+min on all 7 days" ="yes",   
  "Group 2:30-59min on all 7 days" ="no",  
  "Group 3:Lower level of activity" ="no",
  "Group 2: 30-59min on all 7 days" ="no",
  "Group 3: Lower level of activity" ="no"
)

# choice at work
lookup_contrl <- list(
  "Always"="yes", 
  "Often"="yes",
  "Never"="no", 
  "Seldom"="no", 
  "Sometimes"="no"  
)

# For recoding depsymp and dvg11
lookup_depsymp <- list(
  "2"="yes", 
  "3"="yes", 
  "4"="yes",
  "0"="no", 
  "1"="no"
)

# deliberate self-harm
lookup_dsh5sc <- list(
  "Yes"="yes",
  "No"="no"
)

# general health
lookup_gen_helf <- list( 
  "...very good,"="yes", 
  "Good"="yes", 
  "good,"="yes", 
  "Very good"="yes",
  "Bad"="no", 
  "bad, or"="no", 
  "Fair"="no", 
  "fair,"="no", 
  "Very bad"="no", 
  "very bad?"="no"
)

# GHQ caseness
# For recoding gh_qg2, ghqg2 and ghq2
lookup_gh_qg2 <- list( # trying to recreate the published data (SHeS dashboard) confirmed that 'don't know' and refused/not answered are excluded from calcs
  "Score 4+"="yes",
  "4 or more"="yes",
  "0"="no", 
  "1-3"="no",
  "Score 0"="no", 
  "Score 1-3"="no"
)


# For recoding involve and involv19
lookup_involve <- list(
  "A fair amount"="yes", 
  "A great deal"="yes",
  "Not at all"="no", 
  "Not very much"="no"
)


lookup_limitill <- list(
  "Limiting LI"="yes",
  "No LI"="no", 
  "Non limiting LI"="no"
)

# For recoding porftvg3 and porftvg3intake
lookup_porftvg3 <- list(
  "5 portions or more"="yes",
  "Less than 5 portions"="no", 
  "None"="no",
  "0.5 to less than 5 portions"="no", 
  "None/less than 0.5"="no",
  "2 portions or more but less than 3"="no",
  "3 portions or more but less than 4"="no",
  "4 portions or more but less than 5"="no",
  "1 portion or more but less than 2"="no",
  "Less than 1 portion"="no"
)

# Unpaid caring
lookup_rg17a_new <- list( 
  # we opted to treat those responding 'varies' and 'don't know' as unlikely to be giving 20+ hours care/week, and to include them in the denominator only. 
  # It's possible these answers were given by respondents who didn't know which of the 3 20+ hours categories their caregiving fell into, but we cannot know. 
  "20 - 34 hours a week"="yes", 
  "35 - 49 hours a week"="yes", 
  "50 or more hours a week"="yes",
  "5 - 19 hours a week"="no", 
  "Varies"="no", 
  "Varies (spontaneous - not on showcard)"="no", 
  "Up to 4 hours a week" = "no",
  "Don't know"= "no", 
  "Don't Know"= "no"
)

# For recoding sdq_totg
lookup_sdq_totg <- list(
  "14-16"="yes", 
  "17-40"="yes",
  "0-13"="no"
)

# For recoding sdq_cong
lookup_sdq_cong <- list(
  "4-10"="yes",                     
  "3"="yes",
  "0-2"="no" 
)

# For recoding sdq_emog
lookup_sdq_emog <- list(
  "5-10"="yes",                     
  "4"="yes",
  "0-3"="no" 
)

# For recoding sdq_hypg
lookup_sdq_hypg <- list(
  "7-10"="yes",                     
  "6"="yes",
  "0-5"="no" 
)

# For recoding sdq_peeg
lookup_sdq_peeg <- list(
  "4-10"="yes",                     
  "3"="yes",
  "0-2"="no" 
)

# Stress at work
lookup_str_work2 <- list(
  "Very / extremely stressful"="yes", 
  "Very / Extremely stressful"="yes", 
  "very/extremely stressful"="yes", 
  "Very/extremely stressful"="yes",
  "moderately stressful"="no", 
  "Moderately stressful"="no", 
  "Not at all / mildly stressful"="no", 
  "Not at all / Mildly stressful"="no",
  "not at all/mildly stressful"="no", 
  "Not at all/mildly stressful"="no" 
)

# Attempted suicide
lookup_suicide2 <- list(
  "Yes in last year (inc last week)"="yes", 
  "Yes in last year (including last week)"="yes", 
  "Yes, in last year (including last week)"="yes",
  "Never"="no", 
  "No"="no", 
  "Yes longer than year"="no", 
  "Yes, longer than year"="no" 
)

# For recoding support1 and support1_19
lookup_support1 <- list(
  "Strongly agree"="yes", 
  "Tend to agree"="yes",
  "Neutral"="no", 
  "Strongly disagree"="no", 
  "Tend to disagree"="no" 
)

# CYP MHI indicators:

# For recoding auditg
lookup_auditg <- list(
  "0-7"="no",
  "8 or more (hazardous/harmful drinking"="yes",
  "8 or more (hazardous / harmful drinking)"="yes" 
)

# For recoding sex/sexresp/final_sex22
lookup_sex <- list(
  "Female"="Female",
  "Male"="Male" 
)

# 6. Initial processing of the survey data: creating a flat file with harmonised variable names.
# =================================================================================================================

## A: How are grouping variables (geogs and SIMD) coded in each survey file? Need standardising?

# cross tabulate years and variables, to see what's available when  
shes_years_vars <- extracted_survey_data_shes %>%
  transmute(year,
            var_label = map(survey_data, names)) %>%
  unnest(var_label) %>%
  arrange(var_label) %>%
  mutate(value=1) %>%
  filter(year!="20") %>% #drop 2020 survey as experimental and not comparable
  filter(!grepl("^bio|^int|^nurs|^vera|^weight|^cint|serial", var_label))  %>% # drop the weights and serial numbers
  pivot_wider(names_from=year, values_from = value) 

  
# This shows some issues that need to be rectified before the dataframe can be 'unlisted' into a flat file:
# 1. File years 03, 12, 13, 14, 1214, and 121314 use 2 HB variables. 
 # hboard and hlthbrd used in 03: keep hlthbrd here (text), as hboard contains codes
 # hbcode and hlth_brd used in 12, 1214, 14 data (keep hlth_brd as it is consistently text in these files)
 # hbcode and hlthbrd used in 13 (keep hlthbrd as it's text)
 # hb_code and hlth_brd used in 121314 (keep hlth_brd as it's text)
 # hbcode and hb_code are used inconsistently (see responses_as_list_shes above): don't use when hlth_brd or hlthbrd are also used (i.e., in the years noted above).
# 2. 2015-18 survey uses two SIMDs (simd5_s_ga for 2015 and simd16_s_ga for 2016-18): harmonise these into "simd_combo" before aggregating
# 3. 1995 and 1998 don't have SIMD data: exclude


## B. Create lookups for harmonising var names and coding:

# lookups:
hb_lookup <- c(hb = "hboard", hb = "hbcode", hb = "hb_code", hb = "hlth_brd", hb = "hlthbrd")
simd_lookup <- c(quintile = "simd5", quintile = "simd20_s_ga", quintile = "simd16_s_ga", quintile = "simd5_sg", 
                 quintile = "simd5_s_ga", quintile = "simd20_sga", quintile = "simd_combo", quintile = "simd20_r_pa") # r_pa needed for 2022. check its coding.
age_lookup <- c(age = "age", age = "respage") # respage used in 1995
sex_lookup <- c(sex = "sex", sex = "final_sex22", sex = "respsex") # respsex used in 1995, final_sex22 used in 2022
indserial_lookup <- c(indserial="cpseriala",  indserial="pserial", indserial="pserial_a", indserial="cpserial_a", indserial="cp_serial_a", indserial="serialx")
hhserial_lookup <- c(hhserial="chh_serial_a", hhserial="chhserial_a", hhserial="chhseriala", hhserial="chserial_a", hhserial="hhserial", hhserial="hserial_a")

# derive lookup for years where only a numeric hbcode is provided (hbcode in 1213 and 1618, hb_code in 1921):
# checked when hbcode/hb_code is provided alongside a character hb field, and all code the same: alphabetically
# extract codings from 2014 file: 
hbcodes <- extracted_survey_data_shes[[4]][[18]] %>%
  group_by(hbcode, hlth_brd) %>%
  summarise() %>%
  ungroup()  
# these are hard-coded into the pipe below


## C. Process the survey microdata before calculating indicator estimates:
# Lots of steps here. If not processing new data the files shes_adult_data and shes_child_data can be read in after these 
# (currently around lines 912 and 951)

# Drop years we don't want:
# drop 2020 survey as experimental and not comparable. 1995 and 1998 don't have SIMD, and have old HBs. 2003 has old HBs too.
shes_data <- extracted_survey_data_shes %>%
  filter(!year %in% c("95", "98", "03", "20")) 
# keep only single year and 4-year aggregations:
shes_data <- shes_data %>% 
  mutate(year = ifelse(year=="2022", "22", year)) %>%
  filter(nchar(year)==2|nchar(year)==8)
  
# Harmonise HB variable names and coding: (working within list column, hence use of 'map' function)
shes_data <- shes_data %>%
  mutate(survey_data = map(survey_data, ~ .x %>% # map() here means this is all being done within the individual items in the list column, while retaining the list format
                             mutate(across(.cols = everything(), as.character)) %>% # some factors muck up the processing otherwise. Will convert some vars back to numeric eventually. 
                             # ensure there's only a single HB variable each year
                             { if (length(grep("hlth_brd|hbcode|hlthbrd|hb_code|hboard", names(.))) > 1) select(., -starts_with("hb")) else .} %>% # drop hb* when there are two hb vars (see logic above)
                             rename(any_of(hb_lookup)) %>% # apply the lookup defined above to rename all hb vars as 'hb'
                             # Standardise HB names for matching with ScotPHO geo_lookup
                             mutate(spatial.unit = case_match(hb,
                                                    "1" ~ "Ayrshire and Arran",   
                                                    "2" ~ "Borders",              
                                                    "3" ~ "Dumfries and Galloway",
                                                    "4" ~ "Fife",                 
                                                    "5" ~ "Forth Valley",         
                                                    "6" ~ "Grampian",             
                                                    "7" ~ "Greater Glasgow & Clyde",             
                                                    "8" ~ "Highland",             
                                                    "9" ~ "Lanarkshire",          
                                                    "10" ~ "Lothian",              
                                                    "11" ~ "Orkney",               
                                                    "12" ~ "Shetland",             
                                                    "13" ~ "Tayside",              
                                                    "14" ~ "Western Isles",
                                                    "Greater" ~ "Greater Glasgow & Clyde",
                                                    "Greater Glasgow" ~ "Greater Glasgow & Clyde",
                                                    "Greater Glascow and Clyde" ~ "Greater Glasgow & Clyde",
                                                    .default = hb)) %>%
                             mutate(spatial.unit = gsub(" and ", " & ", spatial.unit),
                                    spatial.unit = case_when(!spatial.unit=="NA" ~ paste0("NHS ", spatial.unit),
                                                   TRUE ~ as.character(NA)),
                                    spatial.scale = "Health board")))


# Harmonise SIMD variable names and coding: 
shes_data <- shes_data %>%
  mutate(survey_data = map(survey_data, ~ .x %>% # map() here means this is all being done within the individual items in the list column, while retaining the list format
                           coalesce_simd() %>% # harmonise SIMD so there's just one per survey (function defined in functions file)
                             { if (length(grep("simd20_s_ga|simd20_r_pa|simd20_sga", names(.))) > 1) select(., -contains("simd20_s")) else .} %>%
                             rename(any_of(simd_lookup)) %>% # apply the lookup defined above to rename all simd vars as 'quintile'
                           #Standardise the SIMD var labels (keep numeric for now, for the deprivation analysis. ScotPHO text labels added later)
                           mutate(quintile = case_when(
                             quintile %in% c("Most deprived", "1st - most deprived", "most deprived", "(33.5277 - 87.5665) most deprived" ) ~ "1",
                             quintile %in% c("2nd", "(21.0421 - 33.5214)") ~ "2",
                             quintile %in% c("3rd", "(13.5303 - 21.0301)") ~ "3",
                             quintile %in% c("4th", "(7.7354 - 13.5231)") ~ "4",
                             quintile %in% c(" 5th - least deprived", "Least deprived", "Least deprived (0.5393 - 7.7347)",
                                             "least deprived", "5th - least deprived") ~ "5",
                             TRUE ~ quintile)
                           )
                           ))

# Harmonise age, sex, and identifier variable names as required:
shes_data <- shes_data %>%
  mutate(survey_data = map(survey_data, ~ .x %>% # map() here means this is all being done within the individual items in the list column, while retaining the list format
                             rename(any_of(age_lookup)) %>% # apply the lookup defined above to rename all age vars to "age"
                             rename(any_of(sex_lookup)) %>% # apply the lookup defined above to rename all sex vars to "sex"
                             mutate(sex = recode(sex, !!!lookup_sex, .default = as.character(NA))) %>% # the 'Refused' and 'Prefer not to say' cats from 2022 get stored as NA here
                             # All versions of individual serial numbers: rename as indserial
                             # drop cpserial_a when pserial_a is also used (in 2010: Liz checked this, and pserial_a is the one we need here)
                             { if (length(grep("cpserial_a|pserial_a", names(.)))>1) select(., -cpserial_a) else .} %>%
                             rename(any_of(indserial_lookup)) %>% 
                             # All versions of household serial numbers: rename as hhserial
                             rename(any_of(hhserial_lookup)))) 
                
# Harmonise the names of the weights (all have the year in them currently):
shes_data <- shes_data %>%
  mutate(survey_data = map(survey_data, ~ .x %>% # map() here means this is all being done within the individual items in the list column, while retaining the list format
                             rename(intwt = starts_with("int") ) %>% 
                             rename(verawt = starts_with("vera")) %>%
                             rename(bio_wt = starts_with("bio") |  starts_with("nurs")) %>% # biowt called nurswt in early years
                             rename(intakewt = starts_with("s") & ends_with("wt_sc")) %>%
                             rename(cintwt = starts_with("cint")))) # child interview weight

# Add age groups: for the SIMD age-standardisation, and for identification of children (0-15y)
shes_data <- shes_data %>%
  mutate(survey_data = map(survey_data, ~ .x %>% # map() here means this is all being done within the individual items in the list column, while retaining the list format
                             filter(!is.na(age)) %>% # 0911 file has a lot of missing data rows in it, so this clear this up
                             mutate(age = as.numeric(age)) %>%
                             mutate(agegp7 = case_when(between(age, 16, 24) ~ "16-24", 
                                                       between(age, 25, 34) ~ "25-34",
                                                       between(age, 35, 44) ~ "35-44",
                                                       between(age, 45, 54) ~ "45-54",
                                                       between(age, 55, 64) ~ "55-64",
                                                       between(age, 65, 74) ~ "65-74",
                                                       age >=75 ~ "75+",
                                                       TRUE ~ as.character(NA))) %>% # 0-15y 
                             mutate(child = between(age, 0, 15)))) 
  

# Ready to unlist the df to create a flat file:
shes_data <- shes_data %>%
  mutate(survey_data = map(survey_data, ~ .x %>% # map() here means this is all being done within the individual items in the list column, while retaining the list format
                             mutate(across(c(psu, strata, ends_with("wt")), as.numeric)))) %>% 
  unnest(cols = c(survey_data)) # Produce a flat file by unnesting the list column


# Do some data checks, now unnested:
table(shes_data$sex, shes_data$year, useNA = "always") # Female/Male; some NA from 2022 (include in Totals)
table(shes_data$quintile, shes_data$year, useNA = "always") # 5 bands; no NAs
table(shes_data$spatial.unit, useNA = "always") # 14 HBs as expected, no NA
table(shes_data$age, useNA = "always") # 0 to 103y; no NAs


# Combine indicators that have two different names in the data
shes_data <- shes_data %>%
  # coalesce the indicator vars with two different names
  mutate(involve = coalesce(involve, involv19)) %>%
  mutate(support1 = coalesce(support1, support1_19)) %>%
  mutate(p_crisis = coalesce(p_crisis, pcris19)) %>%
  mutate(dsh5sc = coalesce(dsh5sc, dsh5)) %>%
  mutate(depsymp = coalesce(depsymp, dvg11)) %>% 
  mutate(anxsymp = coalesce(anxsymp, dvj12)) %>%
  #mutate(gen_helf = coalesce(gen_helf, genhelf)) %>% # years with genhelf now excluded before this point
  #mutate(gh_qg2 = coalesce(ghqg2, gh_qg2)) %>% # years with ghqg2 now excluded before this point
  # delete the redundant vars now
  select(-c(involv19, support1_19, pcris19, dsh5, dvg11, dvj12)) 


# Convert some variables to numeric where appropriate
shes_data <- shes_data %>%
  mutate(across(c(life_sat, work_bal), ~ substr(., 1, 2))) %>% # 0 and 10 have text in them, so this command just selects the numeric part
  mutate(across(c(p_crisis, wemwbs, life_sat, work_bal, sdq_pro), as.numeric))  
#gives warning for non-numeric data in each (e.g., refused, not applicable...)
  

# Recode the variables
shes_data <- shes_data %>%  
  
  # Variables with simple recoding:
  mutate(adt10gp_tw = recode(adt10gp_tw, !!!lookup_adt10gp_tw, .default = as.character(NA))) %>%
  mutate(contrl = recode(contrl, !!!lookup_contrl, .default = as.character(NA))) %>%
  mutate(gen_helf = recode(gen_helf, !!!lookup_gen_helf, .default = as.character(NA))) %>%
  mutate(gh_qg2 = recode(gh_qg2, !!!lookup_gh_qg2, .default = as.character(NA))) %>%
  mutate(limitill = recode(limitill, !!!lookup_limitill, .default = as.character(NA))) %>%
  mutate(str_work2 = recode(str_work2, !!!lookup_str_work2, .default = as.character(NA))) %>%
  mutate(suicide2 = recode(suicide2, !!!lookup_suicide2, .default = as.character(NA))) %>%
  mutate(involve = recode(involve, !!!lookup_involve, .default = as.character(NA))) %>%
  mutate(support1 = recode(support1, !!!lookup_support1, .default = as.character(NA))) %>%
  mutate(dsh5sc = recode(dsh5sc, !!!lookup_dsh5sc, .default = as.character(NA))) %>%
  mutate(depsymp = recode(depsymp, !!!lookup_depsymp, .default = as.character(NA))) %>%
  mutate(anxsymp = recode(anxsymp, !!!lookup_anxsymp, .default = as.character(NA))) %>%
  mutate(auditg = recode(auditg, !!!lookup_auditg, .default = as.character(NA))) %>%
  mutate(sdq_totg = recode(sdq_totg, !!!lookup_sdq_totg, .default = as.character(NA))) %>%
  mutate(sdq_peeg = recode(sdq_peeg, !!!lookup_sdq_peeg, .default = as.character(NA))) %>%
  mutate(sdq_cong = recode(sdq_cong, !!!lookup_sdq_cong, .default = as.character(NA))) %>%
  mutate(sdq_hypg = recode(sdq_hypg, !!!lookup_sdq_hypg, .default = as.character(NA))) %>%
  mutate(sdq_emog = recode(sdq_emog, !!!lookup_sdq_emog, .default = as.character(NA))) %>%
  mutate(childpa1hr = recode(c00sum7s, !!!lookup_childpa1hr, .default = as.character(NA))) %>%
  
  # Portions of fruit and veg: variable changed in 2021
  mutate(porftvg3 = recode(porftvg3, !!!lookup_porftvg3, .default = as.character(NA))) %>%
  # porftvg3intake data only in 2021 so far, so not in an aggregated file, but could require processing once more data are added
 # mutate(porftvg3intake = recode(porftvg3intake, !!!lookup_porftvg3, .default = as.character(NA))) %>% # porftvg3intake variable (from food diary) only used if number_of_recalls == 2
 # mutate(porftvg3intake = case_when(number_of_recalls %in% c("1", "Not applicable") ~ as.character(NA),
 #                                   TRUE ~ porftvg3intake)) %>% # in 2021 porftvg3 is only valid if number_of_recalls == 2, so recode other options as NA. Earlier years won't have anything but NA for the recall var. 
  
  # Hours of unpaid caring needs coding from 2 vars:
  mutate(rg17a_new = recode(rg17a_new, !!!lookup_rg17a_new, .default = as.character(NA))) %>%
  mutate(rg17a_new = case_when(is.na(rg17a_new) & rg15a_new %in% c("Yes", "No", "Don't know", "Don't Know") ~ "no", # need rg15a_new (Do you provide any regular help or care for any sick, disabled or frail person?) to identify those who give no caring per week (0 hrs not included in rg17a_new)
                               TRUE ~ rg17a_new)) %>% # makes sure those who don't give care are also counted
  
  # People you can turn to in a crisis:
  mutate(p_crisis = case_when(p_crisis >= 3 ~ "yes", # no lookup as easier to work with this var as numeric
                              p_crisis < 3 ~ "no", 
                              TRUE ~ as.character(NA))) %>%
  
  # SDQ prosocial score 8-10:
  mutate(sdq_pro = case_when(sdq_pro >= 8 ~ "yes", # no lookup as easier to work with this var as numeric
                             sdq_pro < 8 ~ "no", 
                              TRUE ~ as.character(NA))) %>%

  # keep only the vars required for the analysis
  select(-c(filename, fileloc, #number_of_recalls, # will be required for future porftvg3intake variable processing (but not currently)
            rg15a_new)) %>%
  select(year, ends_with("wt"), psu, strata, sex, agegp7, age, spatial.unit, spatial.scale, quintile, everything())


# Add trend_axis (character) and numeric year variables 
shes_data <- shes_data %>%  
  mutate(trend_axis = case_when(nchar(year)==2 ~ paste0("20", year), # e.g., "08" -> "2008"
                                nchar(year)==4 ~ paste0("20", substr(year, 1, 2), "-", "20", substr(year, 3, 4)), # e.g., "1516" -> "2015-2016"
                                nchar(year)==6 ~ paste0("20", substr(year, 1, 2), "-", "20", substr(year, 5, 6)), # e.g., "151617" -> "2015-2017"
                                nchar(year)==8 ~ paste0("20", substr(year, 1, 2), "-", "20", substr(year, 7, 8)), # e.g., "15161718" -> "2015-2018"
                                TRUE ~ as.character(NA)), # shouldn't be any...
         # Replicating the standard used elsewhere in ScotPHO: year = the midpoint of the year range, rounded up if decimal
         year = case_when(nchar(trend_axis)==4 ~ as.numeric(trend_axis), 
                          nchar(trend_axis)>4 ~ rnd(0.5*(as.numeric(substr(trend_axis, 6, 9)) + as.numeric(substr(trend_axis, 1, 4)))), # e.g., "2015-2018" -> "2017" or "2015-2016" to "2016"
                          TRUE ~ as.numeric(NA))) # shouldn't be any...


## D. Load the population data for the age-standardisation of SIMD results:

# Age-standardisation requires mid-year private household population estimates (see methodology note on the SHeS dashboard)
# (downloaded from https://scotland.shinyapps.io/sg-scottish-health-survey/_w_4523e40893ec40a5b3860eef4fcb525e/Private%20household%20population%20estimates,%202008-2021,%20Scotland.xlsx)
# (updated data 2018-21 obtained by request from NRS statisticscustomerservices@nrscotland.gov.uk, and Stefania.Sechi@nrscotland.gov.uk in the household estimates department)

# Read in the data from spreadsheets
shes_source_dir <- "/conf/MHI_Data/big/big_mhi_data/unzipped/shes"
private_pops_2008to18 <- read.xlsx(here(shes_source_dir, "Private household population estimates, 2008-2018, Scotland.xlsx"),
                                   startRow = 3, rows = c(3:17)) 
private_pops_2019to21 <- read.xlsx(here(shes_source_dir, "NRS-private-population-scotland-2018-21.xlsx"),
                                   sheet = "private population 2018-21",
                                   startRow = 2, rows = c(2:16)) %>%
  select(-"2018") # duplicates data in the 2008to18 spreadsheet, so can drop here
private_pops_2022to23 <- read.xlsx(here(shes_source_dir, "NRS - 2025 - 047 - Private household population estimates - 28 August 2025.xlsx"),
                                   sheet = "Private hhold pop",
                                   startRow = 4, rows = c(4:18)) 

# Combine the data, and manipulate so it can be merged into the SHeS respondent data
private_pops <- private_pops_2008to18 %>%
  merge(y = private_pops_2019to21) %>%
  merge(y = private_pops_2022to23) %>%
  rename(sex=Sex,
         agegp7 = Age.group) %>%
  pivot_longer(cols = c(-sex, -agegp7), names_to = "year", values_to = "scotpop", names_transform = list(year = as.integer)) %>%
  group_by(year, sex) %>%
  mutate(totpop = sum(scotpop)) %>%
  ungroup() %>%
  mutate(prop_pop = rnd4dp(scotpop / totpop)) %>% # the proportion of the population in each age group, by year and sex
  select(year, sex, agegp7, prop_pop) 
# Inconsistency in which year's pop data were used for which year's SIMD standardisation by the SHeS team:
# SHeS team used the pop from the same year for the 2008 to 2011 surveys, and pop from the previous year thereafter. 
# I have opted to match consistently to the year in each survey file's year column (rounded-up midpoint if multi-year)


# merge in the private household pops for age standardisation purposes
shes_data <- shes_data %>%  
  merge(y=private_pops, by = c("agegp7", "year", "sex"), all.x=TRUE) 

# save intermediate df:
#arrow::write_parquet(shes_data, paste0(derived_data, "shes_data.parquet"))
# read back in if not in memory:
#shes_data <- arrow::read_parquet(paste0(derived_data, "shes_data.parquet"))




# 7. Split data into adult and child subsets
# =================================================================================================================

## A: Subset off the adult indicators
# repeat all rows of the data with sex=="Total" & restrict to adults
shes_adult_data <- shes_data %>%
  mutate(sex="Total") %>%
  rbind(shes_data) %>%
  filter(!child) %>%
  select(-c(child, contains("serial"), starts_with("par"), cintwt, age))
# save intermediate df:
#arrow::write_parquet(shes_adult_data, paste0(derived_data, "shes_adult_data.parquet"))
# read back in if not in memory:
#shes_adult_data <- arrow::read_parquet(paste0(derived_data, "shes_adult_data.parquet"))


## B. Keep a selection of the adult variables for linking to child data (will link if an individual is listed as a parent/carer of the child)
# subset adult data to merge with child data:
parent_data <- shes_data %>%
  filter(!child) %>% # keep 16+
  select(trend_axis, contains("serial"), person, auditg, gh_qg2) # the parent variables of interest for the CYP mental health indicators

# Subset off the data to form the child indicators 
shes_child_data <- shes_data %>%
  filter(child) %>% # keep 0-15
  select(year, trend_axis, contains("serial"), par1, par2, 
         cintwt, psu, strata, sex, age, spatial.unit, spatial.scale, quintile, 
         starts_with("sdq"), childpa1hr) %>%
  merge(y=parent_data, by.x=c("trend_axis", "hhserial", "par1"), by.y = c("trend_axis", "hhserial", "person"), all.x=TRUE) %>% #1st parent/carer in hhd
  merge(y=parent_data, by.x=c("trend_axis", "hhserial", "par2"), by.y = c("trend_axis", "hhserial", "person"), all.x=TRUE) %>% #2nd parent/carer in hhd
  # calculate the new child MHIs using the data for both parents (.x and .y)
  mutate(ch_ghq = case_when(gh_qg2.x=="yes" | gh_qg2.y=="yes" ~ "yes", # yes if either parent has GHQ>4
                            gh_qg2.x=="no" | gh_qg2.y=="no" ~ "no", # otherwise no (if the data were collected)
                            TRUE ~ as.character(NA)), # NA if no data (question not asked / 'don't know'/refused/not answered)
         ch_audit = case_when(auditg.x=="yes" | auditg.y=="yes" ~ "yes", # yes if either parent has harmful/hazardous (8+) AUDIT score
                              auditg.x=="no" | auditg.y=="no" ~ "no", # otherwise no (if the data were collected)
                              TRUE ~ as.character(NA)))  # NA if no data (question not asked / 'don't know'/refused/not answered)

# final child data (add in sex=total)
shes_child_data <- shes_child_data %>%
  mutate(sex="Total") %>%
  rbind(shes_child_data) %>%
  mutate(agegp = case_when(age %in% c(0:3) ~ "0-3 years",
                           age %in% c(4:6) ~ "4-6 years",
                           age %in% c(7:9) ~ "7-9 years",
                           age %in% c(10:12) ~ "10-12 years",
                           age %in% c(13:15) ~ "13-15 years",
                           TRUE ~ as.character(NA))) %>%
  select(year, trend_axis, cintwt, spatial.unit, spatial.scale, quintile, psu, strata, sex, agegp, 
         ch_ghq, ch_audit, starts_with("sdq"), childpa1hr)

# save intermediate df:
#arrow::write_parquet(shes_child_data, paste0(derived_data, "shes_child_data.parquet"))
# read back in if not in memory:
#shes_child_data <- arrow::read_parquet(paste0(derived_data, "shes_child_data.parquet"))

# Data checks:
table(shes_child_data$trend_axis, shes_child_data$ch_ghq)
# GHQ data for parents of children all years and aggregated years since 2008
table(shes_child_data$trend_axis, shes_child_data$ch_audit)
# AUDIT data for parents of children from 2012, but some missings (related to 2018 and 2022)
table(shes_child_data$trend_axis, shes_child_data$childpa1hr)
# From SHeS dashboard notes: Data is not available for 2017 and 2018 (and hence 2015-18 and 2017-21) due to differences in the way the data was collected for these years which means that the estimates for these years are not comparable with the other SHeS surveys.
table(shes_child_data$trend_axis, shes_child_data$sdq_peeg)
table(shes_child_data$trend_axis, shes_child_data$sdq_cong)
table(shes_child_data$trend_axis, shes_child_data$sdq_hypg)
table(shes_child_data$trend_axis, shes_child_data$sdq_emog)
table(shes_child_data$trend_axis, shes_child_data$sdq_totg)
table(shes_child_data$trend_axis, shes_child_data$sdq_pro)

# Do some more data checks:

# Adult data
# Groupings:
table(shes_adult_data$trend_axis, useNA = "always") # 2008 to 2022; no NA
table(shes_adult_data$sex, useNA = "always") # Female/Male/Total; 82 NA (2022)
table(shes_adult_data$quintile, useNA = "always") # 5 groups; no NAs
table(shes_adult_data$spatial.unit, useNA = "always") # 14 HBs; no NAs 
table(shes_adult_data$agegp7, useNA = "always") # no NAs

# 18 categorical indicators:
table(shes_adult_data$gh_qg2, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_adult_data$porftvg3, useNA = "always") # just yes, no and NA, so coding has worked
#table(shes_adult_data$porftvg3intake, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_adult_data$gen_helf, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_adult_data$limitill, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_adult_data$depsymp, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_adult_data$anxsymp, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_adult_data$involve, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_adult_data$p_crisis, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_adult_data$str_work2, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_adult_data$contrl, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_adult_data$support1, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_adult_data$suicide2, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_adult_data$dsh5sc, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_adult_data$rg17a_new, useNA = "always") # just yes, no and NA, so coding has worked

# 3 numeric indicators:
table(shes_adult_data$work_bal, useNA = "always") # just numeric and NA, so coding has worked
table(shes_adult_data$wemwbs, useNA = "always") # all numeric and NA, so coding has worked
table(shes_adult_data$life_sat, useNA = "always") # all numeric and NA, so coding has worked


# Child data
# Groupings:
table(shes_child_data$trend_axis, useNA = "always") # 2008 to 2022; no NA
table(shes_child_data$sex, useNA = "always") # Female/Male/Total; 2 NA
table(shes_child_data$quintile, useNA = "always") # 5 groups; no NAs
table(shes_child_data$spatial.unit, useNA = "always") # 14 HBs; no NA 
table(shes_child_data$agegp7, useNA = "always") # none (as expected)

# 9 categorical indicators:
table(shes_child_data$ch_ghq, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_child_data$ch_audit, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_child_data$childpa1hr, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_child_data$sdq_totg, useNA = "always") # just yes, no and NA, so coding has worked. All are 4-12years.
table(shes_child_data$sdq_peeg, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_child_data$sdq_cong, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_child_data$sdq_hypg, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_child_data$sdq_emog, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_child_data$sdq_pro, useNA = "always") # just yes, no and NA, so coding has worked





# 8. Calculate indicator values by various groupings
# =================================================================================================================

# These survey calculation functions are in the functions.R script
# There are some warnings that appear: a deprecated bit (I can't find where to change this) and some 'NAs introduced by coercion'. These are OK.

# #test runs:
# df = shes_adult_data
# var = "gh_qg2"
# wt = "intwt"
# ind_id = 30003
# type= "percent"

# df=shes_child_data
# var="ch_ghq"
# wt="cintwt"
# ind_id=30130
# type= "percent"


# ADULT

# percents:

# 1. intwt used with main sample variables 
svy_percent_gh_qg2 <- calc_indicator_data(df = shes_adult_data, var = "gh_qg2", wt = "intwt", ind_id = 30003, type= "percent") # ok
svy_percent_gen_helf <- calc_indicator_data(shes_adult_data, "gen_helf", "intwt", ind_id=99108, type= "percent") # ok
svy_percent_limitill <- calc_indicator_data(shes_adult_data, "limitill", "intwt", ind_id=99109, type= "percent") # ok 
svy_percent_adt10gp_tw <- calc_indicator_data(shes_adult_data, "adt10gp_tw", "intwt", ind_id=99107, type= "percent") # ok
svy_percent_porftvg3 <- calc_indicator_data(shes_adult_data, "porftvg3", "intwt", ind_id=30013, type= "percent") # ok
svy_percent_rg17a_new <- calc_indicator_data(shes_adult_data, "rg17a_new", "intwt", ind_id=30026, type= "percent") # ok

# 2. verawt used for vera vars: National and SIMD only (samples too small for HB) 
svy_percent_involve <- calc_indicator_data(shes_adult_data, "involve", "verawt", ind_id=30021, type= "percent") # ok
svy_percent_p_crisis <- calc_indicator_data(shes_adult_data, "p_crisis", "verawt", ind_id=30023, type= "percent") # ok
svy_percent_str_work2 <- calc_indicator_data(shes_adult_data, "str_work2", "verawt", ind_id=30051, type= "percent") # ok
svy_percent_contrl <- calc_indicator_data(shes_adult_data, "contrl", "verawt", ind_id=30053, type= "percent") # ok
svy_percent_support1 <- calc_indicator_data(shes_adult_data, "support1", "verawt", ind_id=30054, type= "percent") # ok

# 3. biowt used with verb/bio sample variables (earlier surveys have nursxxwt not bioxxwt):
# National and SIMD only (samples too small for HB) (use single or 2y agg data?)
svy_percent_depsymp <- calc_indicator_data(shes_adult_data, "depsymp", "bio_wt", ind_id=30004, type= "percent") # ok
svy_percent_anxsymp <- calc_indicator_data(shes_adult_data, "anxsymp", "bio_wt", ind_id=30005, type= "percent") # ok
svy_percent_dsh5sc <- calc_indicator_data(shes_adult_data, "dsh5sc", "bio_wt", ind_id=30010, type= "percent") # ok
svy_percent_suicide2 <- calc_indicator_data(shes_adult_data, "suicide2", "bio_wt", ind_id=30009, type= "percent") # ok

# # 4. intake24 wt used with intake24 porftvg3 variable (from 2021)
# svy_percent_porftvg3intake <- calc_indicator_data(shes_adult_data, "porftvg3intake", "intakewt") # ok

# scores:

# 1. intwts used with main sample variables 
svy_score_wemwbs <- calc_indicator_data(shes_adult_data, "wemwbs", "intwt", ind_id=30001, type= "score") # ok
svy_score_life_sat <- calc_indicator_data(shes_adult_data, "life_sat", "intwt", ind_id=30002, type= "score") # ok

# 2. verawt used for vera vars: National and SIMD only (samples too small for HB) 
svy_score_work_bal <- calc_indicator_data(shes_adult_data, "work_bal", "verawt", ind_id=30052, type= "score") # ok


# CHILDREN

# 1. cintwt used with main sample variables 
svy_percent_ch_ghq <- calc_indicator_data(shes_child_data, "ch_ghq", "cintwt", ind_id=30130, type= "percent")  # ok
svy_percent_ch_audit <- calc_indicator_data(shes_child_data, "ch_audit", "cintwt", ind_id=30129, type= "percent")  # ok
svy_percent_childpa1hr <- calc_indicator_data(shes_child_data, "childpa1hr", "cintwt", ind_id=30111, type= "percent")  %>% # ok
  mutate(split_value = ifelse(split_value=="0-3 years", "2-3 years", split_value))
svy_percent_sdq <- calc_indicator_data(shes_child_data, "sdq_totg", "cintwt", ind_id=99117, type= "percent")  # ok
svy_percent_sdq_peer <- calc_indicator_data(shes_child_data, "sdq_peeg", "cintwt", ind_id=30170, type= "percent")  # ok
svy_percent_sdq_emo <- calc_indicator_data(shes_child_data, "sdq_emog", "cintwt", ind_id=30172, type= "percent")  # ok
svy_percent_sdq_cond <- calc_indicator_data(shes_child_data, "sdq_cong", "cintwt", ind_id=30173, type= "percent")  # ok
svy_percent_sdq_hyp <- calc_indicator_data(shes_child_data, "sdq_hypg", "cintwt", ind_id=30174, type= "percent")  # ok
svy_percent_sdq_pro <- calc_indicator_data(shes_child_data, "sdq_pro", "cintwt", ind_id=30175, type= "percent")  # ok

# Let's check that all ages are available when split_name="Age", and that there are sufficient denominators (>30 for SHeS)
make_denom_table <- function(df) {
  
  df %>% 
    filter(split_name == "Age group") %>%
    select(trend_axis, split_value, denominator) %>%
    pivot_wider(names_from = split_value, values_from = denominator) %>%
    print(n = 30) 
  
}

make_denom_table(svy_percent_ch_ghq) # 0 to 15y
make_denom_table(svy_percent_ch_audit) # 0 to 15y
make_denom_table(svy_percent_childpa1hr) # 2 to 15y
make_denom_table(svy_percent_sdq) # 4 to 12 years
make_denom_table(svy_percent_sdq_peer) # 4 to 12 years
make_denom_table(svy_percent_sdq_emo) # 4 to 12 years
make_denom_table(svy_percent_sdq_cond) # 4 to 12 years
make_denom_table(svy_percent_sdq_hyp) # 4 to 12 years
make_denom_table(svy_percent_sdq_pro) # 4 to 12 years
# Yep, all denoms >30 and most >100


# 9. Combine all the resulting indicator data into a single file
###############################################################################

shes_results0 <- mget(ls(pattern = "^svy_"), .GlobalEnv) %>% # finds all the dataframes produced by the functions above
  do.call(rbind.data.frame, .)  #rbinds them all together (appending the rows)

# drop the row names
rownames(shes_results0) <- NULL 

# save intermediate df:
#arrow::write_parquet(shes_results0, paste0(derived_data, "shes_results0.parquet"))
# read back in if not in memory:
#shes_results0 <- arrow::read_parquet(paste0(derived_data, "shes_results0.parquet"))

# Check the splits are ok:
table(shes_results0$split_name, shes_results0$split_value, useNA="always")
# Three splits (age, SIMD, and sex) available
# No split_names or split_values are blank.
# Each split_name has a Total category.
# This is correct

# Check the deprivation splits have 6 rows each (5 quintiles + 1 total)
# Deprivation data, keep all the totals that match each breakdown (Scotland x indicator x sex x trend_axis)
shes_results1 <- shes_results0 %>% # from 26267 to 26063
  group_by(trend_axis, sex, indicator, ind_id, code, year, def_period, split_name) %>%
  mutate(count = n()) %>%
  ungroup() %>%
  filter(!(split_name=="Deprivation (SIMD)" & count<6)) %>% # 1 if only a total provided, 2 if only one quintile could be calculated in addition to the total.
  select(-count, -quintile) 

# Availability by HB
hb_data <- shes_results1 %>%
  filter(substr(code, 1, 3)=="S08" & nchar(trend_axis)>4)  # all HB data
ftable(hb_data$indicator, hb_data$split_value, hb_data$sex, hb_data$year)  
# Full HB coverage for all indicators

# 6 adult vars from SHeS main sample are available from the published data (statistics.gov.scot, see SHeS script in the ScotPHO-indicator-production repo).
# The UKDS data can supplement those published data with SIMD x sex data (Scotland). Just keep that breakdown here:
published_vars <- c("gh_qg2", "gen_helf", "limitill",
                      "adt10gp_tw", "porftvg3", "wemwbs")

published_to_keep <- shes_results1 %>%
  filter(indicator %in% published_vars & 
           substr(code, 1, 3)=="S00" & 
           split_name=="Deprivation (SIMD)" & 
           sex %in% c("Male", "Female")) 

shes_results1 <- shes_results1 %>%
  filter(!indicator %in% published_vars) %>% 
  rbind(published_to_keep) 


# data checks:
table(shes_results1$trend_axis, useNA = "always") # 2008 to 2022, na NA
table(shes_results1$sex, useNA = "always") # Male, Female, Total 
table(shes_results1$indicator, useNA = "always") # 27 vars (18 adult, 9 child), no NA
table(shes_results1$year, useNA = "always") # 2008 to 2022
table(shes_results1$def_period, useNA = "always") # Aggregated years () and Survey year (), no NA
table(shes_results1$split_name, useNA = "always") # Deprivation, Age, or Sex, no NA
table(shes_results1$split_value, useNA = "always") # 1 to 5, M/F/Total, 0y to 15y, no NA
# all good

# Suppress values where necessary:
# SHeS suppress values where denominator (unweighted base) is <30
shes_results1 <- shes_results1 %>%
  mutate(across(.cols = c(numerator, rate, lowci, upci),
                .fns = ~case_when(denominator < 30 ~ as.numeric(NA),
                                  TRUE ~ as.numeric(.x)))) 

# get indicator names into more informative names for using as filenames
shes_raw_data <- shes_results1 %>%
  mutate(indicator = case_when( indicator == "gh_qg2" ~ "common_mh_probs",    
                                indicator == "gen_helf" ~ "self_assessed_health",  
                                indicator == "limitill" ~ "limiting_long_term_condition",  
                                indicator == "adt10gp_tw" ~ "physical_activity",
                                indicator == "porftvg3" ~ "fruit_veg_consumption",  
                                indicator == "rg17a_new" ~ "unpaid_caring", 
                                indicator == "wemwbs" ~ "mental_wellbeing",    
                                indicator == "life_sat" ~ "life_satisfaction",  
                                indicator == "ch_ghq" ~ "cyp_parent_w_ghq4",    
                                indicator == "ch_audit" ~ "cyp_parent_w_harmful_alc",
                                indicator == "involve" ~ "involved_locally",  
                                indicator == "p_crisis" ~ "support_network", 
                                indicator == "str_work2" ~ "stress_at_work",
                                indicator == "contrl" ~ "choice_at_work",   
                                indicator == "support1" ~ "line_manager", 
                                indicator == "depsymp" ~ "depression_symptoms",  
                                indicator == "anxsymp" ~ "anxiety_symptoms",  
                                indicator == "dsh5sc" ~ "deliberate_selfharm",   
                                indicator == "suicide2" ~ "attempted_suicide",
                                indicator == "work_bal" ~ "work-life_balance",
                                indicator == "sdq_totg" ~ "cyp_sdq_totaldiffs",
                                indicator == "childpa1hr" ~ "cyp_pa_over_1h_per_day",
                                indicator == "sdq_totg" ~ "cyp_sdq_totaldiffs",
                                indicator == "sdq_peeg" ~ "cyp_sdq_peer",
                                indicator == "sdq_cong" ~ "cyp_sdq_conduct",
                                indicator == "sdq_hypg" ~ "cyp_sdq_hyperactivity",
                                indicator == "sdq_emog" ~ "cyp_sdq_emotional",
                                indicator == "sdq_pro" ~ "cyp_sdq_prosocial",
                                TRUE ~ as.character(NA)  )) %>%
  select(-denominator) 

# save data ----
saveRDS(shes_raw_data, file = paste0(profiles_data_folder, '/Prepared Data/shes_raw.rds'))
#shes_raw_data <- readRDS(file = paste0(data_folder, 'Prepared Data/shes_raw.rds'))


# 10. Import into the SHeS script in scotpho-indicator-production repo and prepare final files there. 
###############################################################################




## END