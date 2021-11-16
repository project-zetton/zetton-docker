#!/usr/bin/env bash

set -x

export RUNTIME_IMAGE_NUM_THREADS=4
export RUNTIME_IMAGE_USE_MIRROR=true
export RUNTIME_IMAGE_BUILD_ON_ARM=true
export RUNTIME_BASE_IMAGE_NAME="arm64v8/ubuntu:bionic"
export RUNTIME_IMAGE_NAME="projectzetton/zetton-docker:ubuntu18.04-gcc9-arm64v8-runtime"
export RUNTIME_IMAGE_BUILD_ON_ARM=true
export DEVEL_IMAGE_NAME="projectzetton/zetton-docker:ubuntu18.04-gcc9-arm64v8-devel"

./script/build_runtime.sh
./script/build_devel.sh
