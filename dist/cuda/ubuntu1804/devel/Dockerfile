ARG PACKAGE_VERSION=11.2.0
ARG OS_VERSION=ubuntu18.04
FROM nvidia/cuda:${PACKAGE_VERSION}-devel-${OS_VERSION}

LABEL maintainer="Yusu Pan <xxdsox@gmail.com>"

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Required to build without user prompts
ENV DEBIAN_FRONTEND=noninteractive

# Enable repository mirrors for China
ARG USE_MIRROR="true"
COPY deps/setup_apt_mirror.sh /tmp/
RUN /tmp/setup_apt_mirror.sh "${USE_MIRROR}" \
    && rm -rf /tmp/setup_apt_mirror.sh

# Setup timezone
ARG TZ="Asia/Shanghai"
COPY deps/setup_timezone.sh /tmp/
RUN /tmp/setup_timezone.sh "${TZ}" \
    && rm -rf /tmp/setup_timezone.sh

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    rsync \
    git \
    curl \
    wget

ARG NUM_THREADS=1

# Install CMake
ARG CMAKE_VERSION=3.24.1
COPY deps/install_cmake.sh /tmp/
RUN /tmp/install_cmake.sh "${CMAKE_VERSION}" "${NUM_THREADS}" \
    && rm -rf /tmp/install_cmake.sh

# Install OpenCV
ARG OPENCV_VERSION=4.6.0
ARG OPENCV_CUDA_ARCH=6.1
COPY deps/install_opencv.sh /tmp/
RUN /tmp/install_opencv.sh "${OPENCV_VERSION}" "${OPENCV_CUDA_ARCH}" "${NUM_THREADS}" \
    && rm -rf /tmp/install_opencv.sh

# Install fmt from source
ARG FMT_VERSION=9.0.0
COPY deps/install_fmt.sh /tmp/
RUN /tmp/install_fmt.sh "${FMT_VERSION}" "${NUM_THREADS}" \
    && rm -rf /tmp/install_fmt.sh

# Install absl from source
ARG ABSL_VERSION=lts_2022_06_23
COPY deps/install_absl.sh /tmp/
RUN /tmp/install_absl.sh "${ABSL_VERSION}" "${NUM_THREADS}" \
    && rm -rf /tmp/install_absl.sh

# Setup dotfiles
COPY conf/.bashrc.custom /root/
RUN echo "source ~/.bashrc.custom" >> "$HOME"/.bashrc

ENV PATH "${PATH}:/usr/local/bin"
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/usr/local/lib:/usr/lib"
ENV PYTHONPATH "${PYTHONPATH}:/usr/local/lib/python3.6/site-packages"

# Setup SSH
COPY deps/setup_ssh.sh /tmp/
RUN /tmp/setup_ssh.sh \
    && rm -rf /tmp/setup_ssh.sh
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 2222

# Setup dev tools
COPY deps/setup_dev_tools.sh /tmp/
RUN /tmp/setup_dev_tools.sh \
    && rm -rf /tmp/setup_dev_tools.sh

# Setup dotfiles
COPY conf/.zshrc /root/
COPY conf/.tmux.conf /root/

ENTRYPOINT service ssh restart && zsh