#!/usr/bin/env bash

# for PC with CPU only
# RUNTIME_IMAGE_NAME=project-zetton/zetton-docker:ubuntu18.04-runtime
# DEVEL_IMAGE_NAME=project-zetton/zetton-docker:ubuntu18.04-devel

# for PC with GPU support
RUNTIME_IMAGE_NAME=project-zetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-runtime
DEVEL_IMAGE_NAME=project-zetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-devel

# for Jetson device
# RUNTIME_IMAGE_NAME=project-zetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-jetson-runtime
# DEVEL_IMAGE_NAME=project-zetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-jetson-devel

docker build \
  -t "${DEVEL_IMAGE_NAME}" \
  -f Dockerfile.devel \
  --build-arg BASE_IMAGE="${RUNTIME_IMAGE_NAME}" \
  .
