# Data from http://ms.mcmaster.ca/~bolker/measdata.html.

library(readr)

measles <- read.table("http://ms.mcmaster.ca/~bolker/measdata/ewcitmeas.dat",
                      na = "*",
                      col.names = c(
                        "dd", "mm", "yy", "london", "bristol", "liverpool", "manchester", "newcastle", "birmingham", "sheffield"
                      ))

measles %>%
  mutate(
    date = sprintf("%4d-%02d-%02d", yy + 1900, mm, dd)
  ) %>%
  select(date, everything(), -yy, -mm, -dd) %>%
  write.csv("measles-cities.csv", row.names = FALSE, quote = FALSE)

measles <- read_table("http://ms.mcmaster.ca/~bolker/measdata/ewmeas.dat",
                      col_names = c(
                        "year", "count"
                      ))

measles %>%
  write.csv("measles.csv", row.names = FALSE, quote = FALSE)
