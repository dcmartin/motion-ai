#!/bin/bash

motion.status()
{
  local host=${1:-localhost}
  local port=${2:-8080}
  local cameras=($(curl -sSL http://${host}:${port}/0/detection/status | awk '{ print $5 }'))

echo -n '{"host":"'${host}'","port":'${port}',"cameras":['
if [ ${#cameras[@]} -gt 0 ]; then
  i=1
  for c in ${cameras[@]}; do
    if [ ${i} -gt 1 ]; then echo ','; fi
    if [ "${c:-}" = 'ACTIVE' ]; then
      r=$(curl -sSL ${host}:${port}/${i}/detection/connection \
           | tail +2 \
           | awk '{ printf("{\"camera\":\"%s\",\"status\":\"%s\"}\n",$4,$6) }' \
           | jq '.id='${i}'|.status=(.status=="OK")')
        echo -n "${r}"
    fi
    i=$((i+1))
  done
fi
echo ']}'
}

###
### MAIN
###

motion.status ${*} | jq
