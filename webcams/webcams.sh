#!/bin/bash

mkwebcams()
{
  local webcams

  if [ ! -z "${1:-}" ] && [ -d "${1}" ]; then
    local allcams=$(${0%/*}/allcams.sh "${1}")
    local cameras=($(echo "${allcams:-null}" | jq -r '.[].cameras[].name'))

    if [ ${#cameras[@]} -gt 0 ]; then
      for camera in ${cameras[@]}; do
        local names=($(echo "${allcams}" | jq -r '.[].cameras[]|select(.name=="'${camera}'").name'))
        local record

        if [ ${#names[@]} -ne 1 ]; then
           echo "ERROR; name: ${camera}; names: ${names[@]}" &> /dev/stderr
           continue
        else
          record=$(echo "${allcams}" | jq '.[].cameras[]|select(.name=="'${camera}'")')
        fi
        if [ "${webcams:-null}" = 'null' ]; then webcams='['; else webcams="${webcams}"','; fi
        webcams="${webcams}""${record:-null}"
      done
      if [ "${webcams:-null}" != 'null' ]; then webcams="${webcams}"']'; else webcams='null'; fi
    fi
  fi
  echo "${webcams:-null}" | jq '.|sort_by(.name)'
}

mkwebcams ${*:-$(pwd)}
