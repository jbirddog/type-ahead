# typeahead
Typeahead

typeahead api using rust/actix-web/sqlite. All data is readonly and is stored in a sqlite db that is
created at image build time.

## To use:

`make dev-env` builds the dev environment

`make compile` compile the source 

`make start` starts the server

The server will be running on port 5000. Endpoints are:

[http://localhost:5000/v1/typeahead/countries?prefix=un&limit=100](http://localhost:5000/v1/typeahead/countries?prefix=un&limit=100)

[http://localhost:5000/v1/typeahead/states?prefix=ga&limit=100](http://localhost:5000/v1/typeahead/states?prefix=ga&limit=100)

[http://localhost:5000/v1/typeahead/cities?prefix=ma&limit=100](http://localhost:5000/v1/typeahead/cities?prefix=ma&limit=100)

prefix and limit are required, limit must be an int.

`make tests` run tests (currently none)

`make fmt` format the codes

`make stop` stops the server

`make sim` run a simulation script (waits for your input)

`make shell` shell into the container

`make lambda-zip` make a zip file to upload as an AWS Lambda Function