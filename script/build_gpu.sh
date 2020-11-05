#!/usr/bin/env bash

docker build \
  -t project-zetton/zetton-docker:gpu \
  -f Dockerfile \
  --build-arg BASE_IMAGE=nvcr.io/nvidia/tensorrt:20.03-py3 \
  .

