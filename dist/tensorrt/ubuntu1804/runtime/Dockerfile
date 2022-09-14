ARG IMAGE_NAME
ARG PACKAGE_VERSION=8.4.3.1
ARG CUDA_VERSION=11.6.2
ARG OS_VERSION=ubuntu18.04

FROM ${IMAGE_NAME}:cuda-${CUDA_VERSION}-devel-${OS_VERSION} as base

FROM base as base-amd64
# Set environment and working directory
ENV TRT_LIBPATH /usr/lib/x86_64-linux-gnu
ENV TRT_OSSPATH /workspace/TensorRT
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${TRT_OSSPATH}/build/out:${TRT_LIBPATH}"

FROM base as base-arm64
# Set environment and working directory
ENV TRT_LIBPATH /usr/lib/aarch64-linux-gnu/
ENV TRT_OSSPATH /workspace/TensorRT
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${TRT_OSSPATH}/build/out:${TRT_LIBPATH}"

FROM base-${TARGETARCH}
ARG TARGETARCH
ARG PACKAGE_VERSION
ARG BASE_PACKAGE
ARG BASE_PACKAGE_VERSION
ARG OS_VERSION

LABEL maintainer="Yusu Pan <xxdsox@gmail.com>"

# Install TensorRT
COPY deps/install_tensorrt.sh /tmp/
RUN /tmp/install_tensorrt.sh \
    "${BASE_PACKAGE_VERSION}" \
    "${PACKAGE_VERSION}" \
    "${OS_VERSION}" \
    "${TARGETARCH}" \
    && rm -rf /tmp/install_tensorrt.sh

WORKDIR /
