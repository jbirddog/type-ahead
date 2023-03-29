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

FROM build AS fetch-data

COPY data/fetch.mk data/fetch.mk
RUN make -C data -f fetch.mk fetch-data

FROM fetch-data AS import-data

COPY data/import.mk data/import.mk
COPY data/import.sql data/import.sql
RUN make -C data -f import.mk import-data