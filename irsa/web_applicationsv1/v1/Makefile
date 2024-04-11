DOCKER_IMAGE_NAME := choisunguk/fastapi_get_bucket
DOCKER_IMAGE_TAG := v1

.PHONY: build
build:
	docker build -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .

.PHONY: push
push:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) --push .
