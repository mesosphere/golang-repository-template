.DEFAULT_GOAL := help

SHELL := /bin/bash -euo pipefail

export GOMODULENAME := $(shell go list -m)

ifneq ($(shell git status --porcelain 2>/dev/null; echo $$?), 0)
	export GIT_TREE_STATE := dirty
else
	export GIT_TREE_STATE :=
endif

.PHONY: dev
dev: ## dev build
dev: clean install generate build lint test mod-tidy build-snapshot

.PHONY: ci
ci: ## CI build
ci: dev diff

.PHONY: clean
clean: ## remove files created during build
	$(call print-target)
	rm -rf dist
	rm -f coverage.*

.PHONY: install
install: ## go install tools
	$(call print-target)
	cd tools && go install -v $(shell cd tools && go list -f '{{ join .Imports " " }}' -tags=tools)

.PHONY: generate
generate: ## go generate
generate: install
	$(call print-target)
	go generate ./...

.PHONY: build
build: ## go build
	$(call print-target)
	go build -o /dev/null ./...

.PHONY: lint
lint: ## golangci-lint
lint: install
	$(call print-target)
	golangci-lint run -c .golangci.yml --fix

.PHONY: test
test: ## go test with race detector and code coverage
test: install
	$(call print-target)
	go-acc --covermode=atomic --output=coverage.out ./... -- -race -short -v
	go tool cover -html=coverage.out -o coverage.html

.PHONY: integration-test
integration-test: ## go test with race detector for integration tests
	$(call print-target)
	go test -race -run Integration -v ./...

.PHONY: mod-tidy
mod-tidy: ## go mod tidy
	$(call print-target)
	go mod tidy
	cd tools && go mod tidy

.PHONY: build-snapshot
build-snapshot: ## goreleaser build --snapshot --rm-dist
build-snapshot: install
	$(call print-target)
	goreleaser build --snapshot --rm-dist

.PHONY: diff
diff: ## git diff
	$(call print-target)
	git diff --exit-code
	RES=$$(git status --porcelain) ; if [ -n "$$RES" ]; then echo $$RES && exit 1 ; fi

.PHONY: release
release: ## goreleaser --rm-dist
release: install
	$(call print-target)
	goreleaser --rm-dist

.PHONY: release-snapshot
release-snapshot: ## goreleaser --rm-dist
release-snapshot: install
	$(call print-target)
	goreleaser release --snapshot --skip-publish --rm-dist

.PHONY: run
run: ## go run
	@go run -race ./cmd/seed

.PHONY: go-clean
go-clean: ## go clean build, test and modules caches
	$(call print-target)
	go clean -r -i -cache -testcache -modcache

.PHONY: docker
docker: ## run in golang container, example: make docker run="make ci"
	docker run --rm -it \
		-v $(CURDIR):/repo $(args) \
		-w /repo \
		golang:1.15 $(run)

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

define print-target
    @printf "Executing target: \033[36m$@\033[0m\n"
endef
