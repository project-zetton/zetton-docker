#!/usr/bin/env bash

# for PC with CPU only
# RUNTIME_BASE_IMAGE_NAME=ubuntu:bionic
# RUNTIME_IMAGE_NAME=project-zetton/zetton-docker:ubuntu18.04-runtime

# for PC with GPU support
RUNTIME_BASE_IMAGE_NAME=nvcr.io/nvidia/tensorrt:20.03-py3
RUNTIME_IMAGE_NAME=project-zetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-runtime

# for Jetson device
# RUNTIME_BASE_IMAGE_NAME=nvcr.io/nvidia/deepstream-l4t:5.0-20.07-base
# RUNTIME_IMAGE_NAME=project-zetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-jetson-runtime

docker build \
  -t "${RUNTIME_IMAGE_NAME}" \
  -f Dockerfile \
  --build-arg BASE_IMAGE="${RUNTIME_BASE_IMAGE_NAME}" \
  .
