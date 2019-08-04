library(dplyr)
library(ggplot2)

set.seed(13)

# Dart board dimensions: http://www.darts501.com/Boards.html

RADIUS_BOARD = 17.0
RADIUS_25 = 3.2 / 2
RADIUS_50 = 1.27 / 2

THROWS <- 1000

SLICES = c(20, 1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5)

throws <- tibble(
  x = rnorm(THROWS, sd = 8) %>% round(2),
  y = rnorm(THROWS, sd = 8) %>% round(2)
) %>%
  mutate(
    phi = (atan2(-x, -y) / pi + 1) * 180,
    slice = (phi + 9) %% 360 %/% 18 + 1,
    r = sqrt(x**2 + y**2),
    score = case_when(
      r <= RADIUS_50 ~ 50,
      r <= RADIUS_25 ~ 25,
      r <= RADIUS_BOARD ~ SLICES[slice],
      TRUE ~ 0
    )
  ) %>%
  select(-phi, -slice, -r)

write.csv(throws, here::here("darts.csv"), quote = FALSE, row.names = FALSE)
