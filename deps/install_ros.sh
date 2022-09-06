#!/usr/bin/env bash

set -ex

ROS_DISTRO=${1:-"melodic"}
ROS_METAPACKAGE=${2:-"desktop-full"}
ROS_PYTHON=${3:-"python2"}
USE_MIRROR=${4:-"false"}

apt-get update \
&& apt-get install -q -y --no-install-recommends dirmngr gnupg2 lsb-core curl

curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
if [ "x${USE_MIRROR}" = "xtrue" ] ; then
  echo "Use mirror for ROS installation"
  echo "deb https://mirrors.sjtug.sjtu.edu.cn/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list ;
else
  echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros1-latest.list ;
fi

if [ "x${ROS_PYTHON}" = "xpython2" ] ; then
  apt-get update \
  && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools
else
  apt-get update \
  && apt-get install --no-install-recommends -y \
    python3-rosdep \
    python3-rosinstall \
    python3-vcstools
fi

rosdep init \
&& rosdep update --rosdistro "${ROS_DISTRO}"

apt-get update \
&& apt-get install -q -y ros-"${ROS_DISTRO}"-${ROS_METAPACKAGE}

apt-get clean \
&& rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
