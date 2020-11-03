#!/bin/bash

config=$(curl -sSL http://localhost:7999/cgi-bin/config 2> /dev/null)

if [ ! -z "${config:-}" ]; then
  echo "${config}" | jq '[.config.cameras[]|{name:.name,type:.type,top:.top,left:.left,icon:.icon,w3w:.w3w,mjpeg_url:.mjpeg_url,username:.username,password:.password}]'
else
  echo "No configuration from localhost:7999/cgi-bin/config; is motion add-on running?" &> /dev/stderr
fi
