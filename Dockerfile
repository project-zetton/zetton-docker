ARG BASE_IMAGE=nvcr.io/nvidia/tensorrt:20.09-py3

FROM ${BASE_IMAGE}
LABEL maintainer="xxdsox@gmail.com"

ARG ROS_DISTRO=melodic
ARG ROS_DESKTOP_FULL=false

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Setup timezone
ARG LOCAL_TIMEZONE="Asia/Shanghai"
RUN echo ${LOCAL_TIMEZONE} > /etc/timezone && \
  ln -sfn /usr/share/zoneinfo/${LOCAL_TIMEZONE} /etc/localtime && \
  apt-get update && \
  apt-get install -q -y --no-install-recommends expect expect-dev time tzdata apt-utils && \
  rm -rf /var/lib/apt/lists/*

# Enable deb-src
RUN apt-get update && \
  apt-get install -q -y --no-install-recommends sed && \
  apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
RUN sed -i '/^#\sdeb-src /s/^# *//' /etc/apt/sources.list

# Install dependencies for building and development
RUN apt-get update &&\
    apt-get install -q -y \
    build-essential cmake \
    libsm6 libxext6 libxrender-dev libgl1-mesa-glx software-properties-common \
    gawk rsync git curl wget tmux zsh vim htop iotop iftop \
    net-tools gdb && \
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# Install CMake
ARG CMAKE_VERSION=3.19.2
COPY deps/install_cmake.sh /tmp/
RUN /tmp/install_cmake.sh "${CMAKE_VERSION}" "${CMAKE_BUILD}"

# Install ROS
ARG ROS_DISTRO=melodic
COPY deps/install_ros.sh /tmp/
RUN /tmp/install_ros.sh "${ROS_DISTRO}"

# Install OpenCV
ARG OPENCV_VERSION=4.4.0
ARG OPENCV_CUDA_ARCH=6.1
COPY deps/install_opencv.sh /tmp/
RUN /tmp/install_opencv.sh "${OPENCV_VERSION}" "${OPENCV_CUDA_ARCH}"

# Setup dotfiles
COPY conf/.bashrc.custom /root/
RUN echo "source ~/.bashrc.custom" >> "$HOME"/.bashrc
RUN sed -i "s/melodic/${ROS_DISTRO}/g" /root/.bashrc.custom

WORKDIR /
