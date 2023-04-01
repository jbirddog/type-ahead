FROM alpine AS build

RUN mkdir /artifacts
WORKDIR /app

RUN apk add -U --no-cache \
    curl \
    make \
    sqlite

COPY Makefile import.sql .

RUN make

CMD ["make", "artifact"] 