# ============================================================================
# ===== Processing UKDS survey data files: SCOTTISH HEALTH SURVEY (shes) =====
# ============================================================================

## NB. THE PROCESSING CAN TAKE A LOT OF MEMORY. IF THE SCRIPT FAILS, OPEN IT IN A SESSION WITH MORE MEMORY.

# Notes on SHeS

# 25 adult indicators: 

# 99107 = adt10gp_tw2	(also in CWB and PA profiles) Percentage of adults who met the recommended moderate or vigorous physical activity guideline in the previous four weeks. In July 2011, the Chief Medical Officers of each of the four UK countries agreed and introduced revised guidelines on physical activity. Adults are recommended to accumulate 150 minutes of moderate activity or 75 minutes of vigorous activity per week, or an equivalent combination of both, in bouts of 10 minutes or more. The variable used was adt10gpTW. This bandings used for this variable include the new walking definition for those aged 65 years and over. 
# 99108 = gen_helf	(also in CWB profile) Percentage of adults who, when asked "How good is your health in general?", selected "good" or "very good". The five possible options ranged from very good to very bad, and the variable was GenHelf2. 
# 99109 = limitill2	(also in CWB profile) Percentage of adults who have a limiting long-term illness. Long-term conditions are defined as a physical or mental health condition or illness lasting, or expected to last, 12 months or more. A long-term condition is defined as limiting if the respondent reported that it limited their activities in any way. The variable used was limitill. 
# 30001 = wemwbs	Mean score on the WEMWBS scale (adults). WEMWBS stands for Warwick-Edinburgh Mental Wellbeing Scale. N.B. This indicator is also available from the ScotPHO Online Profiles (national, health board, and council area level, but not by SIMD). The questionnaire consists of 14 positively worded items designed to assess: positive affect (optimism, cheerfulness, relaxation) and satisfying interpersonal relationships and positive functioning (energy, clear thinking, self-acceptance, personal development, mastery and autonomy). It is scored by summing the response to each item answered on a 1 to 5 Likert scale ('none of the time', 'rarely', 'some of the time', often', 'all of the time'). The total score ranges from 14 to 70 with higher scores indicating greater wellbeing. The variable used was WEMWBS. 
# 30002 = life_sat	Percentage with the highest levels of life satisfaction: responses above the mode (9 to 10-Extremely satisfied) when asked "All things considered, how satisfied are you with your life as a whole nowadays?"
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
# 14001 - mus_rec - Adults meeting muscle strengthening guidelines. 2011 CMO guidelines recommend 2x 30 minute muscle strengthening sessions per week
# 14002 - adt10gp_tw_LOW - Adults with very low activity levels. Also in CWB, AMH profiles. 2011 CMO guidelines recommend 150 mins/week MVPA.
# 99105: Food insecurity
# 99106: Adult Healthy Weight 
# 4170: Alcohol consumption: Binge drinking (drinking over (6/8) units in a day (includes non-drinkers): Over 8 units for men, over 6 units for women" (previous indicator definition excluded non-drinkers from denom)
# 4171: Alcohol consumption: Hazardous/Harmful drinker" (% consuming over 14 units per week) (NB. original ScotPHO indicator excluded non-drinkers from denominator... it's not clear whether they are included here) 
# 4172: Alcohol consumption (mean weekly units)

# 15 child indicators:
# 30130 = ch_ghq  Percentage of children aged 15 years or under who have a parent/carer who scores 4 or more on the General Health Questionnaire-12 (GHQ-12)
# 30129 = ch_audit  Percentage of children aged 15 years or under with a parent/carer who reports consuming alcohol at hazardous or harmful levels (AUDIT questionnaire score 8+)
# 30170	Peer relationship problems - Percentage of children with a 'slightly raised', 'high' or 'very high' score (a score of 3-10) on the peer relationship problems scale of the Strengths and Difficulties Questionnaire (SDQ)
# 99117	Total difficulties - Percentage of children with a 'slightly raised', 'high' or 'very high' total difficulties score (a score of 14-40) on the Strengths and Difficulties Questionnaire (SDQ). A total difficulties score of 14 or over is also referred to as borderline (14-16) or abnormal (17-40).
# 30172	Emotional symptoms - Percentage of children with a 'slightly raised', 'high' or 'very high' score (a score of 4-10) on the emotional symptoms scale of the Strengths and Difficulties Questionnaire (SDQ)
# 30173	Conduct problems - Percentage of children with a 'slightly raised', 'high' or 'very high' score (a score of 3-10) on the conduct problems scale of the Strengths and Difficulties Questionnaire (SDQ)
# 30174	Hyperactivity/inattention - Percentage of children with a 'slightly raised', 'high' or 'very high' score (a score of 6-10) on the hyperactivity/inattention scale of the Strengths and Difficulties Questionnaire (SDQ)
# 30175	Prosocial behaviour - Percentage of children with a 'close to average' score (a score of 8-10) on the prosocial scale of the Strengths and Difficulties Questionnaire (SDQ)
# 30111 % children meeting 1 hour PA per day (INCL. SCHOOL)
# 14012 % children meeting activity guidelines (NOT inc school) (var ch00sum7)
# 14003 - c00sum7s - Children with very low activity levels
# 14006 - spt1ch - Children participating in sport
# 14007 - ch30plyg - Children engaging in active play
# 30114 = gen_helf	Percentage of children who, when asked "How good is your health in general?", selected "good" or "excellent". The five possible options ranged from very good to very bad, and the variable was GenHelf2. 
# 30115 = limitill2	Percentage of children who have a limiting long-term illness. Long-term conditions are defined as a physical or mental health condition or illness lasting, or expected to last, 12 months or more. A long-term condition is defined as limiting if the respondent reported that it limited their activities in any way. The variable used was limitill. 

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
  tidyverse,
  here, # for file paths within project/repo folders
  haven, # importing .dta files from Stata
  openxlsx, # reading and creating spreadsheets
  arrow, # work with parquet files
  survey, # analysing data from a clustered survey design
  reactable # required for the QA .Rmd file
)

## B. Source generic and specialist functions 

source(here("functions", "functions.R")) # sources the repo-specific functions 

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

# Read in geography lookup (based on area names and types -> code)
geo_lookup <- readRDS(file.path(profiles_lookups, "Geography", "opt_geo_lookup.rds")) %>% 
  select(!c(parent_area, areaname_full))

# lookup of all required geog codes
geography_lookup <- readRDS(file.path(profiles_lookups, "/Geography/DataZone11_All_Geographies_Lookup.rds")) |>
  select(ca=ca2019, hb=hb2019, hscp=hscp2019, adp, pd) |>
  unique()



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
# RECENT RUNS:
# 01 APR 2026: ADDING MORE VARS FROM THE SHES DASHBOARD, AND HARMONISING EXISTING VARS WITH THEIRS.
# 10 MAR 2026: ADDING 2024 DATA
# 21 JAN 2026: ADDING IN PA PROFILE INDICATORS
# 14 JAN 2026: ADDING 2023 DATA
# 12 JAN 2026: ADDITION OF CHILD SDQ VARS
extracted_survey_data_shes <- extract_survey_data("shes", additional="^int.*wt$|^cint.*wt$|^bio.*wt$|^vera.*wt$|^nurs.*wt$|intake24_wt_sc")# What this function is doing:
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
  filter(!str_detect(filename, "intake24")) %>% # this drops the shes intake24 files (the derived var we need is already in the individual file)
  # Drop years we don't want:
  # drop 2020 survey as experimental and not comparable. 1995 and 1998 don't have SIMD, and have old HBs. 2003 has old HBs too.
  filter(!year %in% c("95", "98", "03", "20")) # Not used



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
                  chars_to_exclude = c("age", "psu", "strata", "par", "serial", "wt$", "_wt_sc$")) #we don't need to work out codings for these numeric vars (and they muck up the output)
# What this function does: 
#   Runs get_valid_responses() function for each variable in each survey file.
#   This extracts any character/factor data, converts to character, stores in a dataframe.
#   Variables containing any of the chars_to_exclude are dropped from the dataframe.
#   The dataframe containing all the unique variable-response pairs is saved as "responses_as_list_shes.rds" and 
#   also to a worksheet called responses_shes in the same spreadsheet as the original variables were. 

## C. Read the responses back in and print out so we can work out how they should be coded
# (also useful to see how sex/geography/simd variables have been recorded, for later standardisation)

responses_as_list_shes <- readRDS(paste0(derived_data, "responses_as_list_shes.rds"))

## D. Print out this list to the console:
responses_as_list_shes
# Compare with the lookups in ukds_shes_lookups.R: are the codings still comprehensive? new coding needed?
# Edit and save ukds_shes_lookups.R as required, then source that file:
source(here("R", "ukds_shes_lookups.R")) # sources the lookups we'll use for the indicator variable coding

###################################


# 6. Initial processing of the survey data: creating a flat file with harmonised variable names.
# =================================================================================================================

## Read the data back in if not in memory:
# extracted_survey_data_shes <- readRDS(paste0(derived_data, "/extracted_survey_data_shes.rds"))

## A: How are grouping variables (geogs and SIMD) coded in each survey file? Need standardising?

# cross tabulate years and variables, to see what's available when  
shes_years_vars <- extracted_survey_data_shes %>%
  transmute(year,
            var_label = map(survey_data, names)) %>%
  unnest(var_label) %>%
  arrange(var_label) %>%
  mutate(value=1) %>%
  filter(!grepl("^bio|^int|^nurs|^vera|^weight|^cint|serial", var_label))  %>% # drop the weights and serial numbers
  pivot_wider(names_from=year, values_from = value) 


# This shows some issues that need to be rectified before the dataframe can be 'unlisted' into a flat file:
# 1. File years 12, 13, 14, 1214, and 121314 use 2 HB variables. 
# hbcode and hlth_brd used in 12, 1214, 14 data (keep hlth_brd as it is consistently text in these files)
# hbcode and hlthbrd used in 13 (keep hlthbrd as it's text)
# hb_code and hlth_brd used in 121314 (keep hlth_brd as it's text)
# hbcode and hb_code are used inconsistently (see responses_as_list_shes above): don't use when hlth_brd or hlthbrd are also used (i.e., in the years noted above).
# 2. 2015-18 survey uses two SIMDs (simd5_s_ga for 2015 and simd16_s_ga for 2016-18): harmonise these into "simd_combo" before aggregating


## B. Create lookups for harmonising var names and coding:

# var name lookups:
simd_lookup <- c(quintile = "simd20_s_ga", quintile = "simd16_s_ga", quintile = "simd5_sg", 
                 quintile = "simd5_s_ga", quintile = "simd20_sga", quintile = "simd_combo", quintile = "simd20_r_pa") # r_pa needed for 2022. check its coding.
sex_lookup <- c(sex = "sex", sex = "final_sex22") # final_sex22 used from 2022
indserial_lookup <- c(indserial="cpseriala",  indserial="pserial_a", indserial="cpserial_a", indserial="cp_serial_a")
hhserial_lookup <- c(hhserial="chh_serial_a", hhserial="chhserial_a", hhserial="chhseriala", hhserial="chserial_a", hhserial="hserial_a")
syear_lookup <- c(syear = "syear", syear = "s_year")


# Read in the CA codes (files 1 and 2 (2012 to 2019) provided by Xenia at SHeS)(STILL WAITING FOR PRE 2012 CODES...)
# These give the CA for each individual in the survey (identified by cpseriala + syear)
# Sub-national geogs can only be reported for the aggregated survey years
ca_codes1 <- read.xlsx(here(profiles_data_folder, "Received Data", "Scottish Health Survey", "LA codes", "shes12131415la.xlsx")) %>% janitor::clean_names(parsing_option=0)
ca_codes2 <- read.xlsx(here(profiles_data_folder, "Received Data", "Scottish Health Survey", "LA codes", "shes16171819la.xlsx")) %>% janitor::clean_names(parsing_option=0)
ca_codes3 <- haven::read_dta("/conf/MHI_Data/big/big_mhi_data/unzipped/shes/shes_2024/UKDA-9518-stata/stata/stata13_se/shes_21222324_eul.dta") %>% 
  janitor::clean_names(parsing_option=0) %>%
  select(cpseriala, syear, lacode)

# MAKE A LOOKUP FILE FROM CA TO OTHER GEOGS:
ca_codes <- rbind(ca_codes1, ca_codes2, ca_codes3) %>%
  mutate(areatype = "Council area",
         areaname = recode(lacode, !!!ca_lookup)) %>%
  mutate(syear = syear+2007) %>%
  merge(y=geo_lookup, by=c("areaname", "areatype")) %>%
  rename(ca = code) %>%
  merge(y = geography_lookup, by="ca")



## C. Process the survey microdata before calculating indicator estimates:
# Lots of steps here. If not processing new data the files shes_adult_data and shes_child_data can be read in after these 
# (currently around lines 912 and 951)

# keep only single year and 4-year aggregations:
shes_data <- extracted_survey_data_shes %>% 
  mutate(year = case_when(year=="2022" ~ "22", 
                          year=="2023" ~ "23",
                          year=="2024" ~ "24",
                          TRUE ~ year)) %>%
  filter(nchar(year)==2|nchar(year)==8)

# Harmonise HB variable names and coding: (working within list column, hence use of 'map' function)
# Now only needed for pre-2012 data. From 2012 we have CA codes that can be used to aggregate the individual responses to all higher geogs, including HBs
shes_data <- shes_data %>%
  mutate(survey_data = map(survey_data, ~ .x %>% # map() here means this is all being done within the individual items in the list column, while retaining the list format
                             mutate(across(.cols = everything(), as.character)) %>% # some factors muck up the processing otherwise. Will convert some vars back to numeric eventually. 
                             select(-any_of(c("hb_code", "hbcode", "hlth_brd"))) %>% # we now have CA lookup table for the years these vars are used
                             { if (length(grep("hlthbrd", names(.))) == 1) #the pre 2012 files have this hb var
                               mutate(., hlthbrd = case_when(!is.na(hlthbrd) ~ paste0("NHS ", as.character(hlthbrd)),
                                                             TRUE ~ as.character(NA)))  
                               else .}
  ))


# Harmonise SIMD variable names and coding: 
# Need to make sure there's only one SIMD column for each survey file, and the col is named the same ("quintile")
shes_data <- shes_data %>%
  mutate(survey_data = map(survey_data, ~ .x %>% # map() here means this is all being done within the individual items in the list column, while retaining the list format
                             mutate(., across(starts_with("simd"), ~recode(., !!!lookup_quintile, .default = as.character(NA)))) %>%
                             # harmonise SIMD vars in the single case where there's unique info in two simd cols (2015-18 file)
                             { if (length(grep("simd5_s_ga|simd16_s_ga", names(.))) > 1)
                               mutate(., simd16_s_ga = coalesce(simd5_s_ga, simd16_s_ga)) %>%
                                 select(., -simd5_s_ga)
                               else .} %>%
                             # select the SIMD col we need if there's more than one (and they don't contain unique info)
                             { if (length(grep("simd20_s_ga|simd20_r_pa|simd20_sga", names(.))) > 1) select(., -contains("simd20_s")) else .} %>%
                             rename(any_of(simd_lookup))  # apply the lookup defined above to rename all simd vars as 'quintile'
  ))

# Harmonise age, sex, and identifier variable names as required:
shes_data <- shes_data %>%
  mutate(survey_data = map(survey_data, ~ .x %>% # map() here means this is all being done within the individual items in the list column, while retaining the list format
                             rename(any_of(sex_lookup)) %>% # apply the lookup defined above to rename all sex vars to "sex"
                             mutate(sex = recode(sex, !!!lookup_sex, .default = as.character(NA))) %>% # the 'Refused' and 'Prefer not to say' cats from 2022 get stored as NA here
                             # All versions of individual serial numbers: rename as indserial
                             # drop cpserial_a when pserial_a is also used (in 2010: Liz checked this, and pserial_a is the one we need here)
                             { if (length(grep("cpserial_a|pserial_a", names(.)))>1) select(., -cpserial_a) else .} %>%
                             rename(any_of(indserial_lookup)) %>% # extract person id (used to link children to their parents)
                             mutate(person=substr(indserial, nchar(indserial)-1, nchar(indserial))) %>%
                             rename(any_of(hhserial_lookup)) %>% # All versions of household serial numbers: rename as hhserial
                             rename(any_of(syear_lookup)) # all survey year vars get renamed to syear 
  )) 

# Harmonise the names of the weights (all have the year in them currently):
shes_data <- shes_data %>%
  mutate(survey_data = map(survey_data, ~ .x %>% # map() here means this is all being done within the individual items in the list column, while retaining the list format
                             select(-any_of(starts_with(c("intsc", "biophy")))) %>% 
                             rename(intwt = starts_with("int") ) %>% 
                             rename(verawt = starts_with("vera")) %>%
                             rename(bio_wt = starts_with("bio") |  starts_with("nurs")) %>% # biowt called nurswt in early years
                             rename(intakewt = contains("intake24_wt")) %>%
                             rename(cintwt = starts_with("cint")))) # child interview weight

# Add age groups: for the SIMD age-standardisation, and for identification of children (0-15y)
shes_data <- shes_data %>%
  mutate(survey_data = map(survey_data, ~ .x %>% # map() here means this is all being done within the individual items in the list column, while retaining the list format
                             filter(!is.na(age)) %>% # 0911 file has a lot of missing data rows in it, so this clear this up
                             mutate(age = as.numeric(age)) %>%
                             mutate(agegp7 = case_when(!ag16g10 %in% c("16-24","25-34","45-54","55-64","35-44","65-74","75+") ~ as.character(NA), 
                                                       TRUE ~ ag16g10)) %>% 
                             mutate(age65plus = case_when(age >= 65 ~ "65y and over",
                                                          age < 65 ~ "16 to 64y")) %>% # use for adult vars with smaller samples OR PA profile: adult low PA, anxiety, depression, delib self harm, att suicide, meet muscle rec, unpaid caring
                             mutate(child = between(age, 0, 15)) %>% # 0-15y 
                             mutate(age_group = case_when(age %in% c(0:4) ~ "0 to 4y",
                                                          age %in% c(5:11) ~ "5 to 11y",
                                                          age %in% c(12:15) ~ "12 to 15y",
                                                          TRUE ~ as.character(NA))) %>%
                             # age groups for children's SDQ indicators:
                             mutate(age_group_sdq = case_when(age %in% c(4:8) ~ "4 to 8y",
                                                              age %in% c(9:12) ~ "9 to 12y",
                                                              TRUE ~ as.character(NA))) %>%
                             # age groups for children's indicators on the ScotPHO PA profile:
                             mutate(age_group_chpa = case_when(age %in% c(2:4) ~ "2 to 4y",
                                                               age %in% c(5:11) ~ "5 to 11y",
                                                               age %in% c(12:15) ~ "12 to 15y",
                                                               TRUE ~ as.character(NA))) %>%
                             # age groups used for children on the SHeS dashboard (will use these for most CYP indicators)
                             # children's physical activity indicators:
                             mutate(age_group_chpa_dashbd = case_when(age %in% c(2:4) ~ "2 to 4y", 
                                                                      age %in% c(5:7) ~ "5 to 7y",
                                                                      age %in% c(8:10) ~ "8 to 10y",
                                                                      age %in% c(11:12) ~ "11 to 12y",
                                                                      age %in% c(13:15) ~ "13 to 15y",
                                                                      TRUE ~ as.character(NA))) %>%
                             # children's gen health and llti indicators:
                             mutate(age_group_ch_dashbd = case_when(age %in% c(0:3) ~ "0 to 3y",
                                                                    age %in% c(4:7) ~ "4 to 7y",
                                                                    age %in% c(8:11) ~ "8 to 11y",
                                                                    age %in% c(12:15) ~ "12 to 15y",
                                                                    TRUE ~ as.character(NA)))))
# NB. gives warning: a few ages are NA. This is OK.

# Ready to unlist the df to create a flat file:
shes_data <- shes_data %>%
  mutate(survey_data = map(survey_data, ~ .x %>% # map() here means this is all being done within the individual items in the list column, while retaining the list format
                             mutate(across(c(psu, strata, ends_with("wt")), as.numeric)))) %>% 
  unnest(cols = c(survey_data)) # Produce a flat file by unnesting the list column
# NB. Gives warning: this is OK


# Do some data checks, now unnested:
table(shes_data$sex, shes_data$year, useNA = "always") # Female/Male; some NA from 2022 (include in Totals)
table(shes_data$quintile, shes_data$year, useNA = "always") # 5 bands; no NAs
#table(shes_data$hlthbrd, useNA = "always") # 14 HBs as expected, no NA
table(shes_data$age, useNA = "always") # 0 to 103y; 6 NAs from ~2023 (refused to answer)

# Combine indicators that have two different names in the data
shes_data <- shes_data %>%
  # coalesce the indicator vars with two different names
  mutate(involve = coalesce(involve, involv19)) %>%
  mutate(support1 = coalesce(support1, support1_19)) %>%
  mutate(p_crisis = coalesce(p_crisis, pcris19)) %>%
  mutate(dsh5sc = coalesce(dsh5sc, dsh5)) %>%
  mutate(depsymp = coalesce(depsymp, dvg11)) %>% 
  mutate(anxsymp = coalesce(anxsymp, dvj12)) %>%
  mutate(adt10gp_tw = coalesce(adt10gptw, adt10gp_tw)) %>%
  mutate(mus_rec = coalesce(mus_rec, musrec)) %>%
  mutate(rg17a_new = coalesce(rg17a_new, rg17anew)) %>%
  mutate(rg15a_new = coalesce(rg15a_new, rg15anew)) %>%
  mutate(str_work2 = coalesce(str_work2, strwork2)) %>%
  mutate(number_of_recalls = coalesce(numberofrecalls, number_of_recalls)) %>%
  mutate(urban_rural = coalesce(urbrur2a, urbrur2a_16, urbrur2a_20, urindsc2)) %>%
  mutate(urban_rural = ifelse(urban_rural=="Not applicable", as.character(NA), urban_rural)) %>%
  mutate(gh_qg2 = coalesce(ghqg2, gh_qg2)) %>% 
  mutate(olimlwb = coalesce(olimlwb, olim_l_wb)) %>%
  mutate(bmi = coalesce(bmivg5, bmivg5_adj, combmivg5_adj)) %>%
  # delete the redundant vars now
  select(-c(involv19, support1_19, pcris19, dsh5, dvg11, dvj12, musrec, adt10gptw, rg17anew, rg15anew, 
            strwork2, numberofrecalls, ghqg2, urbrur2a, urbrur2a_16, urbrur2a_20, urindsc2, olim_l_wb,
            bmivg5, bmivg5_adj, combmivg5_adj)) 

# standardise the equivalised income column
shes_data <- shes_data %>%
  mutate(eqv5_15 = case_when(str_detect(eqv5_15, "Bottom") ~ "Q5 (lowest income)", # confirmed the ordering using the SHeS dashboard data
                             str_detect(eqv5_15, "2nd") ~ "Q2",
                             str_detect(eqv5_15, "3rd") ~ "Q3",
                             str_detect(eqv5_15, "4th") ~ "Q4",
                             str_detect(eqv5_15, "Top") ~ "Q1 (highest income)",
                             TRUE ~ as.character(NA)))

# Convert some variables to numeric where appropriate
shes_data <- shes_data %>%
  mutate(across(c(work_bal), ~ substr(., 1, 2))) %>% # 0 and 10 have text in them, so this command just selects the numeric part
  mutate(across(c(p_crisis, wemwbs, work_bal, sdq_pro), as.numeric)) %>%
  mutate(drating = as.numeric(as.character(drating))) # starts as factor
#gives warning for non-numeric data in each (e.g., refused, not applicable...)

# Create the drkcat315 var when it's NA (prior to files containing 2015 data)
shes_data <- shes_data %>% 
  mutate(drkcat315 = case_when(!is.na(drkcat315) ~ drkcat315,
                               drating<=14 ~ "Moderate (up to and including 14)", # use the units reported first,
                               drating>14 ~ "Hazardous/harmful (over 14)",
                               dnany %in% c("Never", "Very occasionally") ~ "Moderate (up to and including 14)", # then include any without units who have answered dnany or dnnow in the denominator
                               dnnow %in% c("Yes", "No") ~ "Moderate (up to and including 14)",
                               TRUE ~ as.character(NA))) %>%
  # mutate(drating = case_when(!is.na(drating) ~ drating, # in cases where units are missing, but resp has said they don't drink now, or very occasionally, replace NA with 0, so that these are included in the denom.
  #                            dnnow == "No" ~ 0,
  #                            dnany %in% c("Never", "Very occasionally") ~ 0, 
  #                            TRUE ~ as.numeric(NA))) %>%
  # ALCOHOL UNITS: SHeS team say they filter on drating>0 and drkcat315>=2 (which I think means they only include drinkers, and remove any with units(drating)==0 or drkcat315==non-drinker)
  mutate(drinker = recode(drkcat315, !!!lookup_drinker, .default = as.character(NA))) %>%
  mutate(drinker_units = case_when(drating==0 ~ as.numeric(NA),
                                   drinker=="yes" ~ drating,
                                   TRUE ~ as.numeric(NA)))


# Recode the variables
shes_data <- shes_data %>%  
  
  # Variables with simple recoding:
  mutate(adt10gp_tw2 = recode(adt10gp_tw, !!!lookup_adt10gp_tw, .default = as.character(NA))) %>% # recodes into a copy, so that the var can also be used for another indicator (adt10gp_tw_LOW)
  mutate(contrl = recode(contrl, !!!lookup_contrl, .default = as.character(NA))) %>%
  mutate(gen_helf = recode(genhelf2, !!!lookup_genhelf2, .default = as.character(NA))) %>%
  mutate(gh_qg2 = recode(gh_qg2, !!!lookup_gh_qg2, .default = as.character(NA))) %>%
  mutate(lifesat2 = recode(lifesat2, !!!lookup_lifesat2, .default = as.character(NA))) %>%
  mutate(limitill2 = recode(limitill, !!!lookup_limitill, .default = as.character(NA))) %>% # recodes into a copy, so that the var can also be used for a split column (limitill_SPLIT)
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
  mutate(cghq214 = recode(cghq214, !!!lookup_childghq, .default = as.character(NA))) %>%
  mutate(childpa1hr = recode(c00sum7s, !!!lookup_childpa1hr, .default = as.character(NA))) %>%
  mutate(ch00sum7 = recode(ch00sum7, !!!lookup_ch00sum7, .default = as.character(NA))) %>%
  mutate(healthyweight = recode(bmi, !!!lookup_healthyweight, .default = as.character(NA))) %>%
  mutate(foodinsecure = recode(wrfood, !!!lookup_foodinsecure, .default = as.character(NA))) %>%
  mutate(binge = recode(olimlwb, !!!lookup_binge, .default = as.character(NA))) %>%
  mutate(hazharmful = recode(drkcat315, !!!lookup_alcoholguidelines, .default = as.character(NA))) %>% # make sure all years have this var before now
  mutate(adt10gp_tw_LOW = recode(adt10gp_tw, !!!lookup_adt10gp_tw_LOW, .default = as.character(NA))) %>%
  mutate(mus_rec = recode(mus_rec, !!!lookup_mus_rec, .default = as.character(NA))) %>%
  mutate(c00sum7s = recode(c00sum7s, !!!lookup_c00sum7s, .default = as.character(NA))) %>% 
  mutate(spt1ch = recode(spt1ch, !!!lookup_spt1ch, .default = as.character(NA))) %>%
  mutate(ch30plyg = recode(ch30plyg, !!!lookup_ch30plyg, .default = as.character(NA))) %>%
  mutate(limitill_SPLIT = recode(limitill, !!!lookup_limitill_SPLIT, .default = as.character(NA))) %>% # _SPLIT differentiates this split variable from the indicator that uses the same column (limitill)
  
  # Portions of fruit and veg: variable changed in 2021 (to a food diary), but SHeS present as a continuous indicator. 
  mutate(porftvg3 = recode(porftvg3, !!!lookup_porftvg3, .default = as.character(NA))) %>% # variable derived from survey questions
  # porftvg3intake data only in 2021 and 2024 so far
  mutate(porftvg3intake = recode(porftvg3intake, !!!lookup_porftvg3, .default = as.character(NA))) %>% # porftvg3intake variable (from food diary) only used if number_of_recalls == 2
  mutate(porftvg3intake = case_when(number_of_recalls %in% c("1", "Not applicable", "Item not applicable") ~ as.character(NA),
                                    TRUE ~ porftvg3intake)) %>% # porftvg3intake is only valid if number_of_recalls == 2, so recode other options as NA. Earlier years won't have anything but NA for the recall var. 
  
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
  select(year, ends_with("wt"), psu, strata, sex, agegp7, age, quintile, everything())


# Add trend_axis (character) and numeric year variables 
shes_data <- shes_data %>%  
  mutate(trend_axis = case_when(nchar(year)==2 ~ paste0("20", year), # e.g., "08" -> "2008"
                                nchar(year)==8 ~ paste0("20", substr(year, 1, 2), "-", "20", substr(year, 7, 8)), # e.g., "15161718" -> "2015-2018"
                                TRUE ~ as.character(NA)), # shouldn't be any...
         # Replicating the standard used elsewhere in ScotPHO: year = the midpoint of the year range, rounded up if decimal
         year = case_when(nchar(trend_axis)==4 ~ as.numeric(trend_axis), 
                          nchar(trend_axis)>4 ~ rnd(0.5*(as.numeric(substr(trend_axis, 6, 9)) + as.numeric(substr(trend_axis, 1, 4)))), # e.g., "2015-2018" -> "2017" or "2015-2016" to "2016"
                          TRUE ~ as.numeric(NA)), # shouldn't be any...
         syear = case_when(as.numeric(syear) < 2000 ~ as.numeric(syear)+2007,
                           TRUE ~ as.numeric(syear)))  
# Warning ok  


## D. Load the population data for the age-standardisation of SIMD results:

# Age-standardisation requires mid-year private household population estimates (see methodology note on the SHeS dashboard)
# (downloaded from https://scotland.shinyapps.io/sg-scottish-health-survey/_w_484e5f010383450eb01c2d335adf1b4a/Private%20household%20population%20estimates,%202008-2022,%20Scotland.xlsx

# Read in the data from spreadsheets
shes_source_dir <- "/conf/MHI_Data/big/big_mhi_data/unzipped/shes"
private_pops <- read.xlsx(here(shes_source_dir, "Private household population estimates, 2008-2022, Scotland.xlsx"), rows = c(3:17)) %>%
  # manipulate data so it can be merged into the SHeS respondent data
  rename(sex=Sex,
         agegp7 = Age.group) %>%
  pivot_longer(cols = c(-sex, -agegp7), names_to = "year", values_to = "scotpop", names_transform = list(year = as.integer)) %>%
  group_by(year, sex) %>%
  mutate(totpop = sum(scotpop)) %>%
  ungroup() %>%
  mutate(prop_pop = rnd4dp(scotpop / totpop)) %>% # the proportion of the population in each age group, by year and sex
  select(year, sex, agegp7, prop_pop) 

# Inconsistency in which year's pop data were used for which year's SIMD standardisation by the SHeS team, as described in the spreadsheet:
# 1. For the 2008-2011 Scottish Health Survey reports, the population estimates for years 2008-2011 were used respectively.
# 2. For each of the 2012-2019 and 2021-2022 Scottish Health Survey reports, the population estimates for the previous year were used respectively. For example, for the 2012 report the 2011 estimates were used and so on. 
# 3. For the 2023 Scottish Health Survey report, the 2021 population estimates were used.
# 4. For the 2024 Scottish Health Survey report, the 2022 population estimates were used.
# 5. For combined years' analysis, the latest year's report estimates were used. For example, for 2021/2022 combined years' analysis, the estimates that were used for the 2022 report were used and so on.

# replicate this:
trend_axis <- unique(shes_data$trend_axis) # from 2008 to 2021-2024
use_private_pop_year <- c(2008,2009,2010,
                          2011,2011,2011,
                          2012,2013,
                          2014,2014, 
                          2015,2015, 
                          2016,2016,     
                          2017,2017,
                          2018,2018,
                          2020,2020,
                          2021,2021,2021,2021,
                          2022,2022)
private_pops_lookup <- data.frame(trend_axis, use_private_pop_year)

# merge in the private household pops for age standardisation purposes
shes_data <- shes_data %>%  
  merge(y=private_pops_lookup, by="trend_axis") %>%
  merge(y=private_pops, 
        by.x = c("agegp7", "use_private_pop_year", "sex"), 
        by.y = c("agegp7", "year", "sex"), 
        all.x=TRUE) # keeps even those without sex=m/f, for completeness

# save intermediate df:
#arrow::write_parquet(shes_data, paste0(derived_data, "shes_data_int.parquet"))
# read back in if not in memory:
#shes_data <- arrow::read_parquet(paste0(derived_data, "shes_data_int.parquet"))


# add in area codes
shes_data <- shes_data %>%
  merge(y=geo_lookup, by.x="hlthbrd", by.y="areaname", all=TRUE) %>% # codes for 2008-2011 HBs
  rename(hb_code = code) %>% 
  merge(y=ca_codes, by.x=c("indserial", "syear"), by.y=c("cpseriala", "syear"), all=TRUE) %>%
  mutate(hb = ifelse(is.na(hb), as.character(hb_code), hb)) %>%
  mutate(across(c("ca", "hb", "adp", "hscp", "pd"), ~ case_when(nchar(trend_axis)==4 ~ as.character(NA),
                                                                TRUE ~ .x)))

# save intermediate df:
#arrow::write_parquet(shes_data, paste0(derived_data, "shes_data.parquet"))
# read back in if not in memory:
#shes_data <- arrow::read_parquet(paste0(derived_data, "shes_data.parquet"))


# 7. Split data into adult and child subsets
# =================================================================================================================

## A: Subset off the adult indicators
# restrict to adults
shes_adult_data <- shes_data %>%
  filter(!child) %>%
  select(-c(child, contains("serial"), starts_with("par"), 
            cintwt, age, age_group,
            c00sum7s, spt1ch, ch30plyg, childpa1hr, contains("sdq")
  ))
# save intermediate df:
#arrow::write_parquet(shes_adult_data, paste0(derived_data, "shes_adult_data.parquet"))
# read back in if not in memory:
#shes_adult_data <- arrow::read_parquet(paste0(derived_data, "shes_adult_data.parquet"))


## B. Keep a selection of the adult variables for linking to child data (will link if an individual is listed as a parent/carer of the child)
# subset adult data to merge with child data:
parent_data <- shes_data %>%
  filter(!child) %>% # keep 16+
  select(trend_axis, contains("serial"), person, auditg, gh_qg2) %>% # the parent variables of interest for the CYP mental health indicators
  mutate(person = as.character(as.numeric(person))) # e.g., convert from "02", to "2" to enable correct matching with child's par1 and par2 vars

# Subset off the data to form the child indicators 
shes_child_data <- shes_data %>%
  filter(child) %>% # keep 0-15
  merge(y=parent_data, by.x=c("trend_axis", "hhserial", "par1"), by.y = c("trend_axis", "hhserial", "person"), all.x=TRUE) %>% #1st parent/carer in hhd
  merge(y=parent_data, by.x=c("trend_axis", "hhserial", "par2"), by.y = c("trend_axis", "hhserial", "person"), all.x=TRUE) %>% #2nd parent/carer in hhd
  # calculate the new child MHIs using the data for both parents (.x and .y)
  mutate(ch_ghq = case_when(gh_qg2.x=="yes" | gh_qg2.y=="yes" ~ "yes", # yes if either parent has GHQ>4
                            gh_qg2.x=="no" | gh_qg2.y=="no" ~ "no", # otherwise no (if the data were collected)
                            TRUE ~ as.character(NA)), # NA if no data (question not asked / 'don't know'/refused/not answered)
         ch_audit = case_when(auditg.x=="yes" | auditg.y=="yes" ~ "yes", # yes if either parent has harmful/hazardous (8+) AUDIT score
                              auditg.x=="no" | auditg.y=="no" ~ "no", # otherwise no (if the data were collected)
                              TRUE ~ as.character(NA))) %>%  # NA if no data (question not asked / 'don't know'/refused/not answered)
  select(year, trend_axis, cintwt, hb, ca, hscp, adp, pd, quintile, psu, strata, sex, starts_with("age_group"),  
         cghq214, ch_ghq, ch_audit, contains("sdq"), childpa1hr, c00sum7s, ch00sum7, spt1ch, ch30plyg,
         gen_helf, limitill2,
         urban_rural, eqv5_15, limitill_SPLIT)

# save intermediate df:
#arrow::write_parquet(shes_child_data, paste0(derived_data, "shes_child_data.parquet"))
# read back in if not in memory:
#shes_child_data <- arrow::read_parquet(paste0(derived_data, "shes_child_data.parquet"))


# 8. Calculate indicator values by various groupings
# # =================================================================================================================
# Go to ukds_shes_calcs.R to perform the calculations and prepare the final results file
# 
# 
# 
# ## END