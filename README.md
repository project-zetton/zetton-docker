# zetton-docker
Docker images for development and deployment environment of Project Zetton.

## Prebuilt images

Prebuilt images are shared on [Docker Hub](https://hub.docker.com/r/projectzetton/zetton-docker/tags?page=1&ordering=last_updated).

## Build

```bash
./build.sh --package-name vanilla --os ubuntu --os-version 18.04 --arch amd64,arm64 --push
./build.sh --package-name ros --package-version melodic --os ubuntu --os-version 18.04 --arch amd64,arm64 --push
./build.sh --package-name cuda --package-version 11.6.2 --os ubuntu --os-version 18.04 --arch amd64 --push
```

## Usage

### Packages

- `vanilla`: pure Ubuntu image with basic tools
- `ros`: `vanilla` image with ROS installed
- `cuda`: Ubuntu image with CUDA installed
- `tensorrt`: `cuda` image with CUDA and TensorRT installed

### Categories

The `base` image provides a minimal environment with the following modifications:

- optional APT mirror
- correct timezone

The `runtime` image provides environments which contains the following packages:

- CMake
- OpenCV
- absl
- fmt

In addition to the packages included in the `runtime` image, the ``devel` image also contains the following features.

- SSH on port `2222` with password
- yapf & clang-format & clangd
- Zsh with Oh-My-Zsh
- Custom Tmux configuration
