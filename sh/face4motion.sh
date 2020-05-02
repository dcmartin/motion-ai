#!/bin/bash

# calculated
BUILD_ARCH=$(uname -m | sed -e 's/aarch64.*/arm64/' -e 's/x86_64.*/amd64/' -e 's/armv.*/arm/')

# MQTT
if [ -z "${MQTT_HOST:-}" ] && [ -s MQTT_HOST ]; then MQTT_HOST=$(cat MQTT_HOST); fi; MQTT_HOST=${MQTT_HOST:-$(hostname -I | awk '{ print $1 }')}
if [ -z "${MQTT_USERNAME:-}" ] && [ -s MQTT_USERNAME ]; then MQTT_USERNAME=$(cat MQTT_USERNAME); fi; MQTT_USERNAME=${MQTT_USERNAME:-username}
if [ -z "${MQTT_PASSWORD:-}" ] && [ -s MQTT_PASSWORD ]; then MQTT_PASSWORD=$(cat MQTT_PASSWORD); fi; MQTT_PASSWORD=${MQTT_PASSWORD:-password}
if [ -z "${MQTT_PORT:-}" ] && [ -s MQTT_PORT ]; then MQTT_PORT=$(cat MQTT_PORT); fi; MQTT_PORT=${MQTT_PORT:-1883}
MQTT='{"host":"'${MQTT_HOST}'","port":'${MQTT_PORT}',"username":"'${MQTT_USERNAME}'","password":"'${MQTT_PASSWORD}'"}'

## MOTION
if [ -z "${MOTION_GROUP:-}" ] && [ -s MOTION_GROUP ]; then MOTION_GROUP=$(cat MOTION_GROUP); fi; MOTION_GROUP=${MOTION_GROUP:-+}
if [ -z "${MOTION_CLIENT:-}" ] && [ -s MOTION_CLIENT ]; then MOTION_CLIENT=$(cat MOTION_CLIENT); fi; MOTION_CLIENT=${MOTION_CLIENT:-+}
if [ -z "${MOTION_CAMERA:-}" ] && [ -s MOTION_CAMERA ]; then MOTION_CAMERA=$(cat MOTION_CAMERA); fi; MOTION_CAMERA=${MOTION_CAMERA:-+}
MOTION='{"group":"'${MOTION_GROUP}'","client":"'${MOTION_CLIENT}'","camera":"'${MOTION_CAMERA}'"}'

# parameters
SERVICE='{"label":"face4motion","id":"com.github.dcmartin.open-horizon.face4motion","version":"'${SERVICE_VERSION:-0.0.1}'","arch":"'${SERVICE_ARCH:-${BUILD_ARCH}}'","ports":{"service":'${SERVICE_PORT:-80}',"host":'${HOST_PORT:-4664}'}}'
FACE='{"country":"'${FACE_COUNTRY:-us}'","pattern":"'${FACE_PATTERN:-all}'","scale":"'${FACE_SCALE:-none}'","threshold":'${FACE_THRESHOLD:-0.5}'}'
LOG='{"debug":'${DEBUG:-false}',"level":"'"${LOG_LEVEL:-info}"'","logto":"'"${LOGTO:-/dev/stderr}"'"}'

# notify
echo 'SERVICE: '$(echo "${SERVICE}" | jq -c '.') &> /dev/stderr
echo 'MOTION: '$(echo "${MOTION}" | jq -c '.') &> /dev/stderr
echo 'MQTT: '$(echo "${MQTT}" | jq -c '.') &> /dev/stderr
echo 'FACE: '$(echo "${FACE}" | jq -c '.') &> /dev/stderr
echo 'LOG: '$(echo "${LOG}" | jq -c '.') &> /dev/stderr

# specify
LABEL=$(echo "${SERVICE:-null}" | jq -r '.label')
ARCH=$(echo "${SERVICE:-null}" | jq -r '.arch')
VERS=$(echo "${SERVICE:-null}" | jq -r '.version')
ID=$(echo "${SERVICE:-null}" | jq -r '.id')
EXT_PORT=$(echo "${SERVICE}" | jq -r '.ports.host')
INT_PORT=$(echo "${SERVICE}" | jq -r '.ports.service') 

# container name
NAME=${SERVICE_NAME:-${LABEL}}

# cleanup
echo "Removing any existing container: ${LABEL}" &> /dev/stderr
docker rm -f ${NAME} &> /dev/null

# start up
echo "Starting new container: ${NAME}; id: ${ID}; architecture: ${ARCH}; version: ${VERS}; host: ${EXT_PORT}; service: ${INT_PORT}" &> /dev/stderr
CID=$(docker run -d \
  --privileged \
  --name ${NAME} \
  --mount type=tmpfs,destination=/tmpfs,tmpfs-size=81920000,tmpfs-mode=1777 \
  --publish=${EXT_PORT}:${INT_PORT} \
  --restart=unless-stopped \
  -e SERVICE_LABEL=${LABEL} \
  -e SERVICE_VERS=${VERS} \
  -e SERVICE_PORT=${INT_PORT} \
  -e MQTT_HOST=$(echo "${MQTT}" | jq -r '.host') \
  -e MQTT_PORT=$(echo "${MQTT}" | jq -r '.port') \
  -e MQTT_USERNAME=$(echo "${MQTT}" | jq -r '.username') \
  -e MQTT_PASSWORD=$(echo "${MQTT}" | jq -r '.password') \
  -e MOTION_GROUP=$(echo "${MOTION}" | jq -r '.group') \
  -e MOTION_CLIENT=$(echo "${MOTION}" | jq -r '.client') \
  -e FACE4MOTION_CAMERA=$(echo "${MOTION}" | jq -r '.camera') \
  -e FACE4MOTION_TOPIC_EVENT=event/end \
  -e FACE4MOTION_USE_MOCK=false \
  -e FACE4MOTION_TOO_OLD=300 \
  -e FACE_COUNTRY=$(echo "${FACE}" | jq -r '.country') \
  -e FACE_PATTERN=$(echo "${FACE}" | jq -r '.pattern') \
  -e FACE_SCALE=$(echo "${FACE}" | jq -r '.scale') \
  -e FACE_THRESHOLD=$(echo "${FACE}" | jq -r '.threshold') \
  -e FACE_PERIOD=60 \
  -e LOG_LEVEL=$(echo "${LOG}" | jq -r '.level') \
  -e LOGTO=$(echo "${LOG}" | jq -r '.logto') \
  -e DEBUG=$(echo "${LOG}" | jq -r '.debug') \
  "dcmartin/${ARCH}_${ID}:${VERS}" 2> /dev/stderr)

# report
if [ "${CID:-null}" != 'null' ]; then
  echo 'Container '${LABEL}' started; status: "curl http://localhost:'$(echo "${SERVICE}" | jq -r '.ports.host')'"; id: '"${CID}" &> /dev/stderr
else
  echo "Container ${LABEL} failed" &> /dev/stderr
fi
echo '{"name":"'${NAME}'","id":"'${CID:-null}'","service":'"${SERVICE}"',"motion":'"${MOTION}"',"face":'"${FACE}"',"mqtt":'"${MQTT}"',"debug":'"${LOG}"'}' | jq '.' | tee "${0##*/}.json"
