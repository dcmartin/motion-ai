#!/bin/bash

###
### webcams GROUP
###

LIMITED_BUILD=$(jq -r '.limited?==true' ${1:-webcams.json})

WEBCAMS=$(jq -r '.[].name' ${1:-webcams.json})

## SENSORS
if [ "${LIMITED_BUILD:-null}" != 'true' ]; then
  WEBCAM_SENSORS='motion_annotated_ago motion_annotated_counter motion_annotated_percent motion_detected_ago motion_detected_counter motion_detected_entity_ago motion_detected_entity_counter'
else
  WEBCAM_SENSORS='motion_annotated_percent motion_detected_ago motion_detected_counter motion_detected_entity_ago motion_detected_entity_counter'
fi

for WID in ${WEBCAM_SENSORS}; do
  echo "#"
  echo "${WID}:"
  echo "  name: ${WID}"
#  echo "  control: hidden"
  echo "  entities:"
  for C in ${WEBCAMS}; do
    echo "    - sensor.${WID}_${C}"
  done
done

## BINARY_SENSORS
if [ "${LIMITED_BUILD:-null}" != 'true' ]; then
  WEBCAM_BINARY_SENSORS='motion_status_camera motion_end motion_annotated motion_detected motion_detected_entity'
else
  WEBCAM_BINARY_SENSORS='motion_status_camera motion_detected motion_detected_entity'
fi

for WID in ${WEBCAM_BINARY_SENSORS}; do
  echo "#"
  echo "${WID}:"
  echo "  name: ${WID}"
#  echo "  control: hidden"
  echo "  entities:"
  for C in ${WEBCAMS}; do
    echo "    - binary_sensor.${WID}_${C}"
  done
done

## SNAPSHOTS
if [ "${LIMITED_BUILD:-null}" != 'true' ]; then
  WEBCAM_SNAPSHOTS='motion_end motion_annotated motion_detected motion_detected_entity'
else
  WEBCAM_SNAPSHOTS='motion_detected motion_detected_entity'
fi

for WID in ${WEBCAM_SNAPSHOTS}; do
  echo "#"
  echo "${WID}_webcams:"
  echo "  name: ${WID}_webcams"
#  echo "  control: hidden"
  echo "  entities:"
  for C in ${WEBCAMS}; do
    echo "    - camera.${WID}_snapshot_${C}"
  done
done

## CAMERAS
if [ "${LIMITED_BUILD:-null}" != 'true' ]; then
  WEBCAM_CAMERAS='motion_event_animated motion_live'
else
  WEBCAM_CAMERAS='motion_live'
fi

for WID in ${WEBCAM_CAMERAS}; do
  echo "#"
  echo "${WID}_webcams:"
  echo "  name: ${WID}_webcams"
#  echo "  control: hidden"
  echo "  entities:"
  for C in ${WEBCAMS}; do
    echo "    - camera.${WID}_${C}"
  done
done
