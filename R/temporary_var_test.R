# child - adult ghq

chghq0 <- shes_results0 %>%
  filter(indicator %in% c("cghq214", "ch_ghq")) %>%
 # filter(trend_axis %in% c("2019", "2022", "2023", "2024")) %>%
  unique()
#needs to be unique, as duplicates exist...


ftable(chghq0$trend_axis, chghq0$indicator)
# ok, so the official SHeS one is available 2019, 2022, 2023, 2024
# my version is available in all trend_axes, incl 4y grouped
# how do they compare in 2019-2024?

chghq <- shes_results0 %>%
  filter(indicator %in% c("cghq214", "ch_ghq")) %>%
  filter(trend_axis %in% c("2019", "2022", "2023", "2024")) %>%
  select(indicator, year, sex, code, split_name, split_value, numerator, denominator, rate, lowci, upci) %>%
  unique() %>%
  pivot_longer(cols = c(numerator, denominator, rate, lowci, upci), names_to="metric", values_to = "value") %>%
  pivot_wider(names_from = indicator, values_from = value)
  
ggplot(chghq, aes(x=cghq214, y=ch_ghq)) + 
  geom_point() +
  facet_wrap(~metric, scales="free")
# confirms very good match, with a few outliers. Typically small diffs with small denoms.

ftable(chghq0$code, chghq0$indicator)
# DECISION: KEEP SHES VAR WHERE AVAILABLE

# porftvg
porftvg <- shes_results0 %>%
  filter(indicator %in% c("porftvg3", "porftvg3intake")) %>%
 # filter(trend_axis %in% c("2019", "2022", "2023", "2024")) %>%
  unique()
#needs to be unique, as duplicates exist...
ftable(porftvg$trend_axis, porftvg$indicator)
# ok, so the official SHeS one is available 2019, 2022, 2023, 2024
# my version is available in all trend_axes, incl 4y grouped

