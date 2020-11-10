#!/bin/bash

## requires docker
if [ -z "$(command -v docker)" ]; then echo "Install docker; exiting" &> /dev/stderr; exit 1; fi

## calculated
BUILD_ARCH=$(uname -m | sed -e 's/aarch64.*/arm64/' -e 's/x86_64.*/amd64/' -e 's/armv.*/arm/')

## NVIDIA specialization
info=$(docker info --format '{{ json . }}')
has_nvidia=$(echo "${info}" | jq '.Runtimes|to_entries[]|select(.key=="nvidia")!=null')
is_default=$(echo "${info}" | jq '.DefaultRuntime=="nvidia"')

if [ "${is_default:-false}" = 'true' ]; then
  echo 'nVidia runtime default' &> /dev/stderr
  NVCC=${NVCC:-/usr/local/cuda/bin/nvcc}
  if [ -e ${NVCC} ]; then
    CUDA=$(${NVCC} --version | egrep '^Cuda' | awk -F, '{ print $2 $3 }')
    echo "Found nvcc: ${NVCC}; CUDA: ${CUDA}" &> /dev/stderr
    if [ ! -z "${CUDA:-}" ]; then 
      CUDA=$(echo "${CUDA}" | awk '{ print $2 }')
      if [ ! -z "${CUDA:-}" ]; then 
        BUILD_ARCH="${BUILD_ARCH}-${CUDA}"
      else
        echo "No CUDA" &> /dev/stderr
      fi
    else
      echo "No CUDA" &> /dev/stderr
    fi
  fi
elif [ "${has_nvidia:-false}" = 'true' ]; then
  echo 'nVidia runtime detected, but not default; CPU only' &> /dev/stderr
fi

## default
if [ -z "${CONTAINER_ID:-}" ]; then
  CONTAINER_ID="com.github.dcmartin.open-horizon.yolo4motion"
fi

# report
echo "Using container named: ${DOCKER_NAMESPACE:-dcmartin}/${BUILD_ARCH}_${CONTAINER_ID}"  &> /dev/stderr

## PARAMETERS

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

## YOLO
if [ -z "${YOLO_CONFIG:-}" ] && [ -s YOLO_CONFIG ]; then YOLO_CONFIG=$(cat YOLO_CONFIG); fi; YOLO_CONFIG=${YOLO_CONFIG:-tiny-v2}
if [ -z "${YOLO_ENTITY:-}" ] && [ -s YOLO_ENTITY ]; then YOLO_ENTITY=$(cat YOLO_ENTITY); fi; YOLO_ENTITY=${YOLO_ENTITY:-all}
if [ -z "${YOLO_SCALE:-}" ] && [ -s YOLO_SCALE ]; then YOLO_SCALE=$(cat YOLO_SCALE); fi; YOLO_SCALE=${YOLO_SCALE:-640x480}
if [ -z "${YOLO_THRESHOLD:-}" ] && [ -s YOLO_THRESHOLD ]; then YOLO_THRESHOLD=$(cat YOLO_THRESHOLD); fi; YOLO_THRESHOLD=${YOLO_THRESHOLD:-0.25}
YOLO='{"config":"'${YOLO_CONFIG}'","entity":"'${YOLO_ENTITY}'","scale":"'${YOLO_SCALE}'","threshold":'${YOLO_THRESHOLD}'}'

## DEBUG
if [ -z "${DEBUG:-}" ] && [ -s DEBUG ]; then DEBUG=$(cat DEBUG); fi; DEBUG=${DEBUG:-false}
if [ -z "${LOG_LEVEL:-}" ] && [ -s LOG_LEVEL ]; then LOG_LEVEL=$(cat LOG_LEVEL); fi; LOG_LEVEL=${LOG_LEVEL:-info}
if [ -z "${LOGTO:-}" ] && [ -s LOGTO ]; then LOGTO=$(cat LOGTO); fi; LOGTO=${LOGTO:-/dev/stderr}
LOG='{"debug":'${DEBUG}',"level":"'"${LOG_LEVEL}"'","logto":"'"${LOGTO}"'"}'

## SERVICE
if [ -z "${CONTAINER_TAG:-}" ] && [ -s CONTAINER_TAG ]; then CONTAINER_TAG=$(cat CONTAINER_TAG); fi; CONTAINER_TAG=${CONTAINER_TAG:-0.1.3}
SERVICE='{"label":"yolo4motion","id":"'${CONTAINER_ID}'","tag":"'${CONTAINER_TAG}'","arch":"'${SERVICE_ARCH:-${BUILD_ARCH}}'","ports":{"service":'${SERVICE_PORT:-80}',"host":'${HOST_PORT:-4662}'},"mount":[{"source":"'${PWD}'/yolov2-tiny-voc.weights","target":"/openyolo/darknet/yolov2-tiny-voc.weights"},{"source":"'${PWD}'/yolov3-tiny.weights","target":"/openyolo/darknet/yolov3-tiny.weights"},{"source":"'${PWD}'/yolov2.weights","target":"/openyolo/darknet/yolov2.weights"},{"source":"'${PWD}'/yolov3.weights","target":"/openyolo/darknet/yolov3.weights"}]}'

# specify
LABEL=$(echo "${SERVICE:-null}" | jq -r '.label')
ARCH=$(echo "${SERVICE:-null}" | jq -r '.arch')
TAG=$(echo "${SERVICE:-null}" | jq -r '.tag')
ID=$(echo "${SERVICE:-null}" | jq -r '.id')
EXT_PORT=$(echo "${SERVICE}" | jq -r '.ports.host')
INT_PORT=$(echo "${SERVICE}" | jq -r '.ports.service') 

# container name
NAME=${SERVICE_NAME:-${LABEL}}

# pull and exit
if [ "${1:-}" == 'pull' ]; then
  echo "Pulling container: ${DOCKER_NAMESPACE:-dcmartin}/${ARCH}_${ID}:${TAG}" &> /dev/stderr
  docker pull "${DOCKER_NAMESPACE:-dcmartin}/${ARCH}_${ID}:${TAG}" 2> /dev/stderr
  exit $?
fi

# extra mounts
if [ $(echo "${SERVICE}" | jq '.mount!=null') = true ]; then
  mounts=$(echo "${SERVICE}" | jq '.mount|to_entries')
  keys=$(echo "${mounts}" | jq '.[]|.key')
  for key in ${keys}; do
    mount=$(echo "${mounts}" | jq '.[]|select(.key=='${key}').value')
    source=$(echo "${mount}" | jq -r '.source' | envsubst)
    target=$(echo "${mount}" | jq -r '.target' | envsubst)

    if [ -e "${source}" ]; then
      OPTIONS="${OPTIONS:-} --mount type=bind,source=${source},target=${target}"
    else
      echo "+++ WARNING -- $0 $$ -- no source: ${source}; not mounted into ${target}" &> /dev/stderr
    fi
  done
else
  if [ "${DEBUG:-}" = true ]; then echo "--- INFO -- $0 $$ -- no mount" &> /dev/stderr; fi
fi

# notify
echo 'SERVICE: '$(echo "${SERVICE}" | jq -c '.') &> /dev/stderr
echo 'MOTION: '$(echo "${MOTION}" | jq -c '.') &> /dev/stderr
echo 'MQTT: '$(echo "${MQTT}" | jq -c '.') &> /dev/stderr
echo 'YOLO: '$(echo "${YOLO}" | jq -c '.') &> /dev/stderr
echo 'LOG: '$(echo "${LOG}" | jq -c '.') &> /dev/stderr

# cleanup
LOGPATH=$(docker inspect --format '{{json .}}' "${LABEL}" | jq -r '.LogPath')
if [ "${LOGPATH:-null}" != 'null' ]; then
  echo 'Attempting (sudo) to remove log file: '"${LOGPATH}" && sudo /bin/rm -f "${LOGPATH}" &> /dev/stderr
else
  echo 'No existing log file: '"${LOGPATH:-none}" &> /dev/stderr
fi
echo "Removing any existing container: ${LABEL}" &> /dev/stderr
docker rm -f ${LABEL} &> /dev/null

# start up
echo "Starting new container: ${LABEL}; id: ${ID}; architecture: ${ARCH}; tag: ${TAG}; host: ${EXT_PORT}; service: ${INT_PORT}" &> /dev/stderr
CID=$(docker run -d \
  --privileged \
  --name ${LABEL} \
  --mount type=tmpfs,destination=/tmpfs,tmpfs-size=81920000,tmpfs-mode=1777 \
  --publish=${EXT_PORT}:${INT_PORT} \
  --restart=unless-stopped \
  -e SERVICE_LABEL=${LABEL} \
  -e SERVICE_VERSION=${TAG} \
  -e SERVICE_PORT=${INT_PORT} \
  -e MQTT_HOST=$(echo "${MQTT}" | jq -r '.host') \
  -e MQTT_PORT=$(echo "${MQTT}" | jq -r '.port') \
  -e MQTT_USERNAME=$(echo "${MQTT}" | jq -r '.username') \
  -e MQTT_PASSWORD=$(echo "${MQTT}" | jq -r '.password') \
  -e MOTION_GROUP=$(echo "${MOTION}" | jq -r '.group') \
  -e MOTION_CLIENT=$(echo "${MOTION}" | jq -r '.client') \
  -e YOLO4MOTION_CAMERA=$(echo "${MOTION}" | jq -r '.camera') \
  -e YOLO4MOTION_TOPIC_EVENT=event/end \
  -e YOLO4MOTION_TOPIC_PAYLOAD=image/end \
  -e YOLO4MOTION_USE_MOCK=false \
  -e YOLO4MOTION_TOO_OLD=500 \
  -e YOLO_CONFIG=$(echo "${YOLO}" | jq -r '.config') \
  -e YOLO_ENTITY=$(echo "${YOLO}" | jq -r '.entity') \
  -e YOLO_SCALE=$(echo "${YOLO}" | jq -r '.scale') \
  -e YOLO_THRESHOLD=$(echo "${YOLO}" | jq -r '.threshold') \
  -e YOLO_PERIOD=60 \
  -e LOG_LEVEL=$(echo "${LOG}" | jq -r '.level') \
  -e LOGTO=$(echo "${LOG}" | jq -r '.logto') \
  -e DEBUG=$(echo "${LOG}" | jq -r '.debug') \
  ${OPTIONS:-} \
  "${DOCKER_NAMESPACE:-dcmartin}/${ARCH}_${ID}:${TAG}" 2> /dev/stderr)

# report
if [ "${CID:-null}" != 'null' ]; then
  echo 'Container '${LABEL}' started; status: "curl http://localhost:'$(echo "${SERVICE}" | jq -r '.ports.host')'"; id: '"${CID}" &> /dev/stderr
else
  echo "Container ${LABEL} failed" &> /dev/stderr
fi
echo '{"name":"'${LABEL}'","id":"'${CID:-null}'","service":'"${SERVICE}"',"motion":'"${MOTION}"',"yolo":'"${YOLO}"',"mqtt":'"${MQTT}"',"debug":'"${LOG}"'}' | jq '.' | tee "${0##*/}.json"
