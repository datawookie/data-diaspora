library(rvest)
library(dplyr)
library(janitor)
library(readr)
library(here)

# Extracta data for this figure: http://cdn.static-economist.com/sites/default/files/imagecache/1872-width/20170415_WOC921.png.
#
# Associated paper: https://doi.org/10.1016/S0140-6736(17)30819-X.

html <- read_html("https://www.thelancet.com/action/showFullTableHTML?isHtml=true&tableId=tbl1&pii=S0140-6736%2817%2930819-X")

html %>%
  html_table() %>%
  .[[1]] %>%
  clean_names() %>%
  # Add missing column name.
  rename(country = x) %>%
  # Fix ugly column names.
  rename_at(
    vars(starts_with("x2015")),
    ~ paste(sub("^x2015_", "", .), "2015", sep = "_")
  ) %>%
  # Replace decimal separator.
  mutate_all(~ gsub("·", ".", .)) %>%
  # Replace funky hyphen.
  mutate_all(~ gsub("−", "-", .)) %>%
  write_csv2(here("smoking-prevalence-lancet.csv"))
