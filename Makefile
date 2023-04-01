#
# still figuring out how I want this all laid out, so in flux.
#  - need to simplify some: https://nullprogram.com/blog/2020/01/22/
#  - make shell and make SERVICE=dev shell or make shell-dev?
#

SRC := type_ahead

DATA_SERVICE := data
DEV_SERVICE := dev
LAMBDA_SERVICE := lambda
RELEASE_SERVICE := release

MY_USER := $(shell id -u)
MY_GROUP := $(shell id -g)
ME := $(MY_USER):$(MY_GROUP)
AS_ME := docker compose run -u $(ME) $(DEV_SERVICE)
AS_ROOT := docker compose run $(DEV_SERVICE)

.PHONY: all
all: dev-env

# TODO: clean

.PHONY: data
data:
	docker compose run --build -u $(ME) $(DATA_SERVICE) 

.PHONY: lambda-env
lambda-env: data
	docker compose build $(LAMBDA_SERVICE)

.PHONY: lambda-shell
lambda-shell:
	docker compose run $(LAMBDA_SERVICE) /bin/sh

# TODO: not working for some reason
#.PHONY: lambda-watch
#lambda-watch: stop
#	docker compose run $(LAMBDA_SERVICE) cargo lambda watch

# TODO have the image contain this zip
.PHONY: lambda-zip
lambda-zip: lambda-env
	set -e ;\
	TMP_ID=$$(docker create type-ahead-lambda) ;\
	docker cp $$TMP_ID:/app/target/release/bootstrap bootstrap ;\
	docker rm -v $$TMP_ID ;\
	zip bootstrap.zip bootstrap ;\
	rm bootstrap ;\

.PHONY: lambda-scaffolding
lambda-scaffolding: lambda-env
	set -e ;\
	mkdir -p lambda_scaffolding ;\
	TMP_ID=$$(docker create type-ahead-lambda) ;\
	docker cp $$TMP_ID:/app/type_ahead/Cargo.toml lambda_scaffolding/Cargo.toml ;\
	docker cp $$TMP_ID:/app/type_ahead/Cargo.lock lambda_scaffolding/Cargo.lock ;\
	docker cp $$TMP_ID:/app/type_ahead/src lambda_scaffolding/src ;\
	docker rm -v $$TMP_ID ;\

.PHONY: release
release: data
	docker compose build --progress=plain $(RELEASE_SERVICE)

.PHONY: release-shell
release-shell:
	docker compose run $(RELEASE_SERVICE) /bin/bash

.PHONY: release-start
release-start: stop
	docker compose up -d $(RELEASE_SERVICE)

.PHONY: dev-env
dev-env: data
	docker compose build --progress=plain $(DEV_SERVICE)

.PHONY: shell
shell:
	$(AS_ROOT) /bin/bash

.PHONY: shell-as-me
shell-as-me:
	$(AS_ME) /bin/bash

.PHONY: owner-check
owner-check:
	find . ! -user $(MY_USER) ! -group $(MY_GROUP)

.PHONY: compile
compile:
	$(AS_ROOT) cargo build --color=never

.PHONY: tests
tests:
	$(AS_ROOT) cargo test --color=never

.PHONY: fmt
fmt:
	$(AS_ROOT) cargo fmt

.PHONY: stop
stop:
	docker compose down

# cargo watch? - https://actix.rs/docs/autoreload
.PHONY: start
start: stop compile
	docker compose up -d $(DEV_SERVICE)

.PHONY: sim
sim:
	python sim.py
