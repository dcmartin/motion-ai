#!/bin/bash

<<<<<<< HEAD
if [ -z "$(command -v curl)" ]; then
  echo 'Install curl; sudo apt install -qq -y curl' &> /dev/stderr
  exit 1
fi

if [ -z "$(command -v docker)" ]; then
  echo 'Getting Docker ..' &> /dev/stderr \
    && curl -sSL -o get.docker.sh 'get.docker.com' \
    && echo 'Installing Docker ..' &> /dev/stderr \
    && sudo bash ./get.docker.sh \
    || echo 'Failed to install Docker' &> /dev/stderr
fi

=======
>>>>>>> upstream/master
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

<<<<<<< HEAD
export DEBIAN_FRONTEND=noninteractive

=======
if [ -z "$(command -v curl)" ]; then
  echo 'Install curl; sudo apt install -qq -y curl' &> /dev/stderr
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

sudo systemctl stop ModemManager
sudo systemctl disable ModemManager

if [ -z "$(command -v docker)" ]; then
  echo 'Getting Docker ..' &> /dev/stderr \
    && curl -sSL -o get.docker.sh 'get.docker.com' \
    && echo 'Installing Docker ..' &> /dev/stderr \
    && sudo bash ./get.docker.sh \
    || echo 'Failed to install Docker' &> /dev/stderr
fi

CONFIG="/etc/docker/daemon.json" \
  && jq '."log-driver"="journald"|."storage-driver"="overlay2"' ${CONFIG} > /tmp/daemon.json \
  && sudo mv -f /tmp/daemon.json ${CONFIG} \
  && sudo systemctl restart docker

>>>>>>> upstream/master
echo 'Updating apt ...' &> /dev/stderr \
  && sudo apt update -qq -y \
  && echo 'Upgrading apt ...' &> /dev/stderr \
  && sudo apt upgrade -qq -y \
  && echo 'Installing prerequisites ...' &> /dev/stderr \
<<<<<<< HEAD
  && sudo apt install -qq -y software-properties-common apparmor-utils apt-transport-https avahi-daemon ca-certificates curl dbus jq socat iperf3 netdata \
=======
  && sudo apt install -qq -y network-manager software-properties-common apparmor-utils apt-transport-https avahi-daemon ca-certificates curl dbus jq socat iperf3 netdata \
>>>>>>> upstream/master
  && echo 'Modifying /etc/netdata/netdata.conf to enable access from any host' \
  && sudo sed -i 's/127.0.0.1/\*/' /etc/netdata/netdata.conf \
  && echo 'Restarting netdata' \
  && sudo systemctl restart netdata \
<<<<<<< HEAD
  && echo 'Skipping network-manager; install with command: sudo apt install -qq -y network-manager' \
  && echo 'Installing HA using LOCAL ./sh/hassio-install.sh script' \
=======
  && echo "Installing using ./sh/hassio-install.sh -d $(pwd -P) $(machine)" \
>>>>>>> upstream/master
  && sudo ./sh/hassio-install.sh -d $(pwd -P) $(machine) \
  || echo 'Failed to get Home Assistant' &> /dev/stderr
