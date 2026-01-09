URL = hmcvlab
NAME = computer-vision
TAG = $(shell git tag --sort=committerdate | tail -1)

.PHONY: format lint build test install-hooks

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
	docker run --rm  \
		-v ${PWD}:/app \
		${URL}/${NAME}:${TAG} \
		sh -c "pytest"

install-hooks:
	@echo "make format && make lint" > .git/hooks/pre-commit
	@echo "make test" > .git/hooks/pre-push
	@chmod +x .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-push