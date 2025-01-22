
# ===== Functions for extracting and processing data from UKDS microdata file =====
# =================================================================================


#' Read and clean stata file data
#'
#' Given a link to a base directory and to specific files, combine the two
#' to create a valid path, and read a .dta file into R, converting names to a clean
#' format
#'
#' @param rel_loc 
#' @param source_dir 
#' @param encoding = NULL (used for the single instance where an Understanding Society file l_indresp has different encoding, and won't read in unless encoding is specified as latin1) 
#'
#' @return a data.frame
#' @export
#'
#' @examples
read_and_clean_dta <- function(rel_loc, source_dir, encoding = NULL){
  stopifnot("file location does not exist" = file.exists(here::here(source_dir, rel_loc)))
  
  if(!is.null(encoding)){
    haven::read_dta(
      here(source_dir, rel_loc), 
      encoding = "latin1"  # setting the encoding fixes an issue with reading in an Understanding Society file
    ) %>% 
      janitor::clean_names() 
  } else {
    haven::read_dta(
      here(source_dir, rel_loc) 
    ) %>% 
      janitor::clean_names() 
  }
}

#' Extract and describe variables
#'
#' @param file_loc 
#' @param source_dir 
#' @param encoding = NULL  
#'
#' @return
#' @export
#'
#' @examples
extract_var_desc <- function(file_loc, source_dir, encoding=NULL){
  dta_full <- read_and_clean_dta(file_loc, source_dir, encoding)
  get_var_desc(dta_full)
}

#' Select variables in files from a list
#'
#' @param file_loc Where the file is located, given `source_dir`
#' @param source_dir A base directory. Combined with `file_loc` this locates the data file
#' @param vars_to_keep List of variables to search for
#' @param verbose Logical, `TRUE` for messages while running
#' @param encoding = NULL  
#'
#' @return `dta_reduced` a data frame with only the varibles of interest kept
#' @export
#'
#' @examples
read_select <- function(file_loc, source_dir, vars_to_keep, 
                        verbose = FALSE, encoding=NULL){
  dta_full <-  read_and_clean_dta(file_loc, source_dir, encoding)
  
  dta_reduced <- dta_full %>% 
    select(any_of(vars_to_keep))

  if (verbose){
    message("data contains ", ncol(dta_full), " variables")
    message("searching for ", length(vars_to_keep), " variables")
    message("found ", ncol(dta_reduced), " variables")
  }
  
  dta_reduced
}




#' Get variable labels and descriptions
#'
#' Given a data.frame read in with haven::read_dta, extract the variable description 
#' for each variable
#'
#' @param df a data.frame created with a successful haven:read_dta call
#'
#' @return a data.frame with two columns: var for variable label and desc for associated description
#' @export
#'
#' @examples
get_var_desc <- function(df){
  stopifnot("input is not a data.frame" = "data.frame" %in% class(df) )
  stopifnot("input does not contain names attribute" = "names" %in% names(attributes(df)) )
  var_desc <- sapply(df, function(x) attributes(x)$label)
  var_desc_df <- tibble(
    var = names(var_desc),
    desc = unname(var_desc)
  )
  var_desc_df  
}


#' Return unique character responses
#'
#'
#'
#' @param x a vector of character or factor type; if another class is given as input NULL will be returned
#' @param verbose a logical flag for whether to print further information
#'
#' @return a character list of unique responses
#' @export
#'
#' @examples
get_valid_responses <- function(x, verbose = FALSE){
  
  if(!(class(x) %in% c("character", "factor"))) {
    return(NULL)
  }  
  
  x <- as.character(x)
  
  labs_x <- unique(x)
  
  if (verbose){
    message("labels detected are ", paste(labs_x, collapse = ", "))
  }
  
  labs_x
}

#' Function to find survey data files, extract variable names and labels (descriptions), and save this info to a spreadsheet. 
#' Will work with the different encoding used for one Understanding Society file (l_indresp)
#'
#' @param survey Survey acronym that corresponds to the survey's UKDS data folder in MHI_Data. One of aps/hbai/shs/shes/shcs/scjs/unsoc
#' @param name_pattern The regular expression used to pull out the survey year from that survey's files' filenames. 
#' The bit of name_pattern in normal brackets () is the year part of the filename, which is to be extracted and store in the year column.
#' The pattern is different for each survey, because the naming was done differently for each. 
#' The regular expressions were worked out using the site https://regex101.com/ and examples of the filenames. 
#' name_pattern = c("hbai" = "i(\\d{4})",
#'                  "scjs" = "scjs_(\\d{4})",
#'                  "shcs" = "shcs(\\d{4})",
#'                  "aps" = "(\\d{2})_eul",
#'                  "shes" = "\\/shes\\D?(\\d{2,10})",
#'                  "shs" = "\\/shs(\\d{4}-?\\d{0,4})",
#'                  "unsoc" = "\\/([a-z]*)_.*") 
#' 
#' @return xlsx workbook "all_survey_var_info.xlsx", with 2 tabs for each survey (one for filenames, one for variable names and their descriptions)
#'
#' @examples save_var_descriptions("shs", "\\/shs(\\d{4}-?\\d{0,4})")
save_var_descriptions <- function (survey, name_pattern) {
  
  # Set the directory containing the data (assumes it is a folder within /conf/MHI_Data/big/big_mhi_data/unzipped/)
  
  source_dir <- paste0("/conf/MHI_Data/big/big_mhi_data/unzipped/", survey)  
  
  # Find all the stata files (extension .dta) in the source_dir. 'recursive' is used so that any subfolders within source_dir are checked.

  if(survey=="unsoc"){
    # for understanding soc: we only want individual-level files (ind*), because there are loads of others
    dta_files <- list.files(source_dir, pattern = "indresp\\.dta$|indall\\.dta$", recursive = TRUE) 
  } else {
    dta_files <- list.files(source_dir, pattern = "\\.dta$", recursive = TRUE) 
  }
  
  # Store the survey year and path for each .dta file
  survey_year_lookups <- tibble(
    year = dta_files %>% # This pulls out the year (/year range) from the file name and location
      str_match(pattern = name_pattern) %>% 
      .[,2] %>%  
      as.character(), # Store years as characters at this point, because some are ranges and contain non-numeric characters 
    filename = dta_files %>% 
      str_match(pattern = "([^\\/]*)\\.dta") %>%  # this pulls out the file name (removing the .dta extension)
      .[,2], 
    fileloc  = dta_files
  )
  
  # For each file in dta_files, let's extract the variable names and descriptions (i.e., labels from the stata file) and store in a dataframe
  # N.B. the actual data aren't read in at this point
  
  start_time <- Sys.time()
  message("Extracting variables and descriptions")
  
  survey_var_descs <- 
    survey_year_lookups %>% 
    mutate(encoding = ifelse(filename=="l_indresp", "latin1", NA)) %>% # deals with the one file among all the survey data that is encoded differently (l_indresp in Understanding Society). Add more filenames if others are found. 
    mutate(
      var_desc = map(fileloc, extract_var_desc, source_dir = source_dir, encoding=encoding), # runs the function extract_var_desc()
      var_desc = map(var_desc, ~.x %>%
                       mutate(across(.cols = everything(), as.character))) # needed because the descriptions for one file (l_indresp) read in as a list and couldn't be unnested in that format
    ) %>% 
    unnest(var_desc) %>%
    select(-encoding)
  
  end_time <- Sys.time()
  message("Extraction completed")
  message("This took ", round(as.double(end_time - start_time, units = "mins"), 2), " minutes")
  
  rm(start_time, end_time)
  
  # Write the filenames (survey_year_lookups), and variable names and variable descriptions (survey_var_descs) to a workbook. 
  # addWorksheet will fall over if the worksheet already exists, so need to removeWorksheet first.
  # But removeWorksheet will cause the function to fall over if the worksheet doesn't exist.
  # So first we make a 'safe' version of removeWorksheet: it will try to remove the worksheet, but if it can't find the worksheet nothing bad will happen, and the function will continue to run.
  
  safe_removeWorksheet <- possibly(removeWorksheet, otherwise = NULL) 
  
  # Load the workbook in, add the filenames, variable names and variable descriptions, and save 
  
  wb <- loadWorkbook(here("data", "all_survey_var_info.xlsx"))
  safe_removeWorksheet(wb, paste0("files-", survey)) # remove pre-existing worksheet, if it exists
  addWorksheet(wb, paste0("files-", survey))
  writeData(wb, paste0("files-", survey), survey_year_lookups)
  safe_removeWorksheet(wb, paste0("vars-", survey)) # remove pre-existing worksheet, if it exists
  addWorksheet(wb, paste0("vars-", survey))
  writeData(wb, paste0("vars-", survey), survey_var_descs)
  saveWorkbook(wb, file = here("data", "all_survey_var_info.xlsx"), overwrite = TRUE)
  
}

#' Extract survey data (from UKDS survey files)
#' 
#' Given a survey acronym (one of aps/hbai/shs/shes/shcs/scjs/unsoc), 
#' a list of files for that survey in the worksheet "all_survey_var_info.xlsx", 
#' and a "vars_to_extract" file for the survey,
#' the function will read in the relevant variables from the files into a single dataframe and save it as an rds file.
#' The dataframe created starts with the file list from "all_survey_var_info.xlsx" and will retain this number of rows (if data can be extracted for all).
#' It will add a list column ("survey_data") in which the survey data are stored. 
#' Can cope with situation if a file is differently encoded: this has only been encountered once, 
#' for UnSoc file l_indresp, so the encoding for that file (latin1) has been hard-coded here. 
#' Need to add other filenames if they are found to need different encoding too.
#'
#' @param survey One of aps/shs/shes/shcs/scjs/unsoc
#'
#' @return The dataframe is written to a rds file called "extracted_survey_data_", survey, ".rds" 
#'
#' @examples
extract_survey_data <- function (survey) {
  
  # Set the directory containing the data (assumes it is a folder within /conf/MHI_Data/big/big_mhi_data/unzipped/)
  
  source_dir <- paste0("/conf/MHI_Data/big/big_mhi_data/unzipped/", survey)  
  
  # Extract the paths to the relevant survey files
  
  survey_year_lookups <- read.xlsx(xlsxFile = here("data", "all_survey_var_info.xlsx"), 
                                   sheet = paste0("files-", survey))
  
  # Source the variables to extract
  
  source(here("R", paste0("vars_to_extract_", survey, ".R")))
  
  # Now extract the variables from the relevant survey files, and store in a single dataframe (requires a list column)
  
  start_time = Sys.time()
  message("Extracting only the variables of interest")
  
  extracted_survey_data <- 
    survey_year_lookups %>% # starts with the list of survey files
    mutate(encoding = ifelse(filename=="l_indresp", "latin1", NA)) %>% # deals with the one file among all the survey data that is encoded differently (l_indresp in Understanding Society). Add more filenames if others are found. 
    mutate(survey_data = # adds a column called survey_data, which is then filled with the result of the subsequent function (making it a list column):
             # The map() function here passes the fileloc (path) from the survey_year_lookups dataframe to the read_select() function (pre-defined in the utils script),
             # along with other required variables (source_dir, vars_to_keep, and encoding). 
             # The read_select function reads in the data (haven package), selects the relevant vars, then cleans the variable names (janitor package)
             map(fileloc, 
                 ~ read_select(.x, 
                               source_dir = source_dir, 
                               vars_to_keep = vars_to_keep,
                               encoding = encoding, 
                               verbose = FALSE) %>% 
                   mutate_if(~"haven_labelled" %in% class(.), as_factor))) %>% # this turns all labelled variables into factors
    # The preceding mutate function stored the survey data for each row of the original list of survey files in the list column survey_data: so this dataframe is no longer a flat file
    mutate(nvar = map_dbl(survey_data, ncol)) %>% # map_dbl() counts the number of columns in each cell of the survey_data list column
    filter(nvar >= 1) %>% # drop rows if no data has been read in. Why would this happen? No variables to select perhaps, like household-level files.
    select(-encoding, -nvar)
  
  
  end_time = Sys.time()
  message("Extraction completed")
  message("This took ", round(as.double(end_time - start_time, units = "mins"), 2), " minutes")
  
  
  # Save this object 
  write_rds(extracted_survey_data, here("data", paste0("extracted_survey_data_", survey, ".rds")))
}


#' Extracts and store the responses that have been recorded for each variable
#'
#' @param survey One of aps/hbai/shs/shes/shcs/scjs/unsoc
#' @param chars_to_exclude Vector of strings that uniquely identify variables that shouldn't be included (e.g., numeric vars like wt or age). Be careful that these don't pick up variables that should be included. 
#'
#' @return var names and their responses are saved as "responses_as_list_", survey, ".rds"
#' @export var names and their responses are written to workbook "all_survey_var_info.xlsx"
#'
#' @examples
extract_responses <- function (survey, chars_to_exclude=NULL) {
  
  # read in the survey data
  df <- readRDS(here("data", paste0("extracted_survey_data_", survey, ".rds")))
  
  # Produce a df with var_name column for the variable name, and responses column containing a list of all recorded responses for that variable
  if(survey=="unsoc"){
    # for understanding soc: variable names are prefixed with a letter representing the wave, so no vars are the same
    # remove the prefix here (using gsub in a mutate function) :
    all_responses <-
      df %>%
      mutate(responses = map(survey_data, ~map(.x, ~get_valid_responses(.x)))) %>% # runs the function get_valid_responses(), adds all the valid responses into a new list column
      # extracts the unique responses for each character and factor variable (so numeric data like weights get NA here)
      unnest_longer(responses) %>% # 1st unnesting of the responses column pulls out the var_name (into responses_id column) and puts all the responses recorded into responses list column.
      unnest_longer(responses) %>% # 2nd unnesting has a row for each possible response for each variable
      mutate(responses_id = gsub("^[a-z]_", "", responses_id)) %>%
      select(var_name=responses_id, responses) %>% # don't need to keep year/filename/etc as the same variable name will have same coding across the years
      unique() %>% # removes duplicates
      group_by(var_name) %>%
      nest() %>% # groups all the responses recorded for each variable into a list column called data (the list column contains a single column tibble)
      mutate(responses = map(data, pull)) %>% # puts the responses in 'data' into a column called responses: this is a simpler character list than 'data' was
      select(-data) %>%
      arrange(var_name)
  } else {
    all_responses <-
      df %>%
      mutate(responses = map(survey_data, ~map(.x, ~get_valid_responses(.x)))) %>% # runs the function get_valid_responses(), adds all the valid responses into a new list column
      # extracts the unique responses for each character and factor variable (so numeric data like weights get NA here)
      unnest_longer(responses) %>% # 1st unnesting of the responses column pulls out the var_name (into responses_id column) and puts all the responses recorded into responses list column.
      unnest_longer(responses) %>% # 2nd unnesting has a row for each possible response for each variable
      select(var_name=responses_id, responses) %>% # don't need to keep year/filename/etc as the same variable name will have same coding across the years
      unique() %>% # removes duplicates
      group_by(var_name) %>%
      nest() %>% # groups all the responses recorded for each variable into a list column called data (the list column contains a single column tibble)
      mutate(responses = map(data, pull)) %>% # puts the responses in 'data' into a column called responses: this is a simpler character list than 'data' was
      select(-data) %>%
      arrange(var_name)
  }
  
  if(!is.null(chars_to_exclude)){
    all_responses <- all_responses %>%
      filter(!grepl(paste(chars_to_exclude, collapse = "|"), var_name))
  } else {
    all_responses
  }
  
  # Turn the df of responses into a list, for printing out and inspecting to work out variable codings
  responses_as_list <- all_responses %>%
    rowwise() %>%
    pull(responses)
  names(responses_as_list) <- all_responses$var_name # add the variable names to the list

  # Save this list
  write_rds(responses_as_list, here("data", paste0("responses_as_list_", survey, ".rds")))
  
  # Make a flat df (no lists) for saving into xlsx
  responses_df <- data.frame(all_responses %>% unnest(cols = c(responses)))
  
  # Load the workbook in, add a worksheet to store the responses for this survey, and save
  safe_removeWorksheet <- possibly(removeWorksheet, otherwise = NULL)
  wb <- loadWorkbook(here("data", "all_survey_var_info.xlsx"))
  safe_removeWorksheet(wb, paste0("responses-", survey)) # remove pre-existing worksheet, if it exists
  addWorksheet(wb, paste0("responses-", survey))
  writeData(wb, paste0("responses-", survey), responses_df)
  saveWorkbook(wb, file = here("data", "all_survey_var_info.xlsx"), overwrite = TRUE)
  
}


#' Unzip many files from zipped to unzipped
#'
#' @param zipped_base the base directory for where the zipped files are kept
#' @param unzipped_base the base directory for where the unzipped files should be unzipped to
#' @param files_to_unzip the specific files to unzip from zipped to unzipped
#'
#' @return Nothing: called for its side effects
#' @export
#'
#' @examples
unzip_subdirs <- function(zipped_base, unzipped_base, files_to_unzip){
  stopifnot("zipped base not a string" = is.character(zipped_base))
  stopifnot("unzipped base not a string" = is.character(unzipped_base))
  stopifnot("zipped base not a string" = is.character(files_to_unzip))
  
  file_name_match <- "[^\\/]*\\.zip$"
  
  loc_names <- str_remove(files_to_unzip, file_name_match)
  
  file_names <- str_extract(files_to_unzip, file_name_match)
  
  # Create the dirs to put the unzipped contents into 
  walk(loc_names, ~ dir.create(here("data", "big", "unzipped", "shes", .x), recursive = TRUE))
  
  # Now unzip to respective dirs 
  
  walk2(loc_names, files_to_unzip, 
        ~unzip(
          zipfile = here("data", "big", "zipped", "shes", .y), 
          exdir = here("data", "big", "unzipped", "shes", .x)
        )
  )
  
  NULL
}


#' Function to coalesce two SIMD variables into a single one, called simd_combo, then remove original SIMD columns
#'
#' This is set up specifically to catch the only case of this occurring: in SHeS file for 2015-18
#' @param df The input dataframe to be checked, and simd columns coalesced where necessary
#'
#' @return df in same format, with, if relevant, the simd_combo column added, and the original two simd columns removed
#' @export
#'
#' @examples
coalesce_simd <- function(df){
  
  if ("simd5_s_ga" %in% names(df) & "simd16_s_ga" %in% names(df)){
    df %>%
      mutate(simd5_s_ga = as.character(simd5_s_ga),
             simd16_s_ga = as.character(simd16_s_ga)) %>%
      mutate(simd5_s_ga = case_when(simd5_s_ga == "Not applicable" ~ as.character(NA),
                                    simd5_s_ga == "2" ~ "2nd",
                                    simd5_s_ga == "3" ~ "3rd",
                                    simd5_s_ga == "4" ~ "4th",
                                    TRUE ~ simd5_s_ga),
             simd16_s_ga = case_when(simd16_s_ga == "Not applicable" ~ as.character(NA),
                                     TRUE ~ simd16_s_ga)) %>%
      mutate(simd_combo = coalesce(simd5_s_ga, simd16_s_ga)) %>%
      select(-simd5_s_ga, -simd16_s_ga)
  }
  else {df}
}


##########################################################################################
# Rounding functions:
##########################################################################################

# round in base R rounds to the even digit, which isn't how the survey data have been rounded.
# So I found this function in SO: https://stackoverflow.com/questions/12688717/round-up-from-5
#function for rounding to 0 dp, that rounds all x.5s up 
rnd <- function(x) trunc(x+sign(x)*0.5)
#function for rounding to nearest 10, that rounds all 5s up 
rnd10 <- function(x) 10*(trunc(x/10+sign(x/10)*0.5))
#function for rounding to 1 dp, that rounds all x.x5s up 
rnd1dp <- function(x) (trunc((x*10)+sign((x*10))*0.5))/10
#function for rounding to 4 dp, that rounds all x.xxxx5s up 
rnd4dp <- function(x) (trunc((x*10000)+sign((x*10000))*0.5))/10000




##########################################################################################
# Functions to run the survey calcs (survey package) on the survey data, by various groupings
##########################################################################################
# These functions prep the data and perform calculations for percentage and score indicators from a microdata file from a survey with a complex survey design.
# Applies to SHeS and Understanding Society data


# # Function to calculate the age-standardised weight (for the SHeS SIMD calcs)
# 
# # Adjusts the weight to reflect age-distribution: this allows the final SIMD calc to produce age-standardised estimates
# # (ER translated this code from SAS code provided by SHeS team, and verified that it functioned correctly)

add_std_weight <- function (df, var, wt) {
  
  df <- df %>%
    #rename(#svy_var = var,
    #  svy_wt = wt) %>% # makes later calculations easier if starting variable and weight have standard name
    # filter(nchar(year) == 2) %>% # keep only single year (national) data. No, using 4-year aggregated data now.
    group_by(trend_axis, agegp7, sex, quintile) %>%
    mutate(numsxag = sum(.data[[wt]][!is.na(var)], na.rm=T)) %>% # sums the weights when there's a valid response for the survey variable
    ungroup() %>%
    group_by(trend_axis, sex, quintile) %>%
    mutate(numsx = sum(.data[[wt]][!is.na(var)], na.rm=T)) %>% # sums the weights when there's a valid response for the survey variable
    ungroup() %>%
    mutate(scaling = prop_pop * numsx/numsxag) %>% # a scaling factor to upweight or downweight any age groups that are under/over-represented in the valid responses
    mutate(wt = .data[[wt]] * scaling) %>% # makes a new weight for the individual that incorporates the age-standardisation
    filter(!is.na(wt)) %>%
    filter(var!="NA") %>%
    select(year, trend_axis, var, wt, sex, quintile, hb, psu, strata)
  
  df
  
}



# Function to get the data ready for the survey calculation.
# The groupings required are passed as a vector to 'variables' 
# If the indicator is a % (type == "percent") then groupings with no positive cases are removed (not needed for score indicators)

prep_df_for_svy_calc <- function(df, var, wt, variables, type) {
  
  svy_df <- df %>%
    # rename the wt to "wt" if not renamed that already:
    rename_with( ~ case_when(. == wt ~ "wt",
                             . == var ~ "var",
                             TRUE ~ .)) %>%
    filter(!is.na(var)) %>%
    filter(!is.na(wt)) %>%
    select(all_of(variables), var, wt, psu, strata)
  
  if(type == "percent") {
    
    svy_df <- svy_df %>%
      group_by(across(all_of(variables))) %>%
      mutate(count_n = sum(var=="yes", na.rm=TRUE)) %>%
      ungroup() %>%
      filter(count_n>0) %>%  # drop groups where there's no cases (N but no n) (breaks the survey calc otherwise)
      select(all_of(variables), var, wt, psu, strata)
  }
  
  svy_df
  
}



# Function to run the survey calculation for the indicator
# Specifies the survey design, and runs the right model, depending on whether the indicator type is percent or score. 

run_svy_calc <- function(svy_df, variables, var, type) {
  
  # single-PSU strata are centred at the sample mean
  options(survey.lonely.psu="adjust") 
  
  # specify the complex survey design
  svy_design <- svydesign(id=~psu,
                          strata=~strata,
                          weights=~wt,
                          data=svy_df,
                          nest=TRUE) #different strata might have same psu numbering (which are different psu)
  
  if (type == "percent") {
    
    # Calculate % and CIs 
    percents <- data.frame(svyby(~I(var=="yes"), 
                                 reformulate(termlabels = variables), # turns the variables vector c(x, y, z) into the rhs formula ~x+y+z
                                 svy_design, 
                                 svyciprop, ci=TRUE, vartype="ci", method="logit")) %>% # produces CIs appropriate for proportions, using the logit method 
      # (this fits a logistic regression model and computes a Wald-type interval on the log-odds scale, which is then transformed to the probability scale)
      mutate(rate = I.var.....yes.. * 100, #resulting estimate has very unwieldly name!
             lowci = ci_l * 100,
             upci = ci_u * 100,
             indicator = var) %>%
      select(all_of(variables), indicator, rate, lowci, upci)
    
  } else if (type == "score") {
    
    # Calculate mean scores and CIs
    scores <- data.frame(svyby(~var, 
                               reformulate(termlabels = variables), 
                               svy_design, svymean, 
                               ci=TRUE, vartype="ci")) %>% 
      rename(rate = var,
             lowci = ci_l,
             upci = ci_u) %>%
      mutate(indicator = var) %>%
      select(all_of(variables), indicator, rate, lowci, upci)
    
    
  } else {
    
    "Error: type should be score or percent"
    
  }
  
}


# Function to add numerators and denominators into the dataset
# Also adds spatial.unit, spatial.scale and quintile columns

add_more_required_cols <- function(df, var, svy_result, variables, type) {
  
  # Options:
  # variables <- c("trend_axis", "sex")
  # variables <- c("trend_axis", "sex", "quintile")
  # variables <- c("trend_axis", "sex", "hb")
  
  # add numerators and denominators (including zeroes if present)
  
  if (type == "percent") {
    
    results <- df %>%
      filter(!is.na(var)) %>%
      group_by(across(all_of(variables))) %>%
      summarize(numerator = sum(.data[[var]]=="yes", na.rm=TRUE),
                denominator = sum(!is.na(.data[[var]]))) %>% # includes situations where no positive cases (these were dropped for the survey analysis, but need to be retained)
      ungroup() %>%
      merge(y = svy_result, by = variables) 
    
  } else if (type == "score") {
    
    results <- df %>%
      filter(!is.na(var)) %>%
      group_by(across(all_of(variables))) %>%
      summarize(denominator = sum(!is.na(.data[[var]]))) %>% 
      ungroup() %>%
      mutate(numerator = as.numeric(NA)) %>%
      merge(y = svy_result, by = variables) 
    
  } else {
    
    "Error: type should be score or percent"
    
  }
  
  
  if ("quintile" %in% variables) {
    
    results <- results %>%
      mutate(spatial.scale = "Scotland",
             spatial.unit = "Scotland") 
    
  } else if ("hb" %in% variables) {
    
    results <- results %>%
      mutate(spatial.scale = "Health board",
             quintile = "Total") %>%
      rename(spatial.unit = hb)
    
  } else {
    
    results <- results %>%
      mutate(spatial.scale = "Scotland",
             spatial.unit = "Scotland",
             quintile = "Total")
    
  }
  
}  


# Function to run the three shared functions for a single indicator

calc_single_breakdown <- function (df, var, wt, variables, type) {
  
  df1 <- prep_df_for_svy_calc(df, var, wt, variables, type)
  df2 <- run_svy_calc(df1, variables, var, type)
  df3 <- add_more_required_cols(df, var, df2, variables, type)
  
}


# Function for calling the required functions to produce Scotland, HB and SIMD data:

calc_indicator_data <- function (df, var, wt, ind_id, type) {
  
  # Scotland by sex
  results_scot <- calc_single_breakdown(df, var, wt, variables = c("trend_axis", "sex"), type)
  
  # Scotland by SIMD and sex 
  if ("agegp7" %in% names(df)) { # adult data
    simd_df <- add_std_weight(df, var, wt) 
  }  else { # child data
    simd_df <- df
  }
  
  results_simd <- calc_single_breakdown(simd_df, var, wt, variables = c("trend_axis", "sex", "quintile"), type)
  
  all_results <- bind_rows(results_scot, results_simd)
  
  # HB by sex
  if (!wt %in% c("verawt", "bio_wt", "intakewt")) { #only analyse these at national and SIMD levels
    
    results_hb <- calc_single_breakdown(df, var, wt, variables = c("trend_axis", "sex", "hb"), type)
    all_results <- bind_rows(all_results,
                             results_hb)
    
  }
  
  # Read in lookup for harmonising area names
  geo_lookup <- readRDS(paste0(lookups, "Geography/opt_geo_lookup.rds")) %>% 
    select(!c(parent_area, areaname_full))
  
  all_results <- all_results %>%
    mutate(ind_id = ind_id) %>%
    # add the geog codes, 
    merge(y=geo_lookup, by.x=c("spatial.unit", "spatial.scale"), by.y=c("areaname", "areatype")) %>%
    # add year back in
    # Replicating the standard used elsewhere in ScotPHO: year = the midpoint of the year range, rounded up if decimal
    mutate(year = case_when(nchar(trend_axis)==4 ~ as.numeric(trend_axis), 
                            nchar(trend_axis)>4 ~ rnd(0.5*(as.numeric(substr(trend_axis, 6, 9)) + as.numeric(substr(trend_axis, 1, 4)))), # e.g., "2015-2018" -> "2017" or "2015-2016" to "2016"
                            TRUE ~ as.numeric(NA))) %>% # shouldn't be any...
    # add def_period
    mutate(def_period = case_when(nchar(trend_axis) == 4 ~ paste0("Survey year (", trend_axis, ")"),
                                  nchar(trend_axis) > 4 ~ paste0("Aggregated survey years (", trend_axis, ")"))) %>%
    # add split info
    mutate(split_name = case_when(is.na(quintile) ~ "Sex", # doesn't work, as there's always an entry in quintile (number or 'Total')
                                  !is.na(quintile) ~ "Deprivation (SIMD)",
                                  TRUE ~ as.character(NA))) %>%
    mutate(split_value = case_when(is.na(quintile) ~ sex, # doesn't work, as there's always an entry in quintile (number or 'Total')
                                   !is.na(quintile) ~ quintile,
                                   TRUE ~ as.character(NA))) %>%
    # Result: All split names are called Deprivation: can fix this in the final processing 
    
    # required columns
    select(-starts_with("spatial")) %>%
    # arrange so the points plot in right order in QA stage
    arrange(ind_id, code, split_name, split_value, year, trend_axis)
  
}

## END
##########################################################################################
##########################################################################################
