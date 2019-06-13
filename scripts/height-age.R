library(dplyr)

set.seed(13)

# Manufacture some feasible but fictional data.
#
N <- 100
#
growing <- data.frame(
  age = runif(N, 0, 18) %>% round(2),
  gender = sample(c("M", "F"), N, replace = TRUE)
) %>% mutate(
  height = ifelse(gender == "M", 25, 20) + ifelse(gender == "M", 8.9, 8.4) * age + rnorm(N, sd = 10),
  height = height %>% round(1)
) %>% select(age, gender, height)
#
# EXERCISES:
#
# 1. Explain what's going on in the code above.
# 2. Produce a scatter plot of height versus age (use base graphics).

write.csv(growing, "height-age.csv", row.names = FALSE, quote = FALSE)
