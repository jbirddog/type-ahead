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

FROM build AS fetch-data

COPY data/fetch.mk data/fetch.mk
RUN make -C data -f fetch.mk fetch-data

FROM fetch-data AS import-data

COPY data/import.mk data/import.mk
COPY data/import.sql data/import.sql
RUN make -C data -f import.mk import-data

# TODO: copy binary and database into final image