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

# Processing involves linking with the Scottish Household Survey microdata to get the SIMD quintile for each household. 
# See script ukds_shs_processing.R for the production of the LUT for that.
# uniqidnew is used to get SIMD info for the respondents (from SHoS data)

# We calculate 3-y rolling averages for all breakdowns, national and local. This limits the latest data point to 2019, as no 2020 data, and 2021 data weren't comparable.
# Latest release on UKDS is 2021. 2022 was released in 2024, but is not on UKDS yet (as of Jan 2025).
# 2023 and 2024 data will be required to make a 3-y average. 
# Unclear when the indicator can next be updated. 2026?




# Packages and functions
# =================================================================================================================

## A. Load in the packages

pacman::p_load(
  here, # for file paths within project/repo folders
  haven, # importing .dta files from Stata
  readxl,
  openxlsx, # reading and creating spreadsheets
  arrow, # work with parquet files
  reactable, # required for the QA .Rmd file
  RcppRoll # rolling sums/averages
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
# # temporary functions:
# source(here("functions", "temp_depr_analysis_updates.R")) # 22.1.25: sources some temporary functions needed until PR #97 is merged into the indicator production repo 

## C. Path to the data derived by this script

derived_data <- "/conf/MHI_Data/derived data/"


# 1. Find survey data files, extract variable names and labels (descriptions), and save this info to a spreadsheet
# =================================================================================================================

## Create a new workbook (first time only. don't run this now)
#wb <- createWorkbook()
#saveWorkbook(wb, file = here("data", "all_survey_var_info.xlsx"))

save_var_descriptions(survey = "shcs", 
                      name_pattern = "shcs(\\d{4})") # the regular expression for this survey's filenames that identifies the survey year(s)
# takes < 1 min

# 2. Manual bit: Look at the vars_'survey' tab of the spreadsheet all_survey_var_info.xlsx to work out which variables are required.
#    Manually store the relevant variables in the file vars_to_extract_'survey'
# =================================================================================================================


# 3. Extract the relevant survey data from the files 
# =================================================================================================================

extracted_survey_data_shcs <- extract_survey_data("shcs") 
# takes < 1 min 


# 4. What are the possible responses?
# =================================================================================================================

# Read in the data if necessary
# extracted_survey_data_shcs <- readRDS(paste0(derived_data, "extracted_survey_data_shcs.rds"))

# get the responses recorded for each variable (combined over the years), and save to xlsx and rds

# 1st run through to see how to identify variables that can be excluded (and the unique characters that will identify these):
# extract_responses(survey = "shcs") 
# responses_as_list_shcs <- readRDS(paste0(derived_data, "responses_as_list_shcs.rds"))
# responses_as_list_shcs  # examine the output

# 2nd run to exclude the numeric vars that don't need codings and/or muck up the output:

extract_responses(survey = "shcs", #survey acronym
                  chars_to_exclude = c("wght", "uniqid")) #we don't need to work out codings for these vars (and they muck up the output)

# read the responses back in and print out so we can work out how they should be coded
# (also useful to see how sex/geography/simd variables have been recorded, for later standardisation)

responses_as_list_shcs <- readRDS(paste0(derived_data, "responses_as_list_shcs.rds"))
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


# matching to SHS using uniqidnew_lut 
uniqidnew_lut <- readRDS(paste0(derived_data, "uniqidnew_lut.rds")) # see script ukds_shs_processing.R for the derivation of this LUT

all_shcs <- all_shcs %>% #22747
  merge(y=uniqidnew_lut, by.x=c("uniqidnew_shs_social", "year"), by.y = c("uniqidnew", "year"), all.x=TRUE) %>%  #22,690 if all.x=F, because some SHCS households don't have id codes
  select(year, la, simd5, any_kids, criturgext_or, ts_wght_p_n, la_wght_p) %>% # remove identifiers for saving outside the MHI folders
  mutate(year = as.numeric(year))

shcs_shs_summary <- all_shcs %>%
  group_by(year, simd5) %>%
  summarise(count = n()) %>%
  ungroup() %>%
  group_by(year) %>%
  summarise(total = sum(count),
            missing = count[is.na(simd5)]) %>%
  ungroup() %>%
  mutate(missing_pc = 100 * missing / total) # 0.04 to 0.54% each year


# split by geography type
la_data <- all_shcs %>%
  select(year, spatial.unit = la, criturgext_or, weight = la_wght_p, any_kids) %>%
  mutate(spatial.scale = "Council area") %>%
  mutate(spatial.unit = gsub(" and ", " & ", spatial.unit),
         spatial.unit = ifelse(spatial.unit=="Edinburgh, City of", "City of Edinburgh", spatial.unit)) %>%
  mutate(split_name = "None",
         split_value = "None")

scot_data <- all_shcs %>%
  select(year, criturgext_or, weight = ts_wght_p_n, any_kids) %>%
  mutate(spatial.unit = "Scotland",
         spatial.scale = "Scotland") %>%
  mutate(split_name = "None",
         split_value = "None")

simd_data <- all_shcs %>%
  filter(!is.na(simd5)) %>%
  select(year, criturgext_or, weight = ts_wght_p_n, simd5, any_kids) %>%
  mutate(spatial.unit = "Scotland",
         spatial.scale = "Scotland") %>%
  mutate(split_name = "Deprivation (SIMD)",
         split_value = simd5) %>%
  select(-simd5)

simd_data2 <- scot_data %>% # repeat to give Scotland totals (includes households with no SIMD given )
  mutate(split_name = "Deprivation (SIMD)", 
         split_value = "Total") %>%
  rbind(simd_data)

## Geography lookup -----

# Read in geography lookup
geo_lookup <- readRDS(paste0(profiles_lookups, "/Geography/opt_geo_lookup.rds")) %>% 
  select(!c(parent_area, areaname_full))

# LAs to HBs lookup
hb <- readRDS(paste0(profiles_lookups, "/Geography/DataZone11_All_Geographies_Lookup.rds")) %>%
  select(ca2019, hb2019) %>%
  distinct(.)

#combine and process indicator data
all_shcs2 <- rbind(la_data,
                   scot_data,
                   simd_data2) %>%
  # add the geog codes
  merge(y=geo_lookup, by.x=c("spatial.unit", "spatial.scale"), by.y=c("areaname", "areatype")) %>%
  select(-starts_with("spatial"))
  
# repeat data replacing CA with HB codes so can be aggregated to HBs too
shcs_hb <- all_shcs2 %>%
  merge(y=hb, by.x="code", by.y= "ca2019") %>% # just keeps the LA-level rows
  select(-code) %>%
  rename(code = hb2019)

# Combine
all_shcs3 <- rbind(all_shcs2, shcs_hb)


##########################################################
### 3. Prepare final files -----
##########################################################


# Function to prepare final files: main_data and simd_data
prepare_final_files <- function(ind_name){
  
  ind <- ifelse(ind_name=="disrepair_cyp", 30166,
                     ifelse(ind_name=="disrepair_all", 30048,
                            "ERROR"))
  
  
  if(ind==30166) {
    all_shcs3 <- all_shcs3 %>%
      filter(any_kids=="Yes")
  }
  
 df <- all_shcs3 %>%
    group_by(year, code, split_name, split_value, criturgext_or) %>%
    summarise(n = n(), # calculate counts
              wt = sum(weight)) %>% # sum the weights
    ungroup() %>%
    pivot_wider(names_from = criturgext_or, values_from = c(n, wt)) %>%
    mutate(n_0 = if_else(is.na(n_0), 0, n_0),
           wt_0 = if_else(is.na(wt_0), 0, wt_0)) %>%
    group_by(code, split_name, split_value) %>%
    dplyr::mutate(across(c(starts_with("n"), starts_with("wt")), # rolling sum of counts and weights over 3 year windows (centred)
                         ~ RcppRoll::roll_sum(., 3,  align = "center", fill = NA), .names = '{col}_rolling')) %>% 
    ungroup() %>%
    filter(!is.na(n_0_rolling)) %>% # drops ends of the series
    mutate(trend_axis = paste0(year-1, "-", year+1),
           Nuw = n_0_rolling + n_1_rolling, # unweighted total (denominator)
           Nw = wt_0_rolling + wt_1_rolling) %>% # grossed up total
    rename(nuw = n_1_rolling, # unweighted numerator
           nw = wt_1_rolling) %>% # grossed up numerator
    mutate(rate = 100 * nw / Nw) %>% 
    mutate(proportion = nw/Nw,
           rate = 100 * proportion,
           ci_wald = 100 * (1.96*sqrt((proportion*(1-proportion))/Nuw)), # Wald method 
           lowci = rate - ci_wald,
           upci = rate + ci_wald) %>%
    select(-proportion, -starts_with("n_"), -starts_with("wt_"), -ci_wald) %>%
    # add def_period
    mutate(def_period = paste0("Aggregated survey years (", trend_axis, ")"),
           ind_id = ind) %>%
    rename(numerator = nuw) %>%
    select(-c(nw, Nw, Nuw)) 
 # smallest unweighted base (denominator) was 165 for adult indicator, 36 for CYP indicator  
 
  # 1 - main data (ie data behind summary/trend/rank tab)
  main_data <- df %>% 
    filter(split_name == "None") %>% 
    select(code, ind_id, year, 
           numerator, rate, upci, lowci, 
           def_period, trend_axis) %>%
    unique() %>%
    arrange(code, year)
  
  # Save the indicator data
  # Including both rds and csv file for now
  write_rds(main_data, file = paste0(profiles_data_folder, "/Data to be checked/", ind_name, "_shiny.rds"))
  write_csv(main_data, file = paste0(profiles_data_folder, "/Data to be checked/", ind_name, "_shiny.csv"))
  
  # 2 - no popgroup data (data are household rather than individual level) 
  
  # 3 - SIMD data (ie data behind deprivation tab)
  
  # Process SIMD data
  simd_data <- df %>%
    filter(split_name == "Deprivation (SIMD)") %>%
    unique() %>%
    select(-split_name) %>%
    rename(quintile = split_value) %>%
    mutate(quint_type = "sc_quin") %>%
    arrange(code, year, quintile)
  
  # add population data (quintile level) so that inequalities can be calculated
  if(ind==30166) {
      simdpop = "depr_pop_under16"
    } else {
      simdpop = "depr_pop_16+"
    }
  
  simd_data <-  simd_data|>
    add_population_to_quintile_level_data(pop = simdpop, 
                                          ind_id = ind, 
                                          ind_name = ind_name) |>
    filter(!is.na(rate)) # not all years have data
  
  # calculate the inequality measures
  simd_data <- simd_data |>
    calculate_inequality_measures() |> # call helper function that will calculate sii/rii/paf
    select(-c(overall_rate, total_pop, proportion_pop, most_rate,least_rate, par_rr, count)) #delete unwanted fields
  
  # save the data as RDS file
  saveRDS(simd_data, paste0(profiles_data_folder, "/Data to be checked/", ind_name, "_ineq.rds"))
  

  # Make data created available outside of function so it can be visually inspected if required
  main_data_result <<- main_data
  simd_data_result <<- simd_data
  
  
}


# Run function to create final files

# CYP indicator:
prepare_final_files(ind_name = "disrepair_cyp")

# Adult indicator:
prepare_final_files(ind_name = "disrepair_all")


       
# Run QA reports

# main data
run_qa(type = "main", filename="disrepair_cyp", test_file=FALSE)
run_qa(type = "main", filename="disrepair_all", test_file=FALSE)

# ineq data: 
run_qa(type = "deprivation", filename="disrepair_cyp", test_file=FALSE)
run_qa(type = "deprivation", filename="disrepair_all", test_file=FALSE)


#END

