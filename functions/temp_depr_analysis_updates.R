# Amended functions from indicator prep repo PR#97: 
# File can be deleted once that is merged into main

analyze_deprivation_aggregated <- function(filename, # the prepared data, without _raw.rds suffix
                                           pop, # what population file to use for denominators
                                           ind_id, # the ind_id
                                           ind_name, # the indicator name (abbreviated, for output file) 
                                           qa = FALSE) {
  
  ###############################################.
  ## Read in data----
  ###############################################.
  
  # read in raw data. 
  data_depr <- readRDS(paste0(data_folder, "Prepared Data/" ,filename, "_raw.rds")) %>% 
    mutate(year = as.numeric(year)) %>% 
    filter(ind_id == ind_id) 
  
  yearstart = min(data_depr$year)
  yearend = max(data_depr$year)
  
  # Are the deprivation data grouped by sex? If so this needs to be accounted for in these calculations.
  sex_column <- "sex" %in% names(data_depr) # gives TRUE or FALSE
  
  # What geogs are in the data?
  codes <- unique(data_depr$code)
  
  ###############################################.
  ## Matching with population lookup----
  ###############################################.
  
  if (sex_column == FALSE) {
    
    # Matching with population lookup (denominator required for SIMD analysis)
    pop_depr_lookup <- readRDS(paste0(lookups, "Population/", pop,'.rds')) %>% 
      subset(year >= yearstart & year <= yearend) #Reading population file and selecting the right year range
    
    # Matching population with data
    data_depr <- right_join(x=data_depr, y=pop_depr_lookup, 
                            by = c("year", "code", "quintile", "quint_type")) %>%
      filter(code %in% codes) 
    
  } else if (sex_column == TRUE) {
    
    # Matching with population lookup (denominator required for SIMD analysis)
    pop_depr_lookup <- readRDS(paste0(lookups, "Population/", pop,'_SR.rds')) %>% 
      subset(year >= yearstart & year <= yearend) %>% #Reading population file and selecting the right year range
      group_by(year, code, sex_grp, quintile, quint_type) %>%
      summarise(denominator = sum(denominator)) %>%
      ungroup() %>%
      rename(sex = sex_grp) %>%
      mutate(sex = case_when(sex==1 ~ "Male",
                             sex==2 ~ "Female"))
    pop_depr_lookup_totals <- pop_depr_lookup %>%
      group_by(year, code, quintile, quint_type) %>%
      summarise(denominator = sum(denominator)) %>%
      ungroup() %>%
      mutate(sex = "Total")
    pop_depr_lookup <- rbind(pop_depr_lookup,
                             pop_depr_lookup_totals)  
    
    # Matching population with data
    data_depr <- right_join(x=data_depr, y=pop_depr_lookup, 
                            by = c("year", "code", "quintile", "quint_type", "sex")) %>%
      filter(code %in% codes) 
    
  }
  
  #selecting only years of interest
  data_depr <- data_depr %>% subset(year >= yearstart & year <= yearend) %>%
    filter(!is.na(rate)) # some data biennial, so need this fix
  
  data_depr$numerator[is.na(data_depr$numerator)] <- 0 # Converting NAs to 0s
  
  ##################################################.
  ##  Create SII and RII ----
  ##################################################.
  
  #call function to generate measures of inequality 
  data_depr <- data_depr %>% inequality_measures()
  
  saveRDS(data_depr, paste0(data_folder, "Temporary/", ind_name, "_final.rds"))
  
  #Preparing data for Shiny tool
  data_shiny <- data_depr %>% 
    select(-c(overall_rate, total_pop, proportion_pop, most_rate, 
              least_rate, par_rr, count))
  
  #Saving file
  saveRDS(data_shiny, file = paste0(data_folder, "Data to be checked/", ind_name, "_ineq.rds"))
  
  #Making final dataset available outside the function
  final_result <<- data_shiny
  
  ##################################################.
  ##  Checking results ----
  ##################################################.
  
  if (qa == FALSE) { #if you don't want to run full data quality checks set qa=false then only scotland chart will be produced
    #Selecting Health boards and Scotland for latest year in dataset
    if (sex_column==TRUE) {
      
      ggplot(data=(data_shiny %>% subset((substr(code, 1, 3)=="S08" | code=="S00000001") 
                                         & year==max(year) & quintile == "Total" & quint_type == "sc_quin")), 
             aes(code, rate) ) +
        geom_point(stat = "identity") +
        geom_errorbar(aes(ymax=upci, ymin=lowci), width=0.5) +
        facet_wrap(~sex)
      
    } else {
      
      ggplot(data=(data_shiny %>% subset((substr(code, 1, 3)=="S08" | code=="S00000001") 
                                         & year==max(year) & quintile == "Total" & quint_type == "sc_quin")), 
             aes(code, rate) ) +
        geom_point(stat = "identity") +
        geom_errorbar(aes(ymax=upci, ymin=lowci), width=0.5)
      
    }
    
  } else  { # if qa set to true (default behaviour) then inequalities rmd report will run
    
    run_ineq_qa(filename={{filename}}
    )} 
  
}



##################################################.
## Inequality measures function ---- 
## generating SII, RII, PAF and Ranges.
## this function separate from main body of function as life expectancy 
#   inequality indicators only require this part
##################################################.

inequality_measures <- function(dataset){
  
  # Are the deprivation data grouped by sex? If so this needs to be accounted for in these calculations.
  
  if ("sex" %in% names(dataset)) {
    
    group_args <- c("code", "year", "quint_type", "sex")
    
  } else {
    
    group_args <- c("code", "year", "quint_type")
    
  }
  
  #################################################.
  ##  SII/RII  ----
  ##################################################.
  
  #Splitting into two files: one with quintiles for SII and one without to keep the total values
  data_depr_sii <- dataset %>% group_by(pick(all_of(group_args))) %>% 
    mutate(overall_rate = rate[quintile == "Total"]) %>% 
    filter(quintile != "Total") %>% 
    #This variables are used for SII, RII and PAR calculation
    mutate(total_pop = sum(denominator), # calculate the total population for each area (without SIMD).
           proportion_pop = denominator/total_pop) %>% # proportion of the population in each SIMD out of the total population. )
    ungroup()
  
  data_depr_totals <- dataset %>% filter(quintile == "Total")
  
  ###############################################.
  # Calculate the regression coefficient
  #Formula from: https://www.scotpho.org.uk/comparative-health/health-inequalities-tools/archive/triple-i-and-hits/
  #https://pdfs.semanticscholar.org/14e0/c5ba25a4fdc87953771a91ec2f7214b2f00d.pdf
  #The dataframe sii_model will have a column for sii, lower ci and upper ci for each
  # geography, year and quintile type
  sii_model <- data_depr_sii %>% group_by(pick(all_of(group_args))) %>% 
    #Checking that all quintiles are present, if not excluding as we are not showing
    #RII and SII for those. Calculations would need to be adjusted and thought well if we wanted to include them
    mutate(count= n()) %>% filter(count == 5) %>% 
    #This first part is to adjust rate and denominator with the population weights
    mutate(cumulative_pro = cumsum(proportion_pop),  # cumulative proportion population for each area
           relative_rank = case_when(
             quintile == "1" ~ 0.5*proportion_pop,
             quintile != "1" ~ lag(cumulative_pro) + 0.5*proportion_pop),
           sqr_proportion_pop = sqrt(proportion_pop), #square root of the proportion of the population in each SIMD
           relrank_sqr_proppop = relative_rank * sqr_proportion_pop,
           rate_sqr_proppop = sqr_proportion_pop * rate) %>% #rate based on population weights
    nest() %>% #creating one column called data with all the variables not in the grouping
    # Calculating linear regression for all the groups, then formatting the results
    # and calculating the confidence intervals
    mutate(model = map(data, ~ lm(rate_sqr_proppop ~ sqr_proportion_pop + relrank_sqr_proppop + 0, data = .)),
           #extracting sii from model, a bit fiddly but it works
           sii = -1 * as.numeric(map(map(model, "coefficients"), "relrank_sqr_proppop")),
           #     cis = map(model, confint_tidy) # deprecated. next two lines do the same thing
           conf.low = as.numeric(map(model, ~confint(., parm = "relrank_sqr_proppop")[1])),
           conf.high = as.numeric(map(model, ~confint(., parm = "relrank_sqr_proppop")[2]))) %>% #calculating confidence intervals
    ungroup() %>% 
    mutate(lowci_sii = -1 * conf.high, #fixing interpretation
           upci_sii = -1 * conf.low) %>% 
    select(-conf.low, -conf.high, -model, -data) %>% #taking out results as not needed anymore
    mutate_at(c("sii", "lowci_sii", "upci_sii"), ~replace(., is.na(.), NA_real_)) #recoding NAs
  
  
  #Merging sii with main data set
  data_depr <- left_join(data_depr_sii, sii_model, by = group_args)
  
  #Calculating RII
  data_depr <- data_depr %>% mutate(rii = sii / overall_rate,
                                    lowci_rii = lowci_sii / overall_rate,
                                    upci_rii = upci_sii / overall_rate,
                                    #Transforming RII into %. This way is interpreted as "most deprived areas are
                                    # xx% above the average" For example: Cancer mortality rate is around 55% higher 
                                    # in deprived areas relative to the mean rate in the population
                                    rii_int = rii * 0.5 *100,
                                    lowci_rii_int = lowci_rii * 0.5 *100,
                                    upci_rii_int = upci_rii * 0.5 *100)
  
  ##################################################.
  ##  PAF Population attributable risk and range  ----
  ##################################################.
  
  #Calculation PAR
  #Formula here: https://pdfs.semanticscholar.org/14e0/c5ba25a4fdc87953771a91ec2f7214b2f00d.pdf
  # https://fhop.ucsf.edu/sites/fhop.ucsf.edu/files/wysiwyg/pg_apxIIIB.pdf
  #Adding columns for Most and least deprived rates
  most_depr <- data_depr %>% filter(quintile == "1") %>% 
    select(all_of(group_args), rate) %>% rename(most_rate = rate)
  
  least_depr <- data_depr %>% filter(quintile == "5") %>% 
    select(all_of(group_args), rate) %>% rename(least_rate = rate)
  
  data_depr <- left_join(data_depr, most_depr, by = group_args)
  data_depr <- left_join(data_depr, least_depr, by = group_args)
  
  data_depr <- data_depr %>%  group_by(pick(all_of(group_args))) %>%
    mutate(#calculating PAR. PAR of incomplete groups to NA
      #CI calculation missing, this can help https://onlinelibrary.wiley.com/doi/pdf/10.1002/sim.2779
      #https://fhop.ucsf.edu/sites/fhop.ucsf.edu/files/wysiwyg/pg_apxIIIB.pdf
      par_rr = (rate/least_rate - 1) * proportion_pop,
      count= n(),
      par = case_when(count != 5 ~ NA_real_,
                      count == 5 ~ sum(par_rr)/(sum(par_rr) + 1) * 100),
      # Calculate ranges 
      abs_range = most_rate - least_rate,
      rel_range = most_rate / least_rate) %>% ungroup()
  
  #Joining with totals.
  #dataframe with the unique values for the different inequality measures
  data_depr_match <- data_depr %>% 
    select(all_of(group_args), sii, upci_sii, lowci_sii, rii, lowci_rii, upci_rii,
           rii_int, lowci_rii_int, upci_rii_int, par, abs_range, rel_range) %>% 
    unique()
  
  data_depr_totals <- left_join(data_depr_totals, data_depr_match, 
                                by = group_args)
  
  data_depr <- bind_rows(data_depr, data_depr_totals) 
  data_depr <<- data_depr
} #end sii/rii/paf/range function


