.mode csv

.import csv/countries.csv countries
.import csv/states.csv states
.import csv/cities.csv cities

create index countries_index on countries(name collate nocase);
create index states_index on states(name collate nocase);
create index cities_index on cities(name collate nocase);
