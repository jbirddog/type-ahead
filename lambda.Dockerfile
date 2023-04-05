FROM ghcr.io/jbirddog/type-ahead-data:main AS data

#FROM rust:1-alpine AS build

#RUN apk -U add \
#    musl-dev \
#    sqlite-dev \
#    zip
    
FROM calavera/cargo-lambda AS base

RUN apt-get update -q && \
    apt-get install -y -q \
	    libsqlite3-dev \
	    zip

WORKDIR /app

COPY app/ ./

RUN cargo lambda build -p type_ahead_lambda --release

WORKDIR /artifacts

COPY --from=data /app/data.db data.db
RUN cp ../app/target/release/type_ahead_lambda bootstrap
RUN zip bootstrap.zip bootstrap data.db

WORKDIR /app
