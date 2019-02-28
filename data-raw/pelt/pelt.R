library(tsibble)
library(tidyverse)

pelt <- read_csv("data-raw/pelt/lynxhare.csv") %>%
  mutate(Hare = Hare * 1000, Lynx = Lynx * 1000) %>%
  as_tsibble(index = Year)

usethis::use_data(pelt, overwrite=TRUE)
