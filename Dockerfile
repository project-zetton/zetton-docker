ARG BASE_IMAGE=nvcr.io/nvidia/tensorrt:20.03-py3

FROM ${BASE_IMAGE}
LABEL maintainer="xxdsox@gmail.com"

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Enable repository mirrors for China
ARG USE_MIRROR="true"
ARG BUILD_ON_ARM="false"
RUN if [ "x${USE_MIRROR}" = "xtrue" ] ; then echo "Use mirrors"; fi
RUN if [ "x${BUILD_ON_ARM}" = "xtrue" ] ; then echo "Build on ARM platform"; fi
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN if [ "x${USE_MIRROR}" = "xtrue" ] ; then \
  apt-get update && \
  apt-get install -q -y --no-install-recommends ca-certificates && \
  apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
  sed -i 's/ports.ubuntu.com/mirrors.sjtug.sjtu.edu.cn/g' /etc/apt/sources.list && \
  sed -i 's/archive.ubuntu.com/mirrors.sjtug.sjtu.edu.cn/g' /etc/apt/sources.list && \
  sed -i 's/archive.canonical.com/mirrors.sjtug.sjtu.edu.cn/g' /etc/apt/sources.list && \
  sed -i 's/security.ubuntu.com/mirrors.sjtug.sjtu.edu.cn/g' /etc/apt/sources.list && \
  sed -i 's/http:\/\/mirrors.sjtug.sjtu.edu.cn/https:\/\/mirrors.sjtug.sjtu.edu.cn/g' /etc/apt/sources.list; \
  fi

# Setup timezone
ARG LOCAL_TIMEZONE="Asia/Shanghai"
RUN echo ${LOCAL_TIMEZONE} > /etc/timezone && \
  ln -sfn /usr/share/zoneinfo/${LOCAL_TIMEZONE} /etc/localtime && \
  apt-get update && \
  apt-get install -q -y --no-install-recommends expect expect-dev time tzdata apt-utils && \
  apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

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

ARG NUM_THREADS=1

# Install GCC
# ARG GCC_VERSION=9
# COPY deps/install_gcc.sh /tmp/
# RUN /tmp/install_gcc.sh "${GCC_VERSION}"

# Install CMake
ARG CMAKE_VERSION=3.20.2
COPY deps/install_cmake.sh /tmp/
RUN /tmp/install_cmake.sh "${CMAKE_VERSION}" "${NUM_THREADS}"

# Install ROS
ARG ROS_DISTRO=melodic
COPY deps/install_ros.sh /tmp/
RUN /tmp/install_ros.sh "${ROS_DISTRO}" "${USE_MIRROR}"

# Install OpenCV
ARG OPENCV_VERSION=4.5.2
ARG OPENCV_CUDA_ARCH=6.1
COPY deps/install_opencv.sh /tmp/
RUN /tmp/install_opencv.sh "${OPENCV_VERSION}" "${OPENCV_CUDA_ARCH}" "${NUM_THREADS}"

# Install absl from source
ARG ABSL_VERSION=lts_2021_11_02
COPY deps/install_absl.sh /tmp/
RUN /tmp/install_absl.sh "${ABSL_VERSION}" "${NUM_THREADS}"

# Setup dotfiles
COPY conf/.bashrc.custom /root/
RUN echo "source ~/.bashrc.custom" >> "$HOME"/.bashrc
RUN sed -i "s/melodic/${ROS_DISTRO}/g" /root/.bashrc.custom

WORKDIR /
