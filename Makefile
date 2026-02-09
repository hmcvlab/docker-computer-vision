.PHONY: format lint build test deploy install_hooks

URL = hmcvlab
NAME = computer-vision
TAG = $(shell git tag --sort=committerdate | tail -1)

format:
	docker run --rm \
		--pull=always \
		-v .:/app \
		"${URL}/format"

lint:
	docker run --rm \
		--pull=always \
		-v .:/app \
		"${URL}/lint"

build:
	docker build -t ${URL}/${NAME}:${TAG} .

test:
	docker run --tty \
		--rm  \
		--ipc=host \
		--ulimit memlock=-1 \
		--ulimit stack=67108864 \
		--gpus all \
		-v .:/app \
		-w /app \
		${URL}/${NAME}:${TAG} \
		bash -c "pytest tests/"

deploy:
	docker buildx rm tmp-builder && \
	docker buildx create --use --name tmp-builder && \
	docker buildx build \
		-t ${URL}/${NAME}:${TAG} \
		-t ${URL}/${NAME}:latest \
		--push \
		--platform linux/amd64,linux/arm64 \
		--file Dockerfile . && \
	docker buildx rm tmp-builder

install-hooks:
	@echo "make format && make lint" > .git/hooks/pre-commit
	@echo "make test" > .git/hooks/pre-push
	@chmod +x .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-push
