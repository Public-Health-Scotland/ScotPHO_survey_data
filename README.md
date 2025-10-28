# ScotPHO_survey_data
Code for extracting survey data from UK Data Service/Archive microdata files and processing for the ScotPHO online profiles app. The script functions.R contains all the required functions. 

## STEP 1

Download and unzip the required data from https://ukdataservice.ac.uk/ to the MHI_data folder for that survey (choose the Stata format, .dta). Requires setting up an account and project and agreeing to conditions for the End User Licence versions of the data. There are already folders for Annual Population Survey (APS), Scottish Health Survey (SHeS), Scottish Household Survey (SHoS), Scottish House Condition Survey (SHCS) and Understanding Society (UnSoc) that we have been keeping up to date as the data are published on UKDS (usually quite a lag though).

## STEP 2

Work through the relevant script for that survey ([survey acronym]_processing.R), or start a new one based on the existing code. 

2a. Run save_var_descriptions() to extract the variable names and descriptions from the survey data (without extracting the actual data)

2b. Manually examine the results (saved to an xlsx) to select the variables that are needed to produce your indicators. Save these variable names to vars_to_extract_[survey acronym].R

2c. Run extract_survey_data() to get the required data. 

2d. Extract all the possible responses that have been used in the data, by running extract_responses(), so you can work out how they need to be coded. 

2e. Recode and further process the raw data. In some cases (e.g., SHeS) the processed data are saved and combined with published data in the ScotPHO-indicator-production repo. In other cases (e.g., SHCS) the processing script produces the final indicator data, saves these to ScotPHO's Data to be checked folder, and runs the required QA tests. 
