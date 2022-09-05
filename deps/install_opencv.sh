#!/usr/bin/env bash

set -ex

OPENCV_VERSION=${1:-"4.4.0"}
CUDA_ARCH=${2:-"6.1"}
NUM_THREADS=${3:-1}

# update pre-install apt-get packages
apt-get update

# required build dependencies
apt-get install -y --no-install-recommends \
  gcc \
  g++ \
  checkinstall \
  pkg-config

# gui features
apt-get install -y --no-install-recommends \
  libgtk-3-dev \
  libtbb-dev \
  qt5-default

# media support (ffmpeg)
apt-get install -y --no-install-recommends \
  ffmpeg \
  libavcodec-dev \
  libavformat-dev \
  libavutil-dev \
  libswscale-dev

# media support (gstreamer)
apt-get install -y --no-install-recommends \
  libgstreamer1.0-dev \
  libgstreamer-plugins-base1.0-dev \
  libgstreamer-plugins-bad1.0-dev \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-libav \
  gstreamer1.0-doc \
  gstreamer1.0-tools \
  gstreamer1.0-x \
  gstreamer1.0-alsa \
  gstreamer1.0-gl \
  gstreamer1.0-gtk3 \
  gstreamer1.0-qt5 \
  gstreamer1.0-pulseaudio \
  libgstreamer-plugins-base1.0-dev \
  libgstreamer-plugins-good1.0-dev \
  libgstreamer-plugins-bad1.0-dev \
  libgstrtspserver-1.0-dev

# camera support (v4l)
apt-get install -y --no-install-recommends libv4l-dev

# python support
apt-get install -y --no-install-recommends \
  python-dev \
  python-numpy \
  python3-dev \
  python3-numpy

# extra dependencies
apt-get install -y --no-install-recommends \
  libjpeg8-dev \
  libjpeg-dev \
  libpng-dev \
  wget \
  unzip \
  git \
  libtbb-dev

# archived dependencies
# apt-get -y install libv4l-dev libdc1394-22-dev
# apt-get -y install libatlas-base-dev
# apt-get -y install libfaac-dev libmp3lame-dev libtheora-dev
# apt-get -y install libxvidcore-dev libx264-dev
# apt-get -y install libopencore-amrnb-dev libopencore-amrwb-dev
# apt-get -y install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen x264 v4l-utils
# apt-get install -y --no-install-recommends \
#   libglew-dev \
#   libtiff5-dev \
#   zlib1g-dev \
#   libpostproc-dev \
#   libeigen3-dev \
#   libgoogle-glog-dev \
#   libgflags-dev \
#   build-essential \
#   gfortran

cd /tmp || exit &&
  wget --no-check-certificate https://github.com/opencv/opencv/archive/"${OPENCV_VERSION}".zip -O opencv.zip &&
  unzip opencv.zip &&
  wget --no-check-certificate https://github.com/opencv/opencv_contrib/archive/"${OPENCV_VERSION}".zip -O opencv_contrib.zip &&
  unzip opencv_contrib.zip &&
  cd /tmp/opencv-"${OPENCV_VERSION}" || exit &&
  mkdir -p build && cd build || exit &&
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="/usr/local" \
    -DBUILD_TESTS=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_opencv_java=OFF \
    -DBUILD_opencv_python2=OFF \
    -DBUILD_opencv_python3=ON \
    -DWITH_OPENCL=OFF \
    -DWITH_OPENMP=OFF \
    -DWITH_FFMPEG=ON \
    -DWITH_GSTREAMER=ON \
    -DWITH_GSTREAMER_0_10=OFF \
    -DWITH_CUDA=OFF \
    -DWITH_NVCUVID=OFF \
    -DWITH_CUBLAS=OFF \
    -DENABLE_FAST_MATH=ON \
    -DCUDA_FAST_MATH=OFF \
    -DWITH_GTK=ON \
    -DWITH_VTK=OFF \
    -DWITH_TBB=ON \
    -DWITH_1394=OFF \
    -DWITH_OPENEXR=OFF \
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
    -DCUDA_ARCH_BIN="${CUDA_ARCH}" \
    -DCUDA_ARCH_PTX="" \
    -DINSTALL_C_EXAMPLES=OFF \
    -DINSTALL_PYTHON_EXAMPLES=OFF \
    -DINSTALL_TESTS=OFF \
    -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${OPENCV_VERSION}/modules \
    -DOPENCV_ENABLE_NONFREE=ON \
    -DOPENCV_GENERATE_PKGCONFIG=YES \
    .. &&
  make -j${NUM_THREADS} &&
  make install

apt-get clean &&
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
