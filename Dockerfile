FROM nvcr.io/nvidia/pytorch:21.10-py3

SHELL ["/bin/bash", "-c", "-o", "pipefail"]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
  libgl1 \
  libx11-6 \
  && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --no-cache-dir \
  kaleido~=0.2 \
  open3d-cpu~=0.18 \
  opencv-python~=4.10 \
  optuna~=4.0 \
  transformers~=4.5 \
  werkzeug~=2.0

