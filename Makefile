all: metar-air-temperature.csv metar-airports.csv weather.csv

metar-air-temperature.csv metar-airports.csv:
	kaggle datasets download fbykov/metar-weather-time-series
	unzip metar-weather-time-series.zip Tair.csv ICAO.csv
	chmod u+r Tair.csv ICAO.csv
	Rscript scripts/metar.R
	rm -f metar-weather-time-series.zip Tair.csv ICAO.csv

weather.csv:
	kaggle datasets download selfishgene/historical-hourly-weather-data
	unzip historical-hourly-weather-data.zip temperature.csv humidity.csv pressure.csv wind_speed.csv wind_direction.csv
	Rscript scripts/weather.R
	rm -f historical-hourly-weather-data.zip temperature.csv humidity.csv pressure.csv wind_speed.csv wind_direction.csv
