library(tsibble)
library(readr)
library(dplyr)
library(polite)
library(rvest)
library(purrr)
library(tidyr)
library(lubridate)
library(forcats)

athletics <- bow("https://www.olympic.org/athletics")

lengths <- c("100m", "200m", "400m", "800m", "1500m", "5000m", "10000m")
events <- cross(list(length = lengths,
           sex = c("men", "women"))) %>%
  map_chr(paste, collapse = "-")

parse_athletics <- function(event){
  html <- nod(athletics, paste0("athletics/", event)) %>%
    scrape() %>%
    html_nodes(".event-box")

  years <- html %>%
    html_nodes("h2") %>%
    html_text() %>%
    readr::parse_number()

  results <- html %>%
    html_nodes("table") %>%
    html_table() %>%
    map2_dfr(years, function(data, year){
      data %>%
        separate(Result, c("Medal", "junk", "Time"), sep = "\r\n") %>%
        transmute(Year = year, Medal,
                  Time = strsplit(trimws(Time), ",") %>% map(1),
                  Time = ifelse(grepl(":", Time),
                                as.numeric(ms(Time)),
                                as.numeric(Time))
        )
    })

  results %>%
    mutate(path = event)
}

olympic_running <- map_dfr(events, parse_athletics) %>%
  separate(path, c("Length", "Sex")) %>%
  select(Year, Length, Sex, Medal, Time) %>%
  group_by(Year, Length, Sex) %>%
  summarise(Time = min(Time, na.rm = TRUE)) %>%
  ungroup %>%
  arrange(Year, Length) %>%
  mutate(Length = fct_relevel(Length, lengths)) %>%
  as_tsibble(key = c(Length, Sex), index = Year) %>%
  fill_na()

usethis::use_data(olympic_running, overwrite=TRUE)
