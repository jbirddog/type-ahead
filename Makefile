SRC := type_ahead

DEV_SERVICE := dev

MY_USER := $(shell id -u)
MY_GROUP := $(shell id -g)
ME := $(MY_USER):$(MY_GROUP)
AS_ME := docker compose run -u $(ME) $(DEV_SERVICE)
AS_ROOT := docker compose run $(DEV_SERVICE)

.PHONY: all
all: dev-env

.PHONY: dev-env
dev-env:
	docker compose build --progress=plain $(DEV_SERVICE)

.PHONY: shell
shell:
	$(AS_ME) /bin/bash

.PHONY: shell-as-root
shell-as-root:
	$(AS_ROOT) /bin/bash

.PHONY: owner-check
owner-check:
	find . ! -user $(MY_USER) ! -group $(MY_GROUP)

.PHONY: compile
compile:
	$(AS_ROOT) cargo build --color=never

.PHONY: tests
tests:
	$(AS_ROOT) cargo test

.PHONY: fmt
fmt:
	$(AS_ROOT) cargo fmt

.PHONY: stop
stop:
	docker compose down

# cargo watch?
.PHONY: run
run: stop
	docker compose up -d #cargo run
