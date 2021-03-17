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

W3W_APIKEY=${MOTION_W3W_APIKEY:-${W3W_APIKEY:-}}

url='http://localhost:7999/cgi-bin/config'
json="${0%/*}/../config.json"
# get the configuration from the motion addon
get_config "${url}" "${json}"

config=$(jq -c '.config.cameras' "${json}" 2> /dev/null)
out=$(mktemp)

if [ $(echo "${config:-null}" | jq '.|length') -gt 0 ]; then
  names=$(echo "${config}" | jq -r '.[].name')
  echo '[' > ${out}
  i=0; for name in ${names}; do
    camera=$(echo "${config}" | jq '.[]|select(.name=="'${name}'")')
    
    if [ "${camera:-null}" != 'null' ]; then
      w3w=$(echo "${camera:-null}" | jq -c '.w3w')
      lat='!secret ha-latitude'
      lng='!secret ha-longitude'
      if [ ! -z "${W3W_APIKEY:-}" ] && [ "${w3w:-[]}" != '[]' ]; then
        w0=$(echo "${w3w}" | jq -r '.[0]')
        w1=$(echo "${w3w}" | jq -r '.[1]')
        w2=$(echo "${w3w}" | jq -r '.[2]')
	if [ ! -z "${w0:-}" ] && [ ! -z "${w1:-}" ] && [ ! -z "${w2:-}" ]; then
          w3w="${w0}.${w1}.${w2}"
	  w3w=$(curl -sSL "https://api.what3words.com/v3/convert-to-coordinates?words=${w3w}&key=${W3W_APIKEY}"| jq -c '.')
	  lat=$(echo "${w3w:-null}" | jq -r '.coordinates.lat')
	  lng=$(echo "${w3w:-null}" | jq -r '.coordinates.lng')
	fi
      fi
      if [ "${i:-0}" -gt 0 ]; then echo ',' >> ${out}; fi
      echo "${camera}" | jq -c '{name:.name,type:.type,latitude:"'"${lat}"'",longitude:"'"${lng}"'",top:.top,left:.left,icon:.icon,w3w:'"${w3w:-null}"',mjpeg_url:.mjpeg_url,username:.username,password:.password}' >> ${out}
      i=$((i+1))
    fi
  done
  echo ']' >> ${out}
else
  echo '[]' >> ${out}
fi
jq '.|sort_by(.name)' ${out} && rm -f ${out}
