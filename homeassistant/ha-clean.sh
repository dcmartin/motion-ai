#!/bin/bash

docker rm -f $(docker ps | egrep 'home-assistant' | awk '{ print $1 }') \
&& \
docker system prune -fa \
&&
sudo rm -f /usr/share/hassio/homeassistant/.storage/core.{config_entries,device_registry,entity_registry,restore_state} \
&& \
sudo rm -f /usr/share/hassio/homeassistant/home-assistant*
