library(tidyverse)
library(tsibble)

aus_livestock <- readabs::read_abs_local(path = "data-raw/aus_livestock/ABS/") %>%
  filter(series_type == "Original") %>%
  select(series, date, value) %>%
  separate(series, into = c("Series", "Animal", "State", "Empty"), sep = " ;") %>%
  mutate(
    Month = yearmonth(date),
    Animal = str_to_sentence(trimws(Animal)),
    State = trimws(State)
  ) %>%
  filter(State != "Total (State)") %>%
  mutate(
    Animal = factor(Animal),
    State = factor(State)
  ) %>%
  select(Month, everything(), -date, -Series, -Empty) %>%
  rename(Count = value) %>%
  filter(!is.na(Count))

usethis::use_data(aus_livestock, overwrite=TRUE)
