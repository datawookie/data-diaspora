library(rvest)
library(janitor)
library(dplyr)
library(stringr)
library(readr)

FILE = "country-summary.csv"
URL = "https://www.geonames.org/countries/"

html <- read_html(URL)

countries <- html %>% html_table() %>% .[[2]]

countries <- countries %>%
  clean_names %>%
  rename(
    iso_alpha2 = iso_3166alpha2,
    iso_alpha3 = iso_3166alpha3,
    iso_numeric = iso_3166numeric,
    area = area_in_km
  ) %>%
  select(-capital) %>%
  mutate(
    iso_numeric = sprintf("%03d", iso_numeric),
    continent = ifelse(is.na(continent), "NA", continent),
    area = area %>% str_replace_all(",", "") %>% as.integer(),
    population = population %>% str_replace_all(",", "") %>% as.integer()
  )

cat("# Data from ", URL, ".\n#\n# area - km^2\n#\n", sep = "", file = FILE)
write_csv(countries, FILE, append = TRUE, col_names = TRUE, na = "")
