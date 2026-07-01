# ============================================================================
# ===== VARIABLE LOOKUPS FOR SCOTTISH HEALTH SURVEY (shes) =====
# ============================================================================

## HOW SHOULD SHES VARIABLES BE CODED?

## IMPORTANT: These lookups need to be reviewed each time new SHeS data are being read in. 
## The available responses should be printed out to the console:
## responses_as_list_shes

## Compare the print out with the lookups here:
## Are the codings still comprehensive? Do they capture every response we want to code as yes or no? (NA/refused/etc can be ignored)
## Amend the lookups as required, then save and source this file before continuing to run ukds_shes_processing.R

# Create lookups to code the variables into the dichotomy needed for the indicators:
# (each lookup needs to contain all response versions including the range of punctuation and capitalisation used)

# Lookups as lists: 
# "yes" indicates a case (summed later to give numerator)
# "no" indicates an alternative response (not a case) that should be included in the denominator
# lookups for splits (quintiles, sex, limiting illness, and CAs) follow the indicator lookups

#########################
# INDICATOR LOOKUPS:
#########################

# physical activity indicator # adt10gptw AND adt10gp_tw
lookup_adt10gp_tw <- list(
  "Meets recommendations"="yes",
  "Low activity"="no", 
  "Some activity"="no", 
  "Very low activity"="no")

# low levels of physical activity indicator
lookup_adt10gp_tw_LOW <- list(
  "Meets recommendations"="no",
  "Low activity"="no", 
  "Some activity"="no", 
  "Very low activity"="yes")

# For recoding anxsymp and dvj12
lookup_anxsymp<- list(
  "2"="yes", 
  "3"="yes", 
  "4"="yes",
  "0"="no", 
  "1"="no" 
)

# For recoding auditg
lookup_auditg <- list(
  "0-7"="no",
  "8 or more (hazardous/harmful drinking"="yes",
  "8 or more (hazardous / harmful drinking)"="yes" 
)

# Healthy weight (for bmivg5, bmivg5_adj, combmivg5_adj)
lookup_healthyweight <- list(
  "18.5 to less than 25"="yes",
  "Under 18.5" ="no",              
  "Over 25-30" ="no",              
  "25 to less than 30" ="no",         
  "Over 18.5-25" ="no",            
  "Over 30-40" ="no",             
  "30 to less than 40" ="no",      
  "Over 40" ="no",                 
  "40 and over"="no"   )

# For recoding child PA (c00sum7s)
lookup_childpa1hr <- list(
  "Group 1:60+min on all 7 days" ="yes",    
  "Group 1: 60+min on all 7 days" ="yes",   
  "Group 2:30-59min on all 7 days" ="no",  
  "Group 3:Lower level of activity" ="no",
  "Group 2: 30-59min on all 7 days" ="no",
  "Group 3: Lower level of activity" ="no"
)

#Children with very low activity levels (inc school)
lookup_c00sum7s <- list(
  "Group 1:60+min on all 7 days" = "no",
  "Group 1: 60+min on all 7 days" = "no",
  "Group 2:30-59min on all 7 days" = "no",
  "Group 2: 30-59min on all 7 days" = "no",
  "Group 3:Lower level of activity" = "yes",
  "Group 3: Lower level of activity" = "yes")

# children living with parent with GHQ12 score of 4+ (cghq214)
lookup_childghq <- list(
  "Living with parent with GHQ12 score of 4+"="yes",
  "Not living with parent with GHQ12 score of 4+"="no"   )

#Children meeting activity guidelines (not inc school)
lookup_ch00sum7 <- list(
  "Group 1:60+min on all 7 days" = "yes",
  "Group 1: 60+min on all 7 days" = "yes",
  "Group 2:30-59min on all 7 days" = "no",
  "Group 2: 30-59min on all 7 days" = "no",
  "Group 3:Lower level of activity" = "no",
  "Group 3: Lower level of activity" = "no")

#Children engaging in active play
lookup_ch30plyg <- list(
  "None" = "no",
  "1 or 2" = "no",
  "3 or 4" = "no",
  "5 or more" = "yes")

# choice at work
lookup_contrl <- list(
  "Always"="yes", 
  "Often"="yes",
  "Never"="no", 
  "Seldom"="no", 
  "Sometimes"="no"  
)

# For recoding depsymp and dvg11
lookup_depsymp <- list(
  "2"="yes", 
  "3"="yes", 
  "4"="yes",
  "0"="no", 
  "1"="no"
)

# drinking over rec limits (drkcat315)
lookup_alcoholguidelines <- list(
  "Hazardous / harmful (over 14)" ="yes",   
  "Hazardous/harmful (over 14)" ="yes",      
  "Moderate (up to and including 14)" ="no", 
  "Non-drinker" ="no" )

# drinker (drkcat315)
lookup_drinker <- list(
  "Hazardous / harmful (over 14)" ="yes",   
  "Hazardous/harmful (over 14)" ="yes",      
  "Moderate (up to and including 14)" ="yes", 
  "Non-drinker" ="no" )


# deliberate self-harm
lookup_dsh5sc <- list(
  "Yes"="yes",
  "No"="no"
)

# GHQ caseness
# For recoding gh_qg2, ghqg2 and ghq2
lookup_gh_qg2 <- list( # trying to recreate the published data (SHeS dashboard) confirmed that 'don't know' and refused/not answered are excluded from calcs
  "Score 4+"="yes",
  "4 or more"="yes",
  "0"="no", 
  "1-3"="no",
  "Score 0"="no", 
  "Score 1-3"="no"
)

# general health (genhelf2)
lookup_genhelf2 <- list( 
  "Very good/good" ="yes",   
  "Very good / good" ="yes",
  "Fair" ="no",             
  "Bad/very bad" ="no",     
  "Bad / very bad" ="no"
)

# For recoding involve and involv19
lookup_involve <- list(
  "A fair amount"="yes", 
  "A great deal"="yes",
  "Not at all"="no", 
  "Not very much"="no"
)

# life satisfaction as % (lifesat2)
lookup_lifesat2 <- list(
  "above the mode (9-10)"="yes",
  "Above the mode (9-10)" = "yes",
  "mode (8)" ="no",               
  "Mode (8)" ="no",               
  "below the mode (0 to 7)" ="no",
  "Below the mode (0 to 7)"="no"   )

lookup_limitill <- list(
  "Limiting LI"="yes",
  "No LI"="no", 
  "Non limiting LI"="no"
)

#Adults meeting muscle strengthening recommendation (musrec and mus_rec)
lookup_mus_rec <- list(
  "No" = "no",
  "Yes" = "yes")

# binge drinking (olim_l_wb and olimlwb)
lookup_binge <- list(
  "Over M8,F6" ="yes",
  "Over 8 units for men, 6 units for women" ="yes",                     
  "From 0 up to and including  M8,F6" ="no",                            
  "From 0 up to and including 8 units for men, 6 units for women"  ="no"   )

# For recoding porftvg3 and porftvg3intake
lookup_porftvg3 <- list(
  "5 portions or more"="yes",
  "Less than 5 portions"="no", 
  "None"="no",
  "0.5 to less than 5 portions"="no", 
  "None/less than 0.5"="no",
  "2 portions or more but less than 3"="no",
  "3 portions or more but less than 4"="no",
  "4 portions or more but less than 5"="no",
  "1 portion or more but less than 2"="no",
  "Less than 1 portion"="no"
)

# Unpaid caring (NB. 2024: renamed to rg17anew)
lookup_rg17a_new <- list( 
  # we opted to treat those responding 'varies' and 'don't know' as unlikely to be giving 20+ hours care/week, and to include them in the denominator only. 
  # It's possible these answers were given by respondents who didn't know which of the 3 20+ hours categories their caregiving fell into, but we cannot know. 
  "20 - 34 hours a week"="yes", 
  "35 - 49 hours a week"="yes", 
  "50 or more hours a week"="yes",
  "5 - 19 hours a week"="no", 
  "Varies"="no", 
  "Varies (spontaneous - not on showcard)"="no", 
  "Up to 4 hours a week" = "no",
  "Don't know"= "no", 
  "Don't Know"= "no"
)

# For recoding sdq_totg
lookup_sdq_totg <- list(
  "14-16"="yes", 
  "17-40"="yes",
  "17-19"="yes",
  "20-40"="yes",
  "0-13"="no"
)

# For recoding sdq_cong
lookup_sdq_cong <- list(
  "4-10"="yes",                     
  "4-5"="yes",                     
  "6-10"="yes",                     
  "3"="yes",
  "0-2"="no" 
)

# For recoding sdq_emog
lookup_sdq_emog <- list(
  "5-10"="yes",                     
  "5-6"="yes",                     
  "7-10"="yes",                     
  "4"="yes",
  "0-3"="no" 
)

# For recoding sdq_hypg
lookup_sdq_hypg <- list(
  "7-10"="yes",                     
  "6"="yes",
  "6-7"="yes",                     
  "8"="yes",                     
  "9-10"="yes",                     
  "0-5"="no" 
)

# For recoding sdq_peeg
lookup_sdq_peeg <- list(
  "4-10"="yes",                     
  "4"="yes",                     
  "5-10"="yes",                     
  "3"="yes",
  "0-2"="no" 
)

#Children participating in sport
lookup_spt1ch <- list(
  "No" = "no",
  "Yes" = "yes")

# Stress at work
lookup_str_work2 <- list(
  "Very / extremely stressful"="yes", 
  "Very / Extremely stressful"="yes", 
  "very/extremely stressful"="yes", 
  "Very/extremely stressful"="yes",
  "moderately stressful"="no", 
  "Moderately stressful"="no", 
  "Not at all / mildly stressful"="no", 
  "Not at all / Mildly stressful"="no",
  "not at all/mildly stressful"="no", 
  "Not at all/mildly stressful"="no" 
)

# Attempted suicide
lookup_suicide2 <- list(
  "Yes in last year (inc last week)"="yes", 
  "Yes in last year (including last week)"="yes", 
  "Yes, in last year (including last week)"="yes",
  "Yes, in last year (including last week or month)" = "yes",
  "Never"="no", 
  "No"="no", 
  "Yes longer than year"="no", 
  "Yes, longer than year"="no" 
)

# For recoding support1 and support1_19
lookup_support1 <- list(
  "Strongly agree"="yes", 
  "Tend to agree"="yes",
  "Neutral"="no", 
  "Strongly disagree"="no", 
  "Tend to disagree"="no" 
)

# food insecurity (wrfood)
lookup_foodinsecure <- list(
  "Yes" ="yes",
  "No"  ="no"   )

#########################
# SPLITS LOOKUPS:
#########################

# For recoding sex/final_sex22
lookup_sex <- list(
  "Female"="Female",
  "Male"="Male" 
)

# recoding limiting illness as a split variable
lookup_limitill_SPLIT <- list(
  "Limiting LI" = "Long-term illness",
  "Non limiting LI" = "Long-term illness",
  "No LI" = "No long-term illness"
)

# recoding quintile
lookup_quintile <- list(
  "Most deprived" = "1", 
  "1st - most deprived" = "1",
  "most deprived" = "1",
  "1" = "1",
  "2nd" = "2",
  "2" = "2",
  "3rd" = "3",
  "3" = "3",
  "4th" = "4",
  "4" = "4",
  " 5th - least deprived"  = "5", 
  "Least deprived"  = "5", 
  "least deprived" = "5", 
  "5th - least deprived" = "5",
  "5" = "5"
)

# CA LOOKUP FROM XENIA (SHES TEAM): 
ca_lookup <- list(
  "100"= 'Aberdeen City',
  "110" = 'Aberdeenshire',
  "120"= 'Angus',
  "130" = 'Argyll & Bute',
  "150"= 'Clackmannanshire',
  "170" = 'Dumfries & Galloway',
  "180"= 'Dundee City',
  "190" = 'East Ayrshire',
  "200"= 'East Dunbartonshire',
  "210" = 'East Lothian',
  "220"= 'East Renfrewshire',
  "230" = 'City of Edinburgh',
  "240"= 'Falkirk',
  "250" = 'Fife',
  "260"= 'Glasgow City',
  "270" = 'Highland',
  "280"= 'Inverclyde',
  "290" = 'Midlothian',
  "300"= 'Moray',
  "235" = 'Na h-Eileanan Siar',
  "310"= 'North Ayrshire',
  "320" = 'North Lanarkshire',
  "330"= 'Orkney Islands',
  "340" = 'Perth & Kinross',
  "350"= 'Renfrewshire',
  "355" = 'Scottish Borders',
  "360"= 'Shetland Islands',
  "370" = 'South Ayrshire',
  "380"= 'South Lanarkshire',
  "390" = 'Stirling',
  "395"= 'West Dunbartonshire',
  "400" = 'West Lothian' )


## CODE TO BE RUN ENDS HERE ##



######################################
## Responses print-out:
# LAST PRINTED OUT: 

# $adt10gp_tw
# [1] "Meets recommendations"   "Schedule not applicable" "Very low activity"       "Some activity"           "Low activity"            "Don't know"             
# [7] "Refused"                 "Not answered"            "Refused/ not answered"   "Refused\\ not answered"  "Refused/not answered"   
#
# $adt10gptw
# [1] "Meets recommendations"   "Schedule not applicable" "Very low activity"       "Some activity"           "Low activity"            "Don't know"             
# [7] "Refused"
# 
# $ag16g10
# [1] "25-34"               "Item not applicable" "45-54"               "55-64"               "16-24"               "35-44"               "75+"                
# [8] "65-74"               "item not applicable" NA                    "Item Not Applicable" "Not applicable"      "Refused"            
# 
# $anxsymp
# [1] "0"                       "Schedule not applicable" "Item not applicable"     "1"                       "4"                       "2"                      
# [7] "3"                       "schedule not applicable" "item not applicable"     "Refusal"                 NA                        "Don't know"             
# [13] "schedule not obtained"   "don't know"              "refused"                 "Not applicable"          "Refused"                 "Schedule not obtained"  
# 
# $auditg
# [1] "0-7"                                      "8 or more (hazardous/harmful drinking"    "Schedule not applicable"                 
# [4] "Refused"                                  "Schedule not obtained"                    "Refusal"                                 
# [7] "Refused/not answered"                     "8 or more (hazardous / harmful drinking)" "Not applicable"                          
# 
# $bmivg5
# [1] "Over 25-30"              "Item not applicable"     "Schedule not applicable" "Over 18.5-25"            "Over 30-40"             
# [6] "Over 40"                 "Under 18.5"              "30 to less than 40"      "25 to less than 30"      "18.5 to less than 25"   
# [11] "40 and over"             "schedule not applicable" "item not applicable"     NA                        "Item Not Applicable"    
# [16] "Not applicable"         
# 
# $bmivg5_adj
# [1] "30 to less than 40"      "18.5 to less than 25"    "25 to less than 30"      "40 and over"             "Not applicable"          "Under 18.5"             
# [7] "Schedule not applicable"
# 
# $c00sum7s
# [1] "Schedule not applicable"          "Group 1:60+min on all 7 days"     "Group 2:30-59min on all 7 days"   "Group 3:Lower level of activity" 
# [5] "Don't know"                       "Item not applicable"              "schedule not applicable"          "item not applicable"             
# [9] "don't know"                       "Dont know"                        NA                                 "Age 16+"                         
# [13] "Age 0-1"                          "Not applicable"                   "Group 1: 60+min on all 7 days"    "Group 2: 30-59min on all 7 days" 
# [17] "Group 3: Lower level of activity"
# 
# $cbm_ig5_new
# [1] "Schedule not applicable"                                "Overweight (>= 85th %ile to < 95th %ile)"              
# [3] "Healthy weight (> 2nd %ile to < 85th %ile)"             "Morbidly obese (>= 98th %ile)"                         
# [5] "Underweight (<= 2nd %ile)"                              "Item not applicable"                                   
# [7] "Obese (>= 95th %ile to  <98th %ile)"                    "missing full date of birth"                            
# [9] "out of range"                                           "no BMI"                                                
# [11] "Not applicable"                                         "No BMI"                                                
# [13] "Missing full date of birth"                             "Out of range"                                          
# [15] "Morbidly obese (>= 98th percentile)"                    "Healthy weight (> 2nd percentile to < 85th percentile)"
# [17] "Overweight (>= 85th percentile to < 95th percentile)"   "Obese (>= 95th percentile to  <98th percentile)"       
# [19] "Underweight (<= 2nd percentile)"                        NA                                                      
# 
# $cbm_ig5_new_int
# [1] "No BMI"                                               "Schedule not applicable"                             
# [3] "Healthy weight (>2nd percentile to <85th percentile)" "Obese (>=95th percentile to <98th percentile)"       
# [5] "Overweight (>=85th percentile to <95th percentile)"   "Morbidly obese (>=98th percentile)"                  
# [7] "Underweight (<=2nd percentile)"                      
# 
# $cbm_ig5_new_sr
# [1] "Schedule not applicable"                                "Healthy weight (> 2nd percentile to < 85th percentile)"
# [3] "Underweight (<= 2nd percentile)"                        "No BMI"                                                
# [5] "Overweight (>= 85th percentile to < 95th percentile)"   "Morbidly obese (>= 98th percentile)"                   
# [7] "Out of range"                                           "Obese (>= 95th percentile to  <98th percentile)"       
# [9] "Missing full date of birth"                            
# 
# $cbmig5_new
# [1] "Schedule not applicable"                                "No BMI"                                                
# [3] "Morbidly obese (>= 98th percentile)"                    "Healthy weight (> 2nd percentile to < 85th percentile)"
# [5] "Overweight (>= 85th percentile to < 95th percentile)"   "Obese (>= 95th percentile to  <98th percentile)"       
# [7] "Missing full date of birth"                             "Underweight (<= 2nd percentile)"                       
# [9] "Out of range"                                          
# 
# $cbmig5_new_int
# [1] "Schedule not applicable"                              "Healthy weight (>2nd percentile to <85th percentile)"
# [3] "No BMI"                                               "Morbidly obese (>=98th percentile)"                  
# [5] "Overweight (>=85th percentile to <95th percentile)"   "Underweight (<=2nd percentile)"                      
# [7] "Obese (>=95th percentile to <98th percentile)"        "Out of range"                                        
# [9] "6"                                  
# 
# $cghq214
# [1] "Not applicable"                                "Not living with parent with GHQ12 score of 4+" "Living with parent with GHQ12 score of 4+"    
# [4] "Refused"                                       "Schedule not obtained"                         "No parent/guardian data"                      
# [7] "Item not applicable"                          
# 
# $ch30plyg
# [1] "not applicable"          "None"                    "5 or more"               "1 or 2"                  "3 or 4"                 
# [6] "Item not applicable"     "Don't know"              "Schedule not applicable" "schedule not applicable" "don't know"             
# [11] "Dont know"               NA                        "Not applicable"         
# 
# $ch_over_wt_new
# [1] "Schedule not applicable"                     "overweight or obese ((>= 95th %ile)"        
# [3] "not overweigh or obese (< 85th %ile)"        "Item not applicable"                        
# [5] "missing full date of birth"                  "out of range"                               
# [7] "schedule not applicable"                     "no BMI"                                     
# [9] "Not applicable"                              "Overweight or obese ((>= 95th %ile)"        
# [11] "Not overweight or obese (< 85th %ile)"       "No BMI"                                     
# [13] "Missing full date of birth"                  "Out of range"                               
# [15] "Overweight or obese ((>= 85th %ile)"         "Overweight or obese ((>= 95th percentile)"  
# [17] "Not overweight or obese (< 85th percentile)" "Overweight or obese (>= 95th percentile)"   
# [19] "Overweight or obese (>= 85th percentile)"    NA                                           
# 
# $ch_over_wt_new_int
# [1] "No BMI"                                      "Schedule not applicable"                    
# [3] "Not overweight or obese (< 85th percentile)" "Overweight or obese (>= 85th percentile)"   
# 
# $ch_over_wt_new_sr
# [1] "Schedule not applicable"                     "Not overweight or obese (< 85th percentile)"
# [3] "No BMI"                                      "Overweight or obese (>= 85th percentile)"   
# [5] "Out of range"                                "Missing full date of birth"                 
# 
# $choverwt_new
# [1] "Schedule not applicable"                     "No BMI"                                     
# [3] "Overweight or obese (>= 85th percentile)"    "Not overweight or obese (< 85th percentile)"
# [5] "Missing full date of birth"                  "Out of range"                               
# 
# $choverwt_new_int
# [1] "Schedule not applicable"                     "Not overweight or obese (< 85th percentile)"
# [3] "No BMI"                                      "Overweight or obese (>= 85th percentile)"   
# [5] "Out of range"   
# 
# $combmivg5_adj
# [1] "Schedule not applicable" "18.5 to less than 25"    "30 to less than 40"      "25 to less than 30"      "Not applicable"         
# [6] "40 and over"             "Under 18.5"              "Don't know"              "Refused"                 "Item not applicable"    
# 
# $contrl
# [1] "schedule not applicable" "Sometimes"               "Often"                   "Always"                  "Never"                   "don't know"             
# [7] "Seldom"                  "refused"                 NA                        "Item not applicable"     "Schedule not applicable" "Dont know"              
# [13] "Don't Know"              "Refusal"                 "Don't know"              "Refused"                 "Not applicable"         
# 
# $depsymp
# [1] "0"                       "Schedule not applicable" "Item not applicable"     "3"                       "1"                       "2"                      
# [7] "4"                       "schedule not applicable" "item not applicable"     "refused"                 "don't know"              "Don't know"             
# [13] "Refusal"                 "Dont know"               NA                        "schdule not obtained"    "Not applicable"          "Refused"                
# [19] "Schedule not obtained"  
# 
# $dnany
# [1] "not applicable"          "Never"                   "Very occasionally"       "schedule not obtained"   "Not applicable"         
# [6] "Schedule not obtained"   "Don't know"              "Schedule not applicable" "Item not applicable"     "Refused"                
# [11] "Refused/not answered"    NA                        "Dont know"               "Refusal"                
# 
# $dnnow
# [1] "Yes"                     "not applicable"          "No"                      "Not answered/refused"    "schedule not obtained"  
# [6] "Don't know"              "Not applicable"          "Schedule not obtained"   "No answer/Refused"       "Schedule not applicable"
# [11] "Item not applicable"     "Refused"                 "Refused/not answered"    "Refusal"                 NA                       
# 
# $drating
# values stored as strings, plus "Not answered (999.00)"
# 
# $drkcat315
# [1] "Moderate (up to and including 14)" "Hazardous/harmful (over 14)"       "Schedule not applicable"           "Non-drinker"                      
# [5] "Don't know"                        "Refused"                           "Schedule obtained"                 "Item not applicable"              
# [9] "Schedule not obtained"             "Not applicable"                    "Hazardous / harmful (over 14)"    
# 
# $dsh5
# [1] "No"                      "Schedule not applicable" "Item not applicable"     "Yes"                     "Don't know"              "Don't Know"             
# [7] "Refusal"                 "item not applicable"     "refused"                 "Refused"                 NA                       
# 
# $dsh5sc
# [1] "Item not applicable"     "No"                      "Schedule not obtained"   "Yes"                     "Not applicable"          "Refusal"                
# [7] "Schedule not applicable" "Refused"                
# 
# $dvg11
# [1] "0"                       "Schedule not applicable" "Item not applicable"     "3"                       "1"                       "2"                      
# [7] "4"                      
# 
# $dvj12
# [1] "0"                       "Schedule not applicable" "Item not applicable"     "1"                       "4"                       "2"                      
# [7] "3"                      
# 
# $final_sex22
# [1] "Male"              "Female"            "Refused"           "Prefer not to say"
# 
# $genhelf2 # (used on dashboard)
# [1] "Very good/good"    "Fair"              "Bad/very bad"      "No answer/refused" "Don't know"        "Refused"           "refused"          
# [8] "don't know"        "Refusal"           "Dont know"         NA                  "Don't Know"        "Not answered"      "Very good / good" 
# [15] "Bad / very bad"   
# 
# $gh_qg2
# [1] "Score 1-3"               "Schedule not applicable" "Score 0"                 "Score 4+"                "Schedule not obtained"   "Refused"                
# [7] "schedule not applicable" "refused"                 "schedule not obtained"   "Refusal"                 "Refused/not answered"    NA                       
# [13] "Don't know"              "Not applicable"         
# 
# $ghq2
# [1] "0"                     "1-3"                   "4 or more"             "Schedule not obtained" "Not answered"         
# 
# $ghqg2
# [1] "Score 0"                 "Score 1-3"               "not applicable"          "Score 4+"                "schedule not obtained"   "Schedule not applicable"
# [7] "No answer/refused"     "Schedule not obtained"   "Refused"                 "Don't know"              "Item not applicable" 
# 
# $hb_code
# [1] NA                            "Forth Valley"                "Fife"                        "Western Isles"               "Greater Glasgow and Clyde"  
# [6] "Grampian"                    "Lothian"                     "Ayrshire and Arran"          "Lanarkshire"                 "Tayside"                    
# [11] "Dumfries and Galloway"       "Highland"                    "Shetland"                    "Borders"                     "Orkney"                     
# [16] "SJ9 Greater Glasgow & Clyde" "SW9 Western Isles"           "SR9 Orkney"                  "ST9 Tayside"                 "SK9 Highland"               
# [21] "SA9 Ayrshire & Arran"        "SS9 Lothian"                 "SY9 Dumfries & Galloway"     "SV9 Forth Valley"            "SF9 Fife"                   
# [26] "SN9 Grampian"                "SL9 Lanarkshire"             "SZ9 Shetland"                "SB9 Borders"                 "10"                         
# [31] "7"                           "9"                           "11"                          "5"                           "2"                          
# [36] "3"                           "12"                          "8"                           "13"                          "6"                          
# [41] "1"                           "4"                           "14"                         
# 
# $hbcode
# [1] "Forth Valley"              "Fife"                      "Western Isles"             "Greater Glasgow"           "Grampian"                 
# [6] "Lothian"                   "Ayrshire and Arran"        "Lanarkshire"               "Tayside"                   "Dumfries and Galloway"    
# [11] "Highland"                  "Shetland"                  "Borders"                   "Orkney"                    NA                         
# [16] "7"                         "10"                        "5"                         "9"                         "12"                       
# [21] "4"                         "2"                         "1"                         "6"                         "3"                        
# [26] "13"                        "8"                         "14"                        "11"                        "Greater Glasgow and Clyde"
# 
# $hlth_brd
# [1] "Fife"                    "Forth Valley"            "Lothian"                 "Borders"                 "Orkney"                  "Greater Glasgow & Clyde"
# [7] "Tayside"                 "Grampian"                "Ayrshire & Arran"        "Western Isles"           "Highland"                "Lanarkshire"            
# [13] "Dumfries & Galloway"     "Shetland"                "Greater"                 "Ayrshire and Arran"      "Dumfries and Galloway"  
# 
# $hlthbrd
# [1] "Lothian"                 "Lanark"                  "Forth Valley"            "Fife"                    "Ayrshire & Arran"        "Glasgow"                
# [7] "Argyll & Clyde"          "Highland & Islands"      "D & G"                   "Grampian"                "Tayside"                 "Borders"                
# [13] "Highland"                "Greater Glasgow"         "Lanarkshire"             "Shetland"                "Dumfries & Galloway"     "Western Isles"          
# [19] "Orkney"                  "Greater Glasgow & Clyde" NA                        "Greater"                 "Ayrshire and Arran"      "Dumfries and Galloway"  
# 
# $involv19
# [1] "Not applicable"          "A fair amount"           "Not very much"           "Schedule not applicable" "A great deal"            "Not at all"             
# [7] "Schedule not obtained"   "Refused"                 "Don't know"             
# 
# $involve
# [1] "Not very much"           "schedule not applicable" "A great deal"            "A fair amount"           "Not at all"              "refused"                
# [7] "item not applicable"     "don't know"              NA                        "Schedule not applicable" "Refusal"                 "Item not applicable"    
# [13] "Dont know"               "Don't Know"              "Don't know"              "Refused"                 "Not applicable"         
# 
# $la_code
# [1] "West Lothian"          "Glasgow City"          "North Lanarkshire"     "Orkney Islands"        "Falkirk"               "Scottish Borders"     
# [7] "Stirling"              "West Dunbartonshire"   "Dumfries and Galloway" "East Lothian"          "South Lanarkshire"     "Clackmannanshire"     
# [13] "Midlothian"            "Edinburgh City"        "Shetland Islands"      "Highland"              "Angus"                 "Argyll and Bute"      
# [19] "Inverclyde"            "Dundee City"           "Perth and Kinross"     "Renfrewshire"          "Aberdeenshire"         "East Ayrshire"        
# [25] "East Renfrewshire"     "North Ayrshire"        "Fife"                  "South Ayrshire"        "Aberdeen City"         "East Dunbartonshire"  
# [31] "Na h-Eileanan Siar"    "Moray"                
# 
# $lifesat2
# [1] "above the mode (9-10)"   "mode (8)"                "below the mode (0 to 7)" "Schedule not applicable" "Don't know"             
# [6] "Refusal"                 NA                        "Refused/not answered"    "Dont know"               "Item not applicable"    
# [11] "Refused"                 "Not applicable"          "Above the mode (9-10)"   "Mode (8)"                "Below the mode (0 to 7)"
# 
# $limitill
# [1] "No LI"           "Non limiting LI" "Limiting LI"     "Don't know"      "Refused"         "refused"         "don't know"      "Refusal"         "Don't Know"     
# [10] "-9"              NA                "Dont know"       "Not answered"   "No answer/refused" NA
# 
# $mus_rec
# [1] "Yes"                     "Schedule not applicable" "No"                     
# 
# $musrec
# [1] "No"                      "Schedule not applicable" "Yes"   
# 
# $number_of_recalls
# [1] "2"              "Not applicable" "1"           
# 
# $numberofrecalls
# [1] "Item not applicable" "2"                   "1"                  
# 
# $olim_l_wb
# [1] "From 0 up to and including  M8,F6"                             "Schedule not applicable"                                      
# [3] "Over M8,F6"                                                    "Refusal"                                                      
# [5] "Item not applicable"                                           "Dont know"                                                    
# [7] "Schedule not obtained"                                         "Don't know"                                                   
# [9] "Refused/not answered"                                          NA                                                             
# [11] "Refused"                                                       "Not applicable"                                               
# [13] "From 0 up to and including 8 units for men, 6 units for women" "Over 8 units for men, 6 units for women"                      
# 
# $olimlwb
# [1] "From 0 up to and including 8 units for men, 6 units for women" "Schedule not applicable"                                      
# [3] "Schedule not obtained"                                         "Over 8 units for men, 6 units for women"                      
# [5] "Don't know"                                                    "Item not applicable"                                          
# [7] "Refused"    
# 
# $p_crisis
# [1] "12"                      "schedule not applicable" "4"                       "10"                      "5"                       "6"                      
# [7] "7"                       "2"                       "15"                      "1"                       "8"                       "3"                      
# [13] "14"                      "0"                       "refused"                 "9"                       "item not applicable"     "don't know"             
# [19] "11"                      "13"                      NA                        "Schedule not applicable" "Refusal"                 "Item not applicable"    
# [25] "Dont know"               "not applicable"          "Don't Know"              "Don't know"              "Not applicable"          "Refused"                
# 
# $pcris19
# [1] "Not applicable"          "7"                       "5"                       "Schedule not applicable" "4"                       "3"                      
# [7] "10"                      "6"                       "20"                      "8"                       "Schedule not obtained"   "1"                      
# [13] "Refused"                 "12"                      "16"                      "2"                       "0"                       "11"                     
# [19] "35"                      "30"                      "15"                      "14"                      "9"                       "13"                     
# [25] "40"                      "32"                      "18"                      "25"                      "415"                     "50"                     
# [31] "70"                      "100"                     "23"                      "28"                      "410"                     "24"                     
# [37] "19"                      "22"                      "Don't know"              "200"                     "17"                      "29"                     
# [43] "49"                      "73"                      "37"                      "Item not applicable"     "21"                      "36"                             
# 
# $porftvg3
# [1] "5 portions or more"      "Less than 5 portions"    "None"                    "Schedule not applicable" "Refused"                 "schedule not applicable"
# [7] "refused"                 "Refusal"                 "Refused/not answered"    NA                       
# 
# $porftvg3intake
# [1] "5 portions or more"          "0.5 to less than 5 portions" "Not applicable"              "None/less than 0.5"    "Item not applicable"       
# 
# $rg15a_new
# [1] "Item not applicable"     "No"                      "Schedule not applicable" "Yes"                     "Don't Know"              "Not applicable"         
# [7] "Don't know"              "Refused"                 "Refusal"                
# 
# $rg15anew
# [1] "No"                      "Schedule not applicable" "Yes"                     "Refused"                 "Item not applicable"    
# 
# $rg17a_new
# [1] "Item not applicable"                    "Schedule not applicable"                "Up to 4 hours a week"                   "5 - 19 hours a week"                   
# [5] "50 or more hours a week"                "20 - 34 hours a week"                   "Varies (spontaneous - not on showcard)" "35 - 49 hours a week"                  
# [9] "Not applicable"                         "Don't Know"                             "Varies"                                 "Don't know"                            
# 
# $rg17anew
# [1] "Item not applicable"                    "Schedule not applicable"                "5 - 19 hours a week"                    "35 - 49 hours a week"                  
# [5] "20 - 34 hours a week"                   "50 or more hours a week"                "Up to 4 hours a week"                   "Varies (Spontaneous - not on showcard)"
# [9] "Don't know"                          
#
# $sdq_cong
# [1] "Schedule not applicable" "0-2"                     "4-10"                    "3"                       "No answer/refused"       "Schedule not obtained"  
# [7] "Refused"                 "schedule not applicable" "schedule not obtained"   "Refusal"                 "Refused/not answered"    NA                       
# [13] "Not applicable"          "4-5"                     "Item not applicable"     "6-10"                   
# 
# $sdq_emog
# [1] "Schedule not applicable" "0-3"                     "5-10"                    "4"                       "No answer/refused"       "Schedule not obtained"  
# [7] "Refused"                 "schedule not applicable" "schedule not obtained"   "Refusal"                 "Refused/not answered"    NA                       
# [13] "Not applicable"          "5-6"                     "7-10"                    "Item not applicable"    
# 
# $sdq_hypg
# [1] "Schedule not applicable" "0-5"                     "7-10"                    "6"                       "No answer/refused"       "Schedule not obtained"  
# [7] "Refused"                 "schedule not applicable" "schedule not obtained"   "Refusal"                 "Refused/not answered"    NA                       
# [13] "Not applicable"          "6-7"                     "8"                       "Item not applicable"     "9-10"                   
# 
# $sdq_peeg
# [1] "Schedule not applicable" "0-2"                     "4-10"                    "3"                       "No answer/refused"       "Schedule not obtained"  
# [7] "Refused"                 "schedule not applicable" "schedule not obtained"   "Refusal"                 "Refused/not answered"    NA                       
# [13] "Not applicable"          "Item not applicable"     "4"                       "5-10"                   
# 
# $sdq_pro
# [1] "Schedule not applicable" "10"                      "9"                       "2"                       "4"                       "8"                      
# [7] "5"                       "7"                       "6"                       "8.75"                    "1"                       "6.25"                   
# [13] "No answer/refused"       "7.5"                     "3"                       "1.25"                    "8.33333333333333"        "Schedule not obtained"  
# [19] "0"                       "Refused"                 "3.75"                    "1.66666666666667"        "schedule not applicable" "schedule not obtained"  
# [25] "2.5"                     "Refusal"                 "Refused/not answered"    NA                        "6.66666666666667"        "Not applicable"         
# [31] "Item not applicable"    
# 
# $sdq_totg
# [1] "Schedule not applicable" "0-13"                    "17-40"                   "14-16"                   "No answer/refused"       "Schedule not obtained"  
# [7] "Refused"                 "schedule not applicable" "schedule not obtained"   NA                        "Not applicable"          "17-19"                  
# [13] "Item not applicable"     "20-40"                  
# 
# $sex
# [1] "Male"              "Female"            NA                  "Refused"           "Prefer not to say"
# 
# $simd16_s_ga
# [1] "Most deprived"  "4"              "3"              "2"              "Least deprived" "Not applicable"
# 
# $simd20_r_pa
# [1] "4th"            "3rd"            "Most deprived"  "2nd"            "Least deprived"
# 
# $simd20_s_ga
# [1] "4"              "3"              "Most deprived"  "2"              "Least deprived"
# 
# $simd20_sga
# [1] "4"              "3"              "Most deprived"  "2"              "Least deprived"
# 
# $simd5_s_ga
# [1] "3rd"                   "2nd"                   " 5th - least deprived" "4th"                   "1st - most deprived"   "3"                    
# [7] "2"                     "Least deprived"        "4"                     "Most deprived"         "most deprived"         "least deprived"       
# [13] "Not applicable"       
# 
# $simd5_sg
# [1] "3rd"                  "5th - least deprived" "2nd"                  "4th"                  "1st - most deprived"  NA                     "3"                   
# [8] "4"                    "1"                    "2"                    "5"                   
# 
# $spt1ch
# [1] "not applicable"          "No"                      "Yes"                     "Schedule not applicable" "Don't know"             
# [6] "No answer/refused"       "Refused"                 "schedule not applicable" "refused"                 "don't know"             
# [11] "Don't Know"              "Refusal"                 NA                        "Dont know"               "Item not applicable"    
# 
# $str_work2
# [1] "schedule not applicable"       "moderately stressful"          "not at all/mildly stressful"   "don't know"                    "very/extremely stressful"     
# [6] "refused"                       NA                              "Item not applicable"           "Schedule not applicable"       "Refusal"                      
# [11] "Don't know"                    "Moderately stressful"          "Very/extremely stressful"      "Not at all/mildly stressful"   "Refused"                      
# [16] "Not at all / Mildly stressful" "Very / Extremely stressful"    "Not applicable"                "Not at all / mildly stressful" "Very / extremely stressful"   
# 
# $strwork2
# [1] "Moderately stressful"          "Schedule not applicable"       "Not at all / mildly stressful" "Very / extremely stressful"   
# [5] "Item not applicable"           "Refused"                       "Don't know"                    "Not applicable"               
# 
# $suicide2
# [1] "No"                                      "Schedule not applicable"                 "Item not applicable"                    
# [4] "Yes longer than year"                    "-5"                                      "Yes in last year (inc last week)"       
# [7] "schedule not applicable"                 "item not applicable"                     "refused"                                
# [10] "Don't know"                              "Refusal"                                 "Dont know"                              
# [13] NA                                        "Not applicable"                          "Refused"                                
# [16] "Yes in last year (including last week)"  "Never"                                   "Yes, in last year (including last week)"
# [19] "Yes, longer than year"                   "Schedule not obtained"                  "Yes, in last year (including last week or month)"              
# 
# $support1
# [1] "schedule not applicable" "Tend to agree"           "Tend to disagree"        "Not_Apply"               "Strongly agree"          "Neutral"                
# [7] "don't know"              "Strongly disagree"       "refused"                 NA                        "Item not applicable"     "Schedule not applicable"
# [13] "Dont know"               "Don't Know"              "Don't know"              "Refusal"                 "Does not apply"          "Refused"                
# [19] "Not applicable"         
# 
# $support1_19
# [1] "Not applicable"          "Schedule not applicable" "Tend to agree"           "Strongly agree"          "Tend to disagree"        "Strongly disagree"      
# [7] "Neutral"                 "Does not apply"          "CAPI routing error"      "Refused"                 "Don't know"              "Item not applicable"    
# [13] "Not_Apply"               "Don't Know"              "Refusal"                  
# 
# $urbrur2a
# [1] "Urban"          "Rural"          "Not applicable"
# 
# $urbrur2a_16
# [1] "Not applicable" "Rural"          "Urban"         
# 
# $urbrur2a_20
# [1] "Not applicable" "Rural"          "Urban"         
# 
# $urindsc2
# [1] "Urban" "Rural"
# 
# $wemwbs
# [1] "39"                      "Schedule not applicable" "50"                      "57"                      "41"                      "56"                     
# [7] "53"                      "58"                      "33"                      "46"                      "59"                      "54"                     
# [13] "52"                      "42"                      "49"                      "35"                      "60"                      "51"                     
# [19] "Refused"                 "63"                      "45"                      "31"                      "48"                      "38"                     
# [25] "30"                      "20"                      "66"                      "43"                      "47"                      "62"                     
# [31] "28"                      "40"                      "Schedule not obtained"   "44"                      "55"                      "68"                     
# [37] "65"                      "64"                      "25"                      "32"                      "36"                      "37"                     
# [43] "26"                      "34"                      "70"                      "17"                      "27"                      "61"                     
# [49] "67"                      "22"                      "69"                      "16"                      "24"                      "29"                     
# [55] "23"                      "14"                      "18"                      "21"                      "19"                      "15"                     
# [61] "schedule not applicable" "refused"                 "Refusal"                 NA                        "Don't know"              "Not applicable"         
# 
# $work_bal
# [1] "schedule not applicable"    "6"                          "5"                          "8"                          "10 - Extremely satisfied"  
# [6] "7"                          "don't know"                 "4"                          "3"                          "2"                         
# [11] "0 - Extremely dissatisfied" "9"                          "1"                          "refused"                    NA                          
# [16] "Item not applicable"        "Schedule not applicable"    "Dont know"                  "Don't Know"                 "Refusal"                   
# [21] "Don't know"                 "Refused"                    "Not applicable"   
#
# $wrfood
# [1] "Schedule not applicable" "No"                      "Yes"                     "Refusal"                 "Refused"                
# [6] "Schedule not obtained"   "Not applicable"          "Don't know"              NA                        "Item not applicable"    




