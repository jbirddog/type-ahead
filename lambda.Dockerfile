FROM ghcr.io/jbirddog/type-ahead-data:main AS data

FROM rust:1-alpine AS build

RUN apk -U add \
    musl-dev \
    sqlite-dev

WORKDIR /app

COPY app/ ./

#ENV PKG_CONFIG_ALLOW_CROSS=1
#RUN cargo build --target x86_64-unknown-linux-musl
RUN cargo build -p type_ahead_lambda --release

WORKDIR /artifacts

COPY --from=data /app/data.db data.db

WORKDIR /app
