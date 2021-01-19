#!/usr/bin/env bash

RUNTIME_BASE_IMAGE_NAME=${RUNTIME_BASE_IMAGE_NAME:-nvcr.io/nvidia/tensorrt:20.11-py3}
RUNTIME_IMAGE_NAME=${RUNTIME_IMAGE_NAME:-projectzetton/zetton-docker:cuda11.1-cudnn8-trt7.2.1-ubuntu18.04-runtime}

docker build \
  -t "${RUNTIME_IMAGE_NAME}" \
  -f Dockerfile \
  --build-arg BASE_IMAGE="${RUNTIME_BASE_IMAGE_NAME}" \
  --build-arg NUM_THREADS=4 \
  --build-arg USE_MIRROR=false \
  .
