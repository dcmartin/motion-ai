#!/bin/bash

# calculated
BUILD_ARCH=$(uname -m | sed -e 's/aarch64.*/aarch64/' -e 's/x86_64.*/amd64/' -e 's/armv.*/arm/')

# requires docker
if [ -z "$(command -v docker)" ]; then echo "Install docker; exiting" &> /dev/stderr; exit 1; fi

## PARAMETERS

# MQTT
if [ -z "${MQTT_HOST:-}" ] && [ -s MQTT_HOST ]; then MQTT_HOST=$(cat MQTT_HOST); fi; MQTT_HOST=${MQTT_HOST:-$(hostname -I | awk '{ print $1 }')}
if [ -z "${MQTT_USERNAME:-}" ] && [ -s MQTT_USERNAME ]; then MQTT_USERNAME=$(cat MQTT_USERNAME); fi; MQTT_USERNAME=${MQTT_USERNAME:-username}
if [ -z "${MQTT_PASSWORD:-}" ] && [ -s MQTT_PASSWORD ]; then MQTT_PASSWORD=$(cat MQTT_PASSWORD); fi; MQTT_PASSWORD=${MQTT_PASSWORD:-password}
if [ -z "${MQTT_PORT:-}" ] && [ -s MQTT_PORT ]; then MQTT_PORT=$(cat MQTT_PORT); fi; MQTT_PORT=${MQTT_PORT:-1883}

MQTT='{"host":"'${MQTT_HOST}'","port":'${MQTT_PORT}',"username":"'${MQTT_USERNAME}'","password":"'${MQTT_PASSWORD}'"}'

## KUIPER
if [ -z "${KUIPER_HOST:-}" ] && [ -s KUIPER_HOST ]; then KUIPER_HOST=$(cat KUIPER_HOST); fi; KUIPER_HOST=${KUIPER_HOST:-localhost}
if [ -z "${KUIPER_PORT:-}" ] && [ -s KUIPER_PORT ]; then KUIPER_PORT=$(cat KUIPER_PORT); fi; KUIPER_PORT=${KUIPER_PORT:-9081}
if [ -z "${KUIPER_VERSION:-}" ] && [ -s KUIPER_VERSION ]; then KUIPER_VERSION=$(cat KUIPER_VERSION); fi; KUIPER_VERSION=${KUIPER_VERSION:-0.3.1}
KUIPER='{"host":"'${KUIPER_HOST}'","port":'${KUIPER_PORT}',"version":"'${KUIPER_VERSION}'"}'

## DEBUG
if [ -z "${DEBUG:-}" ] && [ -s DEBUG ]; then DEBUG=$(cat DEBUG); fi; DEBUG=${DEBUG:-false}

## LOG
if [ -z "${LOG_LEVEL:-}" ] && [ -s LOG_LEVEL ]; then LOG_LEVEL=$(cat LOG_LEVEL); fi; LOG_LEVEL=${LOG_LEVEL:-info}
if [ -z "${LOGTO:-}" ] && [ -s LOGTO ]; then LOGTO=$(cat LOGTO); fi; LOGTO=${LOGTO:-/dev/stderr}

LOG='{"debug":'${DEBUG}',"level":"'"${LOG_LEVEL}"'","logto":"'"${LOGTO}"'"}'

## SERVICE
if [ -z "${CONTAINER_ID:-}" ]; then CONTAINER_ID="kuiper"; fi
if [ -z "${CONTAINER_TAG:-}" ] && [ -s CONTAINER_TAG ]; then CONTAINER_TAG=$(cat CONTAINER_TAG); fi; CONTAINER_TAG=${KUIPER_VERSION:-0.3.1}

SERVICE='{"label":"kuiper","id":"'${CONTAINER_ID}'","tag":"'${CONTAINER_TAG}'","arch":"'${SERVICE_ARCH:-${BUILD_ARCH}}'","ports":{"service":9081,"host":'${KUIPER_PORT:-9081}'}}'

## COLORS
NO_COLOR='\033[0m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN_ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT_GRAY='\033[0;37m'

DARK_GRAY='\033[1;30m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_PURPLE='\033[1;35m'
LIGHT_CYAN='\033[1;36m'
WHITE='\034[1;37m'

# used
MC=${PURPLE}
TEST_BAD=${LIGHT_RED}
TEST_GOOD=${LIGHT_GREEN}
NC=${NO_COLOR}

##
## KUIPER
##

## source
source ${0%/*}/libkuiper.sh

motion_kuiper_stream_create()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo -e "${RED}${FUNCNAME[0]} ${*}${NC}" &> /dev/stderr; fi

  local name="${1}"
  local topic="${2}"
  local schema="${3:-}"
  local result

  echo -e "${MC}Dropping stream \"${name}\"${NC}" &> /dev/stderr
  result=$(kuiper.stream.drop ${name}) && echo "${result}" &> /dev/stderr
  echo -e "${MC}Creating stream \"${name}\" with \"${topic}\"${NC}" &> /dev/stderr
  result=$(kuiper.stream.create ${name} "${topic}" "${schema}") && echo "${result}" &> /dev/stderr
  echo -e "${MC}Describing stream \"${name}\"${NC}" &> /dev/stderr
  result=$(kuiper.stream.describe ${name})
  echo "${result:-null}"
}

motion_kuiper_rule_create()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo -e "${RED}${FUNCNAME[0]} ${*}${NC}" &> /dev/stderr; fi

  local name="${1}"
  local topic="${2}"
  local schema="${3:-}"
  local query="${4:-}"
  local result

  echo -e "${MC}Drop rule \"${name}\"${NC}" &> /dev/stderr
  result=$(kuiper.rule.drop ${name}) && echo "${result}" &> /dev/stderr
  echo -e "${MC}Creating rule \"${name}\"${NC}" &> /dev/stderr
  result=$(kuiper.rule.create ${name} "${MOTION_GROUP:-motion}/kuiper/${name}" "${query}") && echo "${result}" &> /dev/stderr
  echo -e "${MC}Describing rule \"${name}\"${NC}" &> /dev/stderr
  result=$(kuiper.rule.describe ${name})
  if [ "${result:-null}" != 'null' ]; then
    echo -e "${MC}Starting rule \"${name}\"${NC}" &> /dev/stderr
    kuiper.rule.start ${name} &> /dev/stderr
  fi
  echo "${result:-null}"
}

motion_kuiper_create()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo -e "${RED}${FUNCNAME[0]} ${*}${NC}" &> /dev/stderr; fi

  local name="${1}"
  local topic="${2}"
  local schema="${3:-}"
  local query="${4:-}"
  local stream=$(motion_kuiper_stream_create "${name}" "${topic}" "${schema}")
  local rule='null'
  local result

  if [ "${stream:-null}" != 'null' ]; then
    result='{"stream":'"${stream}"',"rule":'$(motion_kuiper_rule_create "${name}" "${topic}" "${schema}" "${query}")'}'
  fi
  echo "${result:-null}"
}

# cleanup
container_clean()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo -e "${RED}${FUNCNAME[0]} ${*}${NC}" &> /dev/stderr; fi

  local label=${1:-}
  local logpath=$(docker inspect --format '{{json .}}' "${label}" | jq -r '.LogPath')

  if [ "${logpath:-null}" != 'null' ]; then
    echo 'Attempting (sudo) to remove log file: '"${logpath}" && sudo /bin/rm -f "${logpath}" &> /dev/stderr
  else
    echo 'No existing log file: '"${logpath:-none}" &> /dev/stderr
  fi
  echo "Removing any existing container: ${label}" &> /dev/stderr
  docker rm -f ${label} &> /dev/null
}

container_start()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo -e "${RED}${FUNCNAME[0]} ${*}${NC}" &> /dev/stderr; fi

  local label=${1}
  local image=${2}
  local ext_port=${3}
  local int_port=${4}
  local broker=${5}
  local result

  # start up
  result=$(docker run -d \
    --name ${label} \
    --mount type=tmpfs,destination=/tmpfs,tmpfs-size=81920000,tmpfs-mode=1777 \
    --publish=${ext_port}:${int_port} \
    --restart=unless-stopped \
    -e MQTT_BROKER_ADDRESS=${broker} \
    ${image}  2> /dev/stderr)
  echo "${result:-null}"
}

###
### MAIN
###

# no globbing due to SQL statements
set -o noglob

# specify
LABEL=$(echo "${SERVICE:-null}" | jq -r '.label')
ARCH=$(echo "${SERVICE:-null}" | jq -r '.arch')
TAG=$(echo "${SERVICE:-null}" | jq -r '.tag')
ID=$(echo "${SERVICE:-null}" | jq -r '.id')
EXT_PORT=$(echo "${SERVICE}" | jq -r '.ports.host')
INT_PORT=$(echo "${SERVICE}" | jq -r '.ports.service') 

# cleanup
container_clean ${LABEL}

# start
CID=$(container_start ${LABEL} "${DOCKER_NAMESPACE:-emqx}/${ID}:${TAG}" ${EXT_PORT} ${INT_PORT} "tcp://${MQTT_USERNAME}:${MQTT_PASSWORD}@${MQTT_HOST}:${MQTT_PORT}")

# report
if [ "${CID:-null}" != 'null' ]; then
  echo 'Container '${LABEL}' started; status: "curl http://'${KUIPER_HOST:-localhost}:${EXT_PORT}'; id: '"${CID}" &> /dev/stderr
else
  echo "Container ${LABEL} failed" &> /dev/stderr
  exit 1
fi

echo -n 'Wating for kuiper...' &> /dev/stderr
i=0; kuiper=''; while [ ${i} -le 10 ]; do 
kuiper="$(curl -sSL http://${KUIPER_HOST:-localhost}:${EXT_PORT} 2> /dev/null)"
  if [ "${kuiper:-null}" = 'OK' ]; then break; fi
  echo -n '.' &> /dev/stderr
  sleep 1
  i=$((i+1))
done
echo '' &> /dev/stderr

if [ "${kuiper:-}" = 'OK' ]; then
  # device_start
  name='device_start'
  topic="${MOTION_GROUP:-+}/${MOTION_CLIENT:-+}/start"
  schema=''

  result=$(motion_kuiper_create "${name}" "${topic}" "${schema}")
  if [ "${result:-null}" != 'null' ]; then
    KUIPER=$(echo "${KUIPER}" | jq '.rules+='"$(echo ${result} | jq '[.rule]')")
    KUIPER=$(echo "${KUIPER}" | jq '.streams+='"$(echo ${result} | jq '[.stream]')")
  fi

  # motion_annotated
  name='motion_annotated'
  topic="${MOTION_GROUP:-+}/${MOTION_CLIENT:-+}/${MOTION_CAMERA:-+}/event/end/+"
  schema='date bigint,time float,count bigint,detected array(struct(entity string,count bigint)),event struct(device string, camera string)'

  result=$(motion_kuiper_create ${name} "${topic}" "${schema}")
  if [ "${result:-null}" != 'null' ]; then
    KUIPER=$(echo "${KUIPER}" | jq '.rules+='"$(echo ${result} | jq '[.rule]')")
    KUIPER=$(echo "${KUIPER}" | jq '.streams+='"$(echo ${result} | jq '[.stream]')")
  fi

  # cameras only
  name='cameras'
  query="select cameras from device_start"

  kuiper.rule.create "${name}" "${MOTION_GROUP:-+}/kuiper/${name}" "${query}" &> /dev/stderr
  result=$(kuiper.rule.describe "${name}")
  if [ "${result:-null}" != 'null' ]; then
    kuiper.rule.start "${name}" &> /dev/stderr
    KUIPER=$(echo "${KUIPER}" | jq '.rules+='"$(echo ${result} | jq '[.]')")
  fi

  if [ "${DEBUG:-false}" = 'true' ]; then
    mosquitto_sub -h ${MQTT_HOST} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -p ${MQTT_PORT} -t "${MOTION_GROUP:-+}/kuiper/device_start" >> debug-devices.json 2> /dev/null &
    mosquitto_sub -h ${MQTT_HOST} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -p ${MQTT_PORT} -t "${MOTION_GROUP:-+}/kuiper/motion_annotated" >> debug-annotations.json 2> /dev/null &
    mosquitto_sub -h ${MQTT_HOST} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -p ${MQTT_PORT} -t "${MOTION_GROUP:-+}/kuiper/cameras" >> debug-cameras.json 2> /dev/null &
  fi
fi

echo '{"name":"'${LABEL}'","id":"'${CID:-null}'","service":'"${SERVICE}"',"status":"'${kuiper:-}'","kuiper":'"${KUIPER}"',"mqtt":'"${MQTT}"',"log":'"${LOG}"'}' | jq '.' | tee "${0##*/}.json"
