IMAGE ?= ghcr.io/petewall/petewall.net
TAG   ?= dev
PORT  ?= 8080

.PHONY: help serve build image run push lint test clean shrink-pngs shrink-jpgs

help: ## List available targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-10s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

themes/PaperMod/theme.toml: ## Initialize the PaperMod theme submodule
	git submodule update --init --recursive

serve: themes/PaperMod/theme.toml ## Run Hugo dev server with drafts
	hugo server -D

build: themes/PaperMod/theme.toml ## Build the static site into public/
	hugo --minify --gc

image: build ## Build the Docker image (depends on build)
	docker build -t $(IMAGE):$(TAG) .

run: image ## Run the Docker image locally on $(PORT)
	docker run --rm -p $(PORT):8080 $(IMAGE):$(TAG)

push: image ## Push the Docker image
	docker push $(IMAGE):$(TAG)

# --panicOnWarning is omitted because PaperMod (pinned at upstream master, no
# release newer than v8.0) still uses .Language.LanguageDirection and
# .Language.LanguageCode, deprecated in Hugo v0.158. Re-enable once upstream
# updates or we shadow the affected layouts.
lint: themes/PaperMod/theme.toml ## Strict Hugo build — fail on warnings
	hugo --minify --gc --printPathWarnings

test: lint ## Alias of lint (the build is the test for a static site)

clean: ## Remove build artifacts
	rm -rf public resources .hugo_build.lock

PNG_FILES := $(shell find content -name "*.png")
shrink-pngs: ## Compress all PNGs in content/ in-place using pngquant
	oxipng --opt max --strip safe --zopfli --fast --verbose $(PNG_FILES)

JPG_FILES := $(shell find content -name "*.jpg" -o -name "*.jpeg")
shrink-jpgs: ## Losslessly optimize all JPGs in content/ in-place using mozjpeg
	@for f in $(JPG_FILES); do \
		before=$$(wc -c < $$f); \
		jpegtran -optimize -copy none -outfile $$f.compressed $$f; \
		after=$$(wc -c < $$f.compressed); \
		echo "$$f: $$before -> $$after bytes"; \
		if [ $$after -lt $$before ]; then \
			mv $$f.compressed $$f; \
		else \
			rm $$f.compressed; \
			echo "    skipped, compressed was larger"; \
		fi; \
	done