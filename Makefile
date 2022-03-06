UID=$(shell id -u)
GID=$(shell id -g)

IMAGE=notte-api
TAG?=latest

all: help

##@ Helpers
.PHONY: help
help: ## Displays this information.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo ""

.PHONY: build
build: ## Builds the image.
	@echo "Building dev image..."
	@DOCKER_BUILDKIT=1 docker build -t $(IMAGE):dev --target dev .

.PHONY: build-pro
build-pro: ## Builds the image.
	@echo "Building pro image..."
	@DOCKER_BUILDKIT=1 docker build -t $(IMAGE):$(TAG) --target pro .

.PHONY: start
start: ## Starts the aplication in development mode.
	@echo "Starting the application in development mode... $(UID)"
	@EXPORTED_USER=$(UID) EXPORTED_GROUP=$(GID) \
		DOCKER_BUILDKIT=1 \
		COMPOSE_DOCKER_CLI_BUILD=1 \
		docker-compose -f docker-compose.yml up -d --build .

.PHONY: stop
stop: ## Stops the aplication.
	@echo "Stopping the application..."

.PHONY: npm-install
npm-install: ## Installs the dependencies.
	@echo "Installing the dependencies..."
	@docker run --rm -v ./app:/app -w /app -u $(UID):$(GID) notte-api:dev npm install

.PHONY: npm-install-dev
npm-install-dev: ## Installs the development dependencies.
	@echo "Installing the development dependencies..."
	@docker run --rm -v app:/app -w /app -u $(UID):$(GID) notte-api:dev npm install --save-dev
