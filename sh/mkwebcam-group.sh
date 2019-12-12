#!/bin/bash

###
### webcams GROUP
###

WEBCAMS=$(jq -r '.[].name' ${1:-webcams.json})

## SENSORS
WEBCAM_SENSORS='motion_annotated_ago motion_annotated_counter motion_annotated_percent motion_detected_ago motion_detected_counter motion_detected_entity_ago motion_detected_entity_counter'

for WID in ${WEBCAM_SENSORS}; do
  echo "#"
  echo "${WID}_webcams:"
  echo "  name: ${WID}_webcams"
  echo "  control: hidden"
  echo "  entities:"
  for C in ${WEBCAMS}; do
    echo "    - sensor.${WID}_${C}"
  done
done

## BINARY_SENSORS
WEBCAM_BINARY_SENSORS='motion_end motion_annotated motion_detected motion_detected_entity'

for WID in ${WEBCAM_BINARY_SENSORS}; do
  echo "#"
  echo "${WID}_webcams:"
  echo "  name: ${WID}_webcams"
  echo "  control: hidden"
  echo "  entities:"
  for C in ${WEBCAMS}; do
    echo "    - binary_sensor.${WID}_${C}"
  done
done

## EVENTS
WEBCAM_IMAGES='motion_end motion_annotated motion_detected motion_detected_entity'

for WID in ${WEBCAM_IMAGES}; do
  echo "#"
  echo "${WID}_images:"
  echo "  name: ${WID}_images"
  echo "  control: hidden"
  echo "  entities:"
  for C in ${WEBCAMS}; do
    echo "    - camera.${WID}_picture_${C}"
  done
done

## DIRECT
WEBCAM_IMAGES='motion_event_animated motion_live'

for WID in ${WEBCAM_IMAGES}; do
  echo "#"
  echo "${WID}_images:"
  echo "  name: ${WID}_images"
  echo "  control: hidden"
  echo "  entities:"
  for C in ${WEBCAMS}; do
    echo "    - camera.${WID}_${C}"
  done
done
