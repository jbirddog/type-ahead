.mode csv

.import csv/countries.csv _countries
.import csv/states.csv _states
.import csv/cities.csv _cities

create table countries (name text);
create table states(name text, country_name text);
create table cities (name text, state_name text, country_name text);

insert into countries (name)
       select name from _countries;

insert into states (name, country_name)
       select name, country_name from _states;
       
insert into cities (name, state_name, country_name)
       select name, state_name, country_name from _cities;

drop table _countries;
drop table _states;
drop table _cities;

create index countries_index on countries(name collate nocase);
create index states_index on states(name collate nocase);
create index cities_index on cities(name collate nocase);

vacuum;
