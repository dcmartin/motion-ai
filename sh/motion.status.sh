#!/bin/bash

motion.restart()
{
  local host=${1:-localhost}
  local port=${2:-8080}
  local camera=${3:-}

  local cameras=($(motion.status ${host} ${port} | jq -r '.cameras[].camera'))

  echo -n '{"host":"'${host}'","port":'${port}',"cameras":['
  if [ ${#cameras[@]} -gt 0 ]; then
    i=1; j=0
    for c in ${cameras[@]}; do
      if [ -z "${camera:-}" ] || [ "${c:-}" = "${camera}" ]; then
        if [ ${j} -gt 1 ]; then echo ','; fi
        r=$(curl -sqSL --connect-timeout 10 ${host}:${port}/${i}/action/restart &> /dev/null && echo '{}' | jq '.id='${i}'|.camera="'${c}'"|.status="restarted"')
        echo -n "${r}"
        j=$((j+1))
      fi
      i=$((i+1))
    done
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
  local cameras=($(curl --connect-timeout 10 -qsSL http://${host}:${port}/0/detection/status 2> /dev/null | awk '{ print $5 }'))

  echo -n '{"host":"'${host}'","port":'${port}',"cameras":['
  if [ ${#cameras[@]} -gt 0 ]; then
    i=1
    for c in ${cameras[@]}; do
      if [ ${i} -gt 1 ]; then echo ','; fi
      if [ "${c:-}" = 'ACTIVE' ]; then
        r=$(curl --connect-timeout 10 -sqSL ${host}:${port}/${i}/detection/connection 2> /dev/null \
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
