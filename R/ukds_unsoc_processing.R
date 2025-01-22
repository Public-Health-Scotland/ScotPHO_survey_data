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
# Survey weights = <wave letter b or d>_indinui_xw or <wave letter f to l>_indinub_xw
# Survey design = psu and strata variables are used to adjust for the clustered survey design
# Availability = Every other FY from 2010/11 to 2020/21, national and SIMD2020 quintile, M/F/Total


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



# 1. Find survey data files, extract variable names and labels (descriptions), and save this info to a spreadsheet
# =================================================================================================================

## Create a new workbook (first time only. don't run this now)
#wb <- createWorkbook()
#saveWorkbook(wb, file = here("data", "all_survey_var_info.xlsx"))

save_var_descriptions(survey = "unsoc", 
                      name_pattern = "\\/([a-z]*)_.*") # the regular expression for this survey's filenames that identifies the survey year(s)
# takes ~ 5 mins

# 2. Manual bit: Look at the vars_'survey' tab of the spreadsheet all_survey_var_info.xlsx to work out which variables are required.
#    Manually store the relevant variables in the file vars_to_extract_'survey'
# =================================================================================================================


# 3. Extract the relevant survey data from the files 
# =================================================================================================================

extracted_survey_data_unsoc <- extract_survey_data("unsoc") 
# takes ~ 6 mins 

# keep only the survey files we are interested in
# filenames: 
# a_ to l_ are UKHLS (Understanding Society): job security question asked every other year
# ba_ to br_ are BHPS: job security question not asked
extracted_survey_data_unsoc <- extracted_survey_data_unsoc %>%
  filter(substr(filename, 1, 2) %in% c("b_", "d_", "f_", "h_", "j_", "l_")) %>% # jobsecurity variable only asked in these waves (last one = l = 2020/21)
  mutate(year = substr(year, 1, 1)) %>%
  mutate(year = case_when(substr(year, 1, 1) == "b" ~ "2010/11", # wave 2
                          substr(year, 1, 1) == "d" ~ "2012/13", # wave 4
                          substr(year, 1, 1) == "f" ~ "2014/15", # wave 6
                          substr(year, 1, 1) == "h" ~ "2016/17", # wave 8
                          substr(year, 1, 1) == "j" ~ "2018/19", # wave 10
                          substr(year, 1, 1) == "l" ~ "2020/21", # wave 12
                          TRUE ~ as.character(NA)))

# save the file
saveRDS(extracted_survey_data_unsoc, here("data", "extracted_survey_data_unsoc.rds"))


# 4. What are the possible responses?
# =================================================================================================================

# Read in the data if necessary
# extracted_survey_data_unsoc <- readRDS(here("data", "extracted_survey_data_unsoc.rds"))


# get the responses recorded for each variable (combined over the years), and save to xlsx and rds

# 1st run through to see how to identify variables that can be excluded (and the unique characters that will identify these):
# extract_responses(survey = "unsoc") 
# responses_as_list_unsoc <- readRDS(here("data", paste0("responses_as_list_unsoc.rds")))
# responses_as_list_unsoc  # examine the output

# 2nd run to exclude the numeric vars that don't need codings and/or muck up the output:

extract_responses(survey = "unsoc", #survey acronym
                  chars_to_exclude = c("strata", "psu", "age")) 

# read the responses back in and print out so we can work out how they should be coded
# (also useful to see how sex/geography/simd variables have been recorded, for later standardisation)

responses_as_list_unsoc <- readRDS(here("data", paste0("responses_as_list_unsoc.rds")))
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
                            setNames(gsub("i_xw|b_xw", "wt", names(.))) %>% #rename the weights the same 
                            setNames(gsub("^[a-z]_", "", names(.))) #remove wave prefix
  )
  ) %>%
  unnest(cols = survey_data) %>% # unnests into a flat file
  select(-c(sex, fileloc)) %>%
  filter(gor_dv=="Scotland") %>% # n = 21184
  mutate(jbsec_r = case_when(jbsec %in% insecure ~ "insecure",
                             jbsec %in% notinsecure ~ "not insecure",
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
unsoc <- unsoc_indresp_df %>%
  merge(unsoc_simd_df, by=c("year", "pidp")) %>%
  select(-starts_with("filename")) %>% # n = 21184
  filter(jbsec_r != "NA") %>% # n = 10142 (dropped where missing: "inapplicable", "missing", "proxy", "refusal", "Not available for IEMB")
  # over half were 'inapplicable' according to unsoc website: https://www.understandingsociety.ac.uk/documentation/mainstage/dataset-documentation/variable/jbsec
  select(year, strata, psu, sex_dv, indinuwt, jbsec_r, imd2020qs_dv)

unsoc_sex <- unsoc_indresp_df %>%
  merge(unsoc_simd_df, by=c("year", "pidp")) %>%
  select(-starts_with("filename")) %>% # n = 21184
  filter(jbsec_r != "NA") %>% # n = 10142
  mutate(sex_dv = as.character(sex_dv)) %>%
  filter(sex_dv %in% c("Male", "Female")) %>% # 2 missings dropped: n = 10140 (this is why a separate dataset was created, for the setting up of the survey design dfs below)
  select(year, strata, psu, sex_dv, indinuwt, jbsec_r, imd2020qs_dv) 



# Run svydesign() function to set up the dfs that the survey package needs to compute survey stats -------------------

options(survey.lonely.psu="adjust") # single-PSU strata are centred at the sample mean

unsoc_svy <- svydesign(id=~psu, 
                       strata=~strata,
                       weights=~indinuwt, 
                       data=unsoc) # data with no missings for SIMD

unsoc_sex_svy <- svydesign(id=~psu, 
                           strata=~strata,
                           weights=~indinuwt, 
                           data=unsoc_sex) # data with missing sex removed

# Run the svyby() function to compute survey stats, by different groupings:

# BY YEAR

# 1. get estimated percents and their CIs
jbsec_year_pc <- data.frame(svyby(~I(jbsec_r=="insecure"), ~year, unsoc_svy, 
                                  svyciprop, ci=TRUE, vartype="ci", method="logit")) %>% # produces CIs appropriate for proportions, using the logit method 
  # (this fits a logistic regression model and computes a Wald-type interval on the log-odds scale, which is then transformed to the probability scale)
  mutate(percent = I.jbsec_r.....insecure.. * 100, 
         lower_ci = ci_l * 100,
         upper_ci = ci_u * 100) %>%
  select(year, percent, lower_ci, upper_ci) 

# 2. get weighted counts
jbsec_year_total_wt <- data.frame(svyby(~jbsec_r, ~year, unsoc_svy, svytotal)) %>%
  mutate(Nw = jbsec_rinsecure + jbsec_rnot.insecure) %>%
  select(year, nw = jbsec_rinsecure, Nw) 

# 3. get unweighted counts
jbsec_year_total_unwt <- unsoc %>%
  group_by(year, jbsec_r) %>%
  summarise(nuw = n()) %>%
  ungroup() %>%
  group_by(year) %>%
  summarise(Nuw = sum(nuw, na.rm=TRUE),
            nuw = nuw[jbsec_r=="insecure"]) %>%
  ungroup()

# 4. combine these statistics
jbsec_year <- jbsec_year_pc %>%
  merge(y = jbsec_year_total_unwt, by="year") %>%
  merge(y = jbsec_year_total_wt, by="year") %>%
  mutate(spatial.scale = "Scotland",
         spatial.unit = "Scotland")

# BY YEAR AND SEX

# 1. get estimated percents and their CIs
jbsec_year_sex_pc <- data.frame(svyby(~I(jbsec_r=="insecure"), ~year+sex_dv, unsoc_sex_svy, 
                                  svyciprop, ci=TRUE, vartype="ci", method="logit")) %>% # produces CIs appropriate for proportions, using the logit method 
  # (this fits a logistic regression model and computes a Wald-type interval on the log-odds scale, which is then transformed to the probability scale)
  mutate(percent = I.jbsec_r.....insecure.. * 100, 
         lower_ci = ci_l * 100,
         upper_ci = ci_u * 100) %>%
  select(year, sex=sex_dv, percent, lower_ci, upper_ci) 

# 2. get weighted counts
jbsec_year_sex_total_wt <- data.frame(svyby(~jbsec_r, ~year+sex_dv, unsoc_sex_svy, svytotal)) %>%
  mutate(Nw = jbsec_rinsecure + jbsec_rnot.insecure) %>%
  select(year, sex=sex_dv, nw = jbsec_rinsecure, Nw)

# 3. get unweighted counts
jbsec_year_sex_total_unwt <- unsoc_sex %>%
  rename(sex = sex_dv) %>%
  group_by(year, sex, jbsec_r) %>%
  summarise(nuw = n()) %>%
  ungroup() %>%
  group_by(year, sex) %>%
  summarise(Nuw = sum(nuw, na.rm=TRUE),
            nuw = nuw[jbsec_r=="insecure"]) %>%
  ungroup()

# 4. combine these statistics
jbsec_year_sex <- jbsec_year_sex_pc %>%
  merge(y = jbsec_year_sex_total_unwt, by=c("year", "sex")) %>%
  merge(y = jbsec_year_sex_total_wt, by=c("year", "sex")) %>%
  mutate(spatial.scale = "Scotland",
         spatial.unit = "Scotland")

# BY YEAR AND SIMD2020 QUINTILE

# 1. get estimated percents and their CIs
jbsec_year_simd_pc <- data.frame(svyby(~I(jbsec_r=="insecure"), ~year+imd2020qs_dv, unsoc_svy, 
                                      svyciprop, ci=TRUE, vartype="ci", method="logit")) %>% # produces CIs appropriate for proportions, using the logit method 
  # (this fits a logistic regression model and computes a Wald-type interval on the log-odds scale, which is then transformed to the probability scale)
  mutate(percent = I.jbsec_r.....insecure.. * 100, 
         lower_ci = ci_l * 100,
         upper_ci = ci_u * 100) %>%
  select(year, imd2020qs_dv, percent, lower_ci, upper_ci) 

# 2. get weighted counts
jbsec_year_simd_total_wt <- data.frame(svyby(~jbsec_r, ~year+imd2020qs_dv, unsoc_svy, svytotal)) %>%
  mutate(Nw = jbsec_rinsecure + jbsec_rnot.insecure) %>%
  select(year, imd2020qs_dv, nw = jbsec_rinsecure, Nw) 

# 3. get unweighted counts
jbsec_year_simd_total_unwt <- unsoc %>%
  group_by(year, imd2020qs_dv, jbsec_r) %>%
  summarise(nuw = n()) %>%
  ungroup() %>%
  group_by(year, imd2020qs_dv) %>%
  summarise(Nuw = sum(nuw, na.rm=TRUE),
            nuw = nuw[jbsec_r=="insecure"]) %>%
  ungroup()

# 4. combine these statistics
jbsec_year_simd <- jbsec_year_simd_pc %>%
  merge(y = jbsec_year_simd_total_unwt, by=c("year", "imd2020qs_dv")) %>%
  merge(y = jbsec_year_simd_total_wt, by=c("year", "imd2020qs_dv")) %>%
  mutate(spatial.scale = "SIMD") %>%
  rename(spatial.unit = imd2020qs_dv) %>%
  mutate(spatial.unit = case_when(
    spatial.unit == 1 ~ "1st - Most deprived",
    spatial.unit == 2 ~ "2nd",
    spatial.unit == 3 ~ "3rd",
    spatial.unit == 4 ~ "4th",
    spatial.unit == 5 ~ "5th - Least deprived"
  )
  )

# Combine the data ready for dashboard 
jobsec <- rbind(jbsec_year, jbsec_year_simd) %>%
  mutate(sex = "Total") %>%
  rbind(jbsec_year_sex) %>%
  pivot_longer(cols = c(percent:Nw), values_to = "value", names_to = "statistic") %>%
  mutate(var_label = "jobsec",
         dataset = 'UnSoc (UKDS data)', 
         measure_type = 'percent',
         year_label = year,
         year = as.numeric(substr(year, 1, 4)))  



# Save the indicator data

#arrow::write_parquet(jobsec, here("data", "jobsec.parquet"))
jobsec <- arrow::read_parquet(here("data", "jobsec.parquet"))


# 7. What are the smallest numbers? Any suppression issues?
# =================================================================================================================

# look for smallest sample sizes (Nuw)
jobsec %>% filter(statistic=="Nuw" & spatial.scale == "Scotland") %>% arrange(value)
# smallest unweighted N is 530 for Scotland (males, 2020/21)

jobsec %>% filter(statistic=="Nuw" & spatial.scale == "SIMD") %>% arrange(value)
# smallest unweighted N is 142 (SIMD quintile 1 in 2020/21)


# look for smallest number of cases (nuw)
jobsec %>% filter(statistic=="nuw" & spatial.scale == "Scotland") %>% arrange(value)
# smallest unweighted n cases is 33 for Scotland (females, 2018/19)

jobsec %>% filter(statistic=="nuw" & spatial.scale == "SIMD") %>% arrange(value)
# smallest unweighted n cases is 9 (SIMD quintile 4 in 2018/19)

# Unweighted bases
# =================================================================================================================
# No reporting guidelines found for UnSoc results
# 
unsoc_unweighted_bases <- jobsec %>%
  filter(statistic %in% c("Nuw"))

# National 
unsoc_unweighted_bases %>%
  filter(sex=="Male", spatial.scale == "Scotland") %>%
  ggplot(aes(year, value)) +
  geom_point() + geom_line() 
# all >500

# SIMD 
unsoc_unweighted_bases %>%
  filter(spatial.scale == "SIMD" & sex=="Total") %>%
  ggplot(aes(year, value, group = spatial.unit, colour = spatial.unit)) +
  geom_point() + geom_line() 
# all >100


# 8. Data amendments following data checks
# =================================================================================================================

# None required


# 9. Data availability
# =================================================================================================================

unsoc_percents <- jobsec %>% 
  filter(statistic=="percent") 

ftable(unsoc_percents$var_label, unsoc_percents$spatial.scale, unsoc_percents$sex , unsoc_percents$year)
# Scotland and SIMD, 2010 to 2020


# 10. Plot the indicator(s)
# =================================================================================================================
# Let's now see what the series look like: 

# National
jobsec %>% 
  pivot_wider(names_from = statistic, values_from = value) %>%
  filter(spatial.unit=="Scotland" & sex=="Total") %>% 
  ggplot(aes(year, percent, group = sex, colour = sex, shape = sex)) + 
  geom_point() + geom_line() +
  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 

# National by sex
jobsec %>% 
  pivot_wider(names_from = statistic, values_from = value) %>%
  filter(spatial.unit=="Scotland" & sex!="Total") %>% 
  ggplot(aes(year, percent, group = sex, colour = sex)) + 
  geom_point() + geom_line() +
  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 

# SIMD
jobsec %>% 
  pivot_wider(names_from = statistic, values_from = value) %>%
  filter(spatial.scale=="SIMD" & spatial.unit %in% c("1st - Most deprived", "5th - Least deprived")) %>% 
  ggplot(aes(year, percent, group = spatial.unit, colour = spatial.unit)) + 
  geom_point() + geom_line() +
  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) 






