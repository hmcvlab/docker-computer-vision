# Docker Image

The image is too large to build in CI, so format, lint, build, test and
release all run locally via the `Makefile`. CI only checks formatting and
lint.

## Development loop

```bash
# edit Dockerfile
make format lint   # check style (pre-commit hook)
make build         # builds hmcvlab/computer-vision:dev
make test          # runs tests inside the dev image (pre-push hook)
```

The image is tagged `dev` during development; version tags are only applied
to images that passed `make test`.

## Release

```bash
git commit -am "..."
make release VERSION=3.3.1
```

`release` requires a clean working tree and a tag that does not exist yet.
It pushes the tested amd64 image, builds and pushes the arm64 variant,
publishes `hmcvlab/computer-vision:VERSION` and `:latest`, then creates and
pushes git tag `VERSION`.

Requires `docker login` to Docker Hub. For arm64 support, the buildx builder
`tmp-builder` and QEMU are set up automatically; `make clean` removes the
builder.

## Run locally

```bash
docker run -it hmcvlab/computer-vision bash
```
