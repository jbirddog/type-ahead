# type-ahead
Type Ahead

Proof of concept type-ahead api using rust/actix-web/sqlite.

## To use:

`make dev-env` builds the dev environment

`make compile` compile the source 

`make start` starts the server

The server will be running on port 5000. Endpoints are:

[http://localhost:5000/countries?prefix=un&limit=100](http://localhost:5000/countries?prefix=ca&limit=100)

[http://localhost:5000/states?prefix=ga&limit=100](http://localhost:5000/countries?prefix=ca&limit=100)

[http://localhost:5000/cities?prefix=ma&limit=100](http://localhost:5000/countries?prefix=ca&limit=100)

Prefix must be a string, limit must be an int.

`make tests` run tests (currently none)

`make fmt` format the codes

`make stop` stops the server

`make sim` run a simulation script (waits for your input)

`make shell` shell into the container
