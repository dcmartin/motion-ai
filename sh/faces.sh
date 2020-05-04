#!/bin/bash

cmd=${0##*/} && cmd=${cmd%%.*}
mkdir -p ${cmd}/

topic='+/+/+/event/face/+'
filter='.|select(.detected|max>98)'

echo "${0##*/} processing; topic: ${topic}; filter: ${filter}; destination: ${cmd}/" &> /dev/stderr

mosquitto_sub -h 192.168.1.50 -u username -P password -t ${topic} \
  | jq -c "${filter}" \
  | while read -r; do
  if [ -z "${REPLY:-}" ]; then continue; fi
  echo "${REPLY}" >> ${cmd}.json
  event=$(echo "${REPLY}" | jq -r '.event.event')
  source=$(echo "${REPLY}" | jq -j '.group,"-",.device,"-",.camera')
  echo "${0##*/} matching event: ${source}.${event}" &> /dev/stderr
  echo "${REPLY}" | jq -c '.' > ${cmd}/${source}.${event}.json
  echo "${REPLY}" | jq -r '.event.image' | base64 --decode > ${cmd}/${source}.${event}.jpg
  echo "${REPLY}" | jq -r '.image' | base64 --decode > ${cmd}/${source}.${event}.jpeg
done
