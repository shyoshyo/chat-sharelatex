# This file was auto-generated, do not edit it directly.
# Instead run bin/update_build_scripts from
# https://github.com/sharelatex/sharelatex-dev-environment
# Version: 1.1.10

BUILD_NUMBER ?= local
BRANCH_NAME ?= $(shell git rev-parse --abbrev-ref HEAD)
PROJECT_NAME = chat
DOCKER_COMPOSE_FLAGS ?= -f docker-compose.yml
DOCKER_COMPOSE := BUILD_NUMBER=$(BUILD_NUMBER) \
	BRANCH_NAME=$(BRANCH_NAME) \
	PROJECT_NAME=$(PROJECT_NAME) \
	MOCHA_GREP=${MOCHA_GREP} \
	docker-compose ${DOCKER_COMPOSE_FLAGS}


clean:
lint:
	$(DOCKER_COMPOSE) run --rm test_unit npm run lint

test: lint test_unit test_acceptance

test_unit:
	@[ ! -d test/unit ] && echo "chat has no unit tests" || $(DOCKER_COMPOSE) run --rm test_unit

test_acceptance: test_clean test_acceptance_pre_run # clear the database before each acceptance test run
	@[ ! -d test/acceptance ] && echo "chat has no acceptance tests" || $(DOCKER_COMPOSE) run --rm test_acceptance

test_clean:
	$(DOCKER_COMPOSE) down -v -t 0

test_acceptance_pre_run:
	@[ ! -f test/acceptance/scripts/pre-run ] && echo "chat has no pre acceptance tests task" || $(DOCKER_COMPOSE) run --rm test_acceptance test/acceptance/scripts/pre-run

.PHONY: clean test test_unit test_acceptance test_clean build publish