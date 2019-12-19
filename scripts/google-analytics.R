library(janitor)
library(googleAnalyticsR)
ga_auth()

ga_account_list()

ga_id <- 173110735 

ga <- google_analytics_4(
  ga_id, 
  date_range = c("2018-12-01", "2019-12-01"),
  metrics = c("sessions", "users"),
  # https://developers.google.com/analytics/devguides/reporting/realtime/dimsmets/
  dimensions = c(
    "date",
    "country",
    "browser",
    "operatingSystem"
  ),
  anti_sample = TRUE
)

ga <- ga %>% clean_names()

write.table(ga, "google-analytics.csv", quote = FALSE, row.names = FALSE, sep = ";")
