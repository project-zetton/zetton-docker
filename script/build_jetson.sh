#!/usr/bin/env bash

# Build general image on host pc
docker build \
  -t project-zetton/zetton-docker:jetson \
  -f Dockerfile \
  --build-arg BASE_IMAGE=nvcr.io/nvidia/deepstream-l4t:5.0-20.07-base \
  .
