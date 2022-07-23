#!/usr/bin/env bash

RUNTIME_IMAGE_NAME=${RUNTIME_IMAGE_NAME:-projectzetton/zetton-docker:cuda11.1-cudnn8-trt7.2.1-opencv4.5.2-ubuntu18.04-runtime}
DEVEL_IMAGE_NAME=${DEVEL_IMAGE_NAME:-projectzetton/zetton-docker:cuda11.1-cudnn8-trt7.2.1-opencv4.5.2-ubuntu18.04-devel}
DEVEL_IMAGE_ROS_DISTRO=${DEVEL_IMAGE_ROS_DISTRO:-melodic}

docker build \
  -t "${DEVEL_IMAGE_NAME}" \
  -f Dockerfile.devel \
  --build-arg BASE_IMAGE="${RUNTIME_IMAGE_NAME}" \
  --build-arg ROS_DISTRO="${DEVEL_IMAGE_ROS_DISTRO}" \
  .
