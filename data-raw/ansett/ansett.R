library(tidyverse)
library(tsibble)

ansett <- read_lines("data-raw/ansett/WKLYPAXS.DAT") %>%
  gsub("\\s+", " ", .) %>%
  read_delim(" ", col_names = FALSE, col_types = "ncccdddddddddddd") %>%
  filter(!is.na(X4)) %>%
  transmute(
    Week = yearweek(parse_date(X3, format = "%d%m%y")),
    Airports = paste(substr(X4,1,3), substr(X4, 4,6), sep = "-"),
    First = X5,
    Business = X7,
    Economy = X11
  ) %>%
  gather("Class", "Passengers", First, Business, Economy) %>%
  filter(!is.na(Passengers)) %>%
  as_tsibble(key = c(Airports, Class), index = Week)

usethis::use_data(ansett, overwrite=TRUE)
