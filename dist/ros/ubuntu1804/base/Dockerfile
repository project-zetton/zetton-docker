ARG IMAGE_NAME
FROM ${IMAGE_NAME}:vanilla-base-ubuntu18.04

LABEL maintainer="Yusu Pan <xxdsox@gmail.com>"

# Install ROS
ARG PACKAGE_VERSION=melodic
ARG ROS_METAPACKAGE=ros-base
ARG ROS_PYTHON=python2
COPY deps/install_ros.sh /tmp/
RUN /tmp/install_ros.sh \
    "${PACKAGE_VERSION}" \
    "${ROS_METAPACKAGE}" \
    "${ROS_PYTHON}" \
    "${USE_MIRROR}"

# Setup dotfiles
COPY conf/.bashrc.custom /root/
RUN echo "source ~/.bashrc.custom" >> "$HOME"/.bashrc
RUN sed -i "s/melodic/${PACKAGE_VERSION}/g" /root/.bashrc.custom
