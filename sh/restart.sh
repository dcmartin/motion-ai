#!/bin/bash
if [ -z "${*:-}" ]; then NODES=$(cat NODES); else NODES=${*}; fi

for i in ${NODES}; do ping -t 15 -c 1 $i &> /dev/null && ssh $i 'cd GIT/motion-ai && git pull && make restart' &> /dev/null && echo "$i success" || echo "$i fail"; done
