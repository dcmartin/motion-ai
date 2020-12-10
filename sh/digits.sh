#!/bin/bash

 # curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey |   sudo apt-key add -
 # apt update -qq -y
 # apt upgrade -qq -y
 # sudo apt install -y nvidia-driver-390
 # sudo apt install -y nvidia-cuda-toolkit

DATA_DIR=${HOME}/.digits/data
JOBS_DIR=${HOME}/.digits/jobs

ORIGINAL='nvidia/digits'
STABLE='nvcr.io/nvidia/digits:20.06-tensorflow-py3'
LATEST='nvcr.io/nvidia/digits:20.11-tensorflow-py3'

TAG="${LATEST}"

mkdir -p ${DATA_DIR} ${JOBS_DIR}

docker run \
  --name digits \
  --restart=unless-stopped \
  -d \
  -p 5000:5000 \
  -v digits-data:${DATA_DIR} \
  -v digits-jobs:${JOBS_DIR} \
  --runtime=nvidia \
  ${TAG}
