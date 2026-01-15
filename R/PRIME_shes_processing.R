# Script to extract some SHeS data for use in the NCD PRIME work.
# NB. Not part of the ScotPHO processing


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


# SHeS variables are extracted in the repo ScotPHO_survey_data, file ukds_shes_processing.R
# Saved in "all_survey_var_info.xlsx"

vars_to_keep <- c(
  
  # main int 2017-2021
  "alcgrp16",	#(D) Alcohol consumption in the last week - non-drinker / ex-drinker / moderate /
  "alcbase",	#(D) Alcohol consumption rating units/week
  "alcbsm15",	#(D) Alcohol consumption: men
  "alcbsm215",	#(D) Alcohol consumption: men version 2
  "alcbswt",	#(D) Alcohol consumption: women
  "alcbswt2",	#(D) Alcohol consumption: women version 2
  "drating",	#(D) Total Units of alcohol/week
  
  # food diary (intake24) 2021 ## THESE ARE NOT IN 2019-2023 DATA ##
 # "porftvg", # fruit&veg portions per day
 # "porftvg3",
  "porftvg5intake",
  "fatpctot_e", # fat as % total energy
  "sf_apctot_e", # sat fat as % total energy
  "cholesterolmg", # ??useful? Cholesterol (mg/portion)
  "cis_monounsaturatedfattyacidsg", #??useful? Cis monounsaturated fatty acids (g/portion)
  
 # bmi:
 # 2019-23 and 2022 data:
 "bmi25",	#(D) BMI (grouped 25 and over) - 2024/2023: Combined adjusted self-reported and i
 "bmi30",	#(D) Valid BMI (grouped 30 and over) - 2024/2023: Combined adjusted self-reported
 "bmi40",	#(D) Valid BMI (grouped 40 and over) - 2024/2023: Combined adjusted self-reported
 # 2022 data: 
 "bmival",	#(D) BMI
 "combmivg5_adj",	#(D) Combined adjusted and interviewer administered valid BMI (grouped)
 "combmi25_adj",	#(D) Combined adjusted self-reported and interviewer administered BMI (grouped 25
 "combmi30_adj",	#(D) Combined adjusted self-reported and interviewer administered BMI (grouped 30
 "combmi40_adj",	#(D) Combined adjusted self-reported and interviewer administered BMI (grouped 40
 "com_bmi_adj",	#(D) Combined adjusted self-reported and interviewer administered measurements
                                                                                                                                                                                                                                                          
  # chars:
  "age", 
  "sex", 
  "simd20_sga", #SIMD2020 used 19 to 21

  # survey design
  "psu", 
  "strata", 

  # weights
  # main sample weights:
  "int17181921wt", 
 "int19212223wt", 
 "bio19212223wt", 
 
 # intake weight:
  "s_he_s_intake24_wt_sc",	#Intake24 weight (scaling weight)
 "number_of_recalls" # keep if 2
  #"int21wt", # don't know which weight is used for fruit/veg portions (it's not intake24)
  #"vera21wt",
  #"bio21wt"
  
  
)


# Get data from indiv survey data files

# Latest for BMI groups = 2019-2023:
year <- 19212223
filename <- "shes19212223i_eul"
fileloc <- "shes_2023/UKDA-9503-stata/stata/stata13_se/shes19212223_eul.dta"
survey_year_lookups <- data.frame(year, filename, fileloc)

# Now extract the variables from the relevant survey files, and store in a single dataframe (requires a list column)
source_dir <- "/conf/MHI_Data/big/big_mhi_data/unzipped/shes"  

shes_2019to2023 <- 
    survey_year_lookups %>% # starts with the list of survey files
    mutate(survey_data = # adds a column called survey_data, which is then filled with the result of the subsequent function (making it a list column):
             # The map() function here passes the fileloc (path) from the survey_year_lookups dataframe to the read_select() function (pre-defined in the utils script),
             # along with other required variables (source_dir, vars_to_keep, and encoding). 
             # The read_select function reads in the data (haven package), selects the relevant vars, then cleans the variable names (janitor package)
             map(fileloc, 
                 ~ read_select(.x, 
                               source_dir = source_dir, 
                               vars_to_keep = vars_to_keep,
                   #            encoding = encoding, 
                               verbose = FALSE) %>% 
                   mutate_if(~"haven_labelled" %in% class(.), as_factor))) %>% # this turns all labelled variables into factors
    # The preceding mutate function stored the survey data for each row of the original list of survey files in the list column survey_data: so this dataframe is no longer a flat file
    mutate(nvar = map_dbl(survey_data, ncol)) %>% # map_dbl() counts the number of columns in each cell of the survey_data list column
    filter(nvar >= 1) %>% # drop rows if no data has been read in. Why would this happen? No variables to select perhaps, like household-level files.
    select(-nvar) %>%
  unnest(cols = c(survey_data)) %>% # Produce a flat file by unnesting the list column
  mutate(across(.cols = everything(), as.character)) %>%
  mutate(across(c(psu, strata, age, ends_with("wt")), as.numeric)) %>% 
  mutate(agegp = case_when(age %in% c(15:24) ~ "16-24 y",
                           age %in% c(25:34) ~ "25-34 y",
                           age %in% c(35:44) ~ "35-44 y",
                           age %in% c(45:54) ~ "45-54 y",
                           age %in% c(55:64) ~ "55-64 y",
                           age %in% c(65:74) ~ "65-74 y",
                           age > 74 ~ "75+ y")) %>%
  filter(!(drating %in% c("Schedule not obtained", "Schedule not applicable", "Not applicable", "Refused", "Don't know"))) %>%
  mutate(drating = as.numeric(as.character(drating))) %>% #values up to 412 units per week
  mutate(drating_r = ifelse(drating>100, 100, drating)) %>% #constrain max to be 100 (needs discussion) (0.4% were >100)
# 1 unit = 8g
# drating = units (g/8) per week (days * 7)
# convert drating to g per day = 
  mutate(grams_per_day = 8 * drating_r/7) %>% # (8g alc in a unit)
  mutate(drinkers = grams_per_day > 0, # 14,435 of 17,744
         low_alc_consumers = grams_per_day <1) # 6244 of 17,744


# Save this object 
write_rds(shes_2019to2023, "/PHI_conf/PHSci/Liz/10 y pop health framework/data/shes_2019to2023.rds")


# Calculate % BMI over 25
# =================================================================================================================

#restrict to respondents with valid data
bmi_2019to2023 <- shes_2019to2023 %>%
  filter(bmi25 %in% c("25 and over", "Under 25") & sex %in% c("Female", "Male"))

# Run the survey calculation for the indicator
# single-PSU strata are centred at the sample mean
options(survey.lonely.psu="adjust") 

# specify the complex survey design
svy_design <- svydesign(id=~psu,
                         strata=~strata,
                         weights=~int19212223wt, # should use biophy192223wt but user guide says not currently available in this data (Jan 2026)
                         data=bmi_2019to2023,
                         nest=TRUE) #different strata might have same psu numbering (which are different psu)

# Calculate % and CIs 
percents <- data.frame(svyby(~I(bmi25=="25 and over"), 
                             reformulate(termlabels = c("year", "sex", "agegp")), # turns the variables vector c(x, y, z) into the rhs formula ~x+y+z
                             svy_design, 
                             svyciprop, ci=TRUE, vartype="ci", method="logit")) %>% # produces CIs appropriate for proportions, using the logit method 
  # (this fits a logistic regression model and computes a Wald-type interval on the log-odds scale, which is then transformed to the probability scale)
  mutate(percent = I.bmi25.....25.and.over.. * 100, #resulting estimate has very unwieldly name!
         lowci = ci_l * 100,
         upci = ci_u * 100) %>%
  select(year, sex, agegp, percent) 

# drop the row names
rownames(percents) <- NULL 

# Calculate mean alcohol consumption (+ SD) for drinkers
# =================================================================================================================

# drinkers only 
drinkers <- extracted_survey_data %>%
  filter(drinkers)

# Run the survey calculation for the indicator
# single-PSU strata are centred at the sample mean
options(survey.lonely.psu="adjust") 

# specify the complex survey design
svy_design <- svydesign(id=~psu,
                        strata=~strata,
                        weights=~int17181921wt,
                        data=drinkers,
                        nest=TRUE) #different strata might have same psu numbering (which are different psu)


# Calculate mean scores and CIs
scores <- data.frame(svyby(~grams_per_day, 
                           reformulate(termlabels = c("year", "sex", "agegp")), 
                           svy_design, svymean, 
                           ci=TRUE, vartype=c("se"))) # "SE" here is actually the standard deviation, as it is the square root of the variance.
    

# Calculate % low alcohol consumers (whole sample)
# =================================================================================================================

# Run the survey calculation for the indicator
# single-PSU strata are centred at the sample mean
options(survey.lonely.psu="adjust") 

# specify the complex survey design
svy_design2 <- svydesign(id=~psu,
                        strata=~strata,
                        weights=~int17181921wt,
                        data=extracted_survey_data,
                        nest=TRUE) #different strata might have same psu numbering (which are different psu)

# Calculate % and CIs 
percents <- data.frame(svyby(~I(low_alc_consumers==TRUE), 
                             reformulate(termlabels = c("year", "sex", "agegp")), # turns the variables vector c(x, y, z) into the rhs formula ~x+y+z
                             svy_design2, 
                             svyciprop, ci=TRUE, vartype="ci", method="logit")) %>% # produces CIs appropriate for proportions, using the logit method 
  # (this fits a logistic regression model and computes a Wald-type interval on the log-odds scale, which is then transformed to the probability scale)
  mutate(percent = I.low_alc_consumers....TRUE. * 100, #resulting estimate has very unwieldly name!
         lowci = ci_l * 100,
         upci = ci_u * 100) %>%
  select(year, sex, agegp, percent) 



# =================================================================================================================
# =================================================================================================================


# Food diary data:

# Get data from indiv survey data files
year <- 21	
filename <- "shes21i_eul"
fileloc <- "shes_2021/UKDA-9048-stata/stata/stata13/shes21i_eul.dta"
survey_year_lookups <- data.frame(year, filename, fileloc)

# Now extract the variables from the relevant survey files, and store in a single dataframe (requires a list column)
source_dir <- "/conf/MHI_Data/big/big_mhi_data/unzipped/shes"  

extracted_survey_data2 <- 
  survey_year_lookups %>% # starts with the list of survey files
  mutate(survey_data = # adds a column called survey_data, which is then filled with the result of the subsequent function (making it a list column):
           # The map() function here passes the fileloc (path) from the survey_year_lookups dataframe to the read_select() function (pre-defined in the utils script),
           # along with other required variables (source_dir, vars_to_keep, and encoding). 
           # The read_select function reads in the data (haven package), selects the relevant vars, then cleans the variable names (janitor package)
           map(fileloc, 
               ~ read_select(.x, 
                             source_dir = source_dir, 
                             vars_to_keep = vars_to_keep,
                             #            encoding = encoding, 
                             verbose = FALSE) %>% 
                 mutate_if(~"haven_labelled" %in% class(.), as_factor))) %>% # this turns all labelled variables into factors
  unnest(cols = c(survey_data)) %>% # Produce a flat file by unnesting the list column
  mutate(across(.cols = everything(), as.character)) %>%
  mutate(across(c(psu, strata, age, contains("wt")), as.numeric)) %>% 
  filter(number_of_recalls==2) %>%
  mutate(agegp = case_when(age %in% c(15:24) ~ "16-24 y",
                           age %in% c(25:34) ~ "25-34 y",
                           age %in% c(35:44) ~ "35-44 y",
                           age %in% c(45:54) ~ "45-54 y",
                           age %in% c(55:64) ~ "55-64 y",
                           age %in% c(65:74) ~ "65-74 y",
                           age > 74 ~ "75+ y")) %>%
  mutate(porftvg_num = case_when(porftvg5intake == "0.5 to less than 1 portion" ~ 0.75,  
                                 porftvg5intake == "1 portion or more but less than 2" ~ 1.5, 
                                 porftvg5intake == "2 portions or more but less than 3" ~ 2.5, 
                                 porftvg5intake == "3 portions or more but less than 4" ~ 3.5,
                                 porftvg5intake == "4 portions or more but less than 5" ~ 4.5,
                                 porftvg5intake == "5 portions or more" ~ 5.5,
                                 porftvg5intake == "None/less than 0.5" ~ 0.25,
                                 porftvg5intake == "Not applicable" ~ as.numeric(NA),
                                TRUE ~ as.numeric(NA))) %>%
  mutate(grams_ftvg = porftvg_num*80) %>%
  mutate(across(c("fatpctot_e", "sf_apctot_e"), 
                ~ifelse(. %in% c("Refused", "Schedule not applicable", "Not applicable"), as.numeric(NA), as.numeric(.)))) %>%
  select(-drating, starts_with("alc")) %>%
  filter(!is.na(s_he_s_intake24_wt_sc))


# Save this object 
write_rds(extracted_survey_data2, "/PHI_conf/PHSci/Liz/10 y pop health framework/data/shes_2017.rds")



# Calculate mean values (+ SD) 
# =================================================================================================================


# fruit and veg consumption
fruitveg_df <- extracted_survey_data2 %>%
  filter(!is.na(grams_ftvg))

# Run the survey calculation for the indicator
# single-PSU strata are centred at the sample mean
options(survey.lonely.psu="adjust") 

# specify the complex survey design
svy_design <- svydesign(id=~psu,
                        strata=~strata,
                        weights=~s_he_s_intake24_wt_sc,
                        data=fruitveg_df,
                        nest=TRUE) #different strata might have same psu numbering (which are different psu)

# Calculate mean scores and CIs
fruitveg <- data.frame(svyby(~grams_ftvg, 
                           reformulate(termlabels = c("year", "sex", "agegp")), 
                           svy_design, svymean, 
                           ci=TRUE, vartype=c("se"))) # "SE" here is actually the standard deviation, as it is the square root of the variance.


# total fat consumption
totfat_df <- extracted_survey_data2 %>%
  filter(!is.na(fatpctot_e))

# Run the survey calculation for the indicator
# single-PSU strata are centred at the sample mean
options(survey.lonely.psu="adjust") 

# specify the complex survey design
svy_design <- svydesign(id=~psu,
                        strata=~strata,
                        weights=~s_he_s_intake24_wt_sc,
                        data=totfat_df,
                        nest=TRUE) #different strata might have same psu numbering (which are different psu)

# Calculate mean scores and CIs
totfat <- data.frame(svyby(~fatpctot_e, 
                             reformulate(termlabels = c("year", "sex", "agegp")), 
                             svy_design, svymean, 
                             ci=TRUE, vartype=c("se"))) # "SE" here is actually the standard deviation, as it is the square root of the variance.

# saturated fat consumption
satfat_df <- extracted_survey_data2 %>%
  filter(!is.na(sf_apctot_e))

# Run the survey calculation for the indicator
# single-PSU strata are centred at the sample mean
options(survey.lonely.psu="adjust") 

# specify the complex survey design
svy_design <- svydesign(id=~psu,
                        strata=~strata,
                        weights=~s_he_s_intake24_wt_sc,
                        data=satfat_df,
                        nest=TRUE) #different strata might have same psu numbering (which are different psu)

# Calculate mean scores and CIs
satfat <- data.frame(svyby(~sf_apctot_e, 
                           reformulate(termlabels = c("year", "sex", "agegp")), 
                           svy_design, svymean, 
                           ci=TRUE, vartype=c("se"))) # "SE" here is actually the standard deviation, as it is the square root of the variance.



#combine all

shes_estimates <- percents %>%
  merge(y=scores, by=c("sex", "agegp")) %>%
  rename(lowalc_pc = percent,
         alc_gperd = grams_per_day,
         alc_gperd_se = se) %>%
  merge(y = fruitveg, by=c("sex", "agegp")) %>%
  rename(fruitveg_g = grams_ftvg,
         fruitveg_se = se) %>%
  select(-starts_with("year")) %>%
  merge(y = totfat, by=c("sex", "agegp")) %>%
  rename(totfat_pc = fatpctot_e,
         totfat_se = se) %>%
  merge(y = satfat, by=c("sex", "agegp")) %>%
  rename(satfat_pc = sf_apctot_e,
         satfat_se = se) %>%
  select(-starts_with("year")) %>%
  arrange(desc(sex), agegp)



write.csv(shes_estimates, "/PHI_conf/PHSci/Liz/10 y pop health framework/data/shes_estimates.csv", row.names = FALSE)

