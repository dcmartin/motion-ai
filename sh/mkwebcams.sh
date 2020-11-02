#!/bin/bash

config=$(curl -sSL http://localhost:7999/cgi-bin/config 2> /dev/null)

if [ ! -z "${config:-}" ]; then
  echo "${config}" | jq '.config.motion.username as $u|.config.motion.password as $p|.config.cameras|to_entries|map({name:.value.name,type:.value.type,top:(10+5*.key),left:10,icon:"cctv",w3w:null,mjpeg_url:.value.mjpeg_url,username:$u,password:$p})'
else
  echo "No configuration from localhost:7999/cgi-bin/config; is motion add-on running?" &> /dev/stderr
fi
