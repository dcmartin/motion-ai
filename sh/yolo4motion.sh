#!/bin/bash

BUILD_ARCH=$(uname -m | sed -e 's/aarch64.*/arm64/' -e 's/x86_64.*/amd64/' -e 's/armv.*/arm/')

CONTAINER=${CONTAINER:-yolo4motion}
PORT=${PORT:-4662}

echo "Removing any existing container: ${CONTAINER}"
docker rm -f ${CONTAINER}

echo "Starting new container: ${CONTAINER}; port: ${PORT}"
docker run -d \
  --privileged \
  --name ${CONTAINER} \
  --mount type=tmpfs,destination=/tmpfs,tmpfs-size=81920000,tmpfs-mode=1777 \
  --publish=${PORT}:80 \
  --restart=unless-stopped \
  -e SERVICE_LABEL=yolo4motion \
  -e SERVICE_VERSION=0.1.0 \
  -e MQTT_HOST=${MQTT_HOST:-127.0.0.1} \
  -e MQTT_PORT=${MQTT_PORT:-1883} \
  -e MQTT_USERNAME=${MQTT_USERNAME:-username} \
  -e MQTT_PASSWORD=${MQTT_PASSWORD:-password} \
  -e MOTION_GROUP=${MOTION_GROUP:-motion} \
  -e MOTION_CLIENT=${MOTION_CLIENT:-${MOTION_DEVICE:-$(hostname)}} \
  -e YOLO4MOTION_CAMERA=${MOTION_CAMERA:-'+'} \
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
  dcmartin/${BUILD_ARCH}_com.github.dcmartin.open-horizon.yolo4motion:0.1.0
