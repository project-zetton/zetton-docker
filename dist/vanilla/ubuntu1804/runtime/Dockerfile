ARG IMAGE_NAME
FROM ${IMAGE_NAME}:vanilla-base-ubuntu18.04

LABEL maintainer="Yusu Pan <xxdsox@gmail.com>"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    rsync \
    git \
    curl \
    wget

ARG NUM_THREADS=1

# Install CMake
ARG CMAKE_VERSION=3.27.8
COPY deps/install_cmake.sh /tmp/
RUN /tmp/install_cmake.sh "${CMAKE_VERSION}" "${NUM_THREADS}" \
    && rm -rf /tmp/install_cmake.sh

# Install OpenCV
ARG OPENCV_VERSION=4.8.0
ARG OPENCV_CUDA_ARCH=6.1
COPY deps/install_opencv.sh /tmp/
RUN /tmp/install_opencv.sh "${OPENCV_VERSION}" "${OPENCV_CUDA_ARCH}" "${NUM_THREADS}" \
    && rm -rf /tmp/install_opencv.sh

# Install fmt from source
ARG FMT_VERSION=10.1.1
COPY deps/install_fmt.sh /tmp/
RUN /tmp/install_fmt.sh "${FMT_VERSION}" "${NUM_THREADS}" \
    && rm -rf /tmp/install_fmt.sh

# Install absl from source
ARG ABSL_VERSION=lts_2023_08_02
COPY deps/install_absl.sh /tmp/
RUN /tmp/install_absl.sh "${ABSL_VERSION}" "${NUM_THREADS}" \
    && rm -rf /tmp/install_absl.sh

# Setup dotfiles
COPY conf/.bashrc.custom /root/
RUN echo "source ~/.bashrc.custom" >> "$HOME"/.bashrc

ENV PATH "${PATH}:/usr/local/bin"
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/usr/local/lib:/usr/lib"
ENV PYTHONPATH "${PYTHONPATH}:/usr/local/lib/python3.6/site-packages"
