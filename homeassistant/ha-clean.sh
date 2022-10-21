#!/bin/bash

docker rm -f $(docker ps | egrep 'home-assistant' | awk '{ print $1 }') \
&& \
docker system prune -fa
