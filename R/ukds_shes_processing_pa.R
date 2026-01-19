# ============================================================================
# ===== Processing UKDS survey data files: SCOTTISH HEALTH SURVEY (shes) =====
# ============================================================================

## NB. THE PROCESSING CAN TAKE A LOT OF MEMORY. IF THE SCRIPT FAILS, OPEN IT IN A SESSION WITH MORE MEMORY.

# Notes on SHeS

#2 adult indicators: 
# 50001 - mus_rec - Adults meeting muscle strengthening guidelines. 2011 CMO guidelines recommend 2x 30 minute muscle strengthening sessions per week
# 50002 - adt10gp_tw - Adults with very low activity levels. Also in CWB, AMH profiles. 2011 CMO guidelines recommend 150 mins/week MVPA.

#3 child indicators
# 50003 - c00sum7s - Children with very low activity levels
# 50004 - spt1ch - Children participating in sport
# 50005 - ch30plyg - Children engaging in active play

# Denominators = Total number of respondents answering the question. 'Don't know' is omitted.

# Survey weights =
# 2 different types of weights need to be used, depending on the variable being analysed:
# main sample weights of the form int...wt
# child interview weights of the form cint..wt

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

source(here("functions", "functions_pa.R")) # sources the file "functions/functions.R" within this project/repo

# Source functions/packages from ScotPHO's scotpho-indicator-production repo 
# (works if you've stored the ScotPHO repo in same location as the current repo)
# change wd first
setwd("../scotpho-indicator-production/")
source("functions/main_analysis.R") # for packages and QA function 
source("functions/deprivation_analysis.R") # for packages and QA function (and path to lookups)

# move back to the ScotPHO_survey_data repo
setwd("/PHI_conf/ScotPHO/1.Analysts_space/Abbie/ScotPHO_survey_data")

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
#save_var_descriptions(survey = "shes", # looks in this folder 
#                       name_pattern = "\\/she?s\\D?(\\d{2,10})") # the regular expression for this survey's filenames that identifies the survey year(s)
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
extracted_survey_data_shes <- extract_survey_data("shes", phy = TRUE) 
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
saveRDS(extracted_survey_data_shes, paste0(derived_data, "extracted_survey_data_shes_pa.rds"))


# 4. What are the possible responses? (needed so we can decide how to code each variable)
# =================================================================================================================

## A. Read the data back in if not in memory:
extracted_survey_data_shes <- readRDS(paste0(derived_data, "extracted_survey_data_shes_pa.rds"))

## B. Get all the possible responses that have been recorded for each variable (combined over the years), and save to xlsx and rds
# Running extract_responses() will modify existing spreadsheet and overwrite existing rds file

# 1st run through to see how to identify any variables that can be excluded (e.g., weights) (and the unique characters that will identify these):
# extract_responses(survey = "shes") 
# responses_as_list_shes <- readRDS(paste0(derived_data, "responses_as_list_shes.rds")))
# responses_as_list_shes  # examine the output
# 2nd run to exclude the numeric vars that don't need codings and/or muck up the output:
extract_responses(survey = "shes", #survey acronym
                  chars_to_exclude = c("wt", "age", "psu", "strata", "weighta", "par", "serial"), phy = TRUE) #we don't need to work out codings for these numeric vars (and they muck up the output)
# What this function does: 
#   Runs get_valid_responses() function for each variable in each survey file.
#   This extracts any character/factor data, converts to character, stores in a dataframe.
#   Variables containing any of the chars_to_exclude are dropped from the dataframe.
#   The dataframe containing all the unique variable-response pairs is saved as "responses_as_list_shes.rds" and 
#   also to a worksheet called responses_shes in the same spreadsheet as the original variables were. 

## C. Read the responses back in and print out so we can work out how they should be coded
# (also useful to see how sex/geography/simd variables have been recorded, for later standardisation)

responses_as_list_shes <- readRDS(paste0(derived_data, "responses_as_list_shes_pa.rds"))

## D. Print out this list to the console and copy into this script for reference:
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?
responses_as_list_shes

###################################

# $adt10gp_tw
# [1] "Meets recommendations"   "Schedule not applicable" "Very low activity"       "Some activity"          
# [5] "Low activity"            "Don't know"              "Refused"                 "Not answered"           
# [9] "Refused/ not answered"   "Refused\\ not answered"  "Refused/not answered"   
# 
# $c00sum7s
# [1] "Schedule not applicable"          "Group 1:60+min on all 7 days"     "Group 2:30-59min on all 7 days"  
# [4] "Group 3:Lower level of activity"  "Don't know"                       "Item not applicable"             
# [7] "schedule not applicable"          "item not applicable"              "don't know"                      
# [10] "Dont know"                        NA                                 "Age 16+"                         
# [13] "Age 0-1"                          "Not applicable"                   "Group 1: 60+min on all 7 days"   
# [16] "Group 2: 30-59min on all 7 days"  "Group 3: Lower level of activity"
# 
# $ch30plyg
# [1] "not applicable"          "None"                    "5 or more"               "1 or 2"                 
# [5] "3 or 4"                  "Item not applicable"     "Don't know"              "Schedule not applicable"
# [9] "schedule not applicable" "don't know"              "Dont know"               NA                       
# [13] "Not applicable"         
# 
# $final_sex22
# [1] "Male"              "Female"            "Refused"           "Prefer not to say"
# 
# $hb_code
# [1] "Forth Valley"                "Fife"                        "Western Isles"               "Greater Glasgow and Clyde"  
# [5] "Grampian"                    "Lothian"                     "Ayrshire and Arran"          "Lanarkshire"                
# [9] "Tayside"                     "Dumfries and Galloway"       "Highland"                    "Shetland"                   
# [13] "Borders"                     "Orkney"                      "SJ9 Greater Glasgow & Clyde" "SW9 Western Isles"          
# [17] "SR9 Orkney"                  "ST9 Tayside"                 "SK9 Highland"                "SA9 Ayrshire & Arran"       
# [21] "SS9 Lothian"                 "SY9 Dumfries & Galloway"     "SV9 Forth Valley"            "SF9 Fife"                   
# [25] "SN9 Grampian"                "SL9 Lanarkshire"             "SZ9 Shetland"                "SB9 Borders"                
# [29] "10"                          "7"                           "9"                           "11"                         
# [33] "5"                           "2"                           "3"                           "12"                         
# [37] "8"                           "13"                          "6"                           "1"                          
# [41] "4"                           "14"                         
# 
# $hbcode
# [1] "Forth Valley"              "Fife"                      "Western Isles"             "Greater Glasgow"          
# [5] "Grampian"                  "Lothian"                   "Ayrshire and Arran"        "Lanarkshire"              
# [9] "Tayside"                   "Dumfries and Galloway"     "Highland"                  "Shetland"                 
# [13] "Borders"                   "Orkney"                    "7"                         "10"                       
# [17] "5"                         "9"                         "12"                        "4"                        
# [21] "2"                         "1"                         "6"                         "3"                        
# [25] "13"                        "8"                         "14"                        "11"                       
# [29] "Greater Glasgow and Clyde" "Greater Glascow and Clyde"
# 
# $hlth_brd
# [1] "Fife"                    "Forth Valley"            "Lothian"                 "Borders"                
# [5] "Orkney"                  "Greater Glasgow & Clyde" "Tayside"                 "Grampian"               
# [9] "Ayrshire & Arran"        "Western Isles"           "Highland"                "Lanarkshire"            
# [13] "Dumfries & Galloway"     "Shetland"                "Greater"                 "Ayrshire and Arran"     
# [17] "Dumfries and Galloway"  
# 
# $hlthbrd
# [1] "Lothian"                 "Lanark"                  "Forth Valley"            "Fife"                   
# [5] "Ayrshire & Arran"        "Glasgow"                 "Argyll & Clyde"          "Highland & Islands"     
# [9] "D & G"                   "Grampian"                "Tayside"                 "Borders"                
# [13] "Highland"                "Greater Glasgow"         "Lanarkshire"             "Shetland"               
# [17] "Dumfries & Galloway"     "Western Isles"           "Orkney"                  "Greater Glasgow & Clyde"
# [21] NA                        "Greater"                 "Ayrshire and Arran"      "Dumfries and Galloway"  
# 
# $mus_rec
# [1] "Yes"                     "Schedule not applicable" "No"                     
# 
# $sex
# [1] "Male"   "Female" NA      
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
# [1] "4"              "3"              "Most deprived"  "2"              "Least deprived" NA              
# 
# $simd5_s_ga
# [1] "3rd"                   "2nd"                   " 5th - least deprived" "4th"                   "1st - most deprived"  
# [6] "3"                     "2"                     "Least deprived"        "4"                     "Most deprived"        
# [11] "most deprived"         "least deprived"        "Not applicable"       
# 
# $spt1ch
# [1] "not applicable"          "No"                      "Yes"                     "Schedule not applicable"
# [5] "Don't know"              "No answer/refused"       "Refused"                 "schedule not applicable"
# [9] "refused"                 "don't know"              "Don't Know"              "Refusal"                
# [13] NA                        "Dont know"               "Item not applicable"    

###################################

# 5. How should the responses be coded?
# =================================================================================================================
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?

# Create lookups to code the variables into the dichotomy needed for the indicators:
# (each lookup needs to contain all response versions including the range of punctuation and capitalisation used)

# Lookups as lists: 
# "yes" indicates a case (summed later to give numerator)
# "no" indicates an alternative response (not a case) that should be included in the denominator

# low levels of physical activity indicator
lookup_adt10gp_tw <- list(
  "Meets recommendations"="no",
  "Low activity"="no", 
  "Some activity"="no", 
  "Very low activity"="yes")

#Children participating in sport
lookup_spt1ch <- list(
  "No" = "no",
  "Yes" = "yes")

#Children engaging in active play
lookup_ch30plyg <- list(
  "None" = "no",
  "1 or 2" = "no",
  "3 or 4" = "no",
  "5 or more" = "yes")

#Children with very low activity levels
lookup_c00sum7s <- list(
  "Group 1:60+min on all 7 days" = "no",
  "Group 1: 60+min on all 7 days" = "no",
  "Group 2:30-59min on all 7 days" = "no",
  "Group 2: 30-59min on all 7 days" = "no",
  "Group 3:Lower level of activity" = "yes",
  "Group 3: Lower level of activity" = "yes")

#Adults meeting muscle strengthening recommedation
lookup_mus_rec <- list(
  "No" = "no",
  "Yes" = "yes")

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
# Drop everything prior to 2012
shes_data <- extracted_survey_data_shes %>%
  filter(!year %in% c("95", "98", "03", "20", "08", "0809", "09", "0810", "10", "08091011", "0911", "1011", "11")) 
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


# Recode the variables
shes_data <- shes_data %>%  
  
  # Variables with simple recoding:
  mutate(adt10gp_tw = recode(adt10gp_tw, !!!lookup_adt10gp_tw, .default = as.character(NA))) %>%
  mutate(mus_rec = recode(mus_rec, !!!lookup_mus_rec, .default = as.character(NA))) %>%
  mutate(c00sum7s = recode(c00sum7s, !!!lookup_c00sum7s, .default = as.character(NA))) %>% 
  mutate(spt1ch = recode(spt1ch, !!!lookup_spt1ch, .default = as.character(NA))) %>%
  mutate(ch30plyg = recode(ch30plyg, !!!lookup_ch30plyg, .default = as.character(NA))) %>%
  mutate(limitill = recode(limitill, !!!lookup_limitill, .default = as.character(NA))) %>%
  
  # keep only the vars required for the analysis
  select(-c(filename, fileloc, bio_wt, intakewt)) %>% #number_of_recalls, # will be required for future porftvg3intake variable processing (but not currently)
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

#add in 65+ age group
shes_data <- shes_data |> 
  mutate(age65plus = case_when(age >= 65 ~ TRUE,
                              TRUE ~ FALSE))

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
#arrow::write_parquet(shes_data, paste0(derived_data, "shes_data_pa.parquet"))
# read back in if not in memory:
shes_data <- arrow::read_parquet(paste0(derived_data, "shes_data_pa.parquet"))


# 7. Split data into adult and child subsets
# =================================================================================================================

## A: Subset off the adult indicators
# repeat all rows of the data with sex=="Total" & restrict to adults
shes_adult_data <- shes_data %>%
  mutate(sex="Total") %>%
  rbind(shes_data) %>%
  filter(!child) %>%
  select(-c(child, contains("serial"), starts_with("par"), cintwt, c00sum7s, spt1ch, ch30plyg, verawt))
# save intermediate df:
#arrow::write_parquet(shes_adult_data, paste0(derived_data, "shes_adult_data_pa.parquet"))
# read back in if not in memory:
shes_adult_data <- arrow::read_parquet(paste0(derived_data, "shes_adult_data_pa.parquet"))

# Subset off the data to form the child indicators 
shes_child_data <- shes_data %>%
  filter(child) %>% # keep 0-15
  select(year, trend_axis, contains("serial"),
         cintwt, psu, strata, sex, age, spatial.unit, spatial.scale, quintile,
         c00sum7s, spt1ch, ch30plyg, limitill) |> 
  filter(age >= 5) #only keep kids aged 5+ - new addition 

# final child data (add in sex=total)
shes_child_data <- shes_child_data %>%
  mutate(sex="Total") %>%
  rbind(shes_child_data) %>%
  select(-indserial, -hhserial) |> 
  mutate(age_group = case_when(age < 12 ~ "5-11",
                               age >= 12 ~ "12-15",
                               TRUE ~ as.character(NA)))

# save intermediate df:
#arrow::write_parquet(shes_child_data, paste0(derived_data, "shes_child_data_pa.parquet"))
# read back in if not in memory:
shes_child_data <- arrow::read_parquet(paste0(derived_data, "shes_child_data_pa.parquet"))

# Data checks:
#Children with very low activity levels
table(shes_child_data$trend_axis, shes_child_data$c00sum7s)
#Children who participate in sport
table(shes_child_data$trend_axis, shes_child_data$spt1ch)
#Children who engage in active play
table(shes_child_data$trend_axis, shes_child_data$ch30plyg)
# From SHeS dashboard notes: Data is not available for 2017 and 2018 (and hence 2015-18 and 2017-21) due to differences in the way the data was collected for these years which means that the estimates for these years are not comparable with the other SHeS surveys.

# Do some more data checks:

# Adult data
#Adults who meet muscle strengthening recommendations
table(shes_adult_data$trend_axis, shes_adult_data$mus_rec)
#Adults with very low activity
table(shes_adult_data$trend_axis, shes_adult_data$adt10gp_tw)

# Groupings:
table(shes_adult_data$trend_axis, useNA = "always") # 2012 to 2022; no NA
table(shes_adult_data$sex, useNA = "always") # Female/Male/Total; 82 NA (2022)
table(shes_adult_data$quintile, useNA = "always") # 5 groups; no NAs
table(shes_adult_data$spatial.unit, useNA = "always") # 14 HBs; no NAs 
table(shes_adult_data$agegp7, useNA = "always") # no NAs

# Child data
# Groupings:
table(shes_child_data$trend_axis, useNA = "always") # 2012 to 2022; no NA
table(shes_child_data$sex, useNA = "always") # Female/Male/Total; 2 NA
table(shes_child_data$quintile, useNA = "always") # 5 groups; no NAs
table(shes_child_data$spatial.unit, useNA = "always") # 14 HBs; no NA 
table(shes_child_data$agegp7, useNA = "always") # none (as expected)

# 8. Calculate indicator values by various groupings
# =================================================================================================================

# These survey calculation functions are in the functions.R script
# There are some warnings that appear: a deprecated bit (I can't find where to change this) and some 'NAs introduced by coercion'. These are OK.

# ADULT
# percents:
#intwt used with main sample variables 
svy_percent_mus_rec <- calc_indicator_data(shes_adult_data, "mus_rec", "intwt", ind_id = 14001, type = "percent")
svy_percent_adt10gp_tw <- calc_indicator_data(shes_adult_data, "adt10gp_tw", "intwt", ind_id= 14002, type= "percent") # ok

# CHILDREN
#cintwt used with main sample variables 
svy_percent_c00sum7s <- calc_indicator_data(shes_child_data, "c00sum7s", "cintwt", ind_id = 14003, type = "percent")
svy_percent_spt1ch <- calc_indicator_data(shes_child_data, "spt1ch", "cintwt", ind_id = 14006, type = "percent")
svy_percent_ch30plyg <- calc_indicator_data(shes_child_data, "ch30plyg", "cintwt", ind_id = 14007, type = "percent")


# Let's check that all ages are available when split_name="Age", and that there are sufficient denominators (>30 for SHeS)
make_denom_table <- function(df) {
  
  df %>% 
    filter(split_name == "Age") %>%
    select(trend_axis, split_value, denominator) %>%
    pivot_wider(names_from = split_value, values_from = denominator) %>%
    print(n = 30) 
  
}

make_denom_table(svy_percent_mus_rec) # 0 to 15y
make_denom_table(svy_percent_adt10gp_tw) # 0 to 15y
make_denom_table(svy_percent_c00sum7s) # 4 to 12 years
make_denom_table(svy_percent_spt1ch) # 0 to 15y
make_denom_table(svy_percent_ch30plyg)
# Yep, all denoms >30 and most >100


# 9. Combine all the resulting indicator data into a single file
###############################################################################

shes_results0 <- mget(ls(pattern = "^svy_"), .GlobalEnv) %>% # finds all the dataframes produced by the functions above
  do.call(rbind.data.frame, .)  #rbinds them all together (appending the rows)
rownames(shes_results0) <- NULL # drop the row names

# save intermediate df:
arrow::write_parquet(shes_results0, paste0(derived_data, "shes_results0_pa.parquet"))
# read back in if not in memory:
shes_results0 <- arrow::read_parquet(paste0(derived_data, "shes_results0_pa.parquet"))


# Currently the only split_names are Age (which doesn't include a total) and Deprivation (SIMD) (which does include a Total)
# Sex data: Extract data split by sex only (i.e., split_value == Total) and get split_name and split_value sorted:
sex_data <- shes_results0 %>%
  filter(split_value == "Total") %>% #10631
  select(-quintile) %>%
  mutate(split_name = "Sex",
         split_value = sex)

# Deprivation data, keep all the totals that match each breakdown (Scotland x indicator x sex x trend_axis)
dep_data <- shes_results0 %>%
  group_by(trend_axis, sex, indicator, ind_id, code, year, def_period, split_name) %>%
  mutate(count = n()) %>%
  ungroup() %>%
  filter(count>2) %>% # 1 if only a total provided, 2 if only one quintile could be calculated in addition to the total.
  select(-count, -quintile) #7295

# Age data: add Age = Total to the age splits for CYP indicators
age_totals <- shes_results0 %>%
  filter(split_value == "Total" & sex == "Total" & indicator %in% c("spt1ch", "ch30plyg", "c00sum7s")) %>% 
  select(-quintile) %>%
  mutate(split_name = "Age")

age_data <- shes_results0 %>%
  filter(split_name=="Age" & indicator %in% c("spt1ch", "ch30plyg", "c00sum7s")) %>%
  select(-quintile) %>%
  rbind(age_totals)
  
# Combine 
shes_results1 <- sex_data %>%
  rbind(dep_data, age_data) # n=19519

# 6 adult vars from SHeS main sample are available from the published data (statistics.gov.scot, see SHeS script in the ScotPHO-indicator-production repo).
# The UKDS data can supplement those published data with SIMD x sex data (Scotland). Just keep that breakdown here:
published_vars <- c("gh_qg2", "gen_helf", "limitill",
                      "adt10gp_tw", "porftvg3", "wemwbs")

published_to_keep <- shes_results1 %>%
  filter(indicator %in% published_vars & 
           substr(code, 1, 3)=="S00" & 
           split_name=="Deprivation (SIMD)" & 
           sex %in% c("Male", "Female")) #1500

shes_results1 <- shes_results1 %>%
  filter(!indicator %in% published_vars) %>% 
  rbind(published_to_keep) #9633

# keep only trend_axis values that are single year or 4-year aggregates (shorter aggregate periods are sometimes available but confuse matters)
shes_results1 <- shes_results1 %>%
  filter(nchar(trend_axis)==4 | #single year
           (as.numeric(substr(trend_axis, 6, 9)) - as.numeric(substr(trend_axis, 1, 4)) > 2)) # aggregations like 2017-2021
# 9633 rows still


# data checks:
table(shes_results1$trend_axis, useNA = "always") # 2008 to 2022, na NA
table(shes_results1$sex, useNA = "always") # Male, Female, Total, (NAs for CYP indicators)
table(shes_results1$indicator, useNA = "always") # 22 vars (18 adult, 4 child), no NA
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
                                  TRUE ~ as.numeric(.x)))) #9633 still

# get indicator names into more informative names for using as filenames
shes_raw_data <- shes_results1 %>%
  mutate(indicator = case_when( indicator == "adt10gp_tw" ~ "adults_very_low_activity",    
                                indicator == "mus_rec" ~ "meeting_muscle_strengthening_recommendations",
                                indicator == "c00sum7s" ~ "children_very_low_activity",
                                indicator == "spt1ch" ~ "children_participating_sport",
                                indicator == "ch30plyg" ~ "children_active_play",
                                TRUE ~ as.character(NA)  ))

# save data ----
saveRDS(shes_raw_data, file = paste0(profiles_data_folder, '/Prepared Data/shes_pa_raw.rds'))
write.csv(shes_raw_data, file = "/PHI_conf/ScotPHO/1.Analysts_space/Abbie/PA_SHES_Test.csv")
shes_raw_data <- readRDS(file = paste0(profiles_data_folder, '/Prepared Data/shes_pa_raw.rds'))


# 10. Import into the SHeS script in scotpho-indicator-production repo and prepare final files there. 
###############################################################################




## END