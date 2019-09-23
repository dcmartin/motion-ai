#!/bin/bash
docker stop homeassistant
sudo rm -fr /usr/share/hassio/homeassistant/.storage
sudo rm -fr /usr/share/hassio/homeassistant/home-assistant*
docker restart homeassistant
