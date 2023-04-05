FROM ghcr.io/jbirddog/type-ahead-data:main AS data

FROM rust:1-slim-bullseye AS deps

RUN apt-get update -q && \
    apt-get install -y -q \
	    libsqlite3-dev

FROM deps AS build

WORKDIR /app

COPY app/ ./

RUN cargo build --release

#FROM gcr.io/distroless/cc-debian11 AS final

#COPY --from=build /app/target/release/type_ahead /app/target/release/type_ahead

FROM deps AS final

COPY --from=build /app/target/release/type_ahead /app/target/release/type_ahead

WORKDIR /artifacts

COPY --from=data /app/data.db data.db

WORKDIR /app

CMD ["/app/target/release/type_ahead"]