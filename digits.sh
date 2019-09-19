#!/bin/bash
docker run \
  --name digits \
  -d \
  -p 5000:5000 \
  -v digits-data:/data \
  -v digits-jobs:/jobs \
  --runtime=nvidia \
  nvidia/digits
