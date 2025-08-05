# ============================================================================
# ===== Processing UKDS survey data files: ANNUAL POPULATION SURVEY (aps) =====
# ============================================================================

# NOTES ON APS

# 1 indicator = workless (ind_id = 30032)
# Definition: “Percentage of adults (16-64 year olds, excluding students) who are unemployed or who are economically inactive and want to work”
# Denominator = Adults 16-64y, excluding students. 
# Survey weights = pwapsa14, pwta14, pwta18, pwta22.
# These are grossing weights, so I had to apply them to the unweighted base to reverse engineer weighted counts that sample weights would have given. 
# Survey design factor = not available in UKDS EUL version of the data. So we analysed without accounting for design effects. 
# Tried initially to derive from NOMIS data, but this included students.
# The variable INECAC05 from the UKDS EUL version of APS does permit exclusion of students (Scotland-wide).
# Future: apply for SecureLab access to APS so that can get data to lower geogs, and perhaps link SIMD data in too.


# Packages and functions
# =================================================================================================================

## A. Load in the packages

pacman::p_load(
  here, # for file paths within project/repo folders
  haven, # importing .dta files from Stata
  openxlsx, # reading and creating spreadsheets
  arrow, # work with parquet files
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

## Create a new workbook (first time only. don't run this now)
#wb <- createWorkbook()
#saveWorkbook(wb, file = here("data", "all_survey_var_info.xlsx"))

save_var_descriptions(survey = "aps", 
                      name_pattern = "(\\d{2})_eul") # the regular expression for this survey's filenames that identifies the survey year(s)
# takes ~ 10 mins


# 2. Manual bit: Look at the vars_'survey' tab of the spreadsheet all_survey_var_info.xlsx to work out which variables are required.
#    Manually store the relevant variables in the file vars_to_extract_'survey'
# =================================================================================================================


# 3. Extract the relevant survey data from the files 
# =================================================================================================================

extracted_survey_data_aps <- extract_survey_data("aps") 
# takes ~ 10 mins 

# For APS this is a huge file because it contains responses for all respondents in the UK.
# So we read in the file, extract the Scottish data only, and resave:
extracted_survey_data_aps <- readRDS(paste0(derived_data, "extracted_survey_data_aps.rds")) %>%
  mutate(survey_data = map(survey_data, ~.x %>%
                          filter(govtof=="Scotland")))  # select only Scottish respondents
write_rds(extracted_survey_data_aps, paste0(derived_data, "extracted_survey_data_aps.rds"))  


# 4. What are the possible responses?
# =================================================================================================================

# Read in the data if necessary
# extracted_survey_data_aps <- readRDS(paste0(derived_data, "extracted_survey_data_aps.rds"))

# get the responses recorded for each variable (combined over the years), and save to xlsx and rds

# 1st run through to see how to identify variables that can be excluded (and the unique characters that will identify these):
# extract_responses(survey = "aps") 
# responses_as_list_aps <- readRDS(paste0(derived_data, "responses_as_list_aps.rds"))
# responses_as_list_aps  # examine the output

# 2nd run to exclude the numeric vars that don't need codings and/or muck up the output:

extract_responses(survey = "aps", #survey acronym
                  chars_to_exclude = c("age", "pwta", "pwapsa14")) #we don't need to work out codings for these numeric vars (and they muck up the output)

# read the responses back in and print out so we can work out how they should be coded
# (also useful to see how sex/geography/simd variables have been recorded, for later standardisation)

responses_as_list_aps <- readRDS(paste0(derived_data, "responses_as_list_aps.rds"))
responses_as_list_aps

# responses_as_list_aps printed out
###################################

# $govtof
# [1] "Scotland"                          
# 
# $inecac05
# [1] "Employee"                                              "Under 16"                                              "Self-employed"                                        
# [4] "Inact- not sk,not like, retired"                       "Inact- seeking, unavailable, student"                  "Inact- not sk,not like,tmp-lngtrm sick,injur disab"   
# [7] "Inact-not sk,not like,lk after fam,home"               "Government emp & training programmes"                  "Inact- not sk,not like, student"                      
# [10] "Inact- not sk,like, temp sick,injur disab"             "ILO unemployed"                                        "Inact- not sking, wld like, student"                  
# [13] "Inact- not sk,like,lking after fam,home"               "Inact- not sk,not like,oth no reason given"            "Inact- not sk,not like,not need,want job"             
# [16] "Does not apply"                                        "Inact-not sk,like,no job avail,not looked,no reas"     "Inact- sking, unavail, other no reason"               
# [19] "Inact- not sk,like, no reason given"                   "Inact- not sk,like, retired"                           "Unpaid family worker"                                 
# [22] "Inact- not sk,like,not need,want job"                  "Inact- not sk,wld like,wait res job app"               "Inact- sking,unav,lking after fam,home"               
# [25] "Inact-not sk,not like,no job avail,not looked,no reas" "Inact- sking,unav,tmp-lngtrm sick injur disab"         "Inact- not sk,not like,wait results app"              
# [28] "Government emp and training programmes"                "Inact- not sk,like,no job avail,not looked,no reas"    "Inactive - seeking, unavailable, student"             
# 
# $sex
# [1] "Female" "Male"      
#
# $stucur
# [1] "FT student"     "Not FT student"
      
###################################


# 5. How should the responses be coded?
# =================================================================================================================
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?

# Create lookups to code the inecac05 variable into the dichotomy needed for the indicator:
yes_responses <- c("ILO unemployed",  # the numerator
            "Inact- not sk,wld like,wait res job app", 
            "Inact- not sk,like,lking after fam,home", 
            "Inact- not sk,like, temp sick,injur disab",
            "Inact-not sk,like,no job avail,not looked,no reas",
            "Inact- not sk,like,not need,want job",
            "Inact- not sk,like, retired",
            "Inact- not sk,like, no reason given",
            "Inact- not sk,like,no job avail,not looked,no reas")             
no_responses <- c("Employee",  # yes + no responses = the denominator
            "Self-employed", 
            "Government emp & training programmes", 
            "Government emp and training programmes", 
            "Unpaid family worker",
            "Inact- sking,unav,lking after fam,home",         
            "Inact- sking,unav,tmp-lngtrm sick injur disab", 
            "Inact- sking, unavail, other no reason",               
            "Inact- not sk,not like,wait results app", 
            "Inact-not sk,not like,lk after fam,home",
            "Inact- not sk,not like,tmp-lngtrm sick,injur disab", 
            "Inact-not sk,not like,no job avail,not looked,no reas", 
            "Inact- not sk,not like,not need,want job",                       
            "Inact- not sk,not like, retired", 
            "Inact- not sk,not like,oth no reason given"
            ) 
na_responses <- c("Does not apply", "No answer", "Under 16",
                  "Inact- not sking, wld like, student",
                  "Inact- not sk,not like, student",               
                  "Inact- seeking, unavailable, student", 
                  "Inactive - seeking, unavailable, student" ) # not counted in the denominator

# 6. Process the survey data to produce the indicator(s)
# =================================================================================================================

# Produce a flat file by unnesting the list column
aps_data <- extracted_survey_data_aps %>%
  mutate(survey_data = map(survey_data, ~.x %>%
                             mutate(across(.cols = everything(), as.character)))) %>% # to deal with some incompatible formats that mucked up the unnest()
  unnest(cols = c(survey_data)) %>%
  mutate(weight = as.numeric(as.character(coalesce(pwta14, pwta18, pwta22, pwapsa14))), # get the weights into one column with var names "weight"
         age = as.numeric(age)) %>% # convert ages back to numeric
  filter(year!="04") %>% # drops 2004 data as inecac05 not in this survey year
  filter(stucur!="FT student") %>% #drop all FT students
  filter(age %in% c(16:64)) %>% # indicator is defined for 16-64 year olds. Drops a few cases where age is NA, but all but one of these have inecac05 = retired, so likely >64.
  select(-contains("pwta"), -pwapsa14) # drop the individual weights columns now
  

# data checks
table(aps_data$year, useNA = "always") # 05 to 24
table(aps_data$age, useNA = "always") # all are 16-64
table(aps_data$sex, useNA = "always") # all are Male or Female
table(aps_data$inecac05, useNA = "always")
#table(aps_data$inecac05, aps_data$stucur, useNA = "always")


# Calculate the indicator
workless <- aps_data %>%
  mutate(sex="Total") %>% # recode all individuals to sex==total
  rbind(aps_data) %>% # add male and female data back in, so grouping produces values for m, f, and total.
  group_by(year, sex) %>%
  summarise(yes_grossed = sum(weight * inecac05 %in% yes_responses, na.rm = TRUE), #grossed up to population
            no_grossed = sum(weight * inecac05 %in% no_responses, na.rm = TRUE), #grossed up to population
            yes_unwted = sum(1 * inecac05 %in% yes_responses, na.rm = TRUE),
            no_unwted = sum(1 * inecac05 %in% no_responses, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(denominator = yes_unwted + no_unwted,
         proportion = yes_grossed / (yes_grossed + no_grossed),
         numerator = rnd(denominator * proportion), # calculate RESPONSE-weighted number of cases based on share of the unweighted base
         rate = 100 * proportion,
         lowci = 100 * (((2*numerator) + (1.96*1.96) - 1.96*sqrt((1.96*1.96) + (4*numerator*(1-proportion)))) / (2 * (denominator + (1.96*1.96)))), # Wilson's score method.
         upci = 100 * (((2*numerator) + (1.96*1.96) + 1.96*sqrt((1.96*1.96) + (4*numerator*(1-proportion)))) / (2 * (denominator + (1.96*1.96)))),
         year = 2000 + as.numeric(year),
         trend_axis = as.character(year),
         def_period = paste0(year, " survey year"),
         code = "S00000001",
         ind_id = 30032,
         split_name = "Sex") %>%
  rename(split_value = sex) %>%
  select(-c(proportion, no_unwted, yes_unwted, yes_grossed, no_grossed, denominator)) %>%
  arrange(ind_id, split_name, split_value, code, year)

# data checks:
table(workless$year, useNA = "always") # 2005 to 2024, no NA
table(workless$split_value, useNA = "always") # Female/Male/Total, no NA


# Suppression required? No.
# denominator check: smallest is over 3000
# numerator check: smallest is 192

# 6. Prepare final files
# =================================================================================================================

# Prepare the main dataset

main_workless <- workless %>%
  filter(split_value == "Total") %>%
  select(-starts_with("split"))

saveRDS(main_workless, file = file.path(profiles_data_folder, "Data to be checked", "workless_shiny.rds"))
write.csv(main_workless, file.path(profiles_data_folder, "Data to be checked", "workless_shiny.csv"), row.names = FALSE)



# Save the popgroup dataset

saveRDS(workless, file = file.path(profiles_data_folder, "Data to be checked", "workless_shiny_popgrp.rds"))
write.csv(workless, file.path(profiles_data_folder, "Data to be checked", "workless_shiny_popgrp.csv"), row.names = FALSE)


# Run QA

run_qa("workless", type = "main")
#run_qa("workless", type = "popgrp")

# QA looks good
  
  
## END

