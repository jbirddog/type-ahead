FROM ghcr.io/jbirddog/type-ahead-data:main AS data

FROM rust:1-slim-bullseye AS build

RUN apt-get update -q && \
    apt-get install -y -q \
	    libsqlite3-dev

WORKDIR /app

COPY app/ ./

RUN cargo build --release

WORKDIR /artifacts

COPY --from=data /app/data.db data.db

WORKDIR /app
