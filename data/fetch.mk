include common.mk

DATA_URL_BASE := https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/csv/

CITIES_DATA_URL := $(DATA_URL_BASE)$(CITIES_CSV)
STATES_DATA_URL := $(DATA_URL_BASE)$(STATES_CSV)
COUNTRIES_DATA_URL := $(DATA_URL_BASE)$(COUNTRIES_CSV)

.PHONY: fetch-cities
fetch-cities:
	curl --create-dirs -o $(CITIES_DATA_FILE) $(CITIES_DATA_URL)

.PHONY: fetch-states
fetch-states:
	curl --create-dirs -o $(STATES_DATA_FILE) $(STATES_DATA_URL)

.PHONY: fetch-countries
fetch-countries:
	curl --create-dirs -o $(COUNTRIES_DATA_FILE) $(COUNTRIES_DATA_URL)

.PHONY: fetch-data
fetch-data: fetch-cities fetch-states fetch-countries
