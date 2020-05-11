#!/bin/bash

if [ -z "${HOST_PORT:-}" ] && [ -s HOST_PORT ]; then HOST_PORT=$(cat HOST_PORT); fi; HOST_PORT=${HOST_PORT:-8123}

docker rm -f homeassistant
docker run --restart=unless-stopped --init -d --name="homeassistant" -e "TZ=America/Los_Angeles" -v ~/GIT/motion-ai/homeassistant:/config -p ${HOST_PORT}:8123 homeassistant/home-assistant:stable
