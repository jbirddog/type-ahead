FROM type-ahead-deps AS deps

RUN rustup component add rustfmt

RUN apt-get update -q && \
    apt-get install -y -q \
    	    curl \
	    make \
    	    sqlite3

FROM deps AS prep-data

COPY data.mk .
RUN make -f data.mk prep-data