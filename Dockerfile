FROM nvcr.io/nvidia/pytorch:21.10-py3

SHELL ["/bin/bash", "-c", "-o", "pipefail"]

ENV DEBIAN_FRONTEND=noninteractive \
  force_color_prompt=yes

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
  libgl1 \
  libx11-6 \
  && rm -rf /var/lib/apt/lists/*

RUN  python3 -m pip uninstall \
  jupytext \
  mdit-py-plugins \
  && python3 -m pip install --no-cache-dir \
  pip~=24.2 \
  kaleido~=0.2 \
  open3d~=0.18 \
  optuna~=4.0 \
  transformers~=4.5 \
  werkzeug~=2.0

