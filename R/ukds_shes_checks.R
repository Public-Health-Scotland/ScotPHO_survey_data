
# ======================================================================================
# ===== Data checks for the indicator data derived from SHeS (via UKDS data files) =====
# ======================================================================================

# Notes on SHeS

# 18 indicators:

# wemwbs	Mean score on the WEMWBS scale (adults). WEMWBS stands for Warwick-Edinburgh Mental Wellbeing Scale. N.B. This indicator is also available from the ScotPHO Online Profiles (national, health board, and council area level, but not by SIMD). The questionnaire consists of 14 positively worded items designed to assess: positive affect (optimism, cheerfulness, relaxation) and satisfying interpersonal relationships and positive functioning (energy, clear thinking, self-acceptance, personal development, mastery and autonomy). It is scored by summing the response to each item answered on a 1 to 5 Likert scale ('none of the time', 'rarely', 'some of the time', often', 'all of the time'). The total score ranges from 14 to 70 with higher scores indicating greater wellbeing. The variable used was WEMWBS. 
# life_sat	Mean score on the question "All things considered, how satisfied are you with your life as a whole nowadays?" (variable LifeSat).  N.B. This indicator is also available from the ScotPHO Online Profiles (national and council area level, but not by SIMD). Life satisfaction is measured by asking participants to rate, on a scale of 0 to 10, how satisfied they are with their life in general. On the scale, 0 represented 'extremely dissatisfied' and 10 'extremely satisfied' (the intervening scale points were numbered but not labelled). 
# work_bal	Mean score for how satisfied adults are with their work-life balance (paid work). Respondents were asked "How satisfied are you with the balance between the time you spend on your paid work and the time you spend on other aspects of your life?" on a scale between 0 (extremely dissatisfied) and 10 (extremely satisfied). The intervening scale points were numbered but not labelled. The variable was WorkBal. 
# gh_qg2	Percentage of adults with a possible common mental health problem. N.B. This indicator is also available from the ScotPHO Online Profiles (national, health board, and council area level, but not by SIMD). A score of four or more on the General Health Questionnaire-12 (GHQ-12) indicates a possible mental health problem over the past few weeks. GHQ-12 is a standardised scale which measures mental distress and mental ill-health. There are 12 questions which cover concentration abilities, sleeping patterns, self-esteem, stress, despair, depression, and confidence in the past few weeks. For each of the 12 questions one point is given if the participant responded 'more than usual' or 'much more than usual'. Scores are then totalled to create an overall score of zero to twelve. A score of four or more (described as a high GHQ-12 score) is indicative of a potential psychiatric disorder. Conversely a score of zero is indicative of psychological wellbeing. As GHQ-12 measures only recent changes to someone's typical functioning it cannot be used to detect chronic conditions. The variable used was GHQg2. 
# adt10gp_tw	Percentage of adults who met the recommended moderate or vigorous physical activity guideline in the previous four weeks. In July 2011, the Chief Medical Officers of each of the four UK countries agreed and introduced revised guidelines on physical activity. Adults are recommended to accumulate 150 minutes of moderate activity or 75 minutes of vigorous activity per week, or an equivalent combination of both, in bouts of 10 minutes or more. The variable used was adt10gpTW. This bandings used for this variable include the new walking definition for those aged 65 years and over. 
# porftvg3	Percentage of adults who met the daily fruit and vegetable consumption recommendation - five or more portions - in the previous day (survey variables porftvg3Intake and porftvg3). According to the guidelines, it is recommended for adults to consume at least five varied portions of fruit and vegetables per day. The module includes questions on consumption of the following food types in the 24 hours to midnight preceding the interview: vegetables (fresh, frozen or canned); salads; pulses; vegetables in composites (e.g. vegetable chilli); fruit (fresh, frozen or canned); dried fruit; fruit in composites (e.g. apple pie); fresh fruit juice. Fruit and vegetable consumption figures for 2021 have been calculated from online dietary recalls using INTAKE24. In 2021, less than half a portion of fruit and vegetables is defined as none. This is due to the inclusion of fruit and vegetables from composite dishes which has led to a decrease in the proportion consuming no fruit or vegetables. Data from earlier years were taken from the fruit and vegetable module. Fruit and vegetable consumption data for NHS health boards and council area areas for 2017-2021 combined are not available, as due to the different method of data collection, it was not possible to combine data for these years. Respondents to the INTAKE24 food diary were included if they had provided data for two days. 
# gen_helf	Percentage of adults who, when asked "How good is your health in general?", selected "good" or "very good". The five possible options ranged from very good to very bad, and the variable was GenHelf. 
# limitill	Percentage of adults who have a limiting long-term illness. Long-term conditions are defined as a physical or mental health condition or illness lasting, or expected to last, 12 months or more. A long-term condition is defined as limiting if the respondent reported that it limited their activities in any way. The variable used was limitill. 
# depsymp	Percentage of adults who had a symptom score of two or more on the depression section of the Revised Clinical Interview Schedule (CIS-R). A score of two or more indicates symptoms of moderate to high severity experienced in the previous week. The variable used was depsymp (or dvg11 in 2008). 
# anxsymp	Percentage of adults who had a symptom score of two or more on the anxiety section of the Revised Clinical Interview Schedule (CIS-R). A score of two or more indicates symptoms of moderate to high severity experienced in the previous week. The variable used was anxsymp (or dvj12 in 2008). 
# suicide2	Percentage of adults who made an attempt to take their own life, by taking an overdose of tablets or in some other way, in the past year. The variable used was suicide2. 
# dsh5sc	Percentage of adults who deliberately harmed themselves but not with the intention of killing themselves in the past year. The variable used was DSH5 from 2008 to 2011, or DSH5SC from 2013 onwards. 
# involve	Percentage of adults who, when asked "How involved do you feel in the local community?", responded "a great deal" or "a fair amount". The four possible options ranged from "a great deal" to "not at all". The variables used were Involve and INVOLV19. 
# p_crisis	Percentage of adults with a primary support group of three or more to rely on for comfort and support in a personal crisis. Respondents were asked "If you had a serious personal crisis, how many people, if any, do you feel you could turn to for comfort and support?", and the variables were PCrisis or PCRIS19. 
# str_work2	Percentage of adults who find their job "very stressful" or "extremely stressful". Respondents were asked "In general, how do you find your job?" and were given options from "not at all stressful" to "extremely stressful". The variable was StrWork2. 
# contrl	Percentage of adults who often or always have a choice in deciding how they do their work, in their current main job. The five possible responses ranged from "always" to "never". The variable was Contrl. 
# support1	Percentage of adults who "strongly agree" or "tend to agree" that their line manager encourages them at work. The five options ranged from "strongly agree" to "strongly disagree". The variables used were Support1 and Support1_19. 
# rg17a_new	Percentage of adults who provide 20 or more hours of care per week to a member of their household or to someone not living with them, excluding help provided in the course of employment. Participants were asked whether they look after, or give any regular help or support to, family members, friends, neighbours or others because of a long-term physical condition, mental ill-health or disability; or problems related to old age. Caring which is done as part of any paid employment is not asked about. From 2014 onwards, this question explicitly instructed respondents to exclude caring as part of paid employment. The variables used to construc this indicator were RG15aNew (Do you provide any regular help or care for any sick, disabled, or frail people?) and RG17aNew (How many hours do you spend each week providing help or unpaid care for him/her/them?). 



# Load in the packages
# =================================================================================================================

pacman::p_load(
  tidyverse, here, stats, arrow
)

# Source generic and specialist functions 
# =================================================================================================================

source(here("utils", "utils.R"))


# Read in the indicator data
# =================================================================================================================

shes_results <- arrow::read_parquet(here("data", "derived", "shes_results.parquet"))


# Compare with published data where available
# =================================================================================================================


# Read in (and process if necessary) any published data
# =================================================================================================================

# SG dashboard is here https://scotland.shinyapps.io/sg-scottish-health-survey/
# available indicators = "adt10gp_tw", "gen_helf", "gh_qg2", "limitill", "porftvg3", "wemwbs" (all main interview variables)
# The dashboard presents data for lifesat and work_bal in ways that don't compare with our indicators (mean scores): 
# published lifesat score = % at mode/below/above, and work_bal = % giving each score from 1-10.
# Dashboard data have been downloaded (separate files by sex, geography and SIMD) and saved.
# Here each csv is read in and processed prior to combining. 
# Variable names and values are standardised to match the dashboard data we've already processed. 

# download by sex = Scotland only:
shes_data_sex <- read.csv("/conf/MHI_Data/big/big_mhi_data/unzipped/shes/shes_dashboard_downloads/trend_data_sex_2024.csv") %>%
  janitor::clean_names() %>%
  rename(spatial.unit = geographylevel,
         Nuw = unweightedbases) %>%
  mutate(spatial.scale = "Scotland",
         dataset = "SHeS-dashboard",
         measure_type = case_when(is.na(percent) ~ "score",
                                  is.na(mean) ~ "percent"),
         value = case_when(is.na(percent) ~ mean,
                           is.na(mean) ~ percent),
         sex = case_when(sex == "All" ~ "Total",
                         TRUE ~ sex),
         year_label = as.character(year)) %>%
  mutate(var_label = case_when(indicator == "Fruit & vegetable consumption (guidelines)" ~ "porftvg3",
                               indicator == "General health questionnaire (GHQ-12)" ~ "gh_qg2",
                               indicator == "Long-term conditions" ~ "limitill",
                               indicator == "Mental wellbeing (WEMWBS)" ~ "wemwbs",
                               indicator == "Self-assessed general health" ~ "gen_helf",
                               indicator == "Summary activity levels" ~ "adt10gp_tw")) %>%
  select(-percent, -mean) %>%
  pivot_longer(cols = c(value, lower_ci, upper_ci, Nuw), values_to = "value", names_to = "statistic") %>%
  mutate(statistic = case_when(measure_type=="percent" & statistic=="value" ~ "percent",
                               measure_type=="score" & statistic=="value" ~ "mean",
                               TRUE ~ statistic)) %>%
  filter((var_label=="adt10gp_tw" & categories=="Meets recommendations") |
           (var_label=="gen_helf" & categories=="Very good/Good") |
           (var_label=="gh_qg2" & categories=="Score 4+") |
           (var_label=="limitill" & categories=="Limiting long-term conditions") |
           (var_label=="porftvg3" & categories=="5 portions or more") |
           (var_label=="wemwbs")) %>%
  mutate(definition = paste0(indicator, "(", categories, ")")) %>%
  select(-indicator, -categories)

# downloaded SIMD data:
shes_data_simd <- read.csv("/conf/MHI_Data/big/big_mhi_data/unzipped/shes/shes_dashboard_downloads/trend_data_simd_2024.csv") %>%
  janitor::clean_names() %>%
  rename(spatial.unit = simd,
         Nuw = unweightedbases) %>%
  mutate(spatial.scale = "SIMD",
         dataset = "SHeS-dashboard",
         sex = "Total", 
         measure_type = case_when(is.na(percent) ~ "score",
                                  is.na(mean) ~ "percent"),
         value = case_when(is.na(percent) ~ mean,
                           is.na(mean) ~ percent),
         year_label = as.character(year),
         spatial.unit = case_when(
           spatial.unit == "1st-Most deprived" ~ "1st - Most deprived",
           spatial.unit == "5th-Least deprived" ~ "5th - Least deprived",
           TRUE ~ spatial.unit)) %>%
  mutate(var_label = case_when(indicator == "Fruit & vegetable consumption (guidelines)" ~ "porftvg3",
                               indicator == "General health questionnaire (GHQ-12)" ~ "gh_qg2",
                               indicator == "Long-term conditions" ~ "limitill",
                               indicator == "Mental wellbeing (WEMWBS)" ~ "wemwbs",
                               indicator == "Self-assessed general health" ~ "gen_helf",
                               indicator == "Summary activity levels" ~ "adt10gp_tw")) %>%
  select(-geographylevel, -percent, -mean) %>%
  pivot_longer(cols = c(value, lower_ci, upper_ci, Nuw), values_to = "value", names_to = "statistic") %>%
  mutate(statistic = case_when(measure_type=="percent" & statistic=="value" ~ "percent",
                               measure_type=="score" & statistic=="value" ~ "mean",
                               TRUE ~ statistic)) %>%
  filter((var_label=="adt10gp_tw" & categories=="Meets recommendations") |
           (var_label=="gen_helf" & categories=="Very good/Good") |
           (var_label=="gh_qg2" & categories=="Score 4+") |
           (var_label=="limitill" & categories=="Limiting long-term conditions") |
           (var_label=="porftvg3" & categories=="5 portions or more") |
           (var_label=="wemwbs") ) %>%
  mutate(definition = paste0(indicator, "(", categories, ")")) %>%
  select(-indicator, -categories)

# downloaded geog data:
shes_data_geog <- read.csv("/conf/MHI_Data/big/big_mhi_data/unzipped/shes/shes_dashboard_downloads/rank_data_2024.csv") %>%
  janitor::clean_names() %>%
  rename(spatial.unit = location,
         Nuw = unweightedbases) %>%
  mutate(dataset = "SHeS-dashboard",
         sex = case_when(sex == "All" ~ "Total",
                         TRUE ~ sex),
         measure_type = case_when(is.na(percent) ~ "score",
                                  is.na(mean) ~ "percent"),
         value = case_when(is.na(percent) ~ mean,
                           is.na(mean) ~ percent),
         spatial.scale = case_when(geographylevel=="Health Board" ~ "HB",
                                   geographylevel=="Local Authority" ~ "LA",
                                   TRUE ~ geographylevel),
         year_label = as.character(year),
         year = as.numeric(substr(year, 1, 4)) + 1) %>%
  mutate(var_label = case_when(indicator == "Fruit & vegetable consumption (guidelines)" ~ "porftvg3",
                               indicator == "General health questionnaire (GHQ-12)" ~ "gh_qg2",
                               indicator == "Long-term conditions" ~ "limitill",
                               indicator == "Mental wellbeing (WEMWBS)" ~ "wemwbs",
                               indicator == "Self-assessed general health" ~ "gen_helf",
                               indicator == "Summary activity levels" ~ "adt10gp_tw")) %>%
  select(-geographylevel, -percent, -mean) %>%
  pivot_longer(cols = c(value, lower_ci, upper_ci, Nuw), values_to = "value", names_to = "statistic") %>%
  mutate(statistic = case_when(measure_type=="percent" & statistic=="value" ~ "percent",
                               measure_type=="score" & statistic=="value" ~ "mean",
                               TRUE ~ statistic)) %>%
  filter((var_label=="adt10gp_tw" & categories=="Meets recommendations") |
           (var_label=="gen_helf" & categories=="Very good/Good") |
           (var_label=="gh_qg2" & categories=="Score 4+") |
           (var_label=="limitill" & categories=="Limiting long-term conditions") |
           (var_label=="porftvg3" & categories=="5 portions or more") |
           (var_label=="wemwbs") ) %>%
  filter(spatial.scale!="Scotland") %>% # already have annual Scotland data, so don't need this
  mutate(definition = paste0(indicator, "(", categories, ")")) %>%
  select(-indicator, -categories)

#combine all data from SHeS dashboard
shes_dashboard_download <- rbind(shes_data_geog,
                                 shes_data_sex,
                                 shes_data_simd) %>%
  select(dataset, year, year_label, var_label, measure_type, statistic, sex, spatial.scale, spatial.unit, value)

#arrow::write_parquet(shes_dashboard_download, here("data", "derived", "shes_dashboard_download.parquet"))
shes_dashboard_download <- arrow::read_parquet(here("data", "derived", "shes_dashboard_download.parquet"))
# pre Sept 2024 update was 21688 obs
# now is 24608

# Combine the published and our processed data
# =================================================================================================================

# Dashboard data:
shes_dboard_data <- shes_dashboard_download %>%
  select(year, year_label, var_label, sex, spatial.scale, spatial.unit, statistic, value) %>%
  filter(statistic %in% c("mean", "percent", "Nuw")) %>%
  mutate(statistic = ifelse(statistic %in% c("mean", "percent"), "value_db", "base_db")) %>%
  pivot_wider(values_from = value, names_from = statistic)
#6152 obs

# Data from UKDS: 
ukds_shes_data <- shes_results %>%
  filter(var_label %in% c("adt10gp_tw", "gen_helf", "gh_qg2", "limitill", "porftvg3", "wemwbs")) %>%
  filter(statistic %in% c("percent", "mean", "Nuw")) %>%
  mutate(statistic = ifelse(statistic %in% c("percent", "mean"), "value_ukds", "base_ukds")) %>%
  pivot_wider(values_from = value, names_from = statistic) %>%
  select(year, year_label, var_label, base_ukds, sex, spatial.scale, spatial.unit, value_ukds)
#3204 obs


# Compare the published and our processed data: calculate differences
# =================================================================================================================

compare_shes_ukds_vs_dashboard <- ukds_shes_data %>%
  merge(y=shes_dboard_data, by=c("year", "year_label", "var_label", "spatial.unit", "spatial.scale", "sex"), all=TRUE) %>%
  mutate(base_diff_pc = 100 * (base_db - base_ukds) / base_db,
         value_ukds_round = case_when(var_label == "wemwbs" ~ rnd1dp(value_ukds),
                                      TRUE ~ rnd(value_ukds)),
         value_diff = value_db - value_ukds_round,
         value_diff_pc = 100 * value_diff / value_db) %>%
  mutate(base_same = between(base_diff_pc, -0.001, 0.001),
         value_same = between(value_diff_pc, -0.001, 0.001)) %>%
  mutate(inwhich = case_when(is.na(value_ukds) & is.na(value_db) ~ "neither",
                             is.na(value_ukds) & !is.na(value_db) ~ "db only",
                             !is.na(value_ukds) & is.na(value_db) ~ "ukds only",
                             !is.na(value_ukds) & !is.na(value_db) ~ "both"))
# arrow::write_parquet(compare_shes_ukds_vs_dashboard, here("data", "derived", "compare_shes_ukds_vs_dashboard.parquet"))
# 7294 obs

table(compare_shes_ukds_vs_dashboard$inwhich)
# both   db only   ukds only 
# 2062      4090        1142 

ftable(compare_shes_ukds_vs_dashboard$inwhich,
       compare_shes_ukds_vs_dashboard$var_label, compare_shes_ukds_vs_dashboard$spatial.scale, 
       compare_shes_ukds_vs_dashboard$sex , compare_shes_ukds_vs_dashboard$year)

# 2062 matching records
# dboard has LA data that UKDS doesn't (in EUL version at least): 4090 obs. All are LA data (not in UKDS EUL)
# UKDS has 1142 obs not in dashboard:
# we have calculated aggregate year values for Scotland, to match lower geog availability for ScotPHO site, but dashboard only presents annual.
# dashboard doesn't provide SIMD values by sex (checked above: we won't present these either)
# dashboard provides HB data from 2012-2014, whereas UKDS has from 2008-2011
# dashboard doesn't have portions fruit/veg for HBs in 2019, unsure why...


# what % of valid comparisons are within 0.001% of each other (i.e., pretty identical)

# Bases:
table(compare_shes_ukds_vs_dashboard$base_same) #2044/2062 = 99%

# Where are bases not identical?
# any non-identical bases (n=18) are for SIMD breakdowns in 2012.
# looked at this in code below:
# e.g., for gen_helf in 2012 the bases match exactly for SIMD1 and 5, but Q2 is +16, Q3 is -23 and Q4 is +7, so some indivs have been assigned to different quintiles
# there's no other SIMD version in this data so not sure how this has happened. 
# ER has tried to check this with SHeS: no response as of 22 Sept 2023

#plot
ggplot(compare_shes_ukds_vs_dashboard, aes(x=base_diff_pc)) +
  geom_histogram() +
  facet_wrap(~var_label)
# very good (want all to have base_diff_pc == 0)


# Values:
table(compare_shes_ukds_vs_dashboard$value_same) #2021 of 2062 = 98%

#plot
ggplot(compare_shes_ukds_vs_dashboard, aes(x=value_diff_pc)) +
  geom_histogram() +
  facet_wrap(~var_label)
# very good match (want all to have value_diff_pc == 0). 

# 41 values differ
# biggest discrepancies seen for gh_qg2: the indicator % is quite small, so a 1%-point diff gives a relatively large % diff. 
# E.g., diff between 11% and 12% is 9%.
# all discrepancies are SIMD
# all out by single percentage point or 0.1 (in case of wemwbs)
# doesn't seem to be rounding issue.


# look at the differences in the wemwbs scores:
table(rnd1dp(compare_shes_ukds_vs_dashboard$value_diff[compare_shes_ukds_vs_dashboard$var_label=="wemwbs"]))
#-0.1    0  0.1 
#   8  343    5 
# of 356 wemwbs comparisons, 343 (96%) are the same
# Is this good enough (close enough) to present (and assume the breakdowns we're not able to compare against published data are similarly close), 
# or just stick with the published data?


# how does the value matching (true/false) vary by spatial scale?
table(compare_shes_ukds_vs_dashboard$value_same, compare_shes_ukds_vs_dashboard$spatial.scale)
#         HB   LA Scotland SIMD
# FALSE    0    0        0   41
# TRUE  1470    0      222  329
# 

# how does the value matching (true/false) vary by indicator and spatial scale?
ftable(compare_shes_ukds_vs_dashboard$var_label, compare_shes_ukds_vs_dashboard$value_same, compare_shes_ukds_vs_dashboard$spatial.scale)
#                     HB  LA Scotland SIMD
# adt10gp_tw  FALSE    0   0        0    5
#             TRUE   252   0       27   40
# gen_helf    FALSE    0   0        0    7
#             TRUE   252   0       39   58
# gh_qg2      FALSE    0   0        0    6
#             TRUE   252   0       39   59
# limitill    FALSE    0   0        0    6
#             TRUE   252   0       39   59
# porftvg3    FALSE    0   0        0    4
#             TRUE   210   0       39   61
# wemwbs      FALSE    0   0        0   13
#             TRUE   252   0       39   52

# all issues are now with the SIMD results.

# The close agreement confirms the accuracy of our data processing, but some very slight differences remain.
# For this reason we opted to replace the UKDS data with SHeS dashboard data, where available.
# This is conducted in the main processing script, to produce shes_results2.parquet
##########################################################



