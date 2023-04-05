FROM ghcr.io/jbirddog/type-ahead-data:main AS data

FROM rust:1-slim-bullseye AS build

RUN rustup component add rustfmt

WORKDIR /app

COPY app/ ./

RUN cargo build

WORKDIR /artifacts

COPY --from=data /app/data.db data.db

WORKDIR /app