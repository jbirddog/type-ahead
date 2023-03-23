include common.mk

DB_NAME := data.db

.PHONY: import-countries
import-countries:
	sqlite3 -csv $(DB_NAME) ".import $(COUNTRIES_DATA_FILE) countries"

.PHONY: import-states
import-states:
	sqlite3 -csv $(DB_NAME) ".import $(STATES_DATA_FILE) states"

.PHONY: import-cities
import-cities:
	sqlite3 -csv $(DB_NAME) ".import $(CITIES_DATA_FILE) cities"

.PHONY: import-data
import-data: import-countries import-states import-cities
