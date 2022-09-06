ARG IMAGE_NAME
ARG PACKAGE_VERSION=8.4.3.1
ARG CUDA_VERSION=11.6.2
ARG OS_VERSION=ubuntu18.04
FROM ${IMAGE_NAME}:cuda-${CUDA_VERSION}-runtime-${OS_VERSION}

LABEL maintainer="Yusu Pan <xxdsox@gmail.com>"

# Install TensorRT
# currently only for x86_64
COPY deps/install_tensorrt.sh /tmp/
RUN /tmp/install_tensorrt.sh \
    && rm -rf /tmp/install_tensorrt.sh

# Install PyPI packages
COPY deps/requirements.txt /tmp/requirements.txt
RUN pip3 install --upgrade pip \
    && pip3 install setuptools>=41.0.0 \
    && pip3 install -r /tmp/requirements.txt \
    && pip3 install jupyter jupyterlab \
    && RUN pip3 install --upgrade numpy \
    && rm -rf /tmp/requirements.txt

# Set environment and working directory
# currently only for x86_64
# ENV TRT_LIBPATH /usr/lib/aarch64-linux-gnu/
ENV TRT_LIBPATH /usr/lib/x86_64-linux-gnu
ENV TRT_OSSPATH /workspace/TensorRT
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${TRT_OSSPATH}/build/out:${TRT_LIBPATH}"

WORKDIR /