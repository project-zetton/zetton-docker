#!/usr/bin/env bash

RUNTIME_IMAGE_NAME=${RUNTIME_IMAGE_NAME:-projectzetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-runtime}
DEVEL_IMAGE_NAME=${DEVEL_IMAGE_NAME:-projectzetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-devel}

docker build \
  -t "${DEVEL_IMAGE_NAME}" \
  -f Dockerfile.devel \
  --build-arg BASE_IMAGE="${RUNTIME_IMAGE_NAME}" \
  .
