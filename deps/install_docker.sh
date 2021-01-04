#!/usr/bin/env bash

set -ex

install_docker() {
  # install docker
  curl https://get.docker.com | sh \
    && sudo systemctl start docker \
    && sudo systemctl enable docker

  # non-root user
  sudo groupadd docker
  sudo usermod -aG docker $USER
  warning "Please log out and log in to take effects"
  # docker run hello-world
}

install_nvidia_docker() {
  # Add the package repositories
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

  # Install the package
  sudo apt-get update && sudo apt-get install -y nvidia-docker2
  sudo systemctl restart docker

  # Test nvidia-smi with the latest official CUDA image
  docker run --gpus all nvidia/cuda:11.0-base nvidia-smi
}

install_docker
install_nvidia_docker
