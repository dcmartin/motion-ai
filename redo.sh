#!/bin/bash
docker stop homeassistant
sudo rm /usr/share/hassio/homeassistant/.storage/core.restore_state
sudo rm /usr/share/hassio/homeassistant/.storage/lovelace
sudo rm -fr /usr/share/hassio/homeassistant/home-assistant*
docker restart homeassistant
