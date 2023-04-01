.PHONY: data
data: fetch-data import-data

.PHONY: artifact
artifact:
	cp $(DB_NAME) ../artifacts/

#
# fetching
#

DATA_URL_BASE := https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/csv/

DATA_DIR := csv/

CITIES_CSV := cities.csv
CITIES_DATA_FILE := $(DATA_DIR)$(CITIES_CSV)
CITIES_DATA_URL := $(DATA_URL_BASE)$(CITIES_CSV)

STATES_CSV := states.csv
STATES_DATA_FILE := $(DATA_DIR)$(STATES_CSV)
STATES_DATA_URL := $(DATA_URL_BASE)$(STATES_CSV)

COUNTRIES_CSV := countries.csv
COUNTRIES_DATA_FILE := $(DATA_DIR)$(COUNTRIES_CSV)
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

#
# importing
#

DB_NAME := data.db

.PHONY: import-data
import-data:
	sqlite3 $(DB_NAME) < import.sql

