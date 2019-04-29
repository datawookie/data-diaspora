# https://data.worldbank.org/indicator/is.air.psgr

library(dplyr)
library(tidyr)
library(stringr)

CSVFILE = "worldbank-air-passengers.csv"
ZIPFILE = "worldbank-air-passengers.zip"
RAWFILE = "API_IS.AIR.PSGR_DS2_en_csv_v2_10576669.csv"

download.file("http://api.worldbank.org/v2/en/indicator/IS.AIR.PSGR?downloadformat=csv", ZIPFILE)

unzip(ZIPFILE, RAWFILE)

passengers <- read.csv(RAWFILE, skip = 4) %>%
  select(-starts_with("Indicator")) %>%
  rename_at(vars(starts_with("Country")), function(col) str_replace(col, "Country\\.", "") %>% str_to_lower()) %>%
  gather(year, count, -name, -code) %>%
  mutate(year = str_replace(year, "^X", "") %>% as.integer()) %>%
  filter(!is.na(year))

write.csv(passengers, CSVFILE, quote = FALSE, row.names = FALSE)

file.remove(RAWFILE, ZIPFILE)
