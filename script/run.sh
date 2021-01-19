#!/usr/bin/env bash

IMAGE_TO_RUN=${DEVEL_IMAGE_NAME:-projectzetton/zetton-docker:cuda10.2-cudnn7-trt7.0.0-ubuntu18.04-devel}

docker stop zetton || true
docker rm zetton || true

xhost +local:docker
docker run -it \
  --rm \
  --privileged \
  --ipc=host \
  --network=host \
  --runtime=nvidia \
  --env="DISPLAY=$DISPLAY" \
  --env="NVIDIA_VISIBLE_DEVICES=all" \
  --env="NVIDIA_DRIVER_CAPABILITIES=all" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --volume="${PWD}:/workspace" \
  "${IMAGE_TO_RUN}"
