.PHONY: format lint build test check release clean install-hooks

URL = hmcvlab
NAME = computer-vision
DEV = dev

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
	docker build -t ${URL}/${NAME}:${DEV} .

test: build
	docker run --tty \
		--rm  \
		--ipc=host \
		--ulimit memlock=-1 \
		--ulimit stack=67108864 \
		--gpus all \
		-v .:/app \
		-w /app \
		${URL}/${NAME}:${DEV} \
		bash -c "pytest tests/"

check:
	@test -n "$(VERSION)" || (echo "usage: make release VERSION=x.y.z"; exit 1)
	@! git rev-parse --verify --quiet refs/tags/$(VERSION) >/dev/null || \
		(echo "error: git tag $(VERSION) already exists"; exit 1)
	@git diff --quiet && git diff --cached --quiet || \
		(echo "error: commit all changes before releasing"; exit 1)

release: check test
	docker tag ${URL}/${NAME}:${DEV} ${URL}/${NAME}:${VERSION}-amd64
	docker push ${URL}/${NAME}:${VERSION}-amd64
	docker buildx inspect tmp-builder >/dev/null 2>&1 || \
		docker buildx create --use --name tmp-builder
	docker run --privileged --rm tonistiigi/binfmt --install arm64 >/dev/null
	docker buildx build \
		--builder tmp-builder \
		--platform linux/arm64 \
		-t ${URL}/${NAME}:${VERSION}-arm64 \
		--push .
	docker buildx imagetools create \
		-t ${URL}/${NAME}:${VERSION} \
		-t ${URL}/${NAME}:latest \
		${URL}/${NAME}:${VERSION}-amd64 \
		${URL}/${NAME}:${VERSION}-arm64
	git tag -a $(VERSION) -m $(VERSION)
	git push origin $(VERSION)

clean:
	docker buildx rm tmp-builder

install-hooks:
	@echo "make format && make lint" > .git/hooks/pre-commit
	@echo "make test" > .git/hooks/pre-push
	@chmod +x .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-push
