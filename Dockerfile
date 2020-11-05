ARG BASE_IMAGE=ubuntu:bionic

FROM ${BASE_IMAGE}
LABEL maintainer="xxdsox@gmail.com"

ARG ROS_DISTRO=melodic
ARG ROS_DESKTOP_FULL=false
ARG LOCAL_TIMEZONE="Asia/Shanghai"

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Setup timezone
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

# Install dependencies for building
RUN apt-get update && \
  apt-get install -q -y --no-install-recommends \
  build-essential cmake \
  libgoogle-glog-dev libgflags-dev libgtest-dev \
  libeigen3-dev libprotobuf-dev \
  autoconf libtool libssl-dev libjansson-dev libuv1-dev libproj-dev \
  inetutils-ping libpcl-dev libtool libtool-bin libpcap0.8-dev && \
  apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# Install dependencies for development
RUN apt-get update && \
  apt-get install -q -y --no-install-recommends \
  gawk rsync git curl wget tmux zsh vim htop iotop iftop \
  net-tools gdb \
  python3 python3-pip python3-dev && \
  apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# Install ROS
RUN apt-get update && \
  apt-get install -q -y --no-install-recommends dirmngr gnupg2 lsb-core && \
  apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
RUN curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add -
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros1-latest.list
RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  python-rosdep \
  python-rosinstall \
  python-vcstools && \
  apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
RUN rosdep init && \
  rosdep update --rosdistro ${ROS_DISTRO}
RUN apt-get update && \
  if [ "x$ROS_DESKTOP_FULL" = "xtrue" ] ; then \
  apt-get install -q -y \
  ros-${ROS_DISTRO}-ros-desktop-full ; \
  else \
  apt-get install -q -y \
  ros-${ROS_DISTRO}-ros-base \
  ros-${ROS_DISTRO}-jsk-recognition-msgs \
  ros-${ROS_DISTRO}-tf2-ros \
  ros-${ROS_DISTRO}-jsk-recognition-msgs \
  ros-${ROS_DISTRO}-eigen-conversions \
  ros-${ROS_DISTRO}-tf-conversions \
  ros-${ROS_DISTRO}-pcl-ros \
  ros-${ROS_DISTRO}-image-transport ; \
  fi && \
  apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# Setup dotfiles
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
  git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
  git clone https://github.com/zsh-users/zsh-completions.git $HOME/.oh-my-zsh/custom/plugins/zsh-completions
RUN chsh -s /bin/zsh root
RUN mkdir -p $HOME/.tmux/plugins && git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
COPY setup /root/.env-setup
RUN ln -sfn /root/.env-setup/.zshrc /root/.zshrc && \
  ln -sfn /root/.env-setup/.tmux.conf /root/.tmux.conf
RUN sed -i "s/melodic/${ROS_DISTRO}/g" /root/.zshrc

# Setup SSH
RUN apt-get update && \
  apt-get install -q -y --no-install-recommends openssh-server && \
  apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
RUN mkdir /var/run/sshd
RUN echo 'root:rsg[HQxFmRbygbZ7' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i "s/#Port 22/Port 2222/" /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 2222

# Install CMake from source
RUN cd /root/.env-setup && \
  echo '3.18\n4\n\n' | ./install_cmake.sh

# Clean
RUN apt-get clean && \
  rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/*

# setup entrypoint
COPY entrypoint.sh /sbin/entrypoint.sh
WORKDIR /
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD [ "/bin/zsh" ]
