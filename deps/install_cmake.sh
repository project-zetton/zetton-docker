#!/usr/bin/env bash

set -ex

CMAKE_VERSION=${1:-"3.19.2"}

# install dependencies for SSL support
apt-get install zlib1g-dev && \
  apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# get latest cmake source
cd /tmp

wget https://github.com/Kitware/CMake/releases/download/v"${CMAKE_VERSION}"/cmake-"${CMAKE_VERSION}".tar.gz && \
tar -xzvf cmake-"${CMAKE_VERSION}".tar.gz && \
cd cmake-"${CMAKE_VERSION}"

# build cmake
./bootstrap --system-curl && \
  make && \
  make install && \
  cmake --version && \
  rm -rf /tmp/*
