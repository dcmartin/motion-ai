#!/bin/bash

# calculated
BUILD_ARCH=$(uname -m | sed -e 's/aarch64.*/arm64/' -e 's/x86_64.*/amd64/' -e 's/armv.*/arm/')

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
if [ -z "${KUIPER_CONFIG:-}" ] && [ -s KUIPER_CONFIG ]; then KUIPER_CONFIG=$(cat KUIPER_CONFIG); fi; KUIPER_CONFIG=${KUIPER_CONFIG:-tiny}
if [ -z "${KUIPER_ENTITY:-}" ] && [ -s KUIPER_ENTITY ]; then KUIPER_ENTITY=$(cat KUIPER_ENTITY); fi; KUIPER_ENTITY=${KUIPER_ENTITY:-all}
if [ -z "${KUIPER_SCALE:-}" ] && [ -s KUIPER_SCALE ]; then KUIPER_SCALE=$(cat KUIPER_SCALE); fi; KUIPER_SCALE=${KUIPER_SCALE:-none}
if [ -z "${KUIPER_THRESHOLD:-}" ] && [ -s KUIPER_THRESHOLD ]; then KUIPER_THRESHOLD=$(cat KUIPER_THRESHOLD); fi; KUIPER_THRESHOLD=${KUIPER_THRESHOLD:-0.25}

KUIPER='{"config":"'${KUIPER_CONFIG}'","entity":"'${KUIPER_ENTITY}'","scale":"'${KUIPER_SCALE}'","threshold":'${KUIPER_THRESHOLD}'}'

## DEBUG
if [ -z "${DEBUG:-}" ] && [ -s DEBUG ]; then DEBUG=$(cat DEBUG); fi; DEBUG=${DEBUG:-false}
if [ -z "${LOG_LEVEL:-}" ] && [ -s LOG_LEVEL ]; then LOG_LEVEL=$(cat LOG_LEVEL); fi; LOG_LEVEL=${LOG_LEVEL:-info}
if [ -z "${LOGTO:-}" ] && [ -s LOGTO ]; then LOGTO=$(cat LOGTO); fi; LOGTO=${LOGTO:-/dev/stderr}

DEBUG='{"debug":'${DEBUG}',"level":"'"${LOG_LEVEL}"'","logto":"'"${LOGTO}"'"}'

## SERVICE
if [ -z "${CONTAINER_ID:-}" ]; then CONTAINER_ID="kuiper"; fi
if [ -z "${CONTAINER_TAG:-}" ] && [ -s CONTAINER_TAG ]; then CONTAINER_TAG=$(cat CONTAINER_TAG); fi; CONTAINER_TAG=${CONTAINER_TAG:-0.3.1}

SERVICE='{"label":"kuiper","id":"'${CONTAINER_ID}'","tag":"'${CONTAINER_TAG}'","arch":"'${SERVICE_ARCH:-${BUILD_ARCH}}'","ports":{"service":'${SERVICE_PORT:-9081}',"host":'${HOST_PORT:-9081}'}}'

# notify
echo 'SERVICE: '$(echo "${SERVICE}" | jq -c '.') &> /dev/stderr
echo 'MOTION: '$(echo "${MOTION}" | jq -c '.') &> /dev/stderr
echo 'MQTT: '$(echo "${MQTT}" | jq -c '.') &> /dev/stderr
echo 'KUIPER: '$(echo "${KUIPER}" | jq -c '.') &> /dev/stderr
echo 'DEBUG: '$(echo "${DEBUG}" | jq -c '.') &> /dev/stderr

# specify
LABEL=$(echo "${SERVICE:-null}" | jq -r '.label')
ARCH=$(echo "${SERVICE:-null}" | jq -r '.arch')
TAG=$(echo "${SERVICE:-null}" | jq -r '.tag')
ID=$(echo "${SERVICE:-null}" | jq -r '.id')
EXT_PORT=$(echo "${SERVICE}" | jq -r '.ports.host')
INT_PORT=$(echo "${SERVICE}" | jq -r '.ports.service') 

##
## KUIPER
##

## source
source ${0%/*}/kuiper-tools.sh

###
### MAIN
###

# cleanup
echo "Removing any existing container: ${LABEL}" &> /dev/stderr
docker rm -f ${LABEL} &> /dev/null
# report
echo "Using container named: ${DOCKER_NAMESPACE:-emqx}/${CONTAINER_ID}"  &> /dev/stderr

# start up
echo "Starting new container: ${LABEL}; id: ${ID}; architecture: ${ARCH}; tag: ${TAG}; host: ${EXT_PORT}; service: ${INT_PORT}" &> /dev/stderr
CID=$(docker run -d \
  --name ${LABEL} \
  --mount type=tmpfs,destination=/tmpfs,tmpfs-size=81920000,tmpfs-mode=1777 \
  --publish=${EXT_PORT}:${INT_PORT} \
  --restart=unless-stopped \
  -e MQTT_BROKER_ADDRESS=tcp://${MQTT_USERNAME}:${MQTT_PASSWORD}@${MQTT_HOST}:${MQTT_PORT} \
  "${DOCKER_NAMESPACE:-emqx}/${ID}:${TAG}" 2> /dev/stderr)

# report
if [ "${CID:-null}" != 'null' ]; then
  echo 'Container '${LABEL}' started; status: "curl http://'${KUIPER_HOST:-localhost}:${EXT_PORT}'; id: '"${CID}" &> /dev/stderr

  while [ "$(curl -sSL http://${KUIPER_HOST:-localhost}:${EXT_PORT} 2> /dev/null)" != 'OK' ]; do echo -n '.'; sleep 1; done; echo ''

  schema='ipaddr string,hostname string,arch string,date bigint,device string,client string,timezone string,unit_system string,latitude float,longitude float,elevation bigint,motion struct( log_type string,log_level bigint,log_file string,target_dir string,auto_brightness string,locate_motion_mode string,locate_motion_style string,post_pictures string,picture_output string,movie_output string,movie_output_motion string,picture_type string,netcam_keepalive string,netcam_userpass string,palette bigint,pre_capture bigint,post_capture bigint,event_gap bigint,fov bigint,minimum_motion_frames bigint,picture_quality bigint,framerate bigint,changes string,text_scale bigint,despeckle_filter string,brightness bigint,contrast bigint,saturation bigint,hue bigint,rotate bigint,webcontrol_port bigint,stream_port bigint,stream_quality bigint,width bigint,height bigint,threshold_tune string,threshold_percent bigint,threshold bigint,lightswitch bigint,interval bigint,type string,stream_auth_method string,username string,password string),cameras array(struct( id bigint,type string,name string,fov bigint,width bigint,height bigint,framerate bigint,event_gap bigint,target_dir string,server bigint,cnum bigint,conf string,mjpeg_url string,rotate bigint,picture_quality bigint,stream_quality bigint,threshold_percent bigint,threshold bigint,palette bigint))'

  #schema='ipaddr string,hostname string,arch string,date bigint,device string,group string,client string,timezone string,unit_system string,latitude float,longitude float,elevation bigint,motion struct( log_type string,log_level bigint,log_file string,target_dir string,auto_brightness string,locate_motion_mode string,locate_motion_style string,post_pictures string,picture_output string,movie_output string,movie_output_motion string,picture_type string,netcam_keepalive string,netcam_userpass string,palette bigint,pre_capture bigint,post_capture bigint,event_gap bigint,fov bigint,minimum_motion_frames bigint,picture_quality bigint,framerate bigint,changes string,text_scale bigint,despeckle_filter string,brightness bigint,contrast bigint,saturation bigint,hue bigint,rotate bigint,webcontrol_port bigint,stream_port bigint,stream_quality bigint,width bigint,height bigint,threshold_tune string,threshold_percent bigint,threshold bigint,lightswitch bigint,interval bigint,type string,stream_auth_method string,username string,password string),cameras array(struct( id bigint,type string,name string,fov bigint,width bigint,height bigint,framerate bigint,event_gap bigint,target_dir string,server bigint,cnum bigint,conf string,mjpeg_url string,rotate bigint,picture_quality bigint,stream_quality bigint,threshold_percent bigint,threshold bigint,palette bigint))'
  topic="${MOTION_GROUP:-+}/${MOTION_CLIENT:-+}/start"
  name='device_start'

  echo "Dropping stream \"${name}\"" && v=$(kuiper.stream.drop ${name}) && echo "${v}"
  echo "Creating stream \"${name}\" with \"${topic}\"" && v=$(kuiper.stream.create ${name} "${topic}" "${schema}") && echo "${v}"
  echo "Describing stream \"${name}\"" && v=$(kuiper.stream.describe ${name}) && echo "${v}"

  echo 'Drop rule "new_device"' && v=$(kuiper.rule.drop new_device) && echo "${v}"
  echo 'Creating rule "new_device"' && v=$(kuiper.rule.create new_device device_start "${MOTION_GROUP:-motion}/devices") && echo "${v}"
  echo 'Describing rule "new_device"' && v=$(kuiper.rule.describe new_device) && echo "${v}"
  echo 'Starting rule "new_device"' && v=$(kuiper.rule.start new_device) && echo "${v}"

  schema='date bigint,cameras array(struct(entity string,count bigint)),event struct(device string, camera string)'
  topic="${MOTION_GROUP:-+}/${MOTION_CLIENT:-+}/${MOTION_CAMERA:-+}/event/end/+"
  name='motion_annotated'

  echo "Dropping stream \"${name}\"" && v=$(kuiper.stream.drop ${name}) && echo "${v}"
  echo "Creating stream \"${name}\" with \"${topic}\"" && v=$(kuiper.stream.create ${name} "${topic}" "${schema}") && echo "${v}"
  echo "Describing stream \"${name}\"" && v=$(kuiper.stream.describe ${name}) && echo "${v}"

  echo 'Drop rule "new_device"' && v=$(kuiper.rule.drop motion_annotated) && echo "${v}"
  echo 'Creating rule "motion_annotated"' && v=$(kuiper.rule.create motion_annotated motion_annotated "${MOTION_GROUP:-motion}/annotations") && echo "${v}"
  echo 'Describing rule "motion_annotated"' && v=$(kuiper.rule.describe motion_annotated) && echo "${v}"
  echo 'Starting rule "motion_annotated"' && v=$(kuiper.rule.start motion_annotated) && echo "${v}"

  mosquitto_sub -h ${MQTT_HOST} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -p ${MQTT_PORT} -t "${MOTION_GROUP:-motion}/devices" &
  mosquitto_sub -h ${MQTT_HOST} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -p ${MQTT_PORT} -t "${MOTION_GROUP:-motion}/annotations" &

else
  echo "Container ${LABEL} failed" &> /dev/stderr
fi
echo '{"name":"'${LABEL}'","id":"'${CID:-null}'","service":'"${SERVICE}"',"motion":'"${MOTION:-null}"',"kuiper":'"${KUIPER}"',"mqtt":'"${MQTT}"',"debug":'"${DEBUG}"'}' | jq '.'

