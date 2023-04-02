FROM rust:1-alpine AS build

RUN apk -U add \
    musl-dev \
    sqlite-dev

WORKDIR /app

COPY Cargo.toml Cargo.lock .
COPY src/ ./src

RUN cargo build
RUN cargo test