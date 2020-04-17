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
  local connect=${2}
  local maxtime=${3}
  local code=$(curl --connect-timeout ${connect} --max-time ${maxtime} -sSL -w '%{http_code}' "rtsp://${ip}/" 2> /dev/null)
  local result

  if [ "${code:-null}" = '200' ]; then
    result='{"ip":"'${ip}'","type":"rtsp","code":"'${code:-200}'"}'
  elif [ "${code:-}" != '000' ]; then
    result='{"ip":"'${ip}'","code":"'${code:-xxx}'"}'
  fi
  echo ${result:-null}
}

nmap_scan()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi

  local ipaddr=${1}
  local net=${2}
  local timeout=${3}
  local ips=$(nmap -sn -T${timeout} ${net} | egrep '^Nmap scan report for [0-9][0-9]*' | sed 's/[^0-9]*\([0-9][0-9]*[0-9]*\.[0-9][0-9]*[0-9]*\.[0-9][0-9]*[0-9]*\.[0-9][0-9]*[0-9]*\).*/\1/')

  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]}: Found: ${ips}" &> /dev/stderr; fi
  echo ${ips}
}

find_rtsp()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi

  local net=${1:-}
  local nmap_timeout=${2:-${NMAP_TIMEOUT:-5}}
  local connect=${3:-${CURL_CONNECT_TIME:-5}}
  local maxtime=${4:-${CURL_MAX_TIME:-20}}
  local ipaddr=$(lookup_ipaddr ${net:-})
  local size=${2:-${NETWORK_SIZE:-24}}
  local result
  
  if [ "${ipaddr:-null}" = 'null' ]; then
    echo "No TCP/IP v4 address for this device on ${net:-any} network; please specify alternative: ${0} eth0" &> /dev/stderr
  else
    net=${ipaddr%.*}.0/${size}
    if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]}: searching network: ${net:-all}; timeout: ${nmap_timeout}; connect: ${connect}; max: ${maxtime} .." &> /dev/stderr; fi

    local ips=($(nmap_scan ${ipaddr} ${net} ${nmap_timeout}))

    if [ ${#ips[@]} -gt 0 ]; then
      local rtsp

      for ip in ${ips[@]}; do
	local dev=$(rtsp_test ${ip} ${connect} ${maxtime})

        if [ "${dev:-null}" != 'null' ]; then
          if [ "${rtsp:-null}" = 'null' ]; then rtsp='['"${dev}"; else rtsp="${rtsp},${dev}"; fi
        fi
      done
      if [ ! -z "${rtsp:-}" ]; then rtsp="${rtsp}]"; else rtsp='null'; fi
    fi
    result='{"nmap":{"timeout":'${nmap_timeout}',"net":"'${net}'","ipaddr":"'${ipaddr}'"},"connect":'${connect}',"max":'${maxtime}',"rtsp":'"${rtsp:-null}"'}'
  fi

  echo "${result:-null}"
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
CURL_MAX_TIME=15
NETWORK_SIZE=24

## doit
find_rtsp ${*}
