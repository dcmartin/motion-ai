#!/bin/bash

# host identifier
HOSTID=$(uname -n | sed 's/[-+#]*//g')

# container
LABEL='motion'
IMAGE='dcmartin/addon-motion-video0:0.10.11'

# defaults
OPTIONS='{"log_level":"info","log_motion_level":"info","log_motion_type":"ALL","default":{"changes":"on","event_gap":5,"framerate":5,"minimum_motion_frames":10,"post_pictures":"best","text_scale":2,"threshold_maximum":100000,"threshold_percent":1,"username":"username","password":"password","netcam_userpass":"username:password","width":640,"height":480},"mqtt":{"host":"127.0.0.1","port":1883,"username":"username","password":"password"},"group":"motion","device":"rpi0w","client":"rpi0w","timezone":"America/Los_Angeles","cameras":[{"name":"local","framerate":5,"palette":8,"type":"local","device":"/dev/video0","width":640,"height":480}]}'

# options
if [ -z "${MOTION_TIMEZONE:-}" ] && [ -s MOTION_TIMEZONE ]; then MOTION_TIMEZONE=$(cat MOTION_TIMEZONE); fi; MOTION_TIMEZONE=${MOTION_TIMEZONE:-$(cat /etc/timezone)}
if [ -z "${LOG_LEVEL:-}" ] && [ -s LOG_LEVEL ]; then LOG_LEVEL=$(cat LOG_LEVEL); fi; LOG_LEVEL=${LOG_LEVEL:-info}
if [ -z "${MOTION_LOG_LEVEL:-}" ] && [ -s MOTION_LOG_LEVEL ]; then MOTION_LOG_LEVEL=$(cat MOTION_LOG_LEVEL); fi; MOTION_LOG_LEVEL=${MOTION_LOG_LEVEL:-info}

if [ -z "${MQTT_HOST:-}" ] && [ -s MQTT_HOST ]; then MQTT_HOST=$(cat MQTT_HOST); fi; MQTT_HOST=${MQTT_HOST:-$(hostname -I | awk '{ print $1 }')}
if [ -z "${MQTT_USERNAME:-}" ] && [ -s MQTT_USERNAME ]; then MQTT_USERNAME=$(cat MQTT_USERNAME); fi; MQTT_USERNAME=${MQTT_USERNAME:-username}
if [ -z "${MQTT_PASSWORD:-}" ] && [ -s MQTT_PASSWORD ]; then MQTT_PASSWORD=$(cat MQTT_PASSWORD); fi; MQTT_PASSWORD=${MQTT_PASSWORD:-password}
if [ -z "${MQTT_PORT:-}" ] && [ -s MQTT_PORT ]; then MQTT_PORT=$(cat MQTT_PORT); fi; MQTT_PORT=${MQTT_PORT:-1883}

if [ -z "${MOTION_GROUP:-}" ] && [ -s MOTION_GROUP ]; then MOTION_GROUP=$(cat MOTION_GROUP); fi; MOTION_GROUP=${MOTION_GROUP:-motion}
if [ -z "${MOTION_DEVICE:-}" ] && [ -s MOTION_DEVICE ]; then MOTION_DEVICE=$(cat MOTION_DEVICE); fi; MOTION_DEVICE=${MOTION_DEVICE:-${HOSTID}}
if [ -z "${MOTION_CLIENT:-}" ] && [ -s MOTION_CLIENT ]; then MOTION_CLIENT=$(cat MOTION_CLIENT); fi; MOTION_CLIENT=${MOTION_CLIENT:-${HOSTID}}
if [ -z "${MOTION_CAMERA_NAME:-}" ] && [ -s MOTION_CAMERA_NAME ]; then MOTION_CAMERA_NAME=$(cat MOTION_CAMERA_NAME); fi; MOTION_CAMERA_NAME=${MOTION_CAMERA_NAME:-${MOTION_DEVICE}}
if [ -z "${MOTION_PALETTE:-}" ] && [ -s MOTION_PALETTE ]; then MOTION_PALETTE=$(cat MOTION_PALETTE); fi; MOTION_PALETTE=${MOTION_PALETTE:-8}
if [ -z "${MOTION_FRAMERATE:-}" ] && [ -s MOTION_FRAMERATE ]; then MOTION_FRAMERATE=$(cat MOTION_FRAMERATE); fi; MOTION_FRAMERATE=${MOTION_FRAMERATE:-5}
if [ -z "${MOTION_ROTATE:-}" ] && [ -s MOTION_ROTATE ]; then MOTION_ROTATE=$(cat MOTION_ROTATE); fi; MOTION_ROTATE=${MOTION_ROTATE:-0}
if [ -z "${MOTION_WIDTH:-}" ] && [ -s MOTION_WIDTH ]; then MOTION_WIDTH=$(cat MOTION_WIDTH); fi; MOTION_WIDTH=${MOTION_WIDTH:-640}
if [ -z "${MOTION_HEIGHT:-}" ] && [ -s MOTION_HEIGHT ]; then MOTION_HEIGHT=$(cat MOTION_HEIGHT); fi; MOTION_HEIGHT=${MOTION_HEIGHT:-480}

if [ -z "${MOTION_CAMERA_DEVICE:-}" ] && [ -s MOTION_CAMERA_DEVICE ]; then MOTION_CAMERA_DEVICE=$(cat MOTION_CAMERA_DEVICE); fi; MOTION_CAMERA_DEVICE=${MOTION_CAMERA_DEVICE:-/dev/video0}
if [ ! -e "${MOTION_CAMERA_DEVICE}" ]; then
  echo "Cannot locate MOTON_CAMERA_DEVICE: ${MOTION_CAMERA_DEVICE:-}; did you run raspi-config?" &> /dev/stderr
  exit 1
fi

if [ -s MOTION_THRESHOLD ]; then 
  MOTION_THRESHOLD=$(cat MOTION_THRESHOLD)
  OPTIONS=$(echo "${OPTIONS}" | jq '.default.threshold="'${MOTION_THRESHOLD}'"')
elif [ -s MOTION_THRESHOLD_PERCENT ]; then 
  MOTION_THRESHOLD_PERCENT=$(cat MOTION_THRESHOLD_PERCENT)
  OPTIONS=$(echo "${OPTIONS}" | jq '.default.threshold_percent="'${MOTION_THRESHOLD_PERCENT}'"')
fi
if [ -s MOTION_THRESHOLD_MAXIMUM ]; then 
  MOTION_THRESHOLD_MAXIMUM=$(cat MOTION_THRESHOLD_MAXIMUM)
  OPTIONS=$(echo "${OPTIONS}" | jq '.default.threshold_maximum="'${MOTION_THRESHOLD}'"')
fi

# configure
OPTIONS=$(echo "${OPTIONS}" | jq '.timezone="'${MOTION_TIMEZONE}'"')
OPTIONS=$(echo "${OPTIONS}" | jq '.log_level="'${LOG_LEVEL}'"')
OPTIONS=$(echo "${OPTIONS}" | jq '.log_motion_level="'${MOTION_LOG_LEVEL}'"')

OPTIONS=$(echo "${OPTIONS}" | jq '.mqtt.host="'${MQTT_HOST}'"')
OPTIONS=$(echo "${OPTIONS}" | jq '.mqtt.password="'${MQTT_PASSWORD}'"')
OPTIONS=$(echo "${OPTIONS}" | jq '.mqtt.port="'${MQTT_PORT}'"')
OPTIONS=$(echo "${OPTIONS}" | jq '.mqtt.username="'${MQTT_USERNAME}'"')

OPTIONS=$(echo "${OPTIONS}" | jq '.group="'${MOTION_GROUP}'"')
OPTIONS=$(echo "${OPTIONS}" | jq '.device="'${MOTION_DEVICE}'"')
OPTIONS=$(echo "${OPTIONS}" | jq '.client="'${MOTION_CLIENT}'"')
OPTIONS=$(echo "${OPTIONS}" | jq '.cameras[0].name="'${MOTION_CAMERA_NAME}'"')
OPTIONS=$(echo "${OPTIONS}" | jq '.cameras[0].device="'${MOTION_CAMERA_DEVICE}'"')
OPTIONS=$(echo "${OPTIONS}" | jq '.cameras[0].palette="'${MOTION_PALETTE}'"')
OPTIONS=$(echo "${OPTIONS}" | jq '.cameras[0].framerate="'${MOTION_FRAMERATE}'"')
OPTIONS=$(echo "${OPTIONS}" | jq '.cameras[0].rotate="'${MOTION_ROTATE}'"')
OPTIONS=$(echo "${OPTIONS}" | jq '.cameras[0].width="'${MOTION_WIDTH}'"')
OPTIONS=$(echo "${OPTIONS}" | jq '.cameras[0].height="'${MOTION_HEIGHT}'"')

# notify
echo 'OPTIONS: '$(echo "${OPTIONS}" | jq -c '.') &> /dev/stderr

# data directory w/ options.json
mkdir -p ${HOME}/${LABEL}/data/
echo "${OPTIONS}" > ${HOME}/${LABEL}/data/options.json

# cleanup
echo "Removing any existing container: ${LABEL}" &> /dev/stderr
docker rm -f ${LABEL} &> /dev/null

# start up
echo "Starting new container: ${LABEL}; image: ${IMAGE}" &> /dev/stderr
CID=$(docker run -d \
  --privileged \
  --network=host \
  --name ${LABEL} \
  --mount type=tmpfs,destination=/tmpfs,tmpfs-size=2560000,tmpfs-mode=1777 \
  --mount type=bind,type=bind,source=${HOME}/${LABEL}/data,target=/data \
  --restart=unless-stopped \
  -e DEBUG=${DEBUG:-} \
  "${IMAGE}" 2> /dev/stderr)

# report
if [ "${CID:-null}" != 'null' ]; then
  echo 'Container '${LABEL}' started; id: '"${CID}" &> /dev/stderr
else
  echo "Container ${LABEL} failed" &> /dev/stderr
fi
echo '{"name":"'${LABEL}'","id":"'${CID:-null}'","options":'"${OPTIONS}"'}' | jq '.' | tee "${0##*/}.json"
