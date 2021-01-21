#!/bin/bash

listen()
{
  # device start-up
  mosquitto_sub -h ${MQTT_HOST} -p ${MQTT_PORT} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -t "+/${MOTION_CLIENT}/start" \
    | jq -c '{"DEVICE":{"group":.group,"device":.device,"cameras":[.cameras[].name]}}' &
  
  # camera found
  mosquitto_sub -h ${MQTT_HOST} -p ${MQTT_PORT} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -t "+/${MOTION_CLIENT}/+/status/found" \
    | jq -c '{"CAMERA_FOUND":.}' &
  # camera lost
  mosquitto_sub -h ${MQTT_HOST} -p ${MQTT_PORT} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -t "+/${MOTION_CLIENT}/+/status/lost" \
    | jq -c '{"CAMERA_LOST":.}' &
  
  # start
  mosquitto_sub -h ${MQTT_HOST} -p ${MQTT_PORT} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -t "+/${MOTION_CLIENT}/+/event/start" \
    | jq -c '{"START":.}' &

  # end
  mosquitto_sub -h ${MQTT_HOST} -p ${MQTT_PORT} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -t "+/${MOTION_CLIENT}/+/event/end" \
    | jq -c '{"END":{"group":.group,"device":.device,"camera":.camera,"event":.event,"timestamp":.timestamp,"device":.device}}' &
  
  ## annotated
  mosquitto_sub -h ${MQTT_HOST} -p ${MQTT_PORT} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -t "+/${MOTION_CLIENT}/+/event/end/+" \
    | jq -c '{"ANNOTATED":{"timestamp":.timestamp,"group":.event.group,"device":.event.device,"camera":.event.camera,"event":.event.event,"timestamp":.event.timestamp,"detected":.detected}}' &
  
  ## face
  mosquitto_sub -h ${MQTT_HOST} -p ${MQTT_PORT} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -t "+/${MOTION_CLIENT}/+/event/face/+" \
    | jq -c '{"FACE":{"timestamp":.timestamp,"group":.event.group,"device":.event.device,"camera":.event.camera,"event":.event.event,"timestamp":.event.timestamp,"detected":.detected}}' &

  ## alpr
  mosquitto_sub -h ${MQTT_HOST} -p ${MQTT_PORT} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -t "+/${MOTION_CLIENT}/+/event/alpr/+" \
    | jq -c '{"ALPR":{"timestamp":.timestamp,"group":.event.group,"device":.event.device,"camera":.event.camera,"event":.event.event,"timestamp":.event.timestamp,"detected":.detected}}' &
  
  # annotated
  mosquitto_sub -h ${MQTT_HOST} -p ${MQTT_PORT} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -t "+/${MOTION_CLIENT}/+/annotated" \
    | jq -c '{"PROCESSED":{"group":.event.group,"device":.event.device,"camera":.event.camera,"images":.event.images|length,"detected":.detected}}' &
    #| jq -c '{"PROCESSED":.|(.event.image=(.event.image!=null))|(.image=(.image!=null))}' &
  
  # detected
  mosquitto_sub -h ${MQTT_HOST} -p ${MQTT_PORT} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -t "+/${MOTION_CLIENT}/+/detected" \
    | jq -c '{"SEEN":{"group":.event.group,"device":.event.device,"camera":.event.camera,"images":.event.images|length,"detected":.detected}}' &
    #| jq -c '{"SEEN":.|(.event.image=(.event.image!=null))|(.image=(.image!=null))}' &
  
  # detected_entity
  mosquitto_sub -h ${MQTT_HOST} -p ${MQTT_PORT} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -t "+/${MOTION_CLIENT}/+/detected_entity" \
    | jq -c '{"FOUND":{"group":.event.group,"device":.event.device,"camera":.event.camera,"images":.event.images|length,"detected":.detected}}' &
}

###
### MAIN
###

if [ -z "$(command -v mosquitto_sub)" ]; then
  echo "Please install mosquitto_sub; sudo apt install -qq -y mosquitto-clients" > /dev/stderr
  exit 1
fi

PIDS=($(ps alxwww | egrep 'mosquitto_sub' | egrep -v 'grep' | awk '{ print $3 }'))
if [ ${#PIDS[@]} -gt 0 ]; then
   echo "Killing existing mosquitto_sub processes: ${PIDS[@]}" &> /dev/stderr
   for pid in ${PIDS[@]}; do kill -9 ${pid}; done
fi

if [ "${1:-}" = 'off' ]; then exit; fi

# MOTION_DEVICE
if [ -s "MOTION_DEVICE" ] || [ ${MOTION_DEVICE:-null} != 'null' ]; then
  v=${MOTION_DEVICE:-$(cat MOTION_DEVICE)} && echo "** SPECIFIED: MOTION_DEVICE: ${v}" > /dev/stderr 
else 
 v=$(hostname -s | sed -e "s/-//g" -e "s/ /_/g") && echo "!! UNSPECIFIED: MOTION_DEVICE unset; default: ${v}" > /dev/stderr 
fi
MOTION_DEVICE=${MOTION_DEVICE:-${v}}

# MOTION_CLIENT
if [ -s "MOTION_CLIENT" ] || [ ${MOTION_CLIENT:-null} != 'null' ]; then
  v=${MOTION_CLIENT:-$(cat MOTION_CLIENT)} && echo "** SPECIFIED: MOTION_CLIENT: ${v}" > /dev/stderr 
else
  v="${MOTION_DEVICE}" && echo "!! UNSPECIFIED: MOTION_CLIENT unset; default: ${v}" > /dev/stderr 
fi
MOTION_CLIENT=${MOTION_CLIENT:-${v}}

# MQTT_HOST
if [ -s "MQTT_HOST" ] || [ ${MQTT_HOST:-null} != 'null' ]; then
  v=${MQTT_HOST:-$(cat MQTT_HOST)} && echo "** SPECIFIED: MQTT_HOST: ${v}" > /dev/stderr 
else
  v=$(hostname -I | awk '{ print $1 }') && echo "!! UNSPECIFIED: MQTT_HOST unset; default: ${v}" > /dev/stderr 
  v=$(read -p "?? INQUIRY: MQTT_HOST: [default: ${v}]: " && echo "${REPLY:-${v}}" | tee MQTT_HOST)
fi
MQTT_HOST=${MQTT_HOST:-${v}}

if [ -s "MQTT_PORT" ]; then MQTT_PORT=$(cat "MQTT_PORT"); else MQTT_PORT=${MQTT_PORT:-1883}; fi
if [ -s "MQTT_USERNAME" ]; then MQTT_USERNAME=$(cat "MQTT_USERNAME"); else MQTT_USERNAME=${MQTT_USERNAME:-username}; fi
if [ -s "MQTT_PASSWORD" ]; then MQTT_PASSWORD=$(cat "MQTT_PASSWORD"); else MQTT_PASSWORD=${MQTT_PASSWORD:-password}; fi

listen
