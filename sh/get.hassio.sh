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

function motionai::get()
{
  local pull=${1:-pull}

  echo 'Downloading yolo weights'; \
    bash ${0%/*}/get.weights.sh \
    || \
    echo "Unable to download weights; use ${0%/*}/get.weights.sh" &> /dev/stderr

  # build YAML
  echo "Building YAML; using default password: ${PASSWORD:-password}"
  yes "${PASSWORD:-password}" | make 2>&1 >> install.log

  # change ownership
  echo "Changing ownership on homeassistant/ directory"
  chown -R ${SUDO_USER:-${USER}} homeassistant/

  for m in yolo face alpr; do \
    echo "Executing ${pull} on container for AI: ${m}"; \
    bash ${0%/*}/${m}4motion.sh ${pull} \
    || \
    echo "Unable to ${pull} container for AI: ${m}; use ${0%/*}/${m}4motion.sh" &> /dev/stderr
  done
}

function docker_update()
{
  local CONFIG=${1}
  local restart='false'
  local nvcc='/usr/local/cuda/bin/nvcc'

  # LOGGING
  if [ ! -s "${CONFIG}" ]; then
    echo '{"log-driver":"journald","storage-driver":"overlay2"}' > ${CONFIG}
    restart='true'
  elif [ $(jq -r '."log-driver"' ${CONFIG}) != 'journald' ] || [ $(jq -r '."storage-driver"' ${CONFIG}) != 'overlay2' ]; then
    jq '."log-driver"="journald"|."storage-driver"="overlay2"' ${CONFIG} > ${CONFIG}.$$
    mv -f ${CONFIG}.$$ ${CONFIG}
    restart='true'
  fi

  # CUDA
  if [ -e ${nvcc} ]; then 
    local runtime='/usr/bin/nvidia-container-runtime'

    if [ -e "${runtime}" ]; then
      if [ $(jq -r '."default-runtime"?' ${CONFIG}) != 'nvidia' ] || [ $(jq -r '.experimental?' ${CONFIG}) != 'true' ]; then
        jq '."default-runtime"="nvidia"|.runtimes+={"nvidia":{"path":"'${runtime}'","runtimeArgs":[]}}|.experimental=true' ${CONFIG} > ${CONFIG}.$$
        mv -f ${CONFIG}.$$ ${CONFIG}
        restart='true'
      fi
    else
      echo "Did not find runtime: ${runtime}" &> /dev/stderr
    fi
  fi
  if [ "${restart:-false}" = 'true' ]; then
    echo "Restarting Docker" &> /dev/stderr
    systemctl restart docker
  fi
}

###
### MAIN
###

if [ $(uname -s) != 'Linux' ]; then
  echo 'Only for LINUX' &> /dev/stderr
  exit 1
fi

if [ "${USER:-null}" != 'root' ]; then
  echo "Please run as root; sudo ${0} ${*}" &> /dev/stderr
  exit 1
fi

# test network

alive=$(curl -fsqL -w '%{http_code}' --connect-timeout 20 --retry-connrefused --retry 10 --retry-max-time 40 --max-time 60 "https://version.home-assistant.io/stable.json" -o /dev/null 2> /dev/null || true)
if [ "${alive:-}" != '200' ]; then
  echo 'Unable to contact "https://version.home-assistant.io/stable.json"; is your DNS configured properly?' &> /dev/stderr
  exit 1
fi

## UPDATE, UPGRADE, PACKAGES

echo 'Updating ...' &> /dev/stderr \
  && DEBIAN_FRONTEND=noninteractive apt update -qq -y 2>&1 >> install.log \
  || echo 'Failed to update software catalog' &> /dev/stderr

echo 'Installing pre-requisite packages ...' &> /dev/stderr \
  && DEBIAN_FRONTEND=noninteractive apt install -qq -y --no-install-recommends \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    make \
    mosquitto-clients \
    socat \
    iperf3 \
    jq \
    curl \
    git \
    build-essential \
    gettext \
    netdata 2>&1 >> install.log \
  || echo 'Failed to install pre-requisite software' &> /dev/stderr

## DOCKER

if [ -z "$(command -v docker)" ]; then
  echo 'Getting Docker ..' &> /dev/stderr \
    && curl -sSL -o get.docker.sh 'get.docker.com' \
    && echo 'Installing Docker ..' &> /dev/stderr \
    && bash ./get.docker.sh \
    || echo 'Failed to install Docker' &> /dev/stderr
fi

docker_update "/etc/docker/daemon.json"

addgroup ${SUDO_USER:-${USER}} docker

if [ ! -e /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf ]; then
  echo 'Modifying NetworkManager to disable WiFi MAC randomization' \
  && mkdir -p /etc/NetworkManager/conf.d \
  && echo '[connection]' > /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf \
  && echo 'wifi.mac-address-randomization=1' >> /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf \
  && echo '[device]' >> /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf \
  && echo 'wifi.scan-rand-mac-address=no' >> /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf \
  && echo 'Restarting network-manager' \
  && systemctl restart network-manager\
  || echo 'Failed to modify NetworkManager.conf' &> /dev/stderr
fi

echo 'Modifying NetData to enable access from any host' \
  && sed -i 's/127.0.0.1/\*/' /etc/netdata/netdata.conf \
  && echo 'SEND_EMAIL="NO"' > /etc/netdata/health_alarm_notify.conf \
  && echo 'Restarting netdata' \
  && systemctl restart netdata \
  || echo 'Failed to modify netdata.conf' &> /dev/stderr

# download AI containers and models
if [ "${0##*/}" == 'get.motion-ai.sh' ]; then

  # get container images and weights for AI(s)
  motionai::get 'run' &

  # wait for HA
  echo -n "Waiting on Home Assistant "
  sleep 30
  t=0; while [ ! -z "$(command -v ha)" ]; do
    info=$(ha core info 2> /dev/null | egrep '^version:' | awk '{ print $2 }')
    t=$((t+1))
    if [ ! -z "${info:-}" ] && [ "${info}" != 'landingpage' ]; then break; fi
    if [ ${t:-0} -gt 30 ]; then break; fi
    echo -n "."
    sleep 10
  done

  if [ ${t:-0} -ge 0 ]; then
    echo " done; version: ${info}"
    if [ "${info}" != '0.116.4' ]; then
      echo "Version of Home Assistant is ${info}"
    fi
  else
    echo 'Problem installing Home Assistant; check with "ha core info" command; re-install with:' "${0%/*}/hassio-install.sh -d $(pwd -P) $(machine)" &> /dev/stderr
    exit 1
  fi

else
  echo "Not getting motion-ai"
fi


# reboot
echo 'Reboot to start afresh; "sudo reboot"' &> /dev/stderr
