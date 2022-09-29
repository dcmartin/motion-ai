#!/bin/bash

for i in battery connectivity current door energy gas humidity illuminance light moisture motion occupancy opening plug power presence problem safety smoke tamper update vibration voltage ; do sed -e "s/temperature/${i}/g" automation/device/class/temperature.yaml > automation/device/class/${i}.yaml; done 

for i in battery connectivity current door energy gas humidity illuminance light moisture motion occupancy opening plug power presence problem safety smoke tamper update vibration voltage ; do sed -e "s/temperature/${i}/g" binary_sensor/device/class/temperature.yaml > binary_sensor/device/class/${i}.yaml; done 
