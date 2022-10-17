#!/bin/bash

if [ -e /usr/local/opt/gnu-sed/libexec/gnubin/sed ]; then
  gnused=/usr/local/opt/gnu-sed/libexec/gnubin/sed
elif [ -e /usr/local/bin/gsed ]; then
  gnused=/usr/local/bin/gsed
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
  local ICON='emoticon-outline'
  local UOM='😐'

  echo "${e}"
  for t in alpr pose; do 
    if [ "${t}" = 'alpr' ]; then
      uom='🚘'
      icon='license'
    elif [ "${t}" = 'pose' ]; then
      uom='🧍'
      icon='human'
    else 
      echo "ERROR: no such element: ${t}"
      exit 1
    fi
    g=$(echo "${e}" | ${gnused} "s/${p}/${t}/g")
    ${gnused} \
      -e "s/[\' ]*mdi:${ICON}[^ \']*[\']*/ \'mdi:${icon}\'/g" \
      -e "s/${p}/${t}/g" \
      -e "s/${p^}/${t^}/g" \
      -e "s/${p^^}/${t^^}/g" \
      -e "s/${UOM}/${uom}/g" \
      "${e}" > "${g}"
  done
}

p='face'

find homeassistant/ -name "${p}.yaml" -print | while read; do copyit "${REPLY}"; done
find homeassistant/ -name "${p}_detected.yaml" -print | while read; do copyit "${REPLY}"; done
find homeassistant/ -name "*.${p}_detected.yaml.tmpl" -print | while read; do copyit "${REPLY}"; done
