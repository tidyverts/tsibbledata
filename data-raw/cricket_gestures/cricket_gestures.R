## code to prepare `cricket_gestures` dataset goes here

library(tidyverse)

list.files("data-raw/cricket_gestures/data/", full.names = TRUE) %>%
  map_dfr(function(path){
  vroom::vroom(path, col_names = FALSE) %>%
    mutate(n = row_number(), sensor = basename(path)) %>%
    pivot_longer(c(-X1, -n, -sensor), names_to = "junk", values_to = "accel") %>%
    select(-junk)
  }) %>%
  group_by(X1, n, sensor) %>%
  mutate(t = row_number()) %>%
  pivot_wider(id_cols = c(X1, n, t),
              names_from = sensor, values_from = accel)

vroom::vroom(c("data-raw/cricket_gestures/Cricket/Cricket_TRAIN.ts",
               "data-raw/cricket_gestures/Cricket/Cricket_TEST.ts"),
             delim = ":", skip = 27,
             col_names = c(paste(rep(c("left", "right"), each = 3), rep(c("X", "Y", "Z"), 2), sep = "_"), "class"),
             col_types = c(col_character(), col_integer()))
# usethis::use_data(cricket_gestures, overwrite = TRUE)
