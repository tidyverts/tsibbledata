library(tidyverse)
library(lubridate)
library(tsibble)
library(readxl)

aus_production <- read_excel("data-raw/aus_production/830101.xls", 2) %>%
  setNames(., paste(colnames(.), .[2,])) %>%
  tail(-9) %>%
  rename(Quarter = `X__1 Series Type`) %>%
  mutate(Quarter = yearquarter(as_date(as.numeric(Quarter), origin = ymd("1900-01-01")))) %>%
  gather("Commodity", "Production", -Quarter) %>%
  separate(Commodity, c("Commodity", "Type"), sep = " ;") %>%
  filter(!is.na(Production), Type == " Original") %>%
  mutate(Production = as.numeric(Production)) %>%
  select(-Type) %>%
  filter(Commodity %in% c(
    "Electricity", "Gas",
    "Portland cement", "Clay bricks",
    "Beer", "Tobacco & cigarettes"
  )) %>%
  spread(Commodity, Production) %>%
  rename(Bricks = `Clay bricks`, Cement = `Portland cement`, Tobacco = `Tobacco & cigarettes`) %>%
  select(Quarter, Beer, Tobacco, Bricks, Cement, Electricity, Gas) %>%
  as_tsibble(index = Quarter)

usethis::use_data(aus_production, overwrite = TRUE)
