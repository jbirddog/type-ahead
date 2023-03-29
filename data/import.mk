DB_NAME := data.db

.PHONY: import-data
import-data:
	sqlite3 $(DB_NAME) < import.sql
