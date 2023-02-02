#!/bin/bash

c=($(jq -r '.[].class' device_class.json | egrep -v 'temperature'))

for i in ${c[@]}; do 
sed -e "s/temperature/${i}/g" sensor/device/class/temperature.yaml > sensor/device/class/${i}.yaml
sed -e "s/temperature/${i}/g" automation/device/class/temperature.yaml > automation/device/class/${i}.yaml
sed -e "s/temperature/${i}/g" binary_sensor/device/class/temperature.yaml > binary_sensor/device/class/${i}.yaml
sed -e "s/temperature/${i}/g" template/device/class/temperature.yaml > template/device/class/${i}.yaml
sed -e "s/temperature/${i}/g" group/device/class/temperature.yaml > group/device/class/${i}.yaml
sed -e "s/temperature/${i}/g" binary_sensor/alarm/class/temperature.yaml > binary_sensor/alarm/class/${i}.yaml
echo "DONE: ${i}"
done 
