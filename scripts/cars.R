library(MASS)
library(janitor)
library(dplyr)
library(stringr)

cars <- Cars93 %>%
  clean_names() %>%
  mutate(
    cylinders = as.character(cylinders),
    cylinders = ifelse(cylinders == "rotary", NA, cylinders) %>% as.integer(),
    model = model %>% str_replace_all("_+", " "),
    missing = is.na(cylinders),
    random = runif(nrow(.)),
    cons = 100 / mpg_highway
  ) %>%
  arrange(desc(missing), cons) %>%
  select(mfr = manufacturer, mod = model, org = origin, type, cyl = cylinders, size = engine_size, weight, len = length, rpm, cons)

cars %>%
  mutate(
    # Gallon per 100 mile
    cons = sprintf("%.2f", cons)
  ) %>%
  write.csv("cars-imperial.csv", quote = FALSE, row.names = FALSE)

cars %>%
  mutate(
    # Litre per 100 km
    cons = sprintf("%.2f", cons / 1.60934 * 3.785411784),
    weight = sprintf("%.0f", weight * 0.453592),
    len = sprintf("%.2f", len * 0.0254)
  ) %>%
  rename(mass = weight) %>%
  write.csv("cars-metric.csv", quote = FALSE, row.names = FALSE)
