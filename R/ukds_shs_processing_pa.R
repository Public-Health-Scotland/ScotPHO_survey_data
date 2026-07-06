# ============================================================================
# ===== Processing UKDS survey data files: SCOTTISH HOUSEHOLD SURVEY (SHoS) =====
# ============================================================================

# 5 indicators
# sprt3aa - adults participating in sport
# anysportnowalk - adults participating in recreational walking
# serv3a - satisfaction with local sports and leisure facilities
# serv3e - satisfaction with local parks and open spaces
# outdoor - adults visiting the outdoors at least once a week
# greenfar - adults living within a 5 min walk of nearest green space

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
  stats, #ftable (flat contingency tables)
  stringr #for handling strings
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
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed

# responses_as_list_shs printed out
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?
###################################
# $anysportnowalk
# [1] "Yes" "No"  NA   


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



###################################
### Unnest data frames          ###
###################################
shs_data <- extracted_survey_data_shs |> 
  mutate(survey_data = map(survey_data, ~.x |> 
                             mutate(across(.cols = everything(), as.character))),  # to deal with some incompatible formats that mucked up the unnest()
         year = as.numeric(substr(year, 1, 4))) |> #keep first 4 digits of year to then convert to numeric. Needed as e.g. 2010-2011 can't be converted to numeric due to chr. 
  filter(year >= 2012) |> #Filter to 2012 onwards as it's when PA module was introduced
  unnest(cols = c(survey_data))  #unnest

###################################
### Apply variable recoding     ###
###################################

#Read in lookup table which shows how survey responses should be converted to TRUE/FALSE to calculate percentages
variable_recode_lookup <- read.csv("/conf/MHI_Data/big/big_mhi_data/unzipped/shs/variable_recoding_table_SHS_PA.csv") 

shs_data <- shs_data |> 
  mutate(across(where(is.character), ~ stringr::str_to_lower(.x))) #convert all character cols to lower case to save fiddling with variations in case in responses between years

#Next apply lookups to all indicator variables
vars <- unique(variable_recode_lookup$variable) #get a vector of all variables that need recoding

shs_data <- shs_data |> 
  mutate(rowid = row_number()) |> #create a row id column to keep track of the different survey responses for each variable when pivoting 
  tidyr::pivot_longer(cols = all_of(vars), names_to = "variable", values_to = "value") |> #pivoting longer to get all recoded variables into a col, to compare against lookup 
  left_join(variable_recode_lookup, by = c("variable", "value")) |> #join the recode lookup to the data
  select(-value) |> #drop the old value for the response
  pivot_wider(names_from = variable, values_from = keep) |>  #pivot wider again so each variable has its own col
  
  #Coalesce some variables that have changed name over the years and are therefore in different columns
  mutate(sex = coalesce(randsex, randgender), #coalesce sex and gender
         simd5 = coalesce(md12quin, md16quin, md20quin), #coalesce all simd quintile col names
         urban_rural = coalesce(shs_2cla, shs_2cla_11)) |>  #coalesce urban-rural classification
  
  #Recode some split variables
  mutate(sex = case_when(sex %in% c("female", "woman/girl") ~ "Female",
                         sex %in% c("male", "man/boy") ~ "Male",
                         TRUE ~ NA_character_), #harmonising variables in sex and gender
         randage = as.numeric(substr(randage, 1, 2)), #removing plus sign from 86+
         age_grp = case_when(randage < 65 ~ "16-64",
                             randage >= 65 ~ "65+",
                             TRUE ~ NA_character_), #creating a split on working age/older adults as different exercise guidelines for each
         rg5a = case_when(rg5a == "yes" ~ "Long-term illness",
                          rg5a == "no" ~ "No long-term illness",
                          TRUE ~ NA_character_)) |> 
  
  #Tidy up some variables
  rename(long_term_illness = rg5a) |> 
  mutate(across(ends_with("wt"), as.numeric))  #convert weights to numeric

###################################
### Harmonise Geography Names   ###
###################################

#Read in lookup for all the various geography name columns
geog_lookup <- readRDS(file.path("/conf/MHI_Data/big/big_mhi_data/unzipped/shs/SHoS_CA_HB_lookup.rds"))

shs_data <- shs_data |> 
  mutate(council = ifelse(!is.na(la), la, council),   #replace the value in council with the value in la if it's ther
         council = str_to_title(council)) |> #re-capitalise the S in the S-code to match lookup and same for alphanumeric la code
  select(-la_code) |> #drop because interferes with lookup
  merge(geog_lookup, by = c("council")) |>    #join lookup

  #Select final variables
  select(year, long_term_illness, ind_wt, all_of(vars), sex, simd5, urban_rural, age_grp, hb_code, la_code) #vars being vector of indicator variables specified above

###################################
### Apply Design Effects       ###
###################################

#When running a new year of data, find the design effect for that year and 
#manually input into the file read in below
#It should be found in the file "Scottish Household Survey Confidence Intervals" found at the URL below:
#https://www.gov.scot/publications/scottish-household-survey-2024-methodology-and-fieldwork-outcomes/documents/

shs_design_effects <- read.csv("/conf/MHI_Data/big/big_mhi_data/unzipped/shs/SHoS Design Effects Formatted.csv")

shs_data <- shs_data |> 
  merge(y = shs_design_effects, by.x = "year", by.y = "Year", all.x = TRUE)



# # data checks
table(shs_data$sex, useNA = "always") # Female/Male/Total
table(shs_data$age_grp, useNA = "always") # 16-86+, 7442 NAs. Assume some people refused to say
table(shs_data$simd5, useNA = "always") # 5 classes, plus a small number of NA
table(shs_data$outdoor, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$serv3a, useNA = "always")# just yes, no and NA, so coding has worked
table(shs_data$serv3e, useNA = "always")# just yes, no and NA, so coding has worked
table(shs_data$sprt3aa, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$anysportnowalk, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$long_term_illness, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$greenfar13, useNA = "always") # just yes, no and NA, so coding has worked
table(shs_data$urban_rural, useNA = "always") # just urban and rural so coding has worked
table(shs_data$urban_rural, useNA = "always") # just urban and rural so coding has worked
table(shs_data$hb_code, useNA = "always")



###################################
### Append Split Totals         ###
###################################

#First need to pivot longer to create 2 cols for split names and values
#and 2 cols for geography type and geography name
shs_data <- shs_data |> 
  mutate(scotland = "S00000001") |> 
  pivot_longer(cols = c("sex", "long_term_illness", "simd5", "age_grp", "urban_rural"), names_to = "split_name", values_to = "split_value") |> 
  pivot_longer(cols = c(la_code, hb_code, scotland), names_to = "spatial.scale", values_to = "spatial.unit") #pivoting the areas longer

#Create a helper function which filters on each split and then appends the data back on to get the total
#Takes the name of the split and what the total value is to be called

append_split_total <- function(data, split_name, split_value){
  data_split <- data |> 
    filter(split_name == split_name) |> #filter on name of split
    mutate(split_value == split_value) #apply total name e.g. Total, All ages etc
  
  bind_rows(data, data_split) #Join split off totals to main df
}

#Apply function for each split name
shs_data2 <- shs_data |> 
  append_split_total(split_name = sex, split_value = Total) |> 
  append_split_total(split_name = long_term_illness, split_value = Total) |> 
  append_split_total(split_name = simd5, split_value = Total) |> 
  append_split_total(split_name = age_grp, split_value = "All ages") |> 
  append_split_total(split_name = urban_rural, split_value = Total)

#Checking whether bases look acceptable
# shs_bases <- shs_data6 |>
#   filter(split_name == "sex") |>
#   filter(split_value == "Total" | is.na(split_name)) |>
#   group_by(spatial.scale, spatial.unit, year) |>
#   mutate(base = n()) |>
#   ungroup()

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
    mutate(split_name = case_when(split_name == "long_term_illness" ~ "Long-term Illness (LTI)",
                                  split_name == "sex" ~ "Sex",
                                  split_name == "simd5" ~ "Deprivation",
                                  split_name == "age_grp" ~ "Age Group",
                                  split_name == "urban_rural" ~ "Urban rural classification"))
  
}


# # Run the function:
aggd_outdoor <- shs_percent_analysis(shs_data7, "outdoor", "ind_wt")
aggd_anysportnowalk <- shs_percent_analysis(shs_data7, "anysportnowalk", "ind_wt")
aggd_sprt3aa <- shs_percent_analysis(shs_data7, "sprt3aa", "ind_wt")
aggd_serv3a <- shs_percent_analysis(shs_data7, "serv3a", "ind_wt")
aggd_serv3e <- shs_percent_analysis(shs_data7, "serv3e", "ind_wt")
aggd_greenfar13 <- shs_percent_analysis(shs_data7, "greenfar13", "ind_wt")

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
