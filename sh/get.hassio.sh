#!/bin/bash

if [ -z "$(command -v docker)" ]; then
  echo 'Getting Docker ..' &> /dev/stderr \
    && curl -sSL -o get.docker.sh 'get.docker.com' \
    && echo 'Installing Docker ..' &> /dev/stderr \
    && sudo bash ./get.docker.sh \
    || echo 'Failed to install Docker' &> /dev/stderr
fi

export DEBIAN_FRONTEND=noninteractive
echo 'Updating apt ...' &> /dev/stderr \
  && sudo apt update -qq -y \
  && echo 'Upgrading apt ...' &> /dev/stderr \
  && sudo apt upgrade -qq -y \
  && echo 'Installing prerequisites ...' &> /dev/stderr \
  && sudo apt install -qq -y software-properties-common apparmor-utils apt-transport-https avahi-daemon ca-certificates curl dbus jq socat \
  && echo 'Skipping network-manager; sudo apt install -qq -y network-manager to install' \
  && echo 'Downloading shell script ...' &> /dev/stderr \
  && curl -sSL -o hassio-install.sh 'https://raw.githubusercontent.com/home-assistant/hassio-installer/master/hassio_install.sh' \
  && chmod 755 hassio-install.sh \
  && echo 'Now install using hassio-install.sh script; sudo ./hassio-install.sh -m raspberrypi3' &> /dev/stderr \
  || echo 'Failed to get Home Assistant' &> /dev/stderr
