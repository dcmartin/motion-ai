#!/bin/bash

find_ipaddr()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi

  local net=${1:-eth0}
  local result=$(ip addr | egrep -A 2 "${net}" | egrep 'inet ' | awk '{ print $2 }' | awk -F/ '{ print $1 }')
  echo ${result:-null}
}

lookup_ipaddr()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi

  local net="${1:-}"
  local ipaddr
  local result

  if [ -z "${net:-}" ]; then
    ipaddr=$(find_ipaddr 'wlan')
    if [ "${ipaddr:-null}" != 'null' ]; then
      result="${ipaddr}"
    else
      ipaddr=$(find_ipaddr 'eth0')
      if [ "${ipaddr:-null}" != 'null' ]; then
        result="${ipaddr}"
      fi
    fi
  else
    result=$(find_ipaddr ${net})
  fi
  echo ${result:-null}
}

rtsp_test()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi

  local ip="${1:-}"
  local connect=${2:-${CURL_CONNECT_TIME:-5}}
  local maxtime=${3:-${CURL_MAX_TIME:-20}}
  local code=$(curl --connect-timeout ${connect} --max-time ${maxtime} -sSL -w '%{http_code}' "rtsp://${ip}/" 2> /dev/null)
  local result

  if [ "${code:-null}" = '200' ]; then
    result='{"ip":"'${ip}'","type":"rtsp","code":"'${code:-200}'"}'
  elif [ "${code:-}" != '000' ]; then
    result='{"ip":"'${ip}'","code":"'${code:-xxx}'"}'
  fi
  echo ${result:-null}
}

find_rtsp()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi

  local net=${1:-}
  local ipaddr=$(lookup_ipaddr ${net:-})
  local size=${2:-${NETWORK_SIZE:-24}}
  local result

  
  if [ "${ipaddr:-null}" = 'null' ]; then
    echo "No TCP/IP v4 address for this device on ${net:-any} network; please specify alternative: ${0} eth0" &> /dev/stderr
  else
    echo "Searching ${net} for devices.." &> /dev/stderr

    net=${ipaddr%.*}.0/${size}
    local ips=$(nmap -sn -T4 ${net} | egrep -v ${ipaddr} | egrep '^Nmap scan' | awk '{ print $5 }' )
    local ipset=(${ips})
    local nip=${#ipset[@]}

    if [ ${nip} -gt 0 ]; then
      echo -n "Total devices: ${nip} " &> /dev/stderr
      for ip in ${ips}; do
        local record=$(rtsp_test ${ip})
        if [ "${record:-null}" != 'null' ]; then
          if [ "${output:-null}" = 'null' ]; then output='['"${record}"; else output="${output},${record}"; fi
          case $(echo "${record}" | jq -r '.code') in
            200)
	      echo -n '+' &> /dev/stderr
	      ;;
            404)
              echo -n '-' &> /dev/stderr
	      ;;
            *)
              echo -n '.' &> /dev/stderr
	      ;;
          esac
        else
          echo -n '_' &> /dev/stderr
        fi
      done
      if [ "${output:-null}" != 'null' ]; then output="${output}"']'; fi
      echo " done" &> /dev/stderr
    else
      echo "No devices" &> /dev/stderr
    fi
  fi

  echo "${output:-null}"
}

###
### MAIN
###

if [ "${USER:-null}" != 'root' ]; then
  echo "Please run as root; sudo ${0} ${*}" &> /dev/stderr
  exit 1
fi

if [ -z "$(command -v nmap)" ]; then
  echo "Please install nmap; sudo apt install -qq -y nmap" &> /dev/stderr
  exit 1
fi

if [ -z "$(command -v ip)" ]; then
  echo "No ip command found; brew install iproute2mac" &> /dev/stderr
  exit 1
fi

## defaults
CURL_CONNECT_TIME=5
CURL_MAX_TIME=20
NETWORK_SIZE=24

## doit
find_rtsp ${*}
