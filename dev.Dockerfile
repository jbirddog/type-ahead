FROM ghcr.io/jbirddog/typeahead-data:main AS data

FROM rust:1-slim-bullseye AS build

RUN rustup component add rustfmt

WORKDIR /app

COPY app/ ./

RUN \
    --mount=type=cache,target=/var/cache/cargo \
    cargo build

WORKDIR /artifacts

COPY --from=data /app/data.db data.db

WORKDIR /app