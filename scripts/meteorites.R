library(rvest)
library(dplyr)
library(tidyr)
library(readr)
library(janitor)

html <- read_html("https://en.wikipedia.org/wiki/Meteorite_fall_statistics")

meteorites_raw <- html %>%
  html_nodes("table.wikitable") %>%
  .[[10]] %>%
  html_table()

meteorites <- meteorites_raw %>%
  select(-Total) %>%
  filter(Epoch != "Total") %>%
  gather(continent, count, -Epoch) %>%
  na.omit() %>%
  clean_names()

write_csv(meteorites, "meteorites.csv")