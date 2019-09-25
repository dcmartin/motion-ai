#!/bin/bash

 # curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey |   sudo apt-key add -
 # apt update -qq -y
 # apt upgrade -qq -y
 # sudo apt install -y nvidia-driver-390
 # sudo apt install -y nvidia-cuda-toolkit

docker run \
  --name digits \
  -d \
  -p 5000:5000 \
  -v digits-data:/data \
  -v digits-jobs:/jobs \
  --runtime=nvidia \
  nvidia/digits
