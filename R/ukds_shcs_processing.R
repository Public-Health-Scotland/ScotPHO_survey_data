# ============================================================================
# ===== Processing UKDS survey data files: SCOTTISH HOUSE CONDITION SURVEY (shcs) =====
# ============================================================================

# NOTES ON SHCS

# 2 indicators:
# 30048 - Households in dwellings with critical, extensive and/or urgent disrepair = 
#         Percentage of households with any disrepair to critical elements, considered urgent disrepair, or extensive disrepair to their dwelling. The variables used were critany, extanyVP, and urgany. 
# 30166 - Children in dwellings with critical, extensive and/or urgent disrepair	=	
#         Proportion of households with children aged under 16 years old with any disrepair to critical elements, considered urgent disrepair, or extensive disrepair to their dwelling. The variables used were critany, extanyVP, urgany, and any_kids. 

# Denominator: all surveyed houses (or all with children)
# Weights: la_wght_p (3-year paired grossing weight for LA data), ts_wght_p_n (paired sampling weight for national data). 
# Design factors are used to account for survey design in CI calc for national (but not LA) estimates: Adjusted CI = CI x design effect (https://www.gov.scot/publications/scottish-house-condition-survey-2019-key-findings/pages/9/)
# "When producing estimates at Local Authority level, no design effect adjustment of standard errors is necessary because simple (actually equal interval) random sampling was carried out within each Local Authority."
# Latest release on UKDS is 2021.

# uniqidnew is used to get SIMD info for the respondents (from SHoS data)


# Packages and functions
# =================================================================================================================

## A. Load in the packages

pacman::p_load(
  here, # for file paths within project/repo folders
  haven, # importing .dta files from Stata
  openxlsx, # reading and creating spreadsheets
  arrow, # work with parquet files
  reactable, # required for the QA .Rmd file
  RcppRoll # rolling sums/averages
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

save_var_descriptions(survey = "shcs", 
                      name_pattern = "shcs(\\d{4})") # the regular expression for this survey's filenames that identifies the survey year(s)
# takes ~ 1 min

# 2. Manual bit: Look at the vars_'survey' tab of the spreadsheet all_survey_var_info.xlsx to work out which variables are required.
#    Manually store the relevant variables in the file vars_to_extract_'survey'
# =================================================================================================================


# 3. Extract the relevant survey data from the files 
# =================================================================================================================

extracted_survey_data_shcs <- extract_survey_data("shcs") 
# takes ~ 1 min 


# 4. What are the possible responses?
# =================================================================================================================

# Read in the data if necessary
# extracted_survey_data_shcs <- readRDS(here("data", "extracted_survey_data_shcs.rds"))

# get the responses recorded for each variable (combined over the years), and save to xlsx and rds

# 1st run through to see how to identify variables that can be excluded (and the unique characters that will identify these):
# extract_responses(survey = "shcs") 
# responses_as_list_shcs <- readRDS(here("data", paste0("responses_as_list_shcs.rds")))
# responses_as_list_shcs  # examine the output

# 2nd run to exclude the numeric vars that don't need codings and/or muck up the output:

extract_responses(survey = "shcs", #survey acronym
                  chars_to_exclude = c("wght", "uniqid")) #we don't need to work out codings for these vars (and they muck up the output)

# read the responses back in and print out so we can work out how they should be coded
# (also useful to see how sex/geography/simd variables have been recorded, for later standardisation)

responses_as_list_shcs <- readRDS(here("data", paste0("responses_as_list_shcs.rds")))
responses_as_list_shcs

# responses_as_list_shcs printed out
###################################

# $any_kids
# [1] "Yes" "No" 
# 
# $critany
# [1] "No"           "Yes"          "Unobtainable"
# 
# $extany_vp
# [1] " No"           " Yes"          " Unobtainable"
# 
# $la
# [1] "Fife"                  "South Lanarkshire"     "Perth and Kinross"     "North Ayrshire"        "Glasgow City"          "North Lanarkshire"     "Dumfries and Galloway"
# [8] "South Ayrshire"        "Argyll and Bute"       "Na h-Eileanan Siar"    "Renfrewshire"          "Highland"              "Edinburgh, City of"    "Angus"                
# [15] "Inverclyde"            "East Dunbartonshire"   "Stirling"              "Falkirk"               "East Renfrewshire"     "Shetland Islands"      "Aberdeen City"        
# [22] "East Ayrshire"         "Dundee City"           "East Lothian"          "West Dunbartonshire"   "West Lothian"          "Aberdeenshire"         "Midlothian"           
# [29] "Orkney Islands"        "Clackmannanshire"      "Moray"                 "Scottish Borders"     
# 
# $urgany
# [1] "none"           "some"           "not applicable" "unobtainable"   NA    

###################################


# 5. How should the responses be coded?
# =================================================================================================================
# NB. When updating with more recent data the responses need to be compared with these: are the codings still comprehensive? new coding needed?

# coding for this indicator is simple and so is incorporated in the next processing step

# 6. Process the survey data to produce the indicator(s)
# =================================================================================================================

# Read in the survey design effects (to account for clustered design): these should be applied to the national CI calculation, but not local.
# Design effects: https://www.gov.scot/publications/scottish-house-condition-survey-methodology-notes-2022/documents/
design <- read_xlsx("/conf/MHI_Data/big/big_mhi_data/unzipped/shcs/SHCS+2022-+Methodology+Notes+%E2%80%93+tables+and+figures.xlsx",
                    sheet = "Table_T3",
                    skip = 4,
                    na = "[z]") %>%
  select(year = "Survey year",
         design_effect = "Physical survey design factor") %>%
  mutate(year = as.numeric(substr(year, 1, 4)))

# cross tabulate years and variables, to see what's available when  
shcs_years_vars <- extracted_survey_data_shcs %>%
  transmute(year,
            var_label = map(survey_data, names)) %>%
  unnest(var_label) %>%
  arrange(var_label) %>%
  mutate(value=1) %>%
  pivot_wider(names_from=var_label, values_from = value)
# all available 2012-2021: same var names each year, so can unnest

all_shcs <- extracted_survey_data_shcs %>% unnest(cols = c(survey_data)) %>%
  mutate(critany = case_when(critany == "Yes" ~ 1, # any critical disrepair
                             critany == "No" ~ 0,
                             critany == "Unobtainable" ~ as.numeric(NA)),
         extany_vp = case_when(extany_vp == " Yes" ~ 1, # any extensive disrepair
                               extany_vp == " No" ~ 0,
                               extany_vp == " Unobtainable" ~ as.numeric(NA)),
         urgany = case_when(urgany == "some" ~ 1, # any urgent disrepair
                            urgany == "none" ~ 0,
                            urgany %in% c("unobtainable", "not applicable") ~ as.numeric(NA)),
         criturgext_or = case_when(critany==1 | extany_vp==1 | urgany==1 ~ 1, # any 1s gives a criturgext_or==1
                                   critany==0 | extany_vp==0 | urgany==0 ~ 0, # then if no 1s, but there's at least one 0, criturgext_or==0
                                   TRUE ~ as.numeric(NA))) %>% # if no 1s or 0s (i.e., data were unobtainable). These are then dropped.
  filter(!is.na(criturgext_or))

# PROCESS SHS DATA TO GET THIS:

# matching to SHS using uniqidnew_lut 
uniqidnew_lut <- readRDS(here("data", "uniqidnew_lut.rds")) %>%
  select(year, uniqidnew, simd5, hb)

shcs_shs <- all_shcs %>% #22747
  merge(y=uniqidnew_lut, by.x=c("uniqidnew_shs_social", "year"), by.y = c("uniqidnew", "year"), all.x=TRUE) %>%  #22,690 if all.x=F, because some SHCS households don't have id codes
  select(year, la, hb, simd5, any_kids, criturgext_or, ts_wght_p_n, la_wght_p) # remove identifiers for saving outside the MHI folders

shcs_shs_summary <- shcs_shs %>%
  group_by(year, simd5) %>%
  summarise(count = n()) %>%
  ungroup() %>%
  group_by(year) %>%
  summarise(total = sum(count),
            missing = count[is.na(simd5)]) %>%
  ungroup() %>%
  mutate(missing_pc = 100 * missing / total) # 0.04 to 0.54% each year


#Save to folder used by ScotPHO indicator prep repo
recvd_data_folder <- "/PHI_conf/ScotPHO/Profiles/Data/Received Data/Scottish House Condition Survey/"
write.csv(shcs_shs, paste0(recvd_data_folder, "ukda_shcs_data.csv"), row.names=F)




# OLD CODE (FROM WHEN INDICATORS WERE FULLY PREPARED IN THIS SCRIPT):

# # Single-year data for Scotland not presented in ScotPHO app: only use the same time periods as for the lower level data
# # # Aggregate for Scotland (annual)
# # criturgext_1y <- all_shcs %>%
# #   group_by(criturgext_or, year) %>%
# #   summarise(n = n(),
# #             wt = sum(ts_wght_p_n)) %>%
# #   ungroup() %>%
# #   group_by(year) %>%
# #   summarise(Nuw = sum(n),
# #             Nw = sum(wt),
# #             nuw = n[criturgext_or==1],
# #             nw = wt[criturgext_or==1]) %>%
# #   ungroup() %>%
# #   merge(y=design, by="year") %>% # add design effects (for national analysis only, not LA)
# #   mutate(proportion = nw/Nw,
# #          percent = 100 * proportion,
# #          ci_wald = 100 * (1.96*sqrt((proportion*(1-proportion))/Nuw)), # Wald method (the method used by SHCS team).
# #          lower_ci = percent - design_effect * ci_wald,
# #          upper_ci = percent + design_effect * ci_wald,
# #          spatial.unit = "Scotland",
# #          spatial.scale = "Scotland") %>%
# #   select(-proportion, -design_effect, -ci_wald)
# 
# 
# 
# # Aggregate for LAs and Scot (3-year pooled)
# 
# # ADULT MHI
# # 30048 - Households in dwellings with critical, extensive and/or urgent disrepair 
# la_data <- all_shcs %>%
#   select(year, spatial.unit = la, criturgext_or, weight = la_wght_p) %>%
#   mutate(spatial.scale = "LA")
# scot_data <- all_shcs %>%
#   select(year, criturgext_or, weight = ts_wght_p_n) %>%
#   mutate(spatial.unit = "Scotland",
#          spatial.scale = "Scotland")
# criturgext_3y <- rbind(la_data, scot_data) %>%
#   group_by(year, spatial.unit, spatial.scale, criturgext_or) %>%
#   summarise(n = n(),
#             wt = sum(weight)) %>%
#   ungroup() %>%
#   pivot_wider(names_from = criturgext_or, values_from = c(n, wt)) %>%
#   group_by(spatial.unit, spatial.scale) %>%
#   dplyr::mutate(across(c(starts_with("n"), starts_with("wt")), 
#                           ~ RcppRoll::roll_sumr(., 3, fill = NA), .names = '{col}_rolling')) %>% # rolling sum over 3 year windows
#   ungroup() %>%
#   filter(!year %in% c("2012", "2013")) %>% # no data, because rolling sum is given for the last year of the 3
#   mutate(year = paste0(as.numeric(year)-2, "-", year),
#          Nuw = n_0_rolling + n_1_rolling,
#          Nw = wt_0_rolling + wt_1_rolling) %>% # grossed up
#   rename(nuw = n_1_rolling,
#          nw = wt_1_rolling) %>% # grossed up
#   mutate(percent = 100 * nw / Nw) %>% # 30 to 85%
#   mutate(proportion = nw/Nw,
#          percent = 100 * proportion,
#          ci_wald = 100 * (1.96*sqrt((proportion*(1-proportion))/Nuw)), # Wald method (doesn't need the weighted counts so can be used for the LA data). 
#          lower_ci = percent - ci_wald,
#          upper_ci = percent + ci_wald,
#          var_label = "criturgext") %>%
#   select(-proportion, -starts_with("n_"), -starts_with("wt_"), -ci_wald) %>%
#   pivot_longer(cols=-c(year, spatial.scale, spatial.unit, var_label), values_to = "value", names_to = "statistic") %>%
#   mutate(dataset = "SHCS (UKDS data)", 
#          measure_type = "percent",
#          sex= "Total",
#          year_label = year,
#          year = case_when(nchar(year)==9 ~ as.numeric(substr(year, 1, 4)) + 1, # mid year of the 3 year range (for plotting purposes)
#                           TRUE ~ as.numeric(NA)), 
#          spatial.unit = as.character(spatial.unit)) %>%
#   filter(!is.na(statistic))
# 
# # Save the indicator data (adult data stays in this repo to be combined with other data for now, as already published)
# #arrow::write_parquet(criturgext_3y, here("data", "criturgext.parquet"))
# 
# 
# ###### Full processing for CYP indicator, to load straight into ScotPHO data folders
# 
# ### paths -----
# data_folder <- "/PHI_conf/ScotPHO/Profiles/Data/"
# lookups <- "/PHI_conf/ScotPHO/Profiles/Data/Lookups/"
# # Read in geography lookup
# geo_lookup <- readRDS(paste0(lookups, "Geography/opt_geo_lookup.rds")) %>% 
#   select(!c(parent_area, areaname_full))
# 
# 
# # CYP MHI
# # 30166 - Children in dwellings with critical, extensive and/or urgent disrepair
# la_data2 <- all_shcs %>%
#   filter(any_kids=="Yes") %>%
#   select(year, spatial.unit = la, criturgext_or, weight = la_wght_p) %>%
#   mutate(spatial.scale = "Council area") %>%
#   mutate(spatial.unit = gsub(" and ", " & ", spatial.unit),
#          spatial.unit = ifelse(spatial.unit=="Edinburgh, City of", "City of Edinburgh", spatial.unit))
# scot_data2 <- all_shcs %>%
#   filter(any_kids=="Yes") %>%
#   select(year, criturgext_or, weight = ts_wght_p_n) %>%
#   mutate(spatial.unit = "Scotland",
#          spatial.scale = "Scotland")
# criturgext_cyp_3y <- rbind(la_data2, scot_data2) %>%
#   group_by(year, spatial.unit, spatial.scale, criturgext_or) %>%
#   summarise(n = n(),
#             wt = sum(weight)) %>%
#   ungroup() %>%
#   pivot_wider(names_from = criturgext_or, values_from = c(n, wt)) %>%
#   mutate(n_0 = if_else(is.na(n_0), 0, n_0),
#          wt_0 = if_else(is.na(wt_0), 0, wt_0)) %>%
#   group_by(spatial.unit, spatial.scale) %>%
#   dplyr::mutate(across(c(starts_with("n"), starts_with("wt")), # rolling sum of counts and weights over 3 year windows
#                        ~ RcppRoll::roll_sumr(., 3, fill = NA), .names = '{col}_rolling')) %>% 
#   ungroup() %>%
#   filter(!is.na(n_0_rolling)) %>% # no data in the first 2 years, because rolling sum is given for the last year of the 3
#   mutate(trend_axis = paste0(as.numeric(year)-2, "-", year),
#          Nuw = n_0_rolling + n_1_rolling,
#          Nw = wt_0_rolling + wt_1_rolling) %>% # grossed up
#   rename(nuw = n_1_rolling,
#          nw = wt_1_rolling) %>% # grossed up
#   mutate(rate = 100 * nw / Nw) %>% # 30 to 85%
#   mutate(proportion = nw/Nw,
#          rate = 100 * proportion,
#          ci_wald = 100 * (1.96*sqrt((proportion*(1-proportion))/Nuw)), # Wald method (doesn't need the weighted counts so can be used for the LA data). 
#          lowci = rate - ci_wald,
#          upci = rate + ci_wald) %>%
#   select(-proportion, -starts_with("n_"), -starts_with("wt_"), -ci_wald) %>%
#   mutate(measure_type = "percent",
#          ind_id = 30166,
#          year = as.numeric(year)-1, # string year was last of the 3 year window, we want the middle year for plotting purposes
#          spatial.unit = as.character(spatial.unit)) %>%
#   # add the geog codes
#   merge(y=geo_lookup, by.x=c("spatial.unit", "spatial.scale"), by.y=c("areaname", "areatype")) %>% # still n=1380
#   # add def_period
#   mutate(def_period = paste0("Aggregated survey years (", trend_axis, ")")) %>%
#   rename(numerator = nuw) %>%
#   select(-c(starts_with("spatial"), nw, Nuw, Nw)) 
# 
# # Save the indicator data
# write.csv(criturgext_cyp_3y, paste0(data_folder, "Test Shiny Data/criturgext_cyp_shiny.csv"), row.names = FALSE)
# write_rds(criturgext_cyp_3y, paste0(data_folder, "Test Shiny Data/criturgext_cyp_shiny.rds"))
# # save to folder that QA script accesses:
# write_rds(criturgext_cyp_3y, paste0(data_folder, "Data to be checked/criturgext_cyp_shiny.rds"))
# 
# # # Run QA reports (not in this repo, so not run here)
# # # main data: failing because the data aren't available at HB level (fix the .rmd later) "Warning: Error in eval: object 'S08' not found"
# # run_qa(filename = "criturgext_cyp")
# 
# 
# # 7. What are the smallest numbers?
# # =================================================================================================================
# 
# # SHCS does not report estimates if the base sample is below 30 cases: 
# # smallest bases will be for individual LAs in the CYP indicator calculation (any_kids=="Yes") so restrict to these here:
# unwtedbases <- all_shcs %>%
#   filter(any_kids=="Yes") %>%
#   group_by(year, la) %>%
#   summarise(n = n()) %>% # sum the unweighted bases
#   ungroup() %>%
#   group_by(la) %>%
#   dplyr::mutate(across(c(starts_with("n")), # rolling sum of counts over 3 year windows
#                        ~ RcppRoll::roll_sumr(., 3, fill = NA), .names = '{col}_rolling')) %>% 
#   ungroup() 
# # smallest unweighted N is 36 for LAs (CYP: Na h-Eileanan Siar, 2014-16)
# 
# 
# # 8. Data amendments following data checks
# # =================================================================================================================
# 
# # None required
# 
# 
# # 9. Data availability
# # =================================================================================================================
# 
# shcs_percents <- criturgext_3y %>% 
#   filter(statistic=="percent") 
# 
# ftable(shcs_percents$var_label, shcs_percents$spatial.scale, shcs_percents$sex , shcs_percents$year_label)
# 
# #                                2012-2014 2013-2015 2014-2016 2015-2017 2016-2018 2017-2019
# # criturgext     LA       Total         32        32        32        32        32        32
# #                Scotland Total          1         1         1         1         1         1
# 
# # cyp:
# table(criturgext_cyp_3y$measure_type, criturgext_cyp_3y$trend_axis)
# 
# #         2012-2014 2013-2015 2014-2016 2015-2017 2016-2018 2017-2019
# # percent        33        33        33        33        33        33
# 
# # 10. Plot the indicator(s)
# # =================================================================================================================
# # Let's now see what the series look like: 
# # Need work to reflect new data formats
# 
# # # Scotland
# # criturgext %>% 
# #   pivot_wider(names_from = statistic, values_from = value) %>%
# #   filter(spatial.unit=="Scotland") %>% 
# #   ggplot(aes(year, percent, group = spatial.unit)) + 
# #   geom_point() + geom_line() +
# #   geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) +
# #   facet_wrap(~var_label)
# # #~55 to 65% each year
# # 
# # 
# # # Local Authority
# # criturgext %>% 
# #   pivot_wider(names_from = statistic, values_from = value) %>%
# #   filter(spatial.scale=="LA") %>% 
# #   ggplot(aes(year, percent, group = spatial.unit, colour=spatial.unit)) + 
# #   geom_point() + geom_line() +
# #   geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.1) +
# #   facet_grid(~var_label) 
# # 

## END
