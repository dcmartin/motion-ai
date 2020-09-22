#!/bin/bash

# calculated
BUILD_ARCH=$(uname -m | sed -e 's/aarch64.*/arm64/' -e 's/x86_64.*/amd64/' -e 's/armv.*/arm/')

# host
IPADDR=($(ip addr | egrep -v 'LOOPBACK' | egrep -A 3 'UP' | egrep 'inet ' | awk '{ print $2 }'))
if [ ${#IPADDR[@]} -gt 0 ]; then 
  IPADDR=${IPADDR[0]%%/*}
fi
if [ -z "${IPADDR:-}" ]; then echo 'No IP address?';  exit 1; fi

# KAFKA
if [ -z "${KAFKA_HOST:-}" ] && [ -s KAFKA_HOST ]; then KAFKA_HOST=$(cat KAFKA_HOST); fi; KAFKA_HOST=${KAFKA_HOST:-${IPADDR}}
if [ -z "${KAFKA_TOPICS:-}" ] && [ -s KAFKA_TOPICS ]; then KAFKA_TOPICS=$(cat KAFKA_TOPICS); fi; KAFKA_TOPICS=${KAFKA_TOPICS:-startup}
if [ -z "${KAFKA_GROUP:-}" ] && [ -s KAFKA_GROUP ]; then KAFKA_GROUP=$(cat KAFKA_GROUP); fi; KAFKA_GROUP=${KAFKA_GROUP:-motion}
if [ -z "${KAFKA_PORT:-}" ] && [ -s KAFKA_PORT ]; then KAFKA_PORT=$(cat KAFKA_PORT); fi; KAFKA_PORT=${KAFKA_PORT:-9092}
if [ -z "${ZOOKEEPER_PORT:-}" ] && [ -s ZOOKEEPER_PORT ]; then ZOOKEEPER_PORT=$(cat ZOOKEEPER_PORT); fi; ZOOKEEPER_PORT=${ZOOKEEPER_PORT:-2181}
if [ -z "${KAFKA_LOG_HOURS:-}" ] && [ -s KAFKA_LOG_HOURS ]; then KAFKA_LOG_HOURS=$(cat KAFKA_LOG_HOURS); fi; KAFKA_LOG_HOURS=${KAFKA_LOG_HOURS:-168}
if [ -z "${KAFKA_LOG_BYTES:-}" ] && [ -s KAFKA_LOG_BYTES ]; then KAFKA_LOG_BYTES=$(cat KAFKA_LOG_BYTES); fi; KAFKA_LOG_BYTES=${KAFKA_LOG_BYTES:-1073741824}

KAFKA='{"host":"'${KAFKA_HOST}'","port":'${KAFKA_PORT}',"topics":"'${KAFKA_TOPICS:-}'","group":"'${KAFKA_GROUP}'","zookeeper":'${ZOOKEEPER_PORT}',"log":{"retention":{"hours":'${KAFKA_LOG_HOURS}',"bytes":'${KAFKA_LOG_BYTES}'},"level":"'${SERVICE_LOG_LEVEL:-info}'"}}'

# parameters
SERVICE='{"label":"kafka","id":"kafka","version":"0.10.1.0","arch":"'${SERVICE_ARCH:-${BUILD_ARCH}}'","ports":{"service":'${SERVICE_PORT:-${KAFKA_PORT}}',"host":'${HOST_PORT:-${KAFKA_PORT}}'}}'

# notify
echo 'SERVICE: '$(echo "${SERVICE}" | jq -c '.') &> /dev/stderr
echo 'KAFKA: '$(echo "${KAFKA}" | jq -c '.') &> /dev/stderr

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
LOGPATH=$(docker inspect --format '{{json .}}' "${LABEL}" 2> /dev/null)
if [ ${LOGPATH:-null} != 'null' ]; then
  LOGPATH=$(echo "${LOGPATH}" | jq -r '.LogPath')
  echo 'Attempting (sudo) to remove log file: '"${LOGPATH}" && sudo /bin/rm -f "${LOGPATH}" &> /dev/stderr
else
  echo 'No existing log file: '"${LOGPATH:-none}" &> /dev/stderr
fi
echo "Removing any existing container: ${LABEL}" &> /dev/stderr
docker rm -f ${NAME} &> /dev/null

# start up
echo "Starting new container: ${NAME}; id: ${ID}; architecture: ${ARCH}; version: ${VERS}; host: ${EXT_PORT}; service: ${INT_PORT}" &> /dev/stderr

CID=$(docker run -d \
  --hostname kafka \
  --name ${NAME} \
  --restart=unless-stopped \
  -p ${ZOOKEEPER_PORT}:${ZOOKEEPER_PORT} \
  -p ${KAFKA_PORT}:${KAFKA_PORT} \
  -e LOG_RETENTION_HOURS=$(echo "${KAFKA}" | jq -r '.log.retention.hours') \
  -e LOG_RETENTION_BYTES=$(echo "${KAFKA}" | jq -r '.log.retention.bytes') \
  -e ADVERTISED_HOST=$(echo "${KAFKA}" | jq -r '.host') \
  -e ADVERTISED_PORT=$(echo "${KAFKA}" | jq -r '.port') \
  -e AUTO_CREATE_TOPICS=true \
  spotify/kafka 2> /dev/stderr)

# report
if [ "${CID:-null}" != 'null' ]; then
  echo 'Container '${LABEL}' started; status: "curl http://localhost:'$(echo "${SERVICE}" | jq -r '.ports.host')'"; id: '"${CID}" &> /dev/stderr
else
  echo "Container ${LABEL} failed" &> /dev/stderr
fi
echo '{"name":"'${NAME}'","id":"'${CID:-null}'","service":'"${SERVICE}"',"kafka":'"${KAFKA}"'}' | jq '.' | tee "${0##*/}.json"
