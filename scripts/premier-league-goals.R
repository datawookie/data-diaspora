# Scraped from https://www.premierleague.com/stats/top/players/goals

library(httr)
library(dplyr)
library(purrr)
library(tidyr)
library(readr)
library(glue)

USER_AGENT = user_agent("Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:79.0) Gecko/20100101 Firefox/79.0")

SEASONS <- tribble(
  ~season, ~id,
  "2019", 274,
  "2018", 210,
  "2017", 79,
  "2016", 54,
  "2015", 42,
  "2014", 27,
  "2013", 22,
  "2012", 21,
  "2011", 20,
  "2010", 19,
  "2009", 18 
)

get_season <- function(id) {
  results <- GET(
    glue('https://footballapi.pulselive.com/football/stats/ranked/players/goals?page=0&pageSize=1000&compSeasons={id}&comps=1&compCodeForActivePlayer=EN_PR&altIds=true'),
    USER_AGENT,
    add_headers(Accept = "*/*"),
    add_headers(Origin = "https://www.premierleague.com")
  )
  
  results <- content(results)$stats$content
  
  map_dfr(results, function(result) {
    tibble(
      name = result$owner$name$display,
      goals = result$value
    )
  })
}

results_nested <- SEASONS %>%
  mutate(
    results = map(id, get_season)
  )

results <- results_nested %>%
  select(-id) %>%
  unnest(cols = c(results))

write_csv(results, "premier-league-goals.csv")
