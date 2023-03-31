SRC := type_ahead

DEV_SERVICE := dev
LAMBDA_SERVICE := lambda
RELEASE_SERVICE := release

# Not sure if the AS_ME/AS_ROOT stuff is as helpful for rust dev env
# as it is for python. may just end up nuking it to simplify this some
MY_USER := $(shell id -u)
MY_GROUP := $(shell id -g)
ME := $(MY_USER):$(MY_GROUP)
AS_ME := docker compose run -u $(ME) $(DEV_SERVICE)
AS_ROOT := docker compose run $(DEV_SERVICE)

.PHONY: all
all: dev-env

.PHONY: lambda-env
lambda-env:
	docker compose build $(LAMBDA_SERVICE)

.PHONY: lambda-shell
lambda-shell:
	docker compose run $(LAMBDA_SERVICE) /bin/bash

# TODO: not working for some reason
#.PHONY: lambda-watch
#lambda-watch: stop
#	docker compose run $(LAMBDA_SERVICE) cargo lambda watch

.PHONY: lambda-zip
lambda-zip: lambda-env
	set -e ;\
	TMP_ID=$$(docker create type-ahead-lambda) ;\
	docker cp $$TMP_ID:/app/type_ahead/target/lambda/type_ahead/bootstrap.zip bootstrap.zip ;\
	docker rm -v $$TMP_ID ;\

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
release:
	docker compose build --progress=plain $(RELEASE_SERVICE)

.PHONY: release-shell
release-shell:
	docker compose run $(RELEASE_SERVICE) /bin/bash

.PHONY: release-start
release-start: stop
	docker compose up -d $(RELEASE_SERVICE)

.PHONY: dev-env
dev-env:
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
