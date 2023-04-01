FROM rust:1-slim-bullseye AS build

RUN rustup component add rustfmt

RUN apt-get update -q && \
    apt-get install -y -q \
    	    curl \
	    libsqlite3-dev \
	    make \
    	    sqlite3

RUN cargo new type_ahead
WORKDIR /type_ahead

COPY Cargo.toml Cargo.lock .

RUN cargo build

COPY artifacts/data.db data/data.db
