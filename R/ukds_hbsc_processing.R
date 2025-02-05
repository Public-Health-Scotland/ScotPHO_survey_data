
# ============================================================================
# ===== Processing UKDS survey data files: HEALTH BEHAVIOUR IN SCHOOL-AGED CHILDREN (HBSC) =====
# ============================================================================

## NB. THE PROCESSING CAN TAKE A LOT OF MEMORY. IF THE SCRIPT FAILS, OPEN IT IN A SESSION WITH MORE MEMORY.

# Notes on HBSC

# 6 CYP indicators: 

# Sleep quality	                            30113	Mean score for P7, S2 and S4 pupils on the Adolescent Sleep Wake Scale 
# Limiting long-standing physical condition	30115	Percentage of P7, S2 and S4 pupils reporting an illness, disability or medical condition that affects their attendance or participation in school.
# Acceptance by classmates	                30137	Percentage of P7, S2 and S4 pupils who strongly agree or agree that other pupils accept them as they are
# Liking school 	                          30141	Percentage of P7, S2 and S4 pupils who like school a lot or a bit at present 
# Relationship with teachers	              30142	Percentage of P5-S6 pupils who strongly agree or agree that their teachers treat them fairly
# Experience of discrimination from adults	30163	Percentage of P7, S2 and S4 pupils reporting that they are very often or often treated unfairly because of their ethnicity, sex or socioeconomic status, by teachers or other adults.

# Denominators = Total number of respondents answering the question. 

# Survey weight = "dataset_weight"

# Survey years on UKDS: 2013/14, 2017/18, 2021/22


# =================================================================================================================

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
source("../scotpho-indicator-production/1.indicator_analysis.R")
source("../scotpho-indicator-production/2.deprivation_analysis.R")
# temporary functions:
source(here("functions", "temp_depr_analysis_updates.R")) # 22.1.25: sources some temporary functions needed until PR #97 is merged into the indicator production repo 

## C. Path to the data derived by this script

derived_data <- "/conf/MHI_Data/derived data/"


# 1. Find survey data files, extract variable names and labels (descriptions), and save this info to a spreadsheet
# =================================================================================================================

## A. Create a new workbook in this repo (only run this the first time)
#wb <- createWorkbook()
#saveWorkbook(wb, file = paste0(derived_data, "all_survey_var_info.xlsx"))

## B. Get all the variable names and their descriptions from the survey data files
# N.B. RUNNING THIS WILL MODIFY THE EXISTING SPREADSHEET:
save_var_descriptions(survey = "hbsc", # looks in this folder 
                       name_pattern = "\\/hbsc_scotland_(\\d{4})") # the regular expression for this survey's filenames that identifies the survey year(s)

# # As of Jan 2025: files = 
# hbsc_scotland_2014_data
# hbsc_scotland_2018_data_archive
# hbsc_scotland_2022_data_archive_26_09_24


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
# N.B. RUNNING THIS WILL OVERWRITE EXISTING DATA 
extracted_survey_data_hbsc <- extract_survey_data("hbsc") 


## B. Save the file (do this if new variables/data have been read in)
# saveRDS(extracted_survey_data_hbsc, paste0(derived_data, "extracted_survey_data_hbsc.rds"))


# 4. What are the possible responses? (needed so we can decide how to code each variable)
# =================================================================================================================

## A. Read the data back in if not in memory:
# extracted_survey_data_hbsc <- readRDS(paste0(derived_data, "extracted_survey_data_hbsc.rds"))

## B. Get all the possible responses that have been recorded for each variable (combined over the years), and save to xlsx and rds
# Running extract_responses() will modify existing spreadsheet and overwrite existing rds file

extract_responses(survey = "hbsc") 

## C. Read the responses back in and print out so we can work out how they should be coded
# (also useful to see how sex/geography/simd variables have been recorded, for later standardisation)

responses_as_list_hbsc <- readRDS(paste0(derived_data, "responses_as_list_hbsc.rds"))

## D. Print out this list to the console and copy into this script for reference:
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?
responses_as_list_hbsc

###################################

# $age
# [1] NA
# 
# $beenbullied
# [1] "I have not been bullied at school in the past couple of months"
# [2] "2 or 3 times a month"                                          
# [3] "It has happened once or twice"                                 
# [4] NA                                                              
# [5] "Several times a week"                                          
# [6] "About once a week"                                             
# 
# $bully_victim
# [1] "Haven't"             NA                    "2-3 times per month" "Once or twice"      
# [5] "Several times/week"  "Once/week"          
# 
# $cbeenbullied
# [1] "I have not been cyberbullied in the past couple of months"
# [2] "It has happened once or twice"                            
# [3] NA                                                         
# [4] "2 or 3 times a month"                                     
# [5] "Several times a week"                                     
# [6] "About once a week"                                        
# 
# $country
# [1] NA
# 
# $d_emc_problem
# [1] "Non-problematic social media user" NA                                 
# [3] "Problematic social media user"    
# 
# $d_family_support
# [1] NA        "Highest" "5.25"    "6"       "6.75"    "1"       "5"       "5.75"    "4.5"     "6.5"    
# [11] "6.25"    "1.25"    "5.5"     "4.75"    "1.5"     "2"       "3.75"    "3"       "1.75"    "2.25"   
# [21] "4"       "4.25"    "3.25"    "2.75"    "3.5"     "2.5"    
# 
# $d_family_support_binary
# [1] "High family support" "Low family support"  NA                   
# 
# $d_peer_support
# [1] NA
# 
# $d_peer_support_binary
# [1] "High Peer support" "Low Peer support"  NA                 
# 
# $d_teacher_support
# [1] NA        "Highest" "7"       "9"       "10"      "11"      "6"       "5"       "8"       "3"      
# [11] "2"       "1"       "4"       "Lowest" 
# 
# $d_teacher_support_binary
# [1] "High teacher support" "Low teacher support"  NA                    
# 
# $d_who5
# [1] NA
# 
# $dataset_weight
# [1] NA
# 
# $gender
# [1] "Boy"  "Girl"
# 
# $gender_binary_s
# [1] "Girl" "Boy"  NA    
# 
# $gender_p
# [1] NA               "Girl"           "Boy"            "In another way"
# 
# $genderid_s
# [1] "I identify myself as a girl" "I identify myself as a boy"  "Neither boy nor girl"       
# [4] "Other/s"                     NA                           
# 
# $life_satisfaction
# [1] "10 Best possible life" "8"                     "9"                     "0 Worst possible life"
# [5] "7"                     "4"                     "5"                     "6"                    
# [9] NA                      "3"                     "2"                     "1"                    
# 
# $lifesat
# [1] "9"                     "8"                     "7"                     "10 Best possible life"
# [5] "6"                     "5"                     NA                      "0 Worst possible life"
# [9] "4"                     "1"                     "3"                     "2"                    
# 
# $like_school
# [1] "Like a bit"    "Like a lot"    "Not very much" "Not at all"    NA             
# 
# $likeschool
# [1] "I like it a lot"                       "I like it a bit"                      
# [3] "I don't like it very much"             NA                                     
# [5] "I don't like it at all"                "I donâ\u0080\u0099t like it very much"
# [7] "I donâ\u0080\u0099t like it at all"   
# 
# $lonely
# [1] "Rarely"           "Sometimes"        "Never"            "Most of the time" NA                
# [6] "Always"          
# 
# $lt_ill_dis 
# [1] "No"  "Yes" NA   
# 
# $mvpa
# [1] "6 days" "5 days" "4 days" "7 days" "0 days" "1 day"  NA       "3 days" "2 days"
# 
# $physact60
# [1] "5 days"  "7 days"  "3 days"  "6 days"  "2 days"  "4 days"  NA        "1 day"   "0 days"  " 2 Days"
# [11] " 6 Days" " 7 Days" " 3 Days" " 5 Days" " 4 Days" "1 Day"   "0 Days" 
# 
# $pupils_accept
# [1] "Agree"                      "Strongly agree"             "Neither agree nor disagree"
# [4] "Strongly disagree"          "Disagree"                   NA                          
# 
# $studaccept
# [1] "Agree"                      "Neither agree nor disagree" "Strongly agree"            
# [4] "Disagree"                   NA                           "Strongly disagree"         
# 
# $schoolpressure
# [1] "A little"   "Not at all" "A lot"      "Some"       NA          
# 
# $schoolwork_pressure
# [1] "Not at all" "A little"   "Some"       "A lot"      NA          
# 
# $self_rated_health
# [1] "Excellent" "Fair"      "Good"      "Poor"      NA         
# 
# $sexbirth_s
# [1] "Female" "Male"   NA      
# 
# $simd2012_quintile_pupil
# [1] NA               "4"              "2"              "3"              "Least deprived" "Most deprived" 
# 
# $sleep_diff
# [1] "Rarely or never"       "About every week"      "About every month"     "About every day"      
# [5] "More than once a week" NA                     
# 
# $sleepdifficulty
# [1] "Rarely or never"       "About every day"       "About every month"     "More than once a week"
# [5] "About every week"      NA                     
# 
# $talk_father
# [1] "Easy"              "Difficult"         "Very easy"         NA                  "Don't have or see"
# [6] "Very difficult"   
# 
# $talk_mother
# [1] "Very easy"         "Easy"              NA                  "Difficult"         "Don't have or see"
# [6] "Very difficult"   
# 
# $talkfather
# [1] "Very easy"                     "Easy"                          "Difficult"                    
# [4] "Very difficult"                "Don't have or see this person" NA                             
# 
# $talkmother
# [1] "Very easy"                     "Easy"                          NA                             
# [4] "Difficult"                     "Don't have or see this person" "Very difficult"               
# 
# $thinkbody
# [1] "About the right size" "A bit too thin"       "A bit too fat"        "Much too fat"        
# [5] "Much too thin"        NA                    
# 
# $thinkbody_1
# [1] "Neither underweight nor overweight" "A bit overweight"                  
# [3] "A bit underweight"                  "Very overweight"                   
# [5] NA                                   "Very underweight"          
###################################



# 5. How should the responses be coded?
# =================================================================================================================
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?

# Create lookups to code the variables into the dichotomy needed for the indicators:
# (each lookup needs to contain all response versions including the range of punctuation and capitalisation used)

# Lookups as lists: 
# "yes" indicates a case (summed later to give numerator)
# "no" indicates an alternative response (not a case) that should be included in the denominator

# bullied
lookup_bullied <- list(
  "2-3 times per month"="yes", 
  "Once or twice"="yes",      
  "Several times/week"="yes",  
  "Once/week"="yes",
  "2 or 3 times a month"="yes",                                           
  "It has happened once or twice"="yes",                                  
  "Several times a week"="yes",                                           
  "About once a week"="yes",  
  
  "I have not been bullied at school in the past couple of months"="no",
  "Haven't"="no"
)

# cyber-bullied
lookup_cbullied <- list(
  "It has happened once or twice"="yes", 
  "2 or 3 times a month"="yes",      
  "Several times a week"="yes",  
  "About once a week"="yes",
  
  "I have not been cyberbullied in the past couple of months"="no"
)

# problematic social media use (var = d_emc_problem)
lookup_socmedia <- list(
  "Problematic social media user"="yes",
  "Non-problematic social media user"="no"
)

# high perceived family support (var = d_family_support_binary)
lookup_famsupport <- list(
  "High family support"="yes",
  "Low family support"="no"
)

# high perceived peer support (var = d_peer_support_binary)
lookup_peersupport <- list(
  "High Peer support"="yes",
  "Low Peer support"="no"
)

# high perceived teacher support (var = d_teacher_support_binary)
lookup_teachersupport <- list(
  "High teacher support"="yes",
  "Low teacher support"="no"
)

# gender (vars = gender, gender_p, gender_binary_s)
lookup_gender <- list(
  "Boy"="Male",
  "I identify myself as a boy"="Male",
  
  "Girl" = "Female",
  "I identify myself as a girl" = "Female",
  
  "In another way" = "Other",
  "Neither boy nor girl" = "Other",      
  "Other/s" = "Other"
)

# lifesatisfaction (vars = life_satisfaction and lifesat)
lookup_lifesat <- list(
  # score 0 worst to 10 best: trim, turn numeric, and average
)

# like school (vars = like_school, likeschool)
lookup_likeschool <- list(
  "Like a bit"="yes",    
  "Like a lot"="yes",    
  "I like it a lot"="yes",
  "I like it a bit"="yes",     
  
  "Not very much"="no", 
  "Not at all"="no", 
  "I don't like it very much"="no",                                                   
  "I don't like it at all"="no",                 
  "I donâ\u0080\u0099t like it very much"="no", 
  "I donâ\u0080\u0099t like it at all"="no"
)


# loneliness (rarely or never) (var = lonely)
lookup_lonely <- list(
  "Rarely"="yes",
  "Never"="yes",
  "Sometimes"="no",
  "Most of the time"="no",
  "Always"="no"
)

# llti (var = lt_ill_dis) # MUST BE OTHER VARS
lookup_llti <- list(
  "Yes"="yes",
  "No"="no"
)

# MVPA (var = physact60, mvpa) (1hr every day last week)
lookup_mvpa <- list(
  "7 days"="yes", 
  " 7 Days"="yes", 
  
  "0 days"="no", 
  "1 day"="no",
  "2 days"="no",
  "3 days"="no",
  "4 days"="no", 
  "5 days"="no", 
  "6 days"="no",
  "0 Days"="no", 
  "1 Day"="no",    
  " 2 Days"="no", 
  " 3 Days"="no",  
  " 4 Days"="no",  
  " 5 Days"="no",  
  " 6 Days"="no"  
  
)






# 6. Initial processing of the survey data: creating a flat file with harmonised variable names.
# =================================================================================================================

## A: How are grouping variables (geogs and SIMD) coded in each survey file? Need standardising?

# cross tabulate years and variables, to see what's available when  
hbsc_years_vars <- extracted_survey_data_hbsc %>%
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
 # hbcode and hb_code are used inconsistently (see responses_as_list_hbsc above): don't use when hlth_brd or hlthbrd are also used (i.e., in the years noted above).
# 2. 2015-18 survey uses two SIMDs (simd5_s_ga for 2015 and simd16_s_ga for 2016-18): harmonise these into "simd_combo" before aggregating
# 3. 1995 and 1998 don't have SIMD data: exclude


## B. Create lookups for harmonising var names and coding:

# lookups:
hb_lookup <- c(hb = "hboard", hb = "hbcode", hb = "hb_code", hb = "hlth_brd", hb = "hlthbrd")
simd_lookup <- c(quintile = "simd5", quintile = "simd20_s_ga", quintile = "simd16_s_ga", quintile = "simd5_sg", quintile = "simd5_s_ga", quintile = "simd20_sga", quintile = "simd_combo")
age_lookup <- c(age = "age", age = "respage") # respage used in 1995
sex_lookup <- c(sex = "sex", sex = "respsex") # respsex used in 1995
indserial_lookup <- c(indserial="cpseriala",  indserial="pserial", indserial="pserial_a", indserial="cpserial_a", indserial="cp_serial_a", indserial="serialx")
hhserial_lookup <- c(hhserial="chh_serial_a", hhserial="chhserial_a", hhserial="chhseriala", hhserial="chserial_a", hhserial="hhserial", hhserial="hserial_a")

# derive lookup for years where only a numeric hbcode is provided (hbcode in 1213 and 1618, hb_code in 1921):
# checked when hbcode/hb_code is provided alongside a character hb field, and all code the same: alphabetically
# extract codings from 2014 file: 
hbcodes <- extracted_survey_data_hbsc[[4]][[18]] %>%
  group_by(hbcode, hlth_brd) %>%
  summarise() %>%
  ungroup()  
# these are hard-coded into the pipe below


## C. Process the survey microdata before calculating indicator estimates:
# Lots of steps here. If not processing new data the files hbsc_adult_data and shes_child_data can be read in after these 
# (currently around lines 912 and 951)

# Drop years we don't want:
# drop 2020 survey as experimental and not comparable. 1995 and 1998 don't have SIMD, and have old HBs. 2003 has old HBs too.
shes_data <- extracted_survey_data_shes %>%
  filter(!year %in% c("95", "98", "03", "20")) 
  
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
                                                    .default = hb)) %>%
                             mutate(spatial.unit = gsub(" and ", " & ", spatial.unit),
                                    spatial.unit = case_when(!spatial.unit=="NA" ~ paste0("NHS ", spatial.unit),
                                                   TRUE ~ as.character(NA)),
                                    spatial.scale = "Health board")))


# Harmonise SIMD variable names and coding: 
shes_data <- shes_data %>%
  mutate(survey_data = map(survey_data, ~ .x %>% # map() here means this is all being done within the individual items in the list column, while retaining the list format
                             coalesce_simd() %>% # harmonise SIMD so there's just one per survey (function defined in functions file)
                             rename(any_of(simd_lookup)) %>% # apply the lookup defined above to rename all simd vars as 'quintile'
                             # Standardise the SIMD var labels (keep numeric for now, for the deprivation analysis. ScotPHO text labels added later)
                             mutate(quintile = case_when(
                               quintile %in% c("Most deprived", "1st - most deprived", "most deprived", "(33.5277 - 87.5665) most deprived" ) ~ "1",
                               quintile %in% c("2nd", "(21.0421 - 33.5214)") ~ "2",
                               quintile %in% c("3rd", "(13.5303 - 21.0301)") ~ "3",
                               quintile %in% c("4th", "(7.7354 - 13.5231)") ~ "4",
                               quintile %in% c(" 5th - least deprived", "Least deprived", "Least deprived (0.5393 - 7.7347)", 
                                               "least deprived", "5th - least deprived") ~ "5",
                               TRUE ~ quintile))))

# Harmonise age, sex, and identifier variable names as required:
shes_data <- shes_data %>%
  mutate(survey_data = map(survey_data, ~ .x %>% # map() here means this is all being done within the individual items in the list column, while retaining the list format
                             rename(any_of(age_lookup)) %>% # apply the lookup defined above to rename all age vars to "age"
                             rename(any_of(sex_lookup)) %>% # apply the lookup defined above to rename all sex vars to "sex"
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
table(shes_data$sex, useNA = "always") # Female/Male; no NA
table(shes_data$quintile, useNA = "always") # 5 bands; no NAs
table(shes_data$spatial.unit, useNA = "always") # 14 HBs as expected; some NAs (all in 2009-2011 file, which won't be used anyway)
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
  mutate(across(c(p_crisis, wemwbs, life_sat, work_bal), as.numeric))  #gives warning for non-numeric data in each (e.g., refused, not applicable...)
  

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
  mutate(p_crisis = case_when(p_crisis >= 3 ~ "yes", # no lookup as easier to work with this pair of vars as numeric
                              p_crisis < 3 ~ "no", 
                              TRUE ~ as.character(NA))) %>%
  
  # keep only the vars required for the analysis
  select(-c(filename, fileloc, age, #number_of_recalls, # will be required for future porftvg3intake variable processing (but not currently)
            rg15a_new)) %>%
  select(year, ends_with("wt"), psu, strata, sex, agegp7, spatial.unit, spatial.scale, quintile, everything())


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
# (downloaded from https://scotland.shinyapps.io/sg-scottish-health-survey/_w_ebb77ce6/Private household population estimates, 2008-2018, Scotland.xlsx)
# (updated data 2018-21 obtained by request from NRS statisticscustomerservices@nrscotland.gov.uk, and Stefania.Sechi@nrscotland.gov.uk in the household estimates department)

# Read in the data from spreadsheets
shes_source_dir <- "/conf/MHI_Data/big/big_mhi_data/unzipped/shes"
private_pops_2008to18 <- read.xlsx(here(shes_source_dir, "Private household population estimates, 2008-2018, Scotland.xlsx"),
                                   startRow = 3, rows = c(3:17)) 
private_pops_2019to21 <- read.xlsx(here(shes_source_dir, "NRS-private-population-scotland-2018-21.xlsx"),
                                   sheet = "private population 2018-21",
                                   startRow = 2, rows = c(2:16)) %>%
  select(-"2018") # duplicates data in the 2008to18 spreadsheet, so can drop here

# Combine the data, and manipulate so it can be merged into the SHeS respondent data
private_pops <- private_pops_2008to18 %>%
  merge(y = private_pops_2019to21) %>%
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
  select(-c(child, contains("serial"), starts_with("par"), cintwt))
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
         cintwt, psu, strata, sex, spatial.unit, spatial.scale, quintile) %>%
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
  select(year, trend_axis, cintwt, spatial.unit, spatial.scale, quintile, psu, strata, sex, ch_ghq, ch_audit)

# save intermediate df:
#arrow::write_parquet(shes_child_data, paste0(derived_data, "shes_child_data.parquet"))
# read back in if not in memory:
#shes_child_data <- arrow::read_parquet(paste0(derived_data, "shes_child_data.parquet"))

# Data checks:
table(shes_child_data$trend_axis, shes_child_data$ch_ghq)
# GHQ data for parents of children all years and aggregated years since 2008
table(shes_child_data$trend_axis, shes_child_data$ch_audit)
# AUDIT data for parents of children from 2012, but some missings (related to 2018)

# Do some more data checks:

# Adult data
# Groupings:
table(shes_adult_data$trend_axis, useNA = "always") # 2008 to 2021; no NA
table(shes_adult_data$sex, useNA = "always") # Female/Male/Total; no NA
table(shes_adult_data$quintile, useNA = "always") # 5 groups; no NAs
table(shes_adult_data$spatial.unit, useNA = "always") # 14 HBs; some NAs (all in 2009-2011 file, which won't be used anyway)
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
table(shes_child_data$trend_axis, useNA = "always") # 2008 to 2021; no NA
table(shes_child_data$sex, useNA = "always") # Female/Male/Total; no NA
table(shes_child_data$quintile, useNA = "always") # 5 groups; no NAs
table(shes_child_data$spatial.unit, useNA = "always") # 14 HBs; some NA (all in 2009-2011 file, which won't be used anyway)
table(shes_child_data$agegp7, useNA = "always") # none (as expected)

# 2 categorical indicators:
table(shes_child_data$ch_ghq, useNA = "always") # just yes, no and NA, so coding has worked
table(shes_child_data$ch_audit, useNA = "always") # just yes, no and NA, so coding has worked





# 8. Calculate indicator values by various groupings
# =================================================================================================================

# These survey calculation functions are in the functions.R script
# There are some warnings that appear: a deprecated bit (I can't find where to change this) and some 'NAs introduced by coercion'. These are OK.

# ADULT

# percents:

# 1. intwt used with main sample variables (HB possible here, so use 4-y agg data)
svy_percent_gh_qg2 <- calc_indicator_data(df = shes_adult_data, var = "gh_qg2", wt = "intwt", ind_id = 30003, type= "percent") # ok
svy_percent_gen_helf <- calc_indicator_data(shes_adult_data, "gen_helf", "intwt", ind_id=30017, type= "percent") # ok
svy_percent_limitill <- calc_indicator_data(shes_adult_data, "limitill", "intwt", ind_id=30018, type= "percent") # ok
svy_percent_adt10gp_tw <- calc_indicator_data(shes_adult_data, "adt10gp_tw", "intwt", ind_id=30012, type= "percent") # ok
svy_percent_porftvg3 <- calc_indicator_data(shes_adult_data, "porftvg3", "intwt", ind_id=30013, type= "percent") # ok
svy_percent_rg17a_new <- calc_indicator_data(shes_adult_data, "rg17a_new", "intwt", ind_id=30026, type= "percent") # ok

# 2. verawt used for vera vars: National and SIMD only (samples too small for HB) (use single or 2y agg data?)
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

# 1. intwts used with main sample variables (HB possible here, so use 4-y agg data)
svy_score_wemwbs <- calc_indicator_data(shes_adult_data, "wemwbs", "intwt", ind_id=30001, type= "score") # ok
svy_score_life_sat <- calc_indicator_data(shes_adult_data, "life_sat", "intwt", ind_id=30002, type= "score") # ok

# 2. verawt used for vera vars: National and SIMD only (samples too small for HB) (use single or 2y agg data?)
svy_score_work_bal <- calc_indicator_data(shes_adult_data, "work_bal", "verawt", ind_id=30052, type= "score") # ok

# CHILDREN

# 1. cintwt used with main sample variables (HB possible here, so use 4-y agg data)
svy_percent_ch_ghq <- calc_indicator_data(shes_child_data, "ch_ghq", "cintwt", ind_id=30130, type= "percent") # ok
svy_percent_ch_audit <- calc_indicator_data(shes_child_data, "ch_audit", "cintwt", ind_id=30129, type= "percent") # ok



# Combine all the resulting indicator data into a single file
###############################################################################

shes_results0 <- mget(ls(pattern = "^svy_"), .GlobalEnv) %>% # finds all the dataframes produced by the functions above
  do.call(rbind.data.frame, .)  #rbinds them all together (appending the rows)
rownames(shes_results0) <- NULL # drop the row names

# data checks:
table(shes_results0$trend_axis, useNA = "always") # 2008 to 2021
table(shes_results0$sex, useNA = "always") # Male, Female, Total
table(shes_results0$indicator, useNA = "always") # 20 vars (18 adult, 2 child), no NA
table(shes_results0$quintile, useNA = "always") # 1 to 5 and some NA: totals for Scotland and HBs
table(shes_results0$year, useNA = "always") # 2008 to 2021
table(shes_results0$def_period, useNA = "always") # 2008 to 2021, no NA
table(shes_results0$split_name, useNA = "always") # Deprivation only, no NA. Absence of sex split will be dealt with below.
table(shes_results0$split_value, useNA = "always") # correct, no NA


# work out which year splits to keep: 
# ScotPHO policy: if there are lower geog breakdowns that are designed to be aggregated over a number of years, we keep the national and SIMD data at that temporal scale too.
# Since 2008, SHeS has collected HB data in a way that is designed to be representative if pooled over 4 years. 
# National and SIMD data are representative annually.  

shes_results1 <- shes_results0 %>%
  mutate(year_range = as.numeric(substr(trend_axis, nchar(trend_axis)-3, nchar(trend_axis))) - as.numeric(substr(trend_axis, 1, 4))) %>%
  mutate(year_range = ifelse(year_range==4, 3, year_range)) %>% #adjusting for the single 5 year span (2017-21) when 2020 was omitted. Still only 4 survey years aggregated
  mutate(scale = substr(code, 1, 3)) %>%
  mutate(scale = case_when(scale=="S08" ~ "HB",
                           scale=="S00" & quintile=="Total" ~ "Scot",
                           scale=="S00" & split_name=="Deprivation (SIMD)" ~ "SIMD"))


# main sample variables (HB possible here, so use 4-y agg data)
main_sample_vars <- c("gh_qg2",    
                      "gen_helf",  
                      "limitill",  
                      "adt10gp_tw",
                      "porftvg3",  
                      "rg17a_new", 
                      "wemwbs",    
                      "life_sat",  
                      "ch_ghq",    
                      "ch_audit")
shes_results_main <- shes_results1 %>%
  filter(indicator %in% main_sample_vars)
ftable(shes_results_main$indicator, shes_results_main$scale, shes_results_main$year_range)
# HB level data for these indicators can be presented when aggregated over 4 years (year_range==3)
# Stick to this for SIMD and National data too.

# only national and SIMD data:
sub_sample_vars <- c("involve",  
                     "p_crisis", 
                     "str_work2",
                     "contrl",   
                     "support1", 
                     "depsymp",  
                     "anxsymp",  
                     "dsh5sc",   
                     "suicide2", 
                     "work_bal")
shes_results_sub <- shes_results1 %>%
  filter(indicator %in% sub_sample_vars)
ftable(shes_results_sub$indicator, shes_results_sub$scale, shes_results_sub$year_range)
# Only national and SIMD data available for these indicators. 
# Present single year data (year_range == 0)

# Now restrict the data to the right year_range, based on whether they are main or sub sample
shes_raw_data <- shes_results1 %>%
  filter((indicator %in% sub_sample_vars & year_range==0) | # single year
           (indicator %in% main_sample_vars & year_range==3) ) # 4 yr aggregation
ftable(shes_raw_data$indicator, shes_raw_data$scale, shes_raw_data$year_range)
# Yep, that's worked

# Check for suppression issues:
# SHeS suppress values where denominator (unweighted base) is <30
# As of Jan 2025, this applies to 13 data points: all of these are HB x sex data for the two CYP indicators
shes_raw_data <- shes_raw_data %>%
  mutate(across(.cols = c(numerator, rate, lowci, upci),
                .fns = ~case_when(denominator < 30 ~ as.numeric(NA),
                                  TRUE ~ as.numeric(.x))))

# save data ----
saveRDS(shes_raw_data, file = paste0(data_folder, 'Prepared Data/shes_raw.rds'))
#shes_raw_data <- readRDS(file = paste0(data_folder, 'Prepared Data/shes_raw.rds'))




##########################################################
### 3. Prepare final files -----
##########################################################

# Eventually we'll use the analysis functions:

# # main dataset analysis functions ----
# analyze_first(filename = "smoking_during_preg", geography = "datazone11", measure = "percent", 
#               yearstart = 2020, yearend = 2023, time_agg = 3)
# 
# analyze_second(filename = "smoking_during_preg", measure = "percent", time_agg = 3, 
#                ind_id = 30058, year_type = "calendar")
# 
# # deprivation analysis function ----
# analyze_deprivation(filename="smoking_during_preg_depr", measure="percent", time_agg=3, 
#                     yearstart= 2020, yearend=2023, year_type = "calendar", ind_id = 30058)

# But for now:

# Function to prepare final files: main_data and popgroup
prepare_final_files <- function(ind, ind_name){
  
  # 1 - main data (ie data behind summary/trend/rank tab)
  
  main_data <- shes_raw_data %>% 
    filter(indicator == ind,
           split_value == "Total",
           sex == "Total") %>% 
    select(code, ind_id, year, 
           numerator, rate, upci, lowci, 
           def_period, trend_axis) %>%
    unique() 
  
  # Save
  # Including both rds and csv file for now
  write_rds(main_data, file = paste0(data_folder, "Data to be checked/", ind_name, "_shiny.rds"))
  write_csv(main_data, file = paste0(data_folder, "Data to be checked/", ind_name, "_shiny.csv"))
  
  # 2 - population groups data (ie data behind population groups tab)
  
  pop_grp_data <- shes_raw_data %>% 
    filter(indicator == ind,
           split_value == "Total") %>% # split_value here refers to SIMD quintile
    select(-split_value) %>% #... so drop and replace with sex
    mutate(split_name = "Sex") %>%
    rename(split_value = sex) %>%
    select(code, ind_id, year, numerator, rate, upci, 
           lowci, def_period, trend_axis, split_name, split_value) 
  
  # Save
  # Including both rds and csv file for now
  write_rds(pop_grp_data, file = paste0(data_folder, "Data to be checked/", ind_name, "_shiny_popgrp.rds"))
  write_csv(pop_grp_data, file = paste0(data_folder, "Data to be checked/", ind_name, "_shiny_popgrp.csv"))
  
  
  # 3 - SIMD data (ie data behind deprivation tab)
  
  # Process SIMD data
  # NATIONAL LEVEL ONLY (BY SEX)
  simd_data <- shes_raw_data %>% 
    filter(indicator == ind & scale!="HB") %>% 
    unique() %>%
    mutate(quint_type = "sc_quin") %>%
    select(code, ind_id, year, numerator, rate, upci, 
           lowci, def_period, trend_axis, quintile, quint_type, sex) 
  
  # Save intermediate SIMD file
  write_rds(simd_data, file = paste0(data_folder, "Prepared Data/", ind_name, "_shiny_depr_raw.rds"))
  write.csv(simd_data, file = paste0(data_folder, "Prepared Data/", ind_name, "_shiny_depr_raw.csv"), row.names = FALSE)
  
  #get ind_id argument for the analysis function 
  ind_id <- unique(simd_data$ind_id)
  
  # Run the deprivation analysis (saves the processed file to 'Data to be checked')
  analyze_deprivation_aggregated(filename = paste0(ind_name, "_shiny_depr"), 
                                 pop = "depr_pop_16+", # 16+ by sex (and age). The function aggregates over the age groups.
                                 ind_id, 
                                 ind_name
  )
  
  # Make data created available outside of function so it can be visually inspected if required
  main_data_result <<- main_data
  pop_grp_data_result <<- pop_grp_data
  simd_data_result <<- simd_data
  
  
}


# Run function to create final files
prepare_final_files(ind = "gh_qg2", ind_name = "GHQ_4plus")    
prepare_final_files(ind = "gen_helf", ind_name = "general_health")  
prepare_final_files(ind = "limitill", ind_name = "limiting_illness")  
prepare_final_files(ind = "adt10gp_tw", ind_name = "adult_phys_act")
prepare_final_files(ind = "porftvg3", ind_name = "fruit_veg_consumption")  
prepare_final_files(ind = "rg17a_new", ind_name = "unpaid_caring") 
prepare_final_files(ind = "wemwbs", ind_name = "mental_wellbeing")    
prepare_final_files(ind = "life_sat", ind_name = "life_satisfaction")  
prepare_final_files(ind = "ch_ghq", ind_name = "cyp_parent_w_ghq4")    
prepare_final_files(ind = "ch_audit", ind_name = "cyp_parent_w_harmful_alc")
prepare_final_files(ind = "involve", ind_name = "involved_locally")  
prepare_final_files(ind = "p_crisis", ind_name = "support_network") 
prepare_final_files(ind = "str_work2", ind_name = "stress_at_work")
prepare_final_files(ind = "contrl", ind_name = "choice_at_work")   
prepare_final_files(ind = "support1", ind_name = "line_manager") 
prepare_final_files(ind = "depsymp", ind_name = "depression_symptoms")  
prepare_final_files(ind = "anxsymp", ind_name = "anxiety_symptoms")  
prepare_final_files(ind = "dsh5sc", ind_name = "deliberate_selfharm")   
prepare_final_files(ind = "suicide2", ind_name = "attempted_suicide")
prepare_final_files(ind = "work_bal", ind_name = "work-life_balance")



# # Run QA reports 
# These use local copies of the .Rmd files.
# These can be deleted once PR #116 is merged into scotpho-indicator-production repo

# # main data: 
run_qa(filename = "GHQ_4plus")    
run_qa(filename = "general_health")  
run_qa(filename = "limiting_illness")  
run_qa(filename = "adult_phys_act")
run_qa(filename = "fruit_veg_consumption")  
run_qa(filename = "unpaid_caring") 
run_qa(filename = "mental_wellbeing")    
run_qa(filename = "life_satisfaction")  
run_qa(filename = "cyp_parent_w_ghq4")    
run_qa(filename = "cyp_parent_w_harmful_alc")
run_qa(filename = "involved_locally")  
run_qa(filename = "support_network") 
run_qa(filename = "stress_at_work")
run_qa(filename = "choice_at_work")   
run_qa(filename = "line_manager") 
run_qa(filename = "depression_symptoms")  
run_qa(filename = "anxiety_symptoms")  
run_qa(filename = "deliberate_selfharm")   
run_qa(filename = "attempted_suicide")
run_qa(filename = "work-life_balance")

# ineq data: 
# get the run_ineq_qa to use full Rmd filepath so can be run from here
run_ineq_qa(filename = "GHQ_4plus")
run_ineq_qa(filename = "general_health")  
run_ineq_qa(filename = "limiting_illness")  
run_ineq_qa(filename = "adult_phys_act")
run_ineq_qa(filename = "fruit_veg_consumption")  
run_ineq_qa(filename = "unpaid_caring") 
run_ineq_qa(filename = "mental_wellbeing")    
run_ineq_qa(filename = "life_satisfaction")  
run_ineq_qa(filename = "cyp_parent_w_ghq4")    
run_ineq_qa(filename = "cyp_parent_w_harmful_alc")
run_ineq_qa(filename = "involved_locally")  
run_ineq_qa(filename = "support_network") 
run_ineq_qa(filename = "stress_at_work")
run_ineq_qa(filename = "choice_at_work")   
run_ineq_qa(filename = "line_manager") 
run_ineq_qa(filename = "depression_symptoms")  
run_ineq_qa(filename = "anxiety_symptoms")  
run_ineq_qa(filename = "deliberate_selfharm")   
run_ineq_qa(filename = "attempted_suicide")
run_ineq_qa(filename = "work-life_balance")

## END