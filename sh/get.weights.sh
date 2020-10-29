#!/bin/bash

get_dropbox()
{
  local DROPBOX=( https://www.dropbox.com/s/ma1z3lq4xjutyj7/yolov2-tiny-voc.weights https://www.dropbox.com/s/uz15x6xbudqyweg/yolov2.weights https://www.dropbox.com/s/iv7114em0cedacv/yolov3-tiny.weights https://www.dropbox.com/s/xhl17axl9915cj3/yolov3.weights )

  for m in ${DROPBOX[@]}; do
    if [ ! -s "${m##*/}" ]; then
      echo -n "Downloading ${m##*/} ... "
      curl -sSL ${m} -o ${m##*/} \
        && echo "done: $(ls -al ${m##*/})" \
        || echo "failed" 
    else
      echo "Weights: ${m} already exists" 
    fi
  done
}

get_pjreddy()
{
  WEIGHTS=(yolov2-tiny-voc.weights yolov3-tiny.weights yolov2.weights yolov3.weights)
  for m in ${WEIGHTS[@]}; do
    if [ ! -s "${m}" ]; then
      wget http://pjreddie.com/media/files/${m}
    else
      echo "Weights: ${m} already exists" 
    fi
  done
}

###
### MAIN
###

if [ ! -z "${1:-}" ] && [ "${1}" == 'pjreddy' ]; then
  get_pjreddy
else
  get_dropbox
fi
