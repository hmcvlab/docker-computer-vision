#!/bin/bash

# Exit on error
set -e

# Function to display messages
log() {
  echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

# Detect architecture
ARCH=$(uname -m)
log "Detected architecture: $ARCH"

apt update -y
apt install -y build-essential cmake git python3-dev python3-pip \
  libgl1-mesa-dev libglu1-mesa-dev libosmesa6-dev \
  libglew-dev libglfw3-dev libx11-dev

# Install for x86_64/AMD64
if [ "$ARCH" = "x86_64" ]; then
  log "Installing Open3D for x86_64/AMD64 architecture using pip"
  python3 -m pip install open3d
  log "Open3D installation completed for x86_64/AMD64"

# Install for ARM (Jetson)
elif [[ $ARCH == "aarch64" || $ARCH == "arm"* ]]; then
  log "Installing Open3D for ARM architecture by building from source"

  # Clone
  cd /tmp
  git clone --recursive https://github.com/intel-isl/Open3D
  cd Open3D
  git submodule update --init --recursive
  mkdir build
  cd build

  # Configure
  # > Set -DBUILD_CUDA_MODULE=ON if CUDA is available (e.g. on Nvidia Jetson)
  # > Set -DBUILD_GUI=ON if OpenGL is available (e.g. on Nvidia Jetson)
  # > We don't support TensorFlow and PyTorch on ARM officially
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_CUDA_MODULE=OFF \
    -DBUILD_GUI=OFF \
    -DBUILD_TENSORFLOW_OPS=OFF \
    -DBUILD_PYTORCH_OPS=OFF \
    -DBUILD_UNIT_TESTS=ON \
    -DBUILD_EXAMPLES=OFF \
    -DCMAKE_INSTALL_PREFIX=~/open3d_install \
    -DPYTHON_EXECUTABLE="$(which python)" \
    ..

  # Build C++ library
  make -j"$(nproc)"

  # Run tests (optional)
  make tests -j"$(nproc)"
  ./bin/tests --gtest_filter="-*Reduce*Sum*"

  # Install C++ package (optional)
  make install

  # Install Open3D python package (optional)
  make install-pip-package -j"$(nproc)"
  python -c "import open3d; print(open3d)"
  # Cleanup
  rm -rf /tmp/Open3D

else
  log "Unsupported architecture: $ARCH"
  exit 1
fi
