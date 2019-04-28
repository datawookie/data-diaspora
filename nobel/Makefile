CSV = nobel-country.csv  nobel-laureate.csv  nobel-location.csv  nobel-organisation.csv  nobel-prize.csv

$(CSV): prepare-tables.R nobel-prizes-raw.csv
	cat $< | R --slave

all: $(CSV)

clean: $(CSV)
	rm $^
