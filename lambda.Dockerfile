FROM rust:1-alpine AS base

RUN apk add -U musl-dev

WORKDIR /app

COPY lambda_scaffolding/ ./

RUN cargo build --release
