#!/bin/bash

p='person'

ICON='account'
OUM='👱'
find homeassistant/ -name "detected_${p}*" -print | while read; do
  e="${REPLY}"
  echo "${e}"
  for t in animal vehicle; do 
    if [ "${t}" = 'animal' ]; then 
      uom='🐄'
      icon='cow'
    else
      uom='🚗'
      icon='car'
    fi
    g=$(echo "${e}" | sed "s/person/${t}/g")
    sed \
      -e "s/${p}/${t}/g" \
      -e "s/${p^}/${t^}/g" \
      -e "s/${p^^}/${t^^}/g" \
      -e "s/[\' ]*mdi:${ICON}[^ \']*[\']*/ \'mdi:${icon}\'/g" \
      -e "s/[\' ]*${OUM}[^ \']*[\']*/ \'${uom}\'/g" \
      "${e}" > "${g}"
  done
done
