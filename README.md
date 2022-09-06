# zetton-docker

Docker images for development and deployment environment of Project Zetton.

## Prebuilt images

Prebuilt images are shared on [Docker Hub](https://hub.docker.com/r/projectzetton/zetton-docker/tags?page=1&ordering=last_updated).

## Building from source

The container image scripts are archived in the `dist/` directory and are available for supported distros and package versions.

Here is an example on how to build an multi-arch container image based on vanilla Ubuntu 18.04:

```bash
./build.sh --package-name vanilla --os ubuntu --os-version 18.04 --arch amd64,arm64 --push
```

More examples:

```bash
# build vanilla images
./build.sh --package-name vanilla --os ubuntu --os-version 18.04 --arch amd64,arm64 --push
# build ros images
./build.sh --package-name ros --package-version melodic --os ubuntu --os-version 18.04 --arch amd64,arm64 --push
# build cuda images
./build.sh --package-name cuda --package-version 11.6.2 --os ubuntu --os-version 18.04 --arch amd64 --push
# build tensorrt images
./build.sh --package-name tensorrt --package-version 8.4.3.1 --os ubuntu --os-version 18.04 --arch amd64 --push --extra-args "--build-arg CUDA_VERSION=11.6.2"
```

See `./build.sh --help` for detailed usage.

## Usage

### Image Tags

```bash
projectzetton/zetton-docker:<package_name>(-<package_version>)-<category>-<os_version>
```

- `<package_name>`:
  - `vanilla`
  - `ros`
  - `cuda`
  - `tensorrt`
- `<package_version>` (optional)
  - `vanilla` is empty
  - `ros` is the ROS distro name
  - `cuda` is the CUDA version
  - `tensorrt` is the TensorRT version
- `<category>`:
  - `base`
  - `runtime`
  - `devel`
- `<os_version>`:
  - `ubuntu18.04`

### Packages

- `vanilla`: pure Ubuntu image with basic tools
- `ros`: `vanilla` image with ROS installed
- `cuda`: Ubuntu image with CUDA installed
- `tensorrt`: `cuda` image with TensorRT and othter deep learning related packages (e.g., PyTorch, TensorFlow and ONNX) installed

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

## Acknowledgement

- The container image scripts are based on [nvidia/container-images/cuda](https://gitlab.com/nvidia/container-images/cuda)
