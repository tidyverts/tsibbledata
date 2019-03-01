library(tidyverse)
library(tsibble)
library(readxl)

files <- list.files("data-raw/aus_livestock/", pattern = ".xls", full.names = TRUE)

series <- map_dfr(files, read_excel, sheet = 1, skip = 9) %>%
  filter(!is.na(`Series ID`), `Series Type` == "Original", grepl("Total", `Data Item Description`)) %>%
  separate(`Data Item Description`, c("Series", "Animal", "State"), sep = ";") %>%
  select(Animal, `Series ID`) %>%
  mutate(Animal = ifelse(grepl("Total", Animal), "Chickens", str_to_sentence(trimws(Animal))))

data <- map_dfr(files, read_excel, sheet = 2, skip = 9) %>%
  mutate(Quarter = yearquarter(`Series ID`)) %>%
  gather("Series ID", "Count", -Quarter, -`Series ID`) %>%
  filter(!is.na(Count))

aus_livestock <- left_join(series, data, by = "Series ID") %>%
  transmute(Quarter, Animal, Count = Count * 1000)

usethis::use_data(aus_livestock, overwrite=TRUE)
