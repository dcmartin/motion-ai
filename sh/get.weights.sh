#!/bin/bash

WEIGHTS=(yolov2-tiny-voc.weights yolov3-tiny.weights yolov2.weights yolov3.weights)

for m in ${WEIGHTS[@]}; do
  if [ ! -s "${m}" ]; then
    wget http://pjreddie.com/media/files/${m}
  else
    echo "Weights: ${m} already exists" &> /dev/stderr
  fi
done
