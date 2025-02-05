
# ============================================
# ===== Setting the variables to extract =====
# ============================================

# Annual Population Survey

vars_to_keep <- c(
  
  # splits
  "country",  # Country (ISO numeric international country code (incl regions for UK))
  "age", #11, 13 or 15 y olds (P7, S2, S4)

  # not sure which of these are most usable: will check
  "gender", # Gender Binary -are you a boy or a girl?
  "gender_p", # Gender (Primary 7)
  "gender_binary_s", # Gender_binary (Secondary 2 & Secondary 4)
  "genderid_s", # Gender identity (Secondary 2 & Secondary 4)
  "sexbirth_s", # registered sex at birth
  
  "simd2012_quintile_pupil", # Pupil postcode SIMD 2012 quintile (2014 only)
  
  #weight
  "dataset_weight",
  
  # Sleep quality	                            30113	Mean score for P7, S2 and S4 pupils on the Adolescent Sleep Wake Scale 
  "sleep_diff", "sleepdifficulty", # Subjective Health Complaint scale - sleepdifficulty frequency in last 6 months
  
  # Limiting long-standing physical condition	30115	Percentage of P7, S2 and S4 pupils reporting an illness, disability or medical condition that affects their attendance or participation in school.
  "lt_ill_dis", # Long-term illness or disability diagnosed by a doctor (2022 only)
  
  # Acceptance by classmates	                30137	Percentage of P7, S2 and S4 pupils who strongly agree or agree that other pupils accept them as they are
  "pupils_accept", "studaccept", # Students accept me as I am
  
  # Liking school 	                          30141	Percentage of P7, S2 and S4 pupils who like school a lot or a bit at present 
  "like_school", #2014 only
  "likeschool", # "School satisfaction" in 2018 and 2022
  
  # Relationship with teachers	              30142	Percentage of P5-S6 pupils who strongly agree or agree that their teachers treat them fairly
  # options: teacher support scale (3 statements), trust in teachers, teachers care, teachers accept me
  "d_teacher_support", "d_teacher_support_binary", # maybe??? Binary = 10+
  
  # Experience of discrimination from adults	30163	Percentage of P7, S2 and S4 pupils reporting that they are very often or often treated unfairly because of their ethnicity, sex or socioeconomic status, by teachers or other adults.
  # nothing???
  
  # possible additions (filling in gaps left by HWB Census):
  ##########################################################
  # mental wellbeing
  "d_who5", # combined WHO-5 score (mental wellbeing, 5 items, but 2022 only): https://data-browser.hbsc.org/measure/who-5-well-being-index/
  # life satisfaction
  "lifesat", "life_satisfaction", # was meant to be obtained from HWBCensus
  # self-rated health (all)
  "self_rated_health",
  # feeling lonely (12 mths) (2022)
  "lonely",
  # cyberbullying: being bullied (2018, 2022)
  "cbeenbullied",
  # bullying: being bullied (2022)
  "beenbullied", "bully_victim",
  # mvpa 60 min + yday (all years)
  "physact60", "mvpa", # check same defn
  # body image (all years) % who think they are too fat
  "thinkbody", "thinkbody_1",
  # problematic social media usage (2018 and 2022)
  "d_emc_problem", #6+ problems reported
  # pressure of schoolwork (all years)
  "schoolwork_pressure", "schoolpressure",
  # high perceived family support (all years) 
  "d_family_support", "d_family_support_binary",
  # high perceived peer social support (all years) (this could be double counting as "pupils accept me" might be part of this scale)
  "d_peer_support", "d_peer_support_binary",
  # ease of comms with father (all years)
  "talkfather", "talk_father",
  # ease of comms with mother (all years)
  "talkmother", "talk_mother"
  
)


## END





