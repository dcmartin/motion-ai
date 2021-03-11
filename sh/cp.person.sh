#!/bin/bash

if [ -e /usr/local/opt/gnu-sed/libexec/gnubin/sed ]; then
  gnused=/usr/local/opt/gnu-sed/libexec/gnubin/sed
elif [ $(sed --version | head -1 | egrep GNU | wc -c) -gt 0 ]; then
  gnused=sed
else
  echo "This script requires GNU sed; install with command: brew install gnu-sed" &> /dev/stderr
  exit 1
fi

function copyit()
{
  local e="${*}"
  local t
  local ICON='account'
  local UOM='👱'

  echo "${e}"
  for t in animal vehicle entity; do 
    if [ "${t}" = 'animal' ]; then 
      uom='🐄'
      icon='cow'
    elif [ "${t}" = 'vehicle' ]; then
      uom='🚚'
      icon='truck'
    elif [ "${t}" = 'entity' ]; then
      uom='👓'
      icon='glasses'
    else 
      echo "ERROR: no such element: ${t}"
      exit 1
    fi
    g=$(echo "${e}" | sed "s/${p}/${t}/g")
    ${gnused} \
      -e "s/[\' ]*mdi:${ICON}[^ \']*[\']*/ \'mdi:${icon}\'/g" \
      -e "s/${p}/${t}/g" \
      -e "s/${p^}/${t^}/g" \
      -e "s/${p^^}/${t^^}/g" \
      -e "s/${UOM}/${uom}/g" \
      "${e}" > "${g}"
  done
}


p='person'

find homeassistant/ -name "detected_${p}.yaml" -print | while read; do copyit "${REPLY}"; done
find homeassistant/ -name "detected_${p}_*.yaml" -print | while read; do copyit "${REPLY}"; done
find homeassistant/ -name "*.detected_${p}.yaml.tmpl" -print | while read; do copyit "${REPLY}"; done

sed -e 's/PERSON/VEHICLE/g' -e 's/mdi:account/mdi:truck/' -e 's/cyan/gold/g' -e 's/person/vehicle/g' -e 's/Person/Vehicle/g' -e 's/👱/🚚/g' homeassistant/lovelace.person.json.tmpl > homeassistant/lovelace.vehicle.json.tmpl
sed -e 's/PERSON/ANIMAL/g' -e 's/mdi:account/mdi:cow/' -e 's/cyan/chartreuse/g' -e 's/person/animal/g' -e 's/Person/Animal/g' -e 's/👱/🐄/g' homeassistant/lovelace.person.json.tmpl > homeassistant/lovelace.animal.json.tmpl
