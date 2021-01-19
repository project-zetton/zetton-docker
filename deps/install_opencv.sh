#!/usr/bin/env bash

set -ex

OPENCV_VERSION=${1:-"4.4.0"}
CUDA_ARCH=${2:-"6.1"}
NUM_THREADS=${3:-1}

# update pre-install apt-get packages
add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
apt-get update

# install developer tools
apt -yq install build-essential checkinstall cmake pkg-config
apt -yq install git gfortran

# install image I/O packages for loading various image file formats from disk
apt -yq install libjpeg8-dev libjpeg-dev libpng-dev
apt install libjasper1 libjasper-dev

#  GTK development library to build Graphical User Interfaces
apt -y install libgtk-3-dev libtbb-dev qt5-default

apt-get install -yq \
  libglew-dev \
  libtiff5-dev \
  zlib1g-dev \
  libpostproc-dev \
  libeigen3-dev \
  libtbb-dev \
  unzip \
  libgoogle-glog-dev \
  libgflags-dev
apt-get install -yq \
  ffmpeg \
  libavcodec-dev \
  libavformat-dev \
  libavutil-dev \
  libswscale-dev
apt-get install -yq \
  libgstreamer1.0-0 \
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
  libgstreamer-plugins-bad1.0-dev
apt -y install libv4l-dev libdc1394-22-dev
apt -y install libatlas-base-dev
apt -y install libfaac-dev libmp3lame-dev libtheora-dev
apt -y install libxvidcore-dev libx264-dev
apt -y install libopencore-amrnb-dev libopencore-amrwb-dev
apt -y install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen x264 v4l-utils
apt-get install -yq python-dev python-numpy python-py python-pytest
apt-get install -yq python3-dev python3-numpy python3-py python3-pytest

cd /tmp || exit && \
  wget --no-check-certificate https://github.com/opencv/opencv/archive/"${OPENCV_VERSION}".zip -O opencv.zip && \
  unzip opencv.zip && \
  wget --no-check-certificate https://github.com/opencv/opencv_contrib/archive/"${OPENCV_VERSION}".zip -O opencv_contrib.zip && \
  unzip opencv_contrib.zip && \
  cd /tmp/opencv-"${OPENCV_VERSION}" || exit && \
  mkdir -p build && cd build || exit && \
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
  .. && \
  make -j${NUM_THREADS} && \
  make install

apt-get clean && \
rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
