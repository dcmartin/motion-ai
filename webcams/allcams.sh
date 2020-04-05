#!/bin/bash

webcam_names()
{
  local webcamdir="${1:-}"
  local output

  if [ ! -z "${webcamdir:-}" ] && [ -d "${webcamdir:-}" ]; then
    local jsons=($(find $(pwd -P ${webcamdir}) -name '*.json' -print))

    if [ ${#jsons[@]} -gt 0 ]; then
      for json in ${jsons[@]}; do
        local name=${json##*/} && name=${name%%.*}
        local cameras=($(jq -r '.[].name' ${json}))
        local list=
          
        if [ -z "${output:-}" ]; then output='['; else output="${output},"; fi
        if [ ${#cameras[@]} -gt 0 ]; then
          for camera in ${cameras[@]}; do
            local w3w=$(jq '.[]|select(.name=="'${camera}'").w3w' ${json})
            local url=$(jq -r '.[]|select(.name=="'${camera}'").mjpeg_url' ${json})
            local icon=$(jq -r '.[]|select(.name=="'${camera}'").icon' ${json})
            local username=$(jq -r '.[]|select(.name=="'${camera}'").username' ${json})
            local password=$(jq -r '.[]|select(.name=="'${camera}'").password' ${json})

            local record='{"name":"'${camera}'","mjpeg_url":"'${url}'","icon":"'${icon}'","username":"'${username}'","password":"'${password}'","w3w":'"${w3w}"'}'
            if [ -z "${list:-}" ]; then list='['; else list="${list},"; fi
            list="${list}""${record}"
          done
          if [ -z "${list:-}" ]; then list='null'; else list="${list}"']'; fi
        fi
        output="${output}"'{"device":"'${name}'","cameras":'${list}'}'
      done
      if [ -z "${output:-}" ]; then output='null'; else output="${output}"']'; fi
    else
      echo "No JSONS: ${jsons[@]}" &> /dev/stderr
      exit 1
    fi
  else
    echo "No directory: ${webcamdir:-null}" &> /dev/stderr
    exit 1
  fi
  echo "${output:-null}"
}


webcam_names ${*} | jq -c '.'
