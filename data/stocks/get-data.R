library(dplyr)
library(Quandl)

Quandl.api_key(QUANDL_KEY)

AAPL = Quandl.datatable('WIKI/PRICES', ticker='AAPL')
GOOGL = Quandl.datatable('WIKI/PRICES', ticker='GOOGL')
FB = Quandl.datatable('WIKI/PRICES', ticker='FB')

prepare <- function(df) {
  df %>%
    filter(date <= '2017-12-31') %>%
    arrange(desc(date)) %>%
    select(-open, -close, -high, -low, -volume, -`ex-dividend`, -split_ratio) %>%
    rename(
      open = adj_open,
      close = adj_close,
      high = adj_high,
      low = adj_low,
      volume = adj_volume
    )
}
AAPL = prepare(AAPL)
GOOGL = prepare(GOOGL)
FB = prepare(FB)

write.csv(AAPL, "AAPL.csv", quote = FALSE, row.names = FALSE)
write.csv(GOOGL, "GOOGL.csv", quote = FALSE, row.names = FALSE)
write.csv(FB, "FB.csv", quote = FALSE, row.names = FALSE)
