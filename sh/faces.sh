#!/bin/bash

# MQTT
if [ -z "${MQTT_HOST:-}" ] && [ -s MQTT_HOST ]; then MQTT_HOST=$(cat MQTT_HOST); fi; MQTT_HOST=${MQTT_HOST:-$(hostname -I | awk '{ print $1 }')}
if [ -z "${MQTT_USERNAME:-}" ] && [ -s MQTT_USERNAME ]; then MQTT_USERNAME=$(cat MQTT_USERNAME); fi; MQTT_USERNAME=${MQTT_USERNAME:-username}
if [ -z "${MQTT_PASSWORD:-}" ] && [ -s MQTT_PASSWORD ]; then MQTT_PASSWORD=$(cat MQTT_PASSWORD); fi; MQTT_PASSWORD=${MQTT_PASSWORD:-password}
if [ -z "${MQTT_PORT:-}" ] && [ -s MQTT_PORT ]; then MQTT_PORT=$(cat MQTT_PORT); fi; MQTT_PORT=${MQTT_PORT:-1883}
MQTT='{"host":"'${MQTT_HOST}'","port":'${MQTT_PORT}',"username":"'${MQTT_USERNAME}'","password":"'${MQTT_PASSWORD}'"}'

## MOTION
if [ -z "${MOTION_GROUP:-}" ] && [ -s MOTION_GROUP ]; then MOTION_GROUP=$(cat MOTION_GROUP); fi; MOTION_GROUP=${MOTION_GROUP:-motion}
if [ -z "${MOTION_CLIENT:-}" ] && [ -s MOTION_CLIENT ]; then MOTION_CLIENT=$(cat MOTION_CLIENT); fi; MOTION_CLIENT=${MOTION_CLIENT:-+}
if [ -z "${MOTION_CAMERA:-}" ] && [ -s MOTION_CAMERA ]; then MOTION_CAMERA=$(cat MOTION_CAMERA); fi; MOTION_CAMERA=${MOTION_CAMERA:-+}
MOTION='{"group":"'${MOTION_GROUP}'","client":"'${MOTION_CLIENT}'","camera":"'${MOTION_CAMERA}'"}'

cmd=${0##*/} && cmd=${cmd%%.*}
mkdir -p ${cmd}/

topic='+/+/+/event/face/+'
filter='.|select(.detected|max>98)'

echo "${0##*/} processing; topic: ${topic}; filter: ${filter}; destination: ${cmd}/" &> /dev/stderr

mosquitto_sub -h ${MQTT_HOST} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -t ${topic} \
  | jq -c "${filter}" \
  | while read -r; do
  if [ -z "${REPLY:-}" ]; then continue; fi
  echo "${REPLY}" >> ${cmd}.json
  event=$(echo "${REPLY}" | jq -r '.event.event')
  src=$(echo "${REPLY}" | jq -j '.event.group,"-",.event.device,"-",.event.camera')
  echo "${0##*/} matching event: ${src}.${event}" &> /dev/stderr
  echo "${REPLY}" | jq -c '.' > ${cmd}/${src}.${event}.json
  echo "${REPLY}" | jq -r '.event.image' | base64 --decode > ${cmd}/${src}.${event}.jpg
  echo "${REPLY}" | jq -r '.image' | base64 --decode > ${cmd}/${src}.${event}.jpeg
done
