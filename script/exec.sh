#!/usr/bin/env bash

docker start zetton
xhost +local:docker
docker exec \
  -it zetton \
  /bin/bash
