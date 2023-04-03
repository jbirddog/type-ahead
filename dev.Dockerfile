FROM ghcr.io/jbirddog/type-ahead-data:pr-1 AS data

FROM rust:1-slim-bullseye AS build

WORKDIR /type_ahead

RUN apt-get update -q && \
    apt-get install -y -q \
	    libsqlite3-dev

COPY Cargo.toml Cargo.lock .
COPY src/ src/

RUN cargo build


#RUN rustup component add rustfmt

#RUN apt-get update -q && \
#    apt-get install -y -q \
#    	    curl \
#	    libsqlite3-dev \
#	    make \
#    	    sqlite3

#RUN cargo new type_ahead
#WORKDIR /type_ahead

#COPY Cargo.toml Cargo.lock .

#RUN cargo build

COPY --from=data /app/data.db data/data.db
