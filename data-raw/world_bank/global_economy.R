library(tidyverse)
library(tsibble)

global_economy <- read_csv("data-raw/world_bank/WDIData.csv") %>%
  filter(`Indicator Code` %in% c("NY.GDP.MKTP.CD", "NY.GDP.MKTP.KD.ZG",
         "SP.POP.TOTL", "NE.EXP.GNFS.ZS", "NE.IMP.GNFS.ZS", "FP.CPI.TOTL")) %>%
  gather("Year", "Value", `1960`:`2018`) %>%
  filter(!is.na(Value)) %>%
  select(-X64, -`Indicator Code`) %>%
  spread(`Indicator Name`, Value) %>%
  mutate(Year = as.numeric(Year)) %>%
  transmute(
    Country = factor(`Country Name`),
    Code = factor(`Country Code`),
    Year = Year,
    GDP = `GDP (current US$)`,
    Growth = `GDP growth (annual %)`,
    CPI = `Consumer price index (2010 = 100)`,
    Imports = `Imports of goods and services (% of GDP)`,
    Exports = `Exports of goods and services (% of GDP)`,
    Population = `Population, total`
  ) %>%
  as_tsibble(key = Country, index = Year)

usethis::use_data(global_economy, overwrite=TRUE)
