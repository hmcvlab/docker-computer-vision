FROM nvcr.io/nvidia/pytorch:25.12-py3

SHELL ["/bin/bash", "-c", "-o", "pipefail"]

ENV DEBIAN_FRONTEND=noninteractive \
  force_color_prompt=yes \
  PATH="/home/ubuntu/.local/bin:${PATH}"

RUN usermod -aG sudo ubuntu && \
  echo "ubuntu:ubuntu" | chpasswd

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
  git-lfs \
  libgl1 \
  libx11-6 \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

USER ubuntu
RUN python3 -m pip install --no-cache-dir \
  pip~=25.3 \
  && python3 -m pip install --no-cache-dir \
  cmaes~=0.11 \
  kaleido~=0.2 \
  open3d~=0.18 \
  opencv-python~=4.9 \
  optuna~=4.0 \
  rich~=13.7 \
  scikit-image~=0.25 \
  timm~=1.0 \
  transformers~=4.53 \
  ujson~=5.10

WORKDIR /home/ubuntu
