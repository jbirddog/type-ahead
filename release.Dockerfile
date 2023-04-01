FROM rust:1-slim-bullseye AS build

WORKDIR /type_ahead

RUN apt-get update -q && \
    apt-get install -y -q \
    	    curl \
	    libsqlite3-dev \
	    make \
    	    sqlite3

COPY Cargo.toml Cargo.lock .
COPY src/ src/

RUN cargo build --release

COPY artifacts/data.db data/data.db

# TODO: copy binary and database into final image