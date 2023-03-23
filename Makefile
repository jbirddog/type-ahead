SRC := type_ahead

DEV_SERVICE := dev

# Not sure if the AS_ME/AS_ROOT stuff is as helpful for rust dev env
# as it is for python. may just end up nuking it to simplify this some
MY_USER := $(shell id -u)
MY_GROUP := $(shell id -g)
ME := $(MY_USER):$(MY_GROUP)
AS_ME := docker compose run -u $(ME) $(DEV_SERVICE)
AS_ROOT := docker compose run $(DEV_SERVICE)

.PHONY: all
all: dev-env

.PHONY: deps
deps:
	docker build \
		-f deps.Dockerfile \
		-t type-ahead-deps \
		--progress=plain \
		.

.PHONY: dev-env
dev-env: deps
	docker compose build --progress=plain $(DEV_SERVICE)

.PHONY: shell
shell:
	$(AS_ROOT) /bin/bash

.PHONY: shell-as-me
shell-as-root:
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
.PHONY: run
run: stop
	docker compose up -d #cargo run
