#!/bin/bash

BUILD_ARCH=$(uname -m | sed -e 's/aarch64.*/arm64/' -e 's/x86_64.*/amd64/' -e 's/armv.*/arm/')

SERVICE='{"name":"'${SERVICE_NAME:-yolomotion}'","arch":"'${ARCH:-${BUILD_ARCH}}'","ports":{"service":'${SERVICE_PORT:-80}',"host":'${HOST_PORT:-4662}'}}'
MOTION='{"client":"'${MOTION_CLIENT:-${MOTION_DEVICE:-$(hostname)}}'","camera":"'${MOTION_CAMERA:-+}'"}'
MQTT='{"host":"'${MQTT_HOST:-127.0.0.1}'","port":'${MQTT_PORT:-1883}',"username":"'${MQTT_USERNAME:-username}'","password":"'${MQTT_PASSWORD:-password}'"}'

THIS=$(echo "${SERVICE:-null}" | jq -r '.name')

echo "Removing any existing container: ${THIS}" &> /dev/stderr
docker rm -f ${THIS} &> /dev/null

echo 'SERVICE: '$(echo "${SERVICE}" | jq -c '.') &> /dev/stderr
echo 'MOTION: '$(echo "${MOTION}" | jq -c '.') &> /dev/stderr
echo 'MQTT: '$(echo "${MQTT}" | jq -c '.') &> /dev/stderr
echo "Starting new container: ${THIS}" &> /dev/stderr

CID=$(docker run -d \
  --privileged \
  --name ${THIS} \
  --mount type=tmpfs,destination=/tmpfs,tmpfs-size=81920000,tmpfs-mode=1777 \
  --publish=$(echo "${SERVICE}" | jq -r '.ports.host'):$(echo "${SERVICE}" | jq -r '.ports.service') \
  --restart=unless-stopped \
  -e SERVICE_LABEL=yolo4motion \
  -e SERVICE_VERSION=0.1.0 \
  -e SERVICE_PORT=$(echo "${SERVICE}" | jq -r '.ports.service') \
  -e MQTT_HOST=$(echo "${MQTT}" | jq -r '.host') \
  -e MQTT_PORT=$(echo "${MQTT}" | jq -r '.port') \
  -e MQTT_USERNAME=$(echo "${MQTT}" | jq -r '.username') \
  -e MQTT_PASSWORD=$(echo "${MQTT}" | jq -r '.password') \
  -e MOTION_GROUP=${MOTION_GROUP:-motion} \
  -e MOTION_CLIENT=$(echo "${MOTION}" | jq -r '.client') \
  -e YOLO4MOTION_CAMERA=$(echo "${MOTION}" | jq -r '.camera') \
  -e YOLO4MOTION_TOPIC_EVENT=event/end \
  -e YOLO4MOTION_TOPIC_PAYLOAD=image/end \
  -e YOLO4MOTION_USE_MOCK=false \
  -e YOLO4MOTION_TOO_OLD=300 \
  -e YOLO_CONFIG=tiny \
  -e YOLO_ENTITY=all \
  -e YOLO_SCALE=none \
  -e YOLO_THRESHOLD=0.25 \
  -e YOLO_PERIOD=60 \
  -e LOG_LEVEL=info \
  -e LOGTO=/dev/stderr \
  -e DEBUG=false \
  dcmartin/${BUILD_ARCH}_com.github.dcmartin.open-horizon.yolo4motion:0.1.0 2> /dev/stderr)

if [ "${CID:-null}" != 'null' ]; then
  echo 'Container '${THIS}' started; status: "curl http://localhost:'$(echo "${SERVICE}" | jq -r '.ports.host')'"; id: '"${CID}" &> /dev/stderr
else
  echo "Container ${THIS} failed" &> /dev/stderr
fi
