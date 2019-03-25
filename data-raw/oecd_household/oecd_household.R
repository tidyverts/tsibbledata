library(tidyverse)
library(tsibble)
library(fable)

hh_budget <- list.files("data-raw/oecd_household/", pattern = ".csv", full.names = TRUE) %>%
  map_dfr(read_csv) %>%
  filter(!is.na(TIME)) %>%
  filter(SUBJECT %in% c("TOT", "NET")) %>%
  filter(MEASURE %in% c("AGRWTH", "PC_HHDI", "PC_NDI", "PC_LF")) %>%
  transmute(Country = LOCATION, Year = TIME, INDICATOR, Value) %>%
  spread(INDICATOR, Value) %>%
  filter(Country %in% c("AUS", "JPN", "CAN", "USA")) %>%
  mutate(Country = recode(Country, AUS = "Australia", JPN = "Japan",
                           CAN = "Canada")) %>%
  filter(between(Year, 1995, 2016)) %>%
  rename(Debt = HHDEBT, DI = HHDI, Expenditure = HHEXP,
         Savings = HHSAV, Wealth = HHWEALTH, Unemployment = UNEMP) %>%
  as_tsibble(key = id(Country), index = Year)

usethis::use_data(hh_budget, overwrite=TRUE)
