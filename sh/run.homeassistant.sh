#!/bin/bash

if [ -z "${EXT_PORT:-}" ] && [ -s EXT_PORT ]; then EXT_PORT=$(cat EXT_PORT); fi; EXT_PORT=${EXT_PORT:-8123}
if [ -z "${INT_PORT:-}" ] && [ -s INT_PORT ]; then INT_PORT=$(cat INT_PORT); fi; INT_PORT=${INT_PORT:-8123}
if [ -z "${HOST_PORT:-}" ] && [ -s HOST_PORT ]; then HOST_PORT=$(cat HOST_PORT); EXT_PORT=${HOST_PORT}; INT_PORT=${HOST_PORT}; fi; HOST_PORT=${HOST_PORT:-${EXT_PORT}}

docker rm -f homeassistant
docker run --restart=unless-stopped --init -d --name="homeassistant" -e "TZ=America/Los_Angeles" -v ~/GIT/motion-ai/homeassistant:/config -p ${EXT_PORT}:${INT_PORT} homeassistant/home-assistant:stable
