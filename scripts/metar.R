library(dplyr)
library(tidyr)
library(stringr)

tair <- read.csv("Tair.csv")
icao <- read.csv("ICAO.csv")

missing <- tair %>%
  select(-time) %>%
  gather(airport, temperature) %>%
  group_by(airport) %>%
  summarise(
    nan_count = is.nan(temperature) %>% sum()
  ) %>%
  arrange(nan_count)

complete <- missing %>% filter(nan_count == 0) %>% pull(airport)

icao <- icao %>%
  filter(icao %in% complete) %>%
  mutate(
    name = str_squish(name)
  )
tair <- tair %>%
  select_at(c("time", complete))

write.csv(tair, "metar-air-temperature.csv", quote = FALSE, row.names = FALSE)
write.csv(icao, "metar-airports.csv", quote = FALSE, row.names = FALSE)
