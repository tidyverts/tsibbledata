library(tidyverse)
library(lubridate)
library(tsibble)

holidays <- list.files("data-raw/vic_elec", pattern = "holidays.txt",
           recursive = TRUE, full.names = TRUE) %>%
  set_names(basename(dirname(.))) %>%
  map_dfr(read_csv, col_names = FALSE, .id = "State") %>%
  transmute(State, Date = as.Date(X1, format = "%d/%m/%Y"), Holiday = TRUE)


# TAS:Hobart, VIC:Melbourne, QLD:Brisbane, NSW:Sydney, SA:Adelaide
temperatures <- list.files("data-raw/vic_elec", pattern = "temperature.csv",
                           recursive = TRUE, full.names = TRUE) %>%
  set_names(basename(dirname(.))) %>%
  map_dfr(read_csv, .id = "State")

demands <- list.files("data-raw/vic_elec", pattern = "demand.csv",
                       recursive = TRUE, full.names = TRUE) %>%
  set_names(basename(dirname(.))) %>%
  map_dfr(read_csv, .id = "State")

vic_elec <- demands %>%
  left_join(temperatures, by = c("State", "Date", "Period")) %>%
  transmute(
    State,
    Time = as.POSIXct(as_date(Date, origin = ymd("1899-12-30")) + minutes(Period * 30)),
    Demand = OperationalLessIndustrial, #+ Industrial,
    Temperature = Temp,
    Date = as_date(Time)
  ) %>%
  left_join(holidays, by = c("State", "Date")) %>%
  mutate(State = recode(State, NSW2015 = "New South Wales", VIC2015 = "Victoria",
                        SA2015 = "South Australia", QLD2015 = "Queensland",
                        TAS2015 = "Tasmania")) %>%
  replace_na(list(Holiday = FALSE)) %>%
  filter(year(Time) %in% 2012:2014, State == "Victoria") %>%
  select(-State) %>%
  as_tsibble(index = Time)

usethis::use_data(vic_elec, overwrite = TRUE)
