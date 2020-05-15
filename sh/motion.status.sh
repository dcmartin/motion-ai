#!/bin/bash

motion.restart()
{
  local host=${1:-localhost}
  local port=${2:-8080}
  local camera=${3:-}

  local cameras=($(motion.status ${host} ${port} | jq -r '.cameras[].camera'))

  echo -n '{"host":"'${host}'","port":'${port}',"cameras":['
  if [ ! -z "${camera:-}" ] && [ ${#cameras[@]} -gt 0 ]; then
    i=1; j=0
    for c in ${cameras[@]}; do
      if [ "${c:-}" = "${camera}" ]; then
        if [ ${j} -gt 1 ]; then echo ','; fi
        r=$(curl -sSL ${host}:${port}/${i}/action/restart &> /dev/null && echo '{}' | jq '.id='${i}'|.camera="'${camera}'"|.status="restarted"')
        echo -n "${r}"
        j=$((j+1))
      fi
      i=$((i+1))
    done
  else
    r=$(curl -sSL ${host}:${port}/0/action/restart &> /dev/null \
       | jq '.id='0'|.status=(.status=="restarted")')
    echo -n "${r}"
  fi
  echo ']}'
}

#{
#  "host": "localhost",
#  "port": 8080,
#  "cameras": [
#    { "camera": "poolcam", "status": true, "id": 1 },
#    { "camera": "dogshed", "status": false, "id": 2 },
#    { "camera": "dogshedfront", "status": true, "id": 3 },
#    { "camera": "sheshed", "status": true, "id": 4 },
#    { "camera": "dogpond", "status": false, "id": 5 },
#    { "camera": "pondview", "status": false, "id": 6 },
#    { "camera": "backyardcam", "status": true, "id": 7 }
#  ]
#}

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

CMD=${0##*/} && CMD=${CMD%%.sh*} && ${CMD} ${*} | jq
