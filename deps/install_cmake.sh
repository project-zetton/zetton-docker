#!/usr/bin/env bash

set -ex

CMAKE_VERSION=${1:-"3.27.8"}
NUM_THREADS=${2:-1}

# install dependencies for SSL support
apt-get update && \
  apt-get install -q -y zlib1g-dev libssl-dev && \
  apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# get latest cmake source
cd /tmp

wget https://github.com/Kitware/CMake/releases/download/v"${CMAKE_VERSION}"/cmake-"${CMAKE_VERSION}".tar.gz && \
tar -xzvf cmake-"${CMAKE_VERSION}".tar.gz && \
cd cmake-"${CMAKE_VERSION}"

# build cmake
./bootstrap --prefix=/usr/local --parallel=${NUM_THREADS} && \
  make -j${NUM_THREADS} && \
  make install && \
  cmake --version && \
  rm -rf /tmp/*
