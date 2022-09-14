ARG IMAGE_NAME
ARG BASE_PACKAGE=vanilla
ARG OS_VERSION=ubuntu18.04
FROM ${IMAGE_NAME}:${BASE_PACKAGE}-runtime-${OS_VERSION}

LABEL maintainer="Yusu Pan <xxdsox@gmail.com>"

# Install ROS
ARG PACKAGE_VERSION=melodic
ARG ROS_METAPACKAGE=ros-base
ARG ROS_PYTHON=python2
ARG USE_MIRROR="true"
COPY deps/install_ros.sh /tmp/
RUN /tmp/install_ros.sh \
    "${PACKAGE_VERSION}" \
    "${ROS_METAPACKAGE}" \
    "${ROS_PYTHON}" \
    "${USE_MIRROR}"

# Setup dotfiles
RUN sed -i "s/melodic/${PACKAGE_VERSION}/g" /root/.bashrc.custom
