FROM nvcr.io/nvidia/pytorch:21.10-py3

SHELL ["/bin/bash", "-c", "-o", "pipefail"]

RUN python3 -m pip install --no-cache-dir \
  kaleido~=0.2 \
  open3d~=0.18 \
  opencv-python~=4.10 \
  optuna~=4.0 \
  transformers~=4.5 \
  werkzeug~=2.0

