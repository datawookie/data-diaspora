library(dplyr)

set.seed(7)

# Manufacture some feasible but fictional data.
#
N <- 200
#
growing <- data.frame(
  age = runif(N, 0, 18) %>% round(2),
  gender = sample(c("M", "F"), N, replace = TRUE)
) %>% mutate(
  height = ifelse(gender == "M", 25, 20) + ifelse(gender == "M", 8.9, 8.3) * age + rnorm(N, sd = 8),
  height = height %>% round(1)
) %>% select(age, gender, height)

plot(height ~ age, col = gender, data = growing)

summary(lm(height ~ age * gender, data = growing))

write.csv(growing, here::here("height-age.csv"), row.names = FALSE, quote = FALSE)
