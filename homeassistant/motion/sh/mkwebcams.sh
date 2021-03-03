#!/bin/bash


function get_config()
{
  local url=${1}
  local json=${2}
  local tmp=$(mktemp)
  curl -sSL -m 2 "${url}" -o "${tmp}" 2> /dev/null
  if [ ! -s "${tmp}" ]; then
    echo "No configuration from ${url}; is motion add-on running?" &> /dev/stderr
    return
  fi
  jq '.' "${tmp}" > "${json}" 2> /dev/null
  rm -f "${tmp}"
}

###
## MAIN
###

url='http://localhost:7999/cgi-bin/config'
json="${0%/*}/../config.json"
# get the configuration from the motion addon
get_config "${url}" "${json}"

config=$(jq -c '.config.cameras' "${json}" 2> /dev/null)

if [ $(echo "${config:-null}" | jq '.|length') -gt 0 ]; then
  echo "${config}" | jq '[.[]|{name:.name,type:.type,top:.top,left:.left,icon:.icon,w3w:.w3w,mjpeg_url:.mjpeg_url,username:.username,password:.password}]|sort_by(.name)'
else
  echo '[]'
fi
