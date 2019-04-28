library(dplyr)
library(tidyr)

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

icao <- icao %>% filter(icao %in% complete)
tair <- tair %>% select_at(c("time", complete))

write.csv(tair, "metar-air-temperature.csv")
write.csv(icao, "metar-airports.csv")
