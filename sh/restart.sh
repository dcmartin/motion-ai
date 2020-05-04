#!/bin/bash
for i in $(cat NODES); do ping -t 15 -c 1 $i &> /dev/null && ssh $i 'cd GIT/motion-ai && git pull && make restart' &> /dev/null && echo "$i success" || echo "$i fail"; done
