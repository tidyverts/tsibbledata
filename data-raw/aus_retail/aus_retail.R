library(tidyverse)
library(readxl)
library(tsibble)

series <- read_excel("data-raw/aus_retail/8501011.xlsx", sheet = 2, skip = 9) %>%
  rename(Month = `Series ID`) %>%
  gather(`Series ID`, Turnover, -Month) %>%
  mutate(Month = yearmonth(Month))
dict <- read_excel("data-raw/aus_retail/8501011.xlsx", sheet = 1, skip = 9) %>%
  filter(`Series Type` == "Original") %>%
  separate(`Data Item Description`, c("Category", "State", "Industry"), sep = ";", extra = "drop") %>%
  transmute(
    State = trimws(State),
    Industry = trimws(Industry),
    `Series ID`) %>%
  filter(
    Industry  != "Total (Industry)",
    State != "Total (State)")

aus_retail <- left_join(dict, series, by = "Series ID") %>%
  filter(!is.na(Turnover)) %>%
  as_tsibble(key = c(State, Industry), index = Month)

usethis::use_data(aus_retail, overwrite = TRUE)
