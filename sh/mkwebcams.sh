#!/bin/bash

###
### webcams GROUP
###

WEBCAMS=$(jq -r '.[].name' ${1:-webcams.json})

WEBCAM_GROUP_IDS='motion_annotated_ago motion_annotated_counter motion_annotated_images motion_annotated_percent motion_annotated motion_detected_ago motion_detected_counter motion_detected_entity_ago motion_detected_entity_counter motion_detected_entity_images motion_detected_entity motion_detected'

for WID in ${WEBCAM_GROUP_IDS}; do
  echo "#"
  echo "${WID}_webcams:"
  echo "  name: ${WID}_webcams"
  echo "  control: hidden"
  echo "  entities:"
  for C in ${WEBCAMS}; do
    echo "    - sensor.${WID}_${C}"
  done
done

IMAGE_GROUP_IDS='motion_camera motion_detected motion_animated motion_live'

for WID in ${IMAGE_GROUP_IDS}; do
  echo "#"
  echo "${WID}_images:"
  echo "  name: ${WID}_images"
  echo "  control: hidden"
  echo "  entities:"
  for C in ${WEBCAMS}; do
    echo "    - camera.${WID}_${C}"
  done
done
