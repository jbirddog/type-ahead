FROM calavera/cargo-lambda AS base

WORKDIR /app

RUN cargo lambda new --http --http-feature=apigw_http type_ahead

WORKDIR /app/type_ahead

#COPY lambda/Cargo.* .

RUN cargo lambda build --release --output-format zip

#CMD ["cargo", "lambda", "watch"]