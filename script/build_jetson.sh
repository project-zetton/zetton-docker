#!/usr/bin/env bash

RUNTIME_BASE_IMAGE_NAME=${RUNTIME_BASE_IMAGE_NAME:-nvcr.io/nvidia/deepstream-l4t:5.1-21.02-base}
RUNTIME_IMAGE_NAME=${RUNTIME_IMAGE_NAME:-projectzetton/zetton-docker:cuda10.2-cudnn8-trt7.1.3-ubuntu18.04-jetson-runtime}

docker build \
  -t "${RUNTIME_IMAGE_NAME}" \
  -f Dockerfile.jetson \
  --build-arg BASE_IMAGE="${RUNTIME_BASE_IMAGE_NAME}" \
  --build-arg NUM_THREADS=4 \
  --build-arg USE_MIRROR=true \
  --build-arg JETSON_SOC="t194" \
  --build-arg JETSON_L4T_VERSION="r32.5" \
  .

