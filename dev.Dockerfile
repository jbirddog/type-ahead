FROM type-ahead-deps AS deps

RUN rustup component add rustfmt

RUN apt-get update -q && \
    apt-get install -y -q \
    	    curl \
	    libsqlite3-dev \
	    make \
    	    sqlite3

COPY data/common.mk data/common.mk

FROM deps AS fetch-data

COPY data/fetch.mk data/fetch.mk
RUN make -C data -f fetch.mk fetch-data

FROM fetch-data AS import-data

COPY data/import.mk data/import.mk
RUN make -C data -f import.mk import-data