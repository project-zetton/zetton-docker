# zetton-docker
Docker images for development and deployment environment of Project Zetton.

## Prebuilt images

Prebuilt images are shared on [Docker Hub](https://hub.docker.com/r/projectzetton/zetton-docker/tags?page=1&ordering=last_updated).

## Usage

### Runtime Images

The `runtime` image provides environments which contains the following packages:

- Ubuntu 18.04
- CMake 3.20.2
- ROS Melodic
- OpenCV 4.5.2
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
   RUNTIME_BASE_IMAGE_NAME=nvcr.io/nvidia/tensorrt:20.11-py3 \
   RUNTIME_IMAGE_NAME=projectzetton/zetton-docker:cuda11.1-cudnn8-trt7.2.1-opencv4.5.2-ubuntu18.04-runtime \
   ./script/build_runtime.sh
   ```

3. For Jetson devices

   ```bash
   ./script/build_jetson.sh
   ```

### Devel Images

In addition to the packages included in the `runtime` image, the ``devel` image also contains the following features.

- SSH on port `2222` with password in `Dockerfile.devel`
- yapf & clang-format & clangd
- Zsh with Oh-My-Zsh
- Custom Tmux configuration

Build commands:

1. For PC with CPU only

   ```bash
   RUNTIME_IMAGE_NAME=projectzetton/zetton-docker:ubuntu18.04-runtime \
   DEVEL_IMAGE_NAME=projectzetton/zetton-docker:ubuntu18.04-devel \
   ./script/build_devel.sh
   ```

2. For PC with GPU support

   ```bash
   RUNTIME_IMAGE_NAME=projectzetton/zetton-docker:cuda11.1-cudnn8-trt7.2.1-opencv4.5.2-ubuntu18.04-runtime \
   DEVEL_IMAGE_NAME=projectzetton/zetton-docker:cuda11.1-cudnn8-trt7.2.1-opencv4.5.2-ubuntu18.04-devel \
   ./script/build_devel.sh
   ```

3. For Jetson devices: already included in `./script/build_jetson.sh`
