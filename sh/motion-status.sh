#!/bin/bash

cameras=($(curl -sSL http://${1:-localhost}:8080/0/detection/status | awk '{ print $5 }'))
echo '{"host":"'${1:-localhost}'","port":'${2:-8080}',"cameras":['
if [ ${#cameras[@]} -gt 0 ]; then
  i=1
  for c in ${cameras[@]}; do
    if [ ${i} -gt 1 ]; then echo ','; fi
    if [ "${c:-}" = 'ACTIVE' ]; then
      curl -sSL localhost:8080/${i}/detection/connection | tail +2 | awk '{ printf("{\"camera\":\"%s\",\"status\":\"%s\"}\n",$4,$6) }'
    fi
    i=$((i+1))
  done
fi
echo ']}'
