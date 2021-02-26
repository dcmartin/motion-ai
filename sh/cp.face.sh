#!/bin/bash

if [ -e /usr/local/opt/gnu-sed/libexec/gnubin/sed ]; then
  gnused=/usr/local/opt/gnu-sed/libexec/gnubin/sed
elif [ $(sed --version | head -1 | egrep GNU | wc -c) -gt 0 ]; then
  gnused=sed
else
  echo "This script requires GNU sed; install with command: brew install gnu-sed" &> /dev/stderr
  exit 1
fi

p='face'
ICON='face'
UOM='👱'

find homeassistant/ -name "*${p}_*.yaml*" -print | while read; do
  e="${REPLY}"
  echo "${e}"
  for t in alpr pose; do 
    if [ "${t}" = 'alpr' ]; then
      uom='🚗'
      icon='license'
    elif [ "${t}" = 'pose' ]; then
      uom='🚶'
      icon='walk'
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
done
