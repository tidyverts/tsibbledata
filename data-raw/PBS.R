library(readr)
library(dplyr)
library(tsibble)

ATC1_def <- tribble(
  ~ ATC1, ~ ATC1_desc,
  "A", "Alimentary tract and metabolism",
  "B", "Blood and blood forming organs",
  "C", "Cardiovascular system",
  "D", "Dermatologicals",
  "G", "Genito urinary system and sex hormones",
  "H", "Systemic hormonal preparations, excl. sex hormones and insulins",
  "J", "Antiinfectives for systemic use",
  "L", "Antineoplastic and immunomodulating agents",
  "M", "Musculo-skeletal system",
  "N", "Nervous system",
  "P", "Antiparasitic products, insecticides and repellents",
  "R", "Respiratory system",
  "S", "Sensory organs",
  "V", "Various"
)

PBS <- read_csv("data-raw/PBS.csv", skip = 4) %>%
  rename( # Add missing names
    Concession = X1,
    ATC1 = X2,
    ATC2 = X3
  ) %>%
  mutate( # Identify two datasets before removing data gaps
    dataset = cumsum(is.na(ATC1)),
    dataset = case_when(
      dataset == 1 ~ "Scripts",
      dataset == 8 ~ "Cost",
      TRUE ~ "Junk"
    )
  ) %>%
  filter(!is.na(ATC1)) %>% # Remove gaps in data
  gather("Month", "Value", -Concession, -ATC1, -ATC2, -dataset) %>%
  filter(!is.na(Value)) %>% # Make time periods implicit
  mutate( # Correct object types
    Value = parse_number(Value),
    Month = yearmonth(strptime(paste0("01-", Month), "%d-%b-%y"))
  ) %>%
  spread(dataset, Value) %>% # Organise datasets into columns
  mutate( # Fix codes for ATC1
    ATC2_desc = ATC2,
    ATC2 = ATC1,
    ATC1 = substr(ATC1, 1, 1)
  ) %>%
  left_join(ATC1_def, by = "ATC1") %>%
  filter(!(Cost == 0 & is.na(Scripts))) %>%  # Remove null rows
  mutate(
    Type = ifelse(grepl("NON-", Concession, fixed = TRUE), "Co-payments", "Safety net"),
    Concession = ifelse(grepl("GENERAL", Concession, fixed = TRUE), "General", "Concessional")
  ) %>%
  select( # Specify column order
    Month,
    Concession, Type,
    ATC1, ATC1_desc,
    ATC2, ATC2_desc,
    Scripts, Cost
  ) %>%
  as_tsibble( # Convert to tsibble
    key = id(Concession, Type, ATC1, ATC2),
    index = Month
  )

usethis::use_data(PBS, overwrite=TRUE)
