library(tsibble)
library(tidyverse)
library(lubridate)

gafa_stock <- list.files("data-raw/gafa_stock", full.names = TRUE, pattern = "*.csv") %>%
  set_names(tools::file_path_sans_ext(basename(.))) %>%
  map_dfr(read_csv, .id = "Symbol") %>%
  rename(Adj_Close = `Adj Close`) %>%
  filter(year(Date) >= 2014, year(Date) <= 2018) %>%
  as_tsibble(key = Symbol, index = Date, regular = FALSE)

usethis::use_data(gafa_stock, overwrite=TRUE)
