library(dplyr)
library(stringr)
library(purrr)

prize <- read.csv("nobel-prizes-raw.csv", stringsAsFactors = FALSE)

names(prize) <- tolower(names(prize)) %>% str_replace("\\.", "_")

prize <- prize %>% mutate_at(
  vars(matches("(organization|birth|death)_")),
  funs(ifelse(. == "", NA, .))
) %>%
  rename(
    type = laureate_type,
    share = prize_share
    ) %>%
  select(-motivation, -prize)

location <- rbind(
  select(prize, birth_city, birth_country) %>% setNames(c("city", "country")),
  select(prize, death_city, death_country) %>% setNames(c("city", "country")),
  select(prize, organization_city, organization_country) %>% setNames(c("city", "country"))
) %>% unique() %>% arrange(city) %>% mutate(id = 1:n()) %>% select(id, country, city)

country <- location %>% select(country) %>% unique() %>% arrange(country) %>% mutate(id = 1:n()) %>% select(id, everything())

location <- location %>% inner_join(country %>% rename(country_id = id), by = c(country = "country"))

prize = inner_join(prize, location, by = c("birth_country" = "country", "birth_city" = "city")) %>%
  rename(birth_location_id = id) %>%
  select(-birth_country, -birth_city)

prize = inner_join(prize, location, by = c("death_country" = "country", "death_city" = "city")) %>%
  rename(death_location_id = id) %>%
  select(-death_country, -death_city)

laureate <- prize %>%
  mutate(sex = str_sub(sex, end = 1)) %>%
  select(id = laureate_id, name = full_name, sex, birth_date, death_date, birth_location_id, death_location_id) %>%
  arrange(id) %>% unique()

prize <- prize %>% select(-full_name, -birth_date, -sex, -death_date, -birth_location_id, -death_location_id)

organisation <- prize %>% select(organization_name, organization_country, organization_city) %>%
  na.omit() %>%
  unique() %>%
  arrange(organization_name) %>%
  mutate(id = 1:n())

# Replace organisation details with ID.
#
prize = prize %>% left_join(organisation) %>%
  rename(organisation_id = id) %>%
  select(-organization_name, -organization_city, -organization_country)

organisation = organisation %>%
  inner_join(location %>% rename(location_id = id),
             by = c("organization_country" = "country", "organization_city" = "city")) %>%
  rename(name = organization_name) %>%
  select(id, name, location_id)

prize <- prize %>%
  select(year, category, type, share, laureate_id, organisation_id) %>%
  arrange(year, category, type) %>%
  mutate(id = 1:n()) %>%
  select(id, everything())

location <- location %>% select(-country)

write.csv(prize, "nobel-prize.csv", quote = FALSE, row.names = FALSE)
write.csv(location, "nobel-location.csv", quote = FALSE, row.names = FALSE)
write.csv(country, "nobel-country.csv", quote = FALSE, row.names = FALSE)
write.csv(organisation, "nobel-organisation.csv", quote = FALSE, row.names = FALSE)
write.csv(laureate, "nobel-laureate.csv", quote = FALSE, row.names = FALSE)

# CREATE SQL ----------------------------------------------------------------------------------------------------------

escape_apostrophe <- function(text) {
  gsub("'", "\\\\'", text)
}
null_from_na <- function(value) {
  ifelse(is.na(value), 'NULL', ifelse(is.character(value), paste0("'", value, "'"), value))
}
null_from_na(NA)
null_from_na("foo")
null_from_na(69)

fid <- file("database-insert.sql", "w")

country %>%
  pmap(function(id, country) {
    sprintf("(%d, '%s')", id, escape_apostrophe(country))
  }) %>%
  unlist() %>%
  paste(collapse = ", ") %>%
  sprintf("INSERT INTO country VALUES %s;", .) %>%
  cat(file = fid, append = TRUE)

location %>%
  pmap(function(id, city, country_id) {
    sprintf("(%d, %s, %d)", id, null_from_na(escape_apostrophe(city)), country_id)
  }) %>%
  unlist() %>%
  paste(collapse = ", ") %>%
  sprintf("INSERT INTO location VALUES %s;", .) %>%
  cat(file = fid, append = TRUE)

laureate %>%
  pmap(function(id, name, sex, birth_date, death_date, birth_location_id, death_location_id) {
    sprintf("(%d, '%s', '%s', %s, %s, %d, %d)",
                id, escape_apostrophe(name), sex, null_from_na(birth_date), null_from_na(death_date), birth_location_id, death_location_id)
  }) %>%
  unlist() %>%
  paste(collapse = ", ") %>%
  sprintf("INSERT INTO laureate VALUES %s;", .) %>%
  cat(file = fid, append = TRUE)

organisation %>%
  pmap(function(id, name, location_id) {
    sprintf("(%d, '%s', %d)", id, escape_apostrophe(name), location_id)
  }) %>%
  unlist() %>%
  paste(collapse = ", ") %>%
  sprintf("INSERT INTO organisation VALUES %s;", .) %>%
  cat(file = fid, append = TRUE)

prize %>%
  pmap(function(id, year, category, type, share, laureate_id, organisation_id) {
    sprintf("(%d, %d, '%s', '%s', '%s', %d, %s)", id, year, category, type, share, laureate_id, null_from_na(organisation_id))
  }) %>%
  unlist() %>%
  paste(collapse = ", ") %>%
  sprintf("INSERT INTO prize VALUES %s;", .) %>%
  cat(file = fid, append = TRUE)

close(fid)
