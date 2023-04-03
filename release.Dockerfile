FROM ghcr.io/jbirddog/type-ahead-data:pr-1 AS data

FROM rust:1-slim-bullseye AS build

WORKDIR /app

RUN apt-get update -q && \
    apt-get install -y -q \
	    libsqlite3-dev

COPY Cargo.toml Cargo.lock .
COPY src/ src/

RUN cargo build --release

COPY --from=data /app/data.db data/data.db
