#!/bin/bash

p='person'

find homeassistant/ -name "detected_${p}*" -print | while read; do
  e="${REPLY}"
  echo "${e}"
  for t in animal vehicle; do 
    if [ "${t}" = 'animal' ]; then 
      icon='cow'
    else
      icon='car'
    fi
    g=$(echo "${e}" | sed "s/person/${t}/g")
    sed \
      -e "s/${p}/${t}/g" \
      -e "s/${p^}/${t^}/g" \
      -e "s/${p^^}/${t^^}/g" \
      -e "s/[\' ]*mdi:account[^ \']*[\']*/ \'mdi:${icon}\'/g" \
      "${e}" > "${g}"
  done
done
