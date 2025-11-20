# ============================================================================
# ===== Processing UKDS survey data files: WEALTH AND ASSETS SURVEY (was) =====
# ============================================================================

# NOTES ON WAS

# 1 indicator = unmanageable debt = 30044 = 
# Definition: 
# Percentage of households where the household is falling behind with bills or credit commitments and either making 
# excessive debt repayments or is in arrears on monthly commitments (liquidity problems); or where the household is 
# burdened by high debt levels relative to annual income (solvency problems)
# Problem debt is defined as having liquidity problems, solvency problems or both. 
# Liquidity problems is defined as "falling behind with bills or credit commitments and (in two or more consecutive 
# months arrears on bills or credit commitments or household debt repayment to net monthly income ratio >25%)". 
# Solvency problems is defined as "feel debt is a heavy burden and debt to net annual income ratio >20%". 

# This script imports the microdata from the WAS to derive the estimates for waves 3 and 4.
# Other figures for Scotland already published, and processed outside of this repo (in main ScotPHO indicator prep repo)
# SG have extracted Scottish data for 5 waves into:
# https://data.gov.scot/wealth/
# WAS does not cover the regions north of the Caledonian Canal and the Scottish islands. 
# It is therefore not representative of the whole of the Scottish population, and especially leaves out 
# some of the most remote areas in Scotland.
# The household head is the person with the highest income, or, for equal incomes, the older person.
# Availability: Scot, M/F/Total, 2010-12 to 2018-20
#	CIs derived using Wald method, % and unweighted base (sample size). 


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

save_var_descriptions(survey = "was", 
                      name_pattern = "(\\d{1})_h") # the regular expression for this survey's filenames that identifies the wave number
# takes ~ 10 mins


# 2. Manual bit: Look at the vars_'survey' tab of the spreadsheet all_survey_var_info.xlsx to work out which variables are required.
#    Manually store the relevant variables in the file vars_to_extract_'survey'
# =================================================================================================================


# 3. Extract the relevant survey data from the files 
# =================================================================================================================

extracted_survey_data_was <- extract_survey_data("was") 
# takes ~ 10 mins 

# For WAS this is a huge file because it contains responses for all respondents in the UK.
# So we read in the file, extract the Scottish data only, and resave:
extracted_survey_data_was <- readRDS(paste0(derived_data, "extracted_survey_data_was.rds")) %>%
  mutate(survey_data = map(survey_data, ~.x %>%
                             filter(govtof=="Scotland")))  # select only Scottish respondents
write_rds(extracted_survey_data_was, paste0(derived_data, "extracted_survey_data_was.rds"))  


# 4. What are the possible responses?
# =================================================================================================================

# Read in the data if necessary
# extracted_survey_data_was <- readRDS(paste0(derived_data, "extracted_survey_data_was.rds"))

# get the responses recorded for each variable (combined over the years), and save to xlsx and rds

# 1st run through to see how to identify variables that can be excluded (and the unique characters that will identify these):
# extract_responses(survey = "was") 
# responses_as_list_was <- readRDS(paste0(derived_data, "responses_as_list_was.rds"))
# responses_as_list_was  # examine the output

# 2nd run to exclude the numeric vars that don't need codings and/or muck up the output:

extract_responses(survey = "was", #survey acronym
                  chars_to_exclude = c("age", "pwta", "pwapsa14")) #we don't need to work out codings for these numeric vars (and they muck up the output)

# read the responses back in and print out so we can work out how they should be coded
# (also useful to see how sex/geography/simd variables have been recorded, for later standardisation)

responses_as_list_was <- readRDS(paste0(derived_data, "responses_as_list_was.rds"))
responses_as_list_was

# responses_as_list_was printed out
###################################


# Import wave 3 and 4 lookups (sent by ONS)
library(readxl)
wave3 <- read_excel("/conf/MHI_Data/big/big_mhi_data/unzipped/was/UKDS_EUL_lookups_waves_3&4/W3_Final.xls") %>% select(case = CaseW3, quintile = Quintile, hhpd) %>% mutate(wave = 3)
wave4 <- read_excel("/conf/MHI_Data/big/big_mhi_data/unzipped/was/UKDS_EUL_lookups_waves_3&4/W4_Final.xls") %>% select(case = CaseW4, quintile = Quintile, hhpd) %>% mutate(wave = 4)


