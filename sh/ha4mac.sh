#!/bin/bash
docker rm -f homeassistant
docker run --restart=unless-stopped --init -d --name="homeassistant" -e "TZ=America/Los_Angeles" -v ~/GIT/motion-ai/homeassistant:/config -p 8123:8123 homeassistant/home-assistant:stable
