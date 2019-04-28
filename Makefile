metar-air-temperature.csv metar-airports.csv:
	kaggle datasets download fbykov/metar-weather-time-series
	unzip metar-weather-time-series.zip Tair.csv ICAO.csv
	chmod u+r Tair.csv ICAO.csv
	Rscript scripts/metar.R
	rm metar-weather-time-series.zip Tair.csv ICAO.csv
