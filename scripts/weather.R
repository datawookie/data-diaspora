library(dplyr)
library(tidyr)

temperature <- read.csv("temperature.csv")
humidity <- read.csv("humidity.csv")
pressure <- read.csv("pressure.csv")
wind_speed <- read.csv("wind_speed.csv")
wind_direction <- read.csv("wind_direction.csv")

temperature <- temperature %>%
  gather(city, temperature, -datetime)
humidity <- humidity %>%
  gather(city, humidity, -datetime)
pressure <- pressure %>%
  gather(city, pressure, -datetime)
wind_speed <- wind_speed %>%
  gather(city, wind_speed, -datetime)
wind_direction <- wind_direction %>%
  gather(city, wind_direction, -datetime)

weather <- temperature %>%
  left_join(humidity) %>%
  left_join(pressure) %>%
  left_join(wind_speed) %>%
  left_join(wind_direction)

write.csv(weather, "weather.csv", quote = FALSE, row.names = FALSE)
