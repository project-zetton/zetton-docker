#!/usr/bin/env bash

set -ex

ROS_DISTRO=${1:-melodic}
USE_MIRROR=${2:-false}

apt-get update && \
apt-get install -q -y --no-install-recommends dirmngr gnupg2 lsb-core

curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add -
if [ "x${USE_MIRROR}" = "xtrue" ] ; then
  echo "deb https://mirrors.sjtug.sjtu.edu.cn/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list ;
else
  echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros1-latest.list ;
fi
apt-get update && \
apt-get install --no-install-recommends -y \
  python-rosdep \
  python-rosinstall \
  python-vcstools

rosdep init && \
rosdep update --rosdistro "${ROS_DISTRO}"

apt-get update && \
  apt-get install -q -y ros-"${ROS_DISTRO}"-desktop-full

apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
