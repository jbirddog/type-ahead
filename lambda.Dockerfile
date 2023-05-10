FROM ghcr.io/jbirddog/typeahead-data:main AS data
    
FROM calavera/cargo-lambda AS base

RUN apt-get update -q && \
    apt-get install -y -q \
	    zip

WORKDIR /app

COPY app/ ./

RUN cargo lambda build -p type_ahead_lambda --release

WORKDIR /artifacts

COPY --from=data /app/data.db data.db
RUN cp ../app/target/lambda/bootstrap/bootstrap bootstrap
RUN zip bootstrap.zip bootstrap data.db

WORKDIR /app/lambda
