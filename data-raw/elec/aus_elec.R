library(tidyverse)
library(lubridate)
library(tsibble)

aus_elec <- list.files("data-raw/elec/", pattern = ".csv", full.names = TRUE) %>%
  set_names(tools::file_path_sans_ext(basename(.))) %>%
  map_dfr(read_csv, .id = "State") %>%
  transmute(
    State,
    Time = as.POSIXct(as_date(Date, origin = ymd("1899-12-30")) + minutes(Period * 30)),
    Demand = OperationalLessIndustrial #+ Industrial
  ) %>%
  filter(year(Time) %in% 2012:2014) %>%
  as_tsibble(key = id(State), index = Time)

usethis::use_data(aus_elec, overwrite = TRUE)
