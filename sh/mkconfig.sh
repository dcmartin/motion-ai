#!/bin/bash

###
### MAIN
###

if [ -z "$(command -v jq)" ]; then
  echo "Please install nmap; sudo apt install -qq -y jq" &> /dev/stderr
  exit 1
fi

if [ -z "$(command -v npm)" ]; then
  echo "Please install nmap; sudo apt install -qq -y npm" &> /dev/stderr
  exit 1
elif [ -z "$(command -v json2yaml)" ]; then
  echo "Please install json2yaml; sudo npm install -g json2yaml" &> /dev/stderr
  exit 1
fi

## defaults
CURL_CONNECT_TIME=5
CURL_MAX_TIME=20
NETWORK_SIZE=24

## doit
mkconfig()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi

  local file=${1:-}
  local result

  if [ -z "${file:-}" ] || [ ! -s "${file}" ]; then
    file=$(pwd -P)/rtsp.json
    echo "Making ${file}"  &> /dev/stderr
    ${0%/*}/find-rtsp.sh > ${file}
  fi

  if [ ! -z "${file:-}" ] && [ -s ${file} ]; then
    local ips=($(jq -r '.rtsp[]|.ip' ${file}))
    local output
    local record

    if [ ${#ips[@]} -gt 0 ]; then
      for ip in ${ips[@]}; do
        local camera=$(jq '.rtsp[]|select(.ip=="'${ip}'")' ${file})

        if [ "${camera:-null}" != 'null' ]; then
          local name=camera-$(echo "${camera}" | jq -r '.ip' | sed 's/\.//g')
          local code=$(echo "${camera}" | jq -r '.code')
          local icon=$(echo "${camera}" | jq -r '.icon')
	  local mac=$(arp "${ip}" | egrep "${ip}" | awk '{ print $3 }')

	  case ${code:-null} in 
            200)
	      if [ "${icon:-null}" = 'null' ]; then icon='video-check-outline'; fi
	      ;;
            404)
	      if [ "${icon:-null}" = 'null' ]; then icon='video-off-outline'; fi
	      ;;
            *)
	      if [ "${icon:-null}" = 'null' ]; then icon='coffin'; fi
	      ;;
          esac

	  case ${mac:-null} in 
	    2c:aa:8e:*)
              if [ "${DEBUG:-false}" = 'true' ]; then echo "${mac} is Wyze" &> /dev/stderr; fi
	      url="rtsp://${ip}/live"
	      ;;
            c8:d7:19:*|00:22:6b:*|00:80:f0:*)
              if [ "${DEBUG:-false}" = 'true' ]; then echo "${mac} is Linksys" &> /dev/stderr; fi
	      url="rtsp://${ip}/img/video.sav"
	      ;;
            --)
              if [ "${DEBUG:-false}" = 'true' ]; then echo "${ip} is not found" &> /dev/stderr; fi
	      mac='null'
	      icon='video-off'
	      url="rtsp://${ip}/"
	      ;;
            *)
              if [ "${DEBUG:-false}" = 'true' ]; then echo "${ip}: ${mac} is Unknown" &> /dev/stderr; fi
	      url="rtsp://${ip}/"
	      ;;
          esac

	  record='{"name":"'${name}'","ip":"'${ip}'","mac":"'${mac}'","type":"netcam","netcam_url":"'${url}'","icon":"'${icon}'","code":"'${code}'"}'

          if [ ! -z "${output:-}" ]; then output="${output},${record}"; else output="[${record}"; fi

        else
          echo "No record: ${ip}" &> /dev/stderr
        fi
      done
      if [ ! -z "${output:-}" ]; then result="${output}]"; fi
    else
       echo "No ips: ${ips[@]}" &> /dev/stderr
    fi
  else
    echo "No file: ${file}" &> /dev/stderr
  fi
  echo "${result:-null}"
}

mkconfig ${*}
