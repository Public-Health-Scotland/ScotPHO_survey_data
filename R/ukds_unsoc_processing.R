# ============================================================================
# ===== Processing UKDS survey data files: UNDERSTANDING SOCIETY (unsoc) =====
# ============================================================================

# NOTES ON UNSOC

# 1 indicator = job security (ind_id = 30055)
# Definition: “Percentage of adults in employment who think it is very likely or likely that they will lose their job by being sacked, laid off, 
# made redundant or not having their contract renewed, during the next 12 months." 
# Var jbsec: Respondents were asked:
# "I would like you to think about your employment prospects over the next 12 months. 
# Thinking about losing your job by being sacked, laid-off, made redundant or not having your contract renewed, how likely do you think it is that you will lose your job during the next 12 months?". 
# Four options were provided, from "very likely" to "very unlikely". 
# The question (jbsec) is asked every two years.
# Responses are in *indresp files and SIMD quintiles are in *indall files: these are merged using pidp identifier (and year)
# Denominator = Employees 16+ who responded to question (including don't knows)
# Survey weights = <wave letter b or d>_indinui_xw or <wave letter f to n>_indinub_xw
# Survey design = psu and strata variables are used to adjust for the clustered survey design
# Availability = Every other FY from 2010/11 (wave B) to 2022/23 (wave N), national and SIMD2020 quintile, M/F/Total


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

## Create a new workbook (first time only. don't run this now)
#wb <- createWorkbook()
#saveWorkbook(wb, file = paste0(derived_data, "all_survey_var_info.xlsx"))

save_var_descriptions(survey = "unsoc", 
                      name_pattern = "\\/([a-z]*)_.*") # the regular expression for this survey's filenames that identifies the survey year(s)
# takes ~ 5 mins

# 2. Manual bit: Look at the vars_'survey' tab of the spreadsheet all_survey_var_info.xlsx to work out which variables are required.
#    Manually store the relevant variables in the file vars_to_extract_'survey'
# =================================================================================================================


# 3. Extract the relevant survey data from the files 
# =================================================================================================================

extracted_survey_data_unsoc <- extract_survey_data("unsoc") 
# takes ~ 8 mins 

# keep only the survey files we are interested in
# filenames: 
# a_ to n_ are UKHLS (Understanding Society): job security question asked every other year (ADD THE NEXT WAVE LETTER WHEN UPDATED DATA AVAILABLE: CURRENTLY (IN 2025) 2022/23 IS LATEST)
# ba_ to br_ are BHPS: job security question not asked
extracted_survey_data_unsoc <- extracted_survey_data_unsoc %>%
  filter(substr(filename, 1, 2) %in% c("b_", "d_", "f_", "h_", "j_", "l_", "n_")) %>% # jobsecurity variable only asked in these waves (last one = N = 2022/23)
  mutate(year = substr(year, 1, 1)) %>%
  mutate(year = case_when(substr(year, 1, 1) == "b" ~ "2010/11", # wave 2
                          substr(year, 1, 1) == "d" ~ "2012/13", # wave 4
                          substr(year, 1, 1) == "f" ~ "2014/15", # wave 6
                          substr(year, 1, 1) == "h" ~ "2016/17", # wave 8
                          substr(year, 1, 1) == "j" ~ "2018/19", # wave 10
                          substr(year, 1, 1) == "l" ~ "2020/21", # wave 12
                          substr(year, 1, 1) == "n" ~ "2022/23", # wave 12
                          TRUE ~ as.character(NA)))

# save the file
saveRDS(extracted_survey_data_unsoc, paste0(derived_data, "extracted_survey_data_unsoc.rds"))


# 4. What are the possible responses?
# =================================================================================================================

# Read in the data if necessary
# extracted_survey_data_unsoc <- readRDS(paste0(derived_data, "extracted_survey_data_unsoc.rds"))


# get the responses recorded for each variable (combined over the years), and save to xlsx and rds

# 1st run through to see how to identify variables that can be excluded (and the unique characters that will identify these):
# extract_responses(survey = "unsoc") 
# responses_as_list_unsoc <- readRDS(paste0(derived_data, "responses_as_list_unsoc.rds"))
# responses_as_list_unsoc  # examine the output

# 2nd run to exclude the numeric vars that don't need codings and/or muck up the output:

extract_responses(survey = "unsoc", #survey acronym
                  chars_to_exclude = c("strata", "psu", "age")) 

# read the responses back in and print out so we can work out how they should be coded
# (also useful to see how sex/geography/simd variables have been recorded, for later standardisation)

responses_as_list_unsoc <- readRDS(paste0(derived_data, "responses_as_list_unsoc.rds"))
responses_as_list_unsoc

# responses_as_list_unsoc printed out
# (N.B. NAs for weights and imd variables aren't an issue here)
###################################

# $gor_dv
# [1] "missing"                  "Northern Ireland"         "London"                   "North West"               "Yorkshire and the Humber" "North East"              
# [7] "West Midlands"            "East Midlands"            "South West"               "East of England"          "South East"               "Scotland"                
# [13] "Wales"                   
# 
# $imd2016qs_dv
# [1] NA
# 
# $imd2020qs_dv
# [1] NA
# 
# $inding2_xw
# [1] NA
#
# $indinub_xw
# [1] NA
# 
# $indinui_xw
# [1] NA
# 
# $jbsec
# [1] "likely"                 "proxy"                  "inapplicable"           "very unlikely"          "unlikely"               "very likely"           
# [7] "don't know"             "refusal"                "missing"                "very unlikely?"         "Not available for IEMB" "Unlikely"              
# [13] "Very unlikely?"         "Likely"                 "Very likely"           
# 
# $pidp
# [1] NA
# 
# $sex
# [1] "female"       "male"         "refusal"      "missing"      "don't know"   "inapplicable"
# 
# $sex_dv
# [1] "Female"       "Male"         "missing"      "inconsistent"

###################################


# 5. How should the responses be coded?
# =================================================================================================================
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?

# Create lookups to code the jbsec variable into the dichotomy needed for the indicator:
insecure <- c("likely", "very likely", "Likely", "Very likely")
notinsecure <- c("unlikely", "Unlikely", "very unlikely", "very unlikely?", "Very unlikely?", "don't know")
na <- c("inapplicable", "missing", "proxy", "refusal", "Not available for IEMB")



# 6. Process the survey data to produce the indicator(s)
# =================================================================================================================

# First extract the job security variable (and respondent details)
unsoc_indresp_df <- extracted_survey_data_unsoc %>% 
  filter(grepl("indresp", filename)) %>% #the jbsec responses are in the indresp files, so just keep them here
  # this mutate standardises variable names in the list column, so can be unnested
  mutate(survey_data = map(survey_data, ~ .x %>% 
                            setNames(gsub("ui_xw|ub_xw|g2_xw", "wt", names(.))) %>% #rename the weights the same 
                            setNames(gsub("^[a-z]_", "", names(.))) #remove wave prefix
  )
  ) %>%
  unnest(cols = survey_data) %>% # unnests into a flat file
  select(-c(sex, fileloc)) %>%
  filter(gor_dv=="Scotland") %>% # n = 21184
  mutate(job_insecurity = case_when(jbsec %in% insecure ~ "yes",
                                    jbsec %in% notinsecure ~ "no",
                                    jbsec %in% na ~ "NA")) 


# data checks
table(unsoc_indresp_df$age_dv, useNA = "always") # all are 16+
table(unsoc_indresp_df$sex_dv, useNA = "always") # most are Male or Female, 3 inconsistent (these have jbsec==NA), and 2 are missing (jbsec== not insecure)


# Now extract the SIMD quintiles
unsoc_simd_df <- extracted_survey_data_unsoc %>% 
  filter(grepl("indall", filename)) %>% # the IMD data are in the indall files, so just keep them here
  # this mutate standardises variable names in the list column, so can be unnested
  mutate(survey_data = map(survey_data, ~ .x %>% 
                            setNames(gsub("^[a-z]_", "", names(.))) #remove wave prefix
  )
  ) %>%
  unnest(cols = survey_data) %>% # unnests into a flat file
  filter(gor_dv=="Scotland")  %>% # n = 29328
  select(year, pidp, starts_with("imd")) 


# data checks
table(unsoc_simd_df$imd2020qs_dv, useNA = "always") # all are between 1 and 5
table(unsoc_simd_df$imd2016qs_dv, useNA = "always") # all are between 1 and 5
# opt to use the IMD2020 variable here as more recent


#merge SIMD quintiles into indresp data
unsoc_total <- unsoc_indresp_df %>%
  mutate(sex_dv = "Total") 

unsoc_sex <- unsoc_indresp_df %>%
  mutate(sex_dv = as.character(sex_dv)) %>%
  filter(sex_dv %in% c("Male", "Female")) %>% # 2 missings dropped: n = 10140 
  rbind(unsoc_total) %>%
  merge(unsoc_simd_df, by=c("year", "pidp")) %>%
  filter(job_insecurity != "NA") %>% # n = 10142
  select(year, strata, psu, sex=sex_dv, indinwt, job_insecurity, quintile = imd2020qs_dv) %>%
  rename(trend_axis = year) %>%
  mutate(year = as.numeric(substr(trend_axis, 1, 4)),
         quintile = as.character(quintile))
  # over half were 'inapplicable' according to unsoc website: https://www.understandingsociety.ac.uk/documentation/mainstage/dataset-documentation/variable/jbsec

table(unsoc_sex$sex, useNA = "always")
table(unsoc_sex$job_insecurity, useNA = "always")
table(unsoc_sex$quintile, useNA = "always")

# 8. Calculate indicator values by various groupings
# =================================================================================================================

# The survey calculation functions are in the functions.R script

jobsec <- calc_indicator_data(unsoc_sex, "job_insecurity", "indinwt", ind_id=30055, type= "percent") %>% # ok
  mutate(code = as.character(code))

# There are some warnings that appear: a deprecated bit (I can't find where to change this) and some cases where wt=0 (16 in total). 
# The zero weights are in the original data.

# Check for suppression issues:
# Nome: smallest denominator here is 58.

# Save the indicator data
#arrow::write_parquet(jobsec, paste0(derived_data, "jobsec.parquet"))
#jobsec <- arrow::read_parquet(paste0(derived_data, "jobsec.parquet"))



# 9. Data availability
# =================================================================================================================

ftable(jobsec$indicator, jobsec$code, jobsec$quintile, jobsec$sex , jobsec$year)
# Scotland and SIMD, 2010/11 to 2020/21, by sex



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
prepare_final_files <- function(ind){
  
  # 1 - main data (ie data behind summary/trend/rank tab)
  
  main_data <- jobsec %>% 
    filter(indicator == ind,
           split_value == "Total",
           sex == "Total") %>% 
    select(code, ind_id, year, 
           numerator, rate, upci, lowci, 
           def_period, trend_axis) %>%
    unique() 
  
  # Save
  # Including both rds and csv file for now
  write_rds(main_data, file = paste0(data_folder, "Data to be checked/", ind, "_shiny.rds"))
  write_csv(main_data, file = paste0(data_folder, "Data to be checked/", ind, "_shiny.csv"))
  
  # 2 - population groups data (ie data behind population groups tab)
  
  pop_grp_data <- jobsec %>% 
    filter(indicator == ind,
           split_value == "Total") %>% # split_value here refers to SIMD quintile
    select(-split_value) %>% #... so drop and replace with sex
    mutate(split_name = "Sex") %>%
    rename(split_value = sex) %>%
    select(code, ind_id, year, numerator, rate, upci, 
           lowci, def_period, trend_axis, split_name, split_value) 
  
  # Save
  # Including both rds and csv file for now
  write_rds(pop_grp_data, file = paste0(data_folder, "Data to be checked/", ind, "_shiny_popgrp.rds"))
  write_csv(pop_grp_data, file = paste0(data_folder, "Data to be checked/", ind, "_shiny_popgrp.csv"))
  
  
  # 3 - SIMD data (ie data behind deprivation tab)
  
  # Process SIMD data
  # NATIONAL LEVEL ONLY (BY SEX)
  simd_data <- jobsec %>% 
    filter(indicator == ind) %>% 
    unique() %>%
    mutate(quint_type = "sc_quin") %>%
    select(code, ind_id, year, numerator, rate, upci, 
           lowci, def_period, trend_axis, quintile, quint_type, sex) 
  
  # Save intermediate SIMD file
  write_rds(simd_data, file = paste0(data_folder, "Prepared Data/", ind, "_shiny_depr_raw.rds"))
  write.csv(simd_data, file = paste0(data_folder, "Prepared Data/", ind, "_shiny_depr_raw.csv"), row.names = FALSE)
  
  #get ind_id argument for the analysis function 
  ind_id <- unique(simd_data$ind_id)
  
  # Run the deprivation analysis (saves the processed file to 'Data to be checked')
  analyze_deprivation_aggregated(filename = paste0(ind, "_shiny_depr"), 
                                 pop = "depr_pop_16+", # 16+ by sex (and age). The function aggregates over the age groups.
                                 ind_id, 
                                 ind
  )
  
  # Make data created available outside of function so it can be visually inspected if required
  main_data_result <<- main_data
  pop_grp_data_result <<- pop_grp_data
  simd_data_result <<- simd_data
  
  
}


# Run function to create final files
prepare_final_files(ind = "job_insecurity")   


# # Run QA reports 
# These currently use local copies of the .Rmd files.
# These can be deleted once PR #116 is merged into scotpho-indicator-production repo

# # main data: 
run_qa(filename = "job_insecurity")    

# ineq data: 
# get the run_ineq_qa to use full Rmd filepath so can be run from here
run_ineq_qa(filename = "job_insecurity")

## END