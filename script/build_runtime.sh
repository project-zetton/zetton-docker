#!/usr/bin/env bash

set -x

RUNTIME_BASE_IMAGE_NAME=${RUNTIME_BASE_IMAGE_NAME:-nvcr.io/nvidia/tensorrt:20.11-py3}
RUNTIME_IMAGE_NAME=${RUNTIME_IMAGE_NAME:-projectzetton/zetton-docker:cuda11.1-cudnn8-trt7.2.1-opencv4.5.2-ubuntu18.04-runtime}
RUNTIME_IMAGE_NUM_THREADS=${RUNTIME_IMAGE_NUM_THREADS:-4}
RUNTIME_IMAGE_USE_MIRROR=${RUNTIME_IMAGE_USE_MIRROR:-true}

docker build \
  -t "${RUNTIME_IMAGE_NAME}" \
  -f Dockerfile \
  --build-arg BASE_IMAGE="${RUNTIME_BASE_IMAGE_NAME}" \
  --build-arg NUM_THREADS="${RUNTIME_IMAGE_NUM_THREADS}" \
  --build-arg USE_MIRROR=${RUNTIME_IMAGE_USE_MIRROR} \
  --build-arg BUILD_ON_ARM=${RUNTIME_IMAGE_BUILD_ON_ARM} \
  .
