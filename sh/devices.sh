#!/bin/bash

MQTT_HOST=${MQTT_HOST:-mqtt}
MQTT_USERNAME=${MQTT_USERNAME:-username}
MQTT_PASSWORD=${MQTT_PASSWORD:-password}

TOPIC="+/+/start"
DEVICES='[]'
TOTAL_BYTES=0
BEGIN=$(date +%s)

echo "--- INFO $0 $$ -- listening for topic ${TOPIC}" &> /dev/stderr

mosquitto_sub -h ${MQTT_HOST} -u username -P password -t ${TOPIC} | while read -r; do

    NOW=$(date +%s)

    if [ -n "${REPLY}" ]; then
      PAYLOAD=${0##*/}.$$.json
      echo "${REPLY}" > ${PAYLOAD}
      VALID=$(echo "${REPLY}" | jq -c '.!=null' 2> ${PAYLOAD%.*}.out)
    else
      if [ "${DEBUG:-}" = true ]; then echo "+++ WARN $0 $$ -- received null payload:" $(date +%T) &> /dev/stderr; fi
      continue
    fi
    if [ "${VALID}" != true ]; then
      if [ "${DEBUG:-}" = true ]; then echo "+++ WARN $0 $$ -- invalid payload: ${VALID}" $(cat ${PAYLOAD%.*}.out) &> /dev/stderr; fi
    else
      BYTES=$(wc -c ${PAYLOAD} | awk '{ print $1 }')
      TOTAL_BYTES=$((TOTAL_BYTES+BYTES))
      ELAPSED=$((NOW-BEGIN))
      if [ ${ELAPSED} -ne 0 ]; then BPS=$(echo "${TOTAL_BYTES} / ${ELAPSED}" | bc -l); else BPS=1; fi
      echo "### DATA $0 $$ -- received at: $(date +%T); bytes: ${BYTES}; total bytes: ${TOTAL_BYTES}; bytes/sec: ${BPS}" &> /dev/stderr
    fi

    group=$(jq -r '.group' ${PAYLOAD})
    device=$(jq -r '.device' ${PAYLOAD})

    ID="${group}-${device}"
    DATE=$(jq -r '.date' ${PAYLOAD})
    STARTED=$((NOW-DATE))

    # MOTION
    if [ $(jq '.motion?!=null' ${PAYLOAD}) = true ]; then
      MOTION_JSON=$(jq -c '.motion' ${PAYLOAD})
      MOTION_STATUS=$(echo "${MOTION_JSON}" | jq -c '.')
    fi
    MOTION_STATUS=${MOTION_STATUS:-null}

    # CAMERAS
    if [ $(jq '.cameras?!=null' ${PAYLOAD}) = true ]; then
      CAMERAS_JSON=$(jq -c '.cameras' ${PAYLOAD})
      NUM_CAMERAS=$(echo "${CAMERAS_JSON}" | jq '.|length')
      CAMERAS=$(echo "${CAMERAS_JSON}" | jq -c '[.[]|{"name":.name,"type":.type,"id":.id,"netcam_url":.netcam_url,"mjpeg_url":.mjpeg_url}]')
    fi
    NUM_CAMERAS=${NUM_CAMERAS:-0}
    CAMERAS=${CAMERAS:-null}

    # ARCH
    if [ $(jq '.cpu?!=null' ${PAYLOAD}) = true ]; then
      ARCH=$(jq -r '.arch' ${PAYLOAD})
    fi
    ARCH=${ARCH:-null}

    # BROKER
    if [ $(jq '.mqtt?!=null' ${PAYLOAD}) = true ]; then
      BROKER_JSON=$(jq -c '.mqtt' ${PAYLOAD})
      BROKER_HOST=$(echo "${BROKER_JSON}" | jq -r '.host')
    fi
    BROKER_HOST="${BROKER_HOST:-undefined}"

    if [ "${DEBUG:-}" = true ]; then echo "--- INFO $0 $$ -- device: ${ID}; motion: ${MOTION_STATUS}; entity: ${ENTITY:-unknown}; started: ${STARTED}; ncamera: ${NUM_CAMERAS}; arch: ${ARCH}; broker: ${BROKER_HOST}" &> /dev/stderr; fi

    if [ ! -z "${ID:-}" ]; then
      THIS=$(echo "${DEVICES}" | jq '.[]|select(.id=="'${ID}'")')
    else
      THIS='null'
    fi
    if [ -z "${THIS}" ] || [ "${THIS}" = 'null' ]; then
      TOTAL_RECEIVED=0
      TOTAL_SEEN=0
      FIRST_SEEN=0
      LAST_SEEN=0
      SEEN_PER_SECOND=0
      THIS='{"id":"'${ID:-}'","entity":"'${ENTITY}'","date":'${DATE}',"started":'${STARTED}',"count":'${TOTAL_RECEIVED}',"seen":'${TOTAL_SEEN}',"first":'${FIRST_SEEN}',"last":'${LAST_SEEN}',"average":'${SEEN_PER_SECOND:-0}',"ncamera":'${NUM_CAMERAS:-0}',"cameras":'${CAMERAS:-null}',"broker":"'${BROKER_HOST:-null}'"}'
      DEVICES=$(echo "${DEVICES}" | jq '.+=['"${THIS}"']')
    else
      TOTAL_RECEIVED=$(echo "${THIS}" | jq '.count') || TOTAL_RECEIVED=0
      TOTAL_SEEN=$(echo "${THIS}" | jq '.seen') || TOTAL_SEEN=0
      FIRST_SEEN=$(echo "${THIS}" | jq '.first') || FIRST_SEEN=0
      SEEN_PER_SECOND=$(echo "${THIS}" | jq '.average') || SEEN_PER_SECOND=0
    fi

    if [ $(jq '.status!=null' ${PAYLOAD}) = true ]; then
      if [ $(jq '.status.mock?!=null' ${PAYLOAD}) = 'true' ]; then
        if [ "${DEBUG:-}" = true ]; then echo "--- INFO $0 $$ -- ${ID}: non-mock" &> /dev/stderr; fi
        WHEN=$(jq -r '.status.date' ${PAYLOAD})
        if [ ${WHEN} -gt ${LAST_SEEN} ]; then
          if [ "${DEBUG:-}" = true ]; then echo "--- INFO $0 $$ -- ${ID}: new payload" &> /dev/stderr; fi
          SEEN=$(jq -r '.status.count' ${PAYLOAD})
          jq -r '.status.image' ${PAYLOAD} | base64 --decode > ${0##*/}.$$.${ID}.jpeg
          if [ ${SEEN} -gt 0 ]; then
            # increment total entities seen
            TOTAL_SEEN=$((TOTAL_SEEN+SEEN))
            # track when
            LAST_SEEN=${WHEN}
            AGO=$((NOW-LAST_SEEN))
            echo "### DATA $0 $$ -- ${ID}; ago: ${AGO:-0}; ${ENTITY} seen: ${SEEN}" &> /dev/stderr
            # calculate interval
            if [ "${FIRST_SEEN:-0}" -eq 0 ]; then FIRST_SEEN=${LAST_SEEN}; fi
            INTERVAL=$((LAST_SEEN-FIRST_SEEN))
            if [ ${INTERVAL} -eq 0 ]; then 
              FIRST_SEEN=${WHEN}
              INTERVAL=0
              SEEN_PER_SECOND=1.0
            else
              SEEN_PER_SECOND=$(echo "${TOTAL_SEEN}/${INTERVAL}" | bc -l)
            fi
            THIS=$(echo "${THIS}" | jq '.date='${NOW}'|.interval='${INTERVAL:-0}'|.ago='${AGO:-0}'|.seen='${TOTAL_SEEN:-0}'|.last='${LAST_SEEN:-0}'|.first='${FIRST_SEEN:-0}'|.average='${SEEN_PER_SECOND:-0})
          else
            if [ "${DEBUG:-}" = true ]; then echo "--- INFO $0 $$ -- ${ID} at ${WHEN}; did not see: ${ENTITY:-null}" &> /dev/stderr; fi
          fi
        else
          if [ "${DEBUG:-}" = true ]; then echo "--- INFO $0 $$ -- old payload" &> /dev/stderr; fi
        fi
      fi
    else
      echo "+++ WARN $0 $$ -- ${ID} at ${WHEN}: no status output" &> /dev/stderr
    fi

    TOTAL_RECEIVED=$((TOTAL_RECEIVED+1)) && THIS=$(echo "${THIS}" | jq '.count='${TOTAL_RECEIVED})
    DEVICES=$(echo "${DEVICES}" | jq -c '(.[]|select(.id=="'${ID}'"))|='"${THIS}")
    DEVICES=$(echo "${DEVICES}" | jq -c '[.|sort_by(.date)[]]')

    echo ">>> $0 $$ -- $(date +%T) - publishing"
    count=$(echo "${DEVICES}" | jq '.|length')
    if [ ${count:-0}  -gt 1 ]; then
      if [ "${DEBUG:-false}" = 'true' ]; then echo "${DEVICES}" | jq -c '[.|sort_by(.date)[]]' &> /dev/stderr; fi
      mosquitto_pub -r -h ${MQTT_HOST} -u ${MQTT_USERNAME} -P ${MQTT_PASSWORD} -t "${group}/status/devices" -m "${DEVICES}"
    else
      echo "NO DEVICES" &> /dev/stderr
    fi
done
rm -f ${0##*/}.$$.*
