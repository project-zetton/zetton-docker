# zetton-docker
Docker images for development and deployment environment of Project Zetton.

## Prebuilt images

Prebuilt images are shared on [Docker Hub](https://hub.docker.com/r/projectzetton/zetton-docker/tags?page=1&ordering=last_updated).

## Usage

### Runtime Images

The `runtime` image provides environments which contains the following packages:

- Ubuntu 18.04
- CMake 3.19.2
- ROS Melodic
- OpenCV 4.4.0
- CUDA/cuDNN/TensorRT (GPU only)

Build commands:

1. For PC with CPU only

   ```bash
   RUNTIME_BASE_IMAGE_NAME=ubuntu:bionic \
   RUNTIME_IMAGE_NAME=projectzetton/zetton-docker:ubuntu18.04-runtime \
   ./script/build_runtime.sh
   ```

2. For PC with GPU support

   ```bash
   RUNTIME_BASE_IMAGE_NAME=nvcr.io/nvidia/tensorrt:20.03-py3 \
   RUNTIME_IMAGE_NAME=projectzetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-runtime \
   ./script/build_runtime.sh
   ```

3. For Jetson devices

   ```bash
   RUNTIME_BASE_IMAGE_NAME=nvcr.io/nvidia/deepstream-l4t:5.0-20.07-base \
   RUNTIME_IMAGE_NAME=projectzetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-jetson-runtime \
   ./script/build_runtime.sh
   ```

### Devel Images

In addition to the packages included in the `runtime` image, the ``devel` image also contains the following features.

- SSH on port `2222` with password in `Dockerfile.devel`
- yapf/clang-format/clangd
- Zsh with Oh-My-Zsh
- Csustom Tmux configuration

Build commands:

1. For PC with CPU only

   ```bash
   RUNTIME_IMAGE_NAME=projectzetton/zetton-docker:ubuntu18.04-runtime \
   DEVEL_IMAGE_NAME=projectzetton/zetton-docker:ubuntu18.04-devel \
   ./script/build_devel.sh
   ```

2. For PC with GPU support

   ```bash
   RUNTIME_IMAGE_NAME=projectzetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-runtime \
   DEVEL_IMAGE_NAME=projectzetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-devel \
   ./script/build_devel.sh
   ```

3. For Jetson devices

   ```bash
   RUNTIME_IMAGE_NAME=projectzetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-jetson-runtime \
   DEVEL_IMAGE_NAME=projectzetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-jetson-devel \
   ./script/build_devel.sh
   ```
