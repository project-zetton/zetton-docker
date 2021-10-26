#!/usr/bin/env bash

set -x

export RUNTIME_BASE_IMAGE_NAME="nvcr.io/nvidia/tensorrt:20.11-py3"
export RUNTIME_IMAGE_NAME="projectzetton/zetton-docker:cuda11.1-cudnn8-trt7.2.1-opencv4.5.2-ubuntu18.04-runtime"
export RUNTIME_IMAGE_NUM_THREADS=4
export RUNTIME_IMAGE_USE_MIRROR=true
export RUNTIME_IMAGE_BUILD_ON_ARM=false
export DEVEL_IMAGE_NAME="projectzetton/zetton-docker:cuda11.1-cudnn8-trt7.2.1-opencv4.5.2-ubuntu18.04-devel"

./script/build_runtime.sh
./script/build_devel.sh

export RUNTIME_BASE_IMAGE_NAME="ubuntu:bionic"
export RUNTIME_IMAGE_NAME="projectzetton/zetton-docker:ubuntu18.04-runtime"
export DEVEL_IMAGE_NAME="projectzetton/zetton-docker:ubuntu18.04-devel"

./script/build_runtime.sh
./script/build_devel.sh

export RUNTIME_BASE_IMAGE_NAME="arm64v8/ubuntu:bionic"
export RUNTIME_IMAGE_NAME="projectzetton/zetton-docker:ubuntu18.04-arm64v8-runtime"
export RUNTIME_IMAGE_BUILD_ON_ARM=true
export DEVEL_IMAGE_NAME="projectzetton/zetton-docker:ubuntu18.04-arm64v8-devel"

./script/build_runtime.sh
./script/build_devel.sh