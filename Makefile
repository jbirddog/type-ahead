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

.PHONY: compile
compile:
	$(AS_ME) cargo build

.PHONY: shell
shell:
	$(AS_ME) /bin/bash

.PHONY: shell-as-root
shell-as-root:
	$(AS_ROOT) /bin/bash

.PHONY: owner-check
owner-check:
	find . ! -user $(MY_USER) ! -group $(MY_GROUP)

#
# tests
#

.PHONY: tests
tests:
	$(AS_ME) cargo test

#
# tooling
#
