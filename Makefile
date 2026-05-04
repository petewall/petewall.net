IMAGE ?= ghcr.io/petewall/petewall.net
TAG   ?= dev
PORT  ?= 8080

.PHONY: help serve build image run push lint test clean

help: ## List available targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-10s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

serve: ## Run Hugo dev server with drafts
	hugo server -D

build: ## Build the static site into public/
	hugo --minify --gc

image: build ## Build the Docker image (depends on build)
	docker build -t $(IMAGE):$(TAG) .

run: image ## Run the Docker image locally on $(PORT)
	docker run --rm -p $(PORT):80 $(IMAGE):$(TAG)

push: image ## Push the Docker image
	docker push $(IMAGE):$(TAG)

lint: ## Strict Hugo build — fail on warnings
	hugo --minify --gc --panicOnWarning --printPathWarnings

test: lint ## Alias of lint (the build is the test for a static site)

clean: ## Remove build artifacts
	rm -rf public resources .hugo_build.lock
