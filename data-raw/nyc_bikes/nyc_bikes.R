library(tidyverse)
library(tsibble)

set.seed(2018)

tmp <- tempfile(fileext = ".csv.zip")
urls <- glue::glue("https://s3.amazonaws.com/tripdata/JC-2018{formatC(1:12, width = 2, flag = '0')}-citibike-tripdata.csv.zip")
nyc_bikes <- map_dfr(urls, function(url){
  download.file(url, tmp)
  read_csv(tmp, locale = locale(tz = "America/New_York"))
})

nyc_bikes <- nyc_bikes %>%
  filter(bikeid %in% sample(unique(bikeid), 10)) %>%
  transmute(
    bike_id = factor(bikeid),
    start_time = starttime,
    stop_time = stoptime,
    start_station = factor(`start station id`),
    start_lat = `start station latitude`,
    start_long = `start station longitude`,
    end_station = factor(`end station id`),
    end_lat = `end station latitude`,
    end_long = `end station longitude`,
    type = factor(usertype),
    birth_year = `birth year`,
    gender = factor(gender, 0:2, c("Unknown", "Male", "Female"))) %>%
  as_tsibble(key = id(bike_id), index = start_time, regular = FALSE)

usethis::use_data(nyc_bikes, overwrite=TRUE)
