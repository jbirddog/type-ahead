FROM rust:1-slim-bullseye AS build

RUN cargo new type_ahead
WORKDIR /type_ahead

COPY Cargo.toml Cargo.lock .

RUN cargo build
