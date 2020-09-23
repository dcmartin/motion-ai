#!/bin/bash

# get architecture

machine()
{
  local uname_machine=$(uname -m)
  local machine
  local supported=('intel-nuc' 'odroid-c2' 'odroid-n2' 'odroid-xu' 'qemuarm' 'qemuarm-64' 'qemux86' 'qemux86-64' 'raspberrypi' 'raspberrypi2' 'raspberrypi3' 'raspberrypi4' 'raspberrypi3-64' 'raspberrypi4-64' 'tinker' )

  # attempt to determine machine/model
  case ${uname_machine} in
    aarch64)
      machine='-m qemuarm-64'
      ;;
    arm*)
      local model=$(cat /proc/cpuinfo | egrep "^Model" | awk -F': ' '{ print $2 }')
      local rpi3='Raspberry Pi 3 Model'
      local rpi4='Raspberry Pi 4 Model'
      local rpi0='Raspberry Pi Zero Model'

      if [[ "${model:-null}" =~ ${rpi4:-null}* ]]; then
        machine='-m raspberrypi4'
      elif [[ "${model:-null}" =~ ${rpi3:-null}* ]]; then
        machine='-m raspberrypi3'
      elif [[ "${model:-null}" =~ ${rpi0:-null}* ]]; then
        machine='-m raspberrypi'
      else
        local hardware=$(cat /proc/cpuinfo | egrep "^Hardware" | awk -F': ' '{ print $2 }')

        if [ "${hardware:-null}" = 'BCM2835' ]; then
          machine='-m raspberrypi2'
        fi
      fi
      ;;
    *)
      ;;
  esac
  if [ "${machine:-null}" = 'null' ]; then
    echo "Architecture: ${uname_machine}; supported: ${supported}" &> /dev/stderr
  fi
  echo "${machine:-}"
}

###
### MAIN
###

export DEBIAN_FRONTEND=noninteractive

if [ "${USER:-null}" != 'root' ]; then
  echo "Please run as root; sudo ${0} ${*}" &> /dev/stderr
  exit 1
fi

if [ -z "$(command -v curl)" ]; then
  echo 'Install curl; sudo apt install -qq -y curl' &> /dev/stderr
  exit 1
fi

## DOCKER

if [ -z "$(command -v docker)" ]; then
  echo 'Getting Docker ..' &> /dev/stderr \
    && curl -sSL -o get.docker.sh 'get.docker.com' \
    && echo 'Installing Docker ..' &> /dev/stderr \
    && bash ./get.docker.sh \
    || echo 'Failed to install Docker' &> /dev/stderr
fi

CONFIG="/etc/docker/daemon.json"
if [ -s ${CONFIG} ]; then
  jq '."log-driver"="journald"|."storage-driver"="overlay2"' ${CONFIG} > /tmp/daemon.json
  mv -f /tmp/daemon.json ${CONFIG}
else
  echo '{"log-driver":"journald","storage-driver":"overlay2"}' > ${CONFIG}
fi
systemctl restart docker

addgroup ${SUDO_USER:-${USER}} docker

## UPDATE, UPGRADE, PACKAGES

echo 'Updating apt ...' &> /dev/stderr && apt update -qq -y \
  && echo 'Upgrading apt ...' &> /dev/stderr && apt upgrade -qq -y \
  && echo 'Installing pre-requisite packages' &> /dev/stderr \
  && apt install -qq -y network-manager software-properties-common apparmor-utils apt-transport-https avahi-daemon ca-certificates curl dbus jq socat iperf3 netdata git \
  || echo 'Failed to install pre-requisite software' &> /dev/stderr

echo 'Modifying NetworkManager to disable WiFi MAC randomization' \
  && echo '[device]' >> /etc/NetworkManager/NetworkManager.conf \
  && echo 'wifi.scan-rand-mac-address=no' >> /etc/NetworkManager/NetworkManager.conf \
  && echo 'Restarting network-manager' \
  && systemctl restart network-manager\
  || echo 'Failed to modify NetworkManager.conf' &> /dev/stderr

echo 'Modifying NetData to enable access from any host' \
  && sed -i 's/127.0.0.1/\*/' /etc/netdata/netdata.conf \
  && echo 'Restarting netdata' \
  && systemctl restart netdata \
  || echo 'Failed to modify netdata.conf' &> /dev/stderr

echo 'Disabling ModemManager' \
  && systemctl status ModemManager &> /dev/null \
  && systemctl stop ModemManager \
  && systemctl disable ModemManager

systemctl status ModemManager &> /dev/null && systemctl stop ModemManager && systemctl disable ModemManager

curl -sSL https://raw.githubusercontent.com/home-assistant/supervised-installer/master/installer.sh -o /tmp/hassio-install.sh \
  && \
  mv -f /tmp/hassio-install.sh ${0%/*}/hassio-install.sh \
  && \
  mv /tmp/installer.sh ${0%/*}/hassio-install.sh \
  && \
  chmod 755 ${0%/*}/hassio-install.sh \
  || \
  echo "Unable to download installer; using backup" &> /dev/stderr

echo "Installing using ${0%/*}/hassio-install.sh -d $(pwd -P) $(machine)" \
  && ${0%/*}/hassio-install.sh -d $(pwd -P) $(machine) \
  || echo 'Failed to get Home Assistant' &> /dev/stderr
