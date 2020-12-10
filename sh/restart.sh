#!/bin/bash
if [ -z "${*:-}" ]; then NODES=$(egrep -v '^#' NODES); else NODES=${*}; fi

for i in ${NODES}; do ping -t 15 -c 1 $i &> /dev/null && ssh $i 'cd GIT/motion-ai && echo 192.168.1.50 > MQTT_HOST && git pull && make restart' &> /dev/null && echo "$i success" || echo "$i fail"; done
