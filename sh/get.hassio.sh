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
  # wait for HA
  echo -n "Waiting on Home Assistant: "
  t=0; while [ ! -z "$(command -v ha)" ]; do 
    info=$(ha core info 2> /dev/null | egrep '^version:' | awk '{ print $2 }')
    t=$((t+1))
    if [ ! -z "${info:-}" ] && [ "${info}" != 'landingpage' ]; then break; fi
    if [ ${t:-0} -gt 30 ]; then break; fi
    echo -n "."
    sleep 60
  done
  
  if [ ${t:-0} -ge 0 ]; then
    echo " done; version: ${info}"
    if [ "${info}" != '0.116.4' ]; then 
      echo "Setting version of Home Assistant to 0.116.4"
      ha core update --version=0.116.4
    fi
  else
    echo 'Problem installing Home Assistant; check with "ha core info" command' &> /dev/stderr
    exit 1
  fi
  
  # check on webcams
  if [ ! -e 'webcams.json' ]; then
    echo "Copied default webcams.json"
    cp webcams.json.tmpl webcams.json
    chown ${SUDO_USER:-${USER}} webcams.json
  fi
  
  # build YAML
  echo "Building YAML; using default password: ${PASSWORD:-password}"
  yes "${PASSWORD:-password}" | make 2>&1 >> install.log \
    && make realclean &> /dev/null \
    && make restart &> /dev/null
  
  # change ownership
  echo "Changing ownership on homeassistant/ directory"
  chown -R ${SUDO_USER:-${USER}} homeassistant/

  for m in yolo face alpr; do \
    echo "Pulling container for AI: ${m}"; \
    bash ${0%/*}/${m}4motion.sh pull \
    || \
    echo "Unable to pull container image for AI: ${m}; use ${0%/*}/${m}4motion.sh" &> /dev/stderr
  done

  echo 'Downloading yolo weights'; \
    bash ${0%/*}/get.weights.sh \
    || \
    echo "Unable to download weights; use ${0%/*}/get.weights.sh" &> /dev/stderr
}

###
### MAIN
###

if [ $(uname -s) != 'Linux' ]; then
  echo 'Only for Ubuntu18, Rasbian Buster, or Debian 10' &> /dev/stderr
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

if [ "${USER:-null}" != 'root' ]; then
  echo "Please run as root; sudo ${0} ${*}" &> /dev/stderr
  exit 1
fi

if [ -z "$(command -v curl)" ]; then
  echo 'Install curl; sudo apt install -qq -y curl' &> /dev/stderr
  exit 1
fi

if [ -z "$(command -v jq)" ]; then
  echo 'Install jq; sudo apt install -qq -y jq' &> /dev/stderr
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
  jq '."log-driver"="journald"|."storage-driver"="overlay2"' ${CONFIG} > ${CONFIG}.$$ \
	  && mv -f ${CONFIG}.$$ ${CONFIG} \
	  || echo "Failed to update ${CONFIG}" &> /dev/stderr
else
  echo '{"log-driver":"journald","storage-driver":"overlay2"}' > ${CONFIG}
fi

# update runtime if CUDA
if [ -e /usr/local/cuda/bin/nvcc ]; then
  jq '."default-runtime"="nvidia"' ${CONFIG} > ${CONFIG}.$$ \
	  && mv -v ${CONFIG}.$$ ${CONFIG} \
	  || echo "Failed to update ${CONFIG}" &> /dev/stderr
  jq '.experimental=true' ${CONFIG} > ${CONFIG}.$$ \
	  && mv -v ${CONFIG}.$$ ${CONFIG} \
	  || echo "Failed to update ${CONFIG}" &> /dev/stderr
  jq '.runtimes={"nvidia":{"path":"/usr/bin/nvidia-container-runtime","runtimeArgs":[]}}' ${CONFIG} > ${CONFIG}.$$ \
	  && mv -v ${CONFIG}.$$ ${CONFIG} \
	  || echo "Failed to update ${CONFIG}" &> /dev/stderr
fi

systemctl restart docker

addgroup ${SUDO_USER:-${USER}} docker

## UPDATE, UPGRADE, PACKAGES

echo 'Updating ...' &> /dev/stderr \
  && apt update -qq -y 2>&1 >> install.log \
  && echo 'Upgrading ...' &> /dev/stderr \
  && DEBIAN_FRONTEND=noninteractive apt upgrade -qq -y --no-install-recommends 2>&1 >> install.log \
  && echo 'Installing pre-requisite packages ...' &> /dev/stderr \
  && DEBIAN_FRONTEND=noninteractive apt install -qq -y --no-install-recommends \
    network-manager \
    software-properties-common \
    apparmor-utils \
    apt-transport-https \
    avahi-daemon \
    ca-certificates \
    dbus \
    make \
    mosquitto-clients \
    socat \
    iperf3 \
    netdata 2>&1 >> install.log \
  || echo 'Failed to install pre-requisite software' &> /dev/stderr

echo 'Modifying NetworkManager to disable WiFi MAC randomization' \
  && mkdir -p /etc/NetworkManager/conf.d \
  && echo '[connection]' > /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf \
  && echo 'wifi.mac-address-randomization=1' >> /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf \
  && echo '[device]' >> /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf \
  && echo 'wifi.scan-rand-mac-address=no' >> /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf \
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

curl -sSL https://raw.githubusercontent.com/home-assistant/supervised-installer/master/installer.sh -o /tmp/hassio-install.sh \
  && \
  mv -f /tmp/hassio-install.sh ${0%/*}/hassio-install.sh \
  && \
  chmod 755 ${0%/*}/hassio-install.sh \
  || \
  echo "Unable to download installer; using backup" &> /dev/stderr

echo "Installing using ${0%/*}/hassio-install.sh -d $(pwd -P) $(machine)" \
  && yes | ${0%/*}/hassio-install.sh -d $(pwd -P) $(machine) 2>&1 >> install.log \
  || echo 'Problem installing Home Assistant; check with "ha core info" command' &> /dev/stderr

# download AI containers and models
if [ "${0##*/}" == 'get.motion-ai.sh' ]; then
  motionai::get
else
  echo "Not getting motion-ai"
fi
