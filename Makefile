URL = gitlab.lrz.de:5005/messtechnik-labor/docker
NAME = $(shell basename $(CURDIR))
TAG = $(shell git tag --sort=committerdate | tail -1)

format:
	docker run --rm \
		--pull=always \
		-v ${PWD}:/app \
		-e UID="$(shell uid -u)" \
		"${URL}/format"

lint:
	docker run --rm \
		--pull=always \
		-v ${PWD}:/app \
		-e UID="$(shell uid -u)" \
		"${URL}/lint"

build:
	docker buildx create --use && \
	docker buildx build \
		-t ${URL}/${NAME}:${TAG} \
		--push \
		--platform linux/amd64,linux/arm64 \
		--file Dockerfile .

test:
	docker run --rm ${URL}/${NAME}:${TAG} \
		sh -c "pytest"
