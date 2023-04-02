FROM rust:1-slim-bullseye AS build

WORKDIR /type_ahead

RUN apt-get update -q && \
    apt-get install -y -q \
	    libsqlite3-dev

COPY Cargo.toml Cargo.lock .
COPY src/ src/

RUN cargo build --release
