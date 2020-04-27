#!/bin/bash

if [ ! -z $(command -v "apt-get") ]; then
  echo "This script is for macOS only" >&2
  exit 1
fi

## BOOT VOLUME MOUNT POINT
if [ -z "${VOLUME_BOOT:-}" ]; then
  VOLUME_BOOT="/Volumes/boot"
else
  echo "+++ WARN $0 $$ -- non-standard VOLUME_BOOT: ${VOLUME_BOOT}"
fi
if [ ! -d "${VOLUME_BOOT}" ]; then
  echo "*** ERROR $0 $$ -- did not find directory: ${VOLUME_BOOT}; flash the SD card manually"
  exit 1
fi

## RPI-UPDATE
if [ -s "master.tar.gz" ]; then
  mkdir ${VOLUME_BOOT}/rpi-update
  if [ -d "${VOLUME_BOOT}/rpi-update/" ]; then
    if [ ! -s "${VOLUME_BOOT}/rpi-update/master.tar.gz" ]; then
      echo "--- INFO $0 $$ -- copying rpi-update (master.tar.gz) to ${VOLUME_BOOT}/rpi-update"
      cp "master.tar.gz" ${VOLUME_BOOT}/rpi-update/
    else
      echo "--- INFO $0 $$ -- exists: ${VOLUME_BOOT}/rpi-update/master.tar.gz"
    fi
  else
    echo "*** ERROR $0 $$ -- unable to create directory: ${VOLUME_BOOT}/rpi-update; copy skipped"
  fi
fi

## WIFI

NETWORK_SSID=${NETWORK_SSID:-}
NETWORK_PASSWORD=${NETWORK_PASSWORD:-}
if [ "${NETWORK_SSID}" == "null" ] || [ "${NETWORK_PASSWORD}" == "null" ]; then
  echo "*** ERROR $0 $$ -- NETWORK_SSID or NETWORK_PASSWORD undefined; run mkconfig.sh"
  exit 1
elif [ -z "${NETWORK_SSID}" ]; then
  echo "*** ERROR $0 $$ -- NETWORK_SSID is blank"
  exit 1
elif [ -z "${NETWORK_PASSWORD}" ]; then
  echo "+++ WARN $0 $$ -- NETWORK_PASSWORD is blank"
fi

## WPA SUPPLICANT
if [ -z ${WPA_SUPPLICANT_FILE:-} ]; then
  WPA_SUPPLICANT_FILE="${VOLUME_BOOT}/wpa_supplicant.conf"
else
  echo "+++ WARN $0 $$ -- non-standard WPA_SUPPLICANT_FILE: ${WPA_SUPPLICANT_FILE}"
fi

## SSH ACCESS
SSH_FILE="${VOLUME_BOOT}/ssh"
touch "${SSH_FILE}"
if [ ! -e "${SSH_FILE}" ]; then
  echo "*** ERROR $0 $$ -- could not create: ${SSH_FILE}"
  exit 1
fi
echo "$(date '+%T') INFO $0 $$ -- created ${SSH_FILE} for SSH access"

## WPA TEMPLATE
if [ ! -z "${WPA_TEMPLATE_FILE:-}" ]; then
  echo "+++ WARN $0 $$ -- non-standard WPA_TEMPLATE_FILE: ${WPA_TEMPLATE_FILE}"
  cp ${WPA_TEMPLATE_FILE} ${VOLUME_BOOT}/wpa_supplicant.conf.tmpl
else
  WPA_TEMPLATE_FILE=${VOLUME_BOOT}/wpa_supplicant.conf.tmpl
  echo 'ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev' > ${WPA_TEMPLATE_FILE}
  echo 'network={' >> ${WPA_TEMPLATE_FILE}
  echo '  ssid="%%NETWORK_SSID%%"' >> ${WPA_TEMPLATE_FILE}
  echo '  psk="%%NETWORK_PASSWORD%%"' >> ${WPA_TEMPLATE_FILE}
  echo '  key_mgmt=WPA-PSK' >> ${WPA_TEMPLATE_FILE}
  echo '}' >> ${WPA_TEMPLATE_FILE}
fi
if [ ! -s "${WPA_TEMPLATE_FILE}" ]; then
  echo "*** ERROR $0 $$ -- could not find: ${WPA_TEMPLATE_FILE}"
  exit 1
fi

# create supplicant configuration file
sed \
  -e 's|%%NETWORK_SSID%%|'"${NETWORK_SSID}"'|g' \
  -e 's|%%NETWORK_PASSWORD%%|'"${NETWORK_PASSWORD}"'|g' \
  "${WPA_TEMPLATE_FILE}" > "${WPA_SUPPLICANT_FILE}"

if [ ! -s "${WPA_SUPPLICANT_FILE}" ]; then
  echo "*** ERROR $0 $$ -- could not create: ${WPA_SUPPLICANT_FILE}"
  exit 1
fi

## SUCCESS
echo "$(date '+%T') INFO $0 $$ -- ${WPA_SUPPLICANT_FILE} created using SSID ${NETWORK_SSID}; password ${NETWORK_PASSWORD}"

echo "--- INFO $0 $$ -- SUCCESS; you may now safely eject volume ${VOLUME_BOOT}"
