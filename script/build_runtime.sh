#!/usr/bin/env bash

RUNTIME_BASE_IMAGE_NAME=${RUNTIME_BASE_IMAGE_NAME:-nvcr.io/nvidia/tensorrt:20.03-py3}
RUNTIME_IMAGE_NAME=${RUNTIME_IMAGE_NAME:-projectzetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-runtime}

docker build \
  -t "${RUNTIME_IMAGE_NAME}" \
  -f Dockerfile \
  --build-arg BASE_IMAGE="${RUNTIME_BASE_IMAGE_NAME}" \
  .
