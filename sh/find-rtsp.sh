#!/bin/bash

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


CURL_CONNECT_TIME=5
CURL_MAX_TIME=20

if [ "${1:-null}" != 'null' ]; then
  wnet="${1}/24"
else
  wlan=$(ip addr | egrep -A 2 'wlan' | egrep 'inet ' | awk '{ print $2 }' | awk -F/ '{ print $1 }')
  if [ "${wlan:-null}" != 'null' ]; then
    wnet=${wlan%.*}.0/24
  else
    eth0=$(ip addr | egrep -A 2 'eth0' | egrep 'inet ' | awk '{ print $2 }' | awk -F/ '{ print $1 }')
    if [ "${eth0:-null}" != 'null' ]; then
      wnet=${eth0%.*}.0/24
      wlan=${eth0}
    else
      echo "Could not identify a network to scan; please specify: sudo ${0} 192.168.1.0" &> /dev/stderr
      exit 1
    fi
  fi
fi

echo "Searching ${wnet} for devices.." &> /dev/stderr

ips=$(nmap -sn -T4 ${wnet} | egrep -v ${wlan:-null} | egrep '^Nmap scan' | awk '{ print $5 }' )
ipset=(${ips})
nip=${#ipset[@]}

if [ ${nip} -gt 0 ]; then
  echo -n "Total devices: ${nip} " &> /dev/stderr
  for ip in ${ips}; do
    code=$(curl --connect-timeout ${CURL_CONNECT_TIME} --max-time ${CURL_MAX_TIME} -sSL -w '%{http_code}' "rtsp://${ip}/" 2> /dev/null)
    if [ "${code:-null}" = '200' ]; then
      echo -n '+' &> /dev/stderr
      record='{"ip":"'${ip}'","type":"rtsp","code":'${code:-null}'}'
    elif [ "${code:-}" != '000' ]; then
      echo -n '-' &> /dev/stderr
      record='{"ip":"'${ip}'","code":"'${code:-null}'"}'
    else
      record=
      echo -n '.' &> /dev/stderr
    fi
    if [ "${record:-null}" != 'null' ]; then
      if [ "${output:-null}" = 'null' ]; then output='['"${record}"; else output="${output},${record}"; fi
    fi
  done
  if [ "${output:-null}" != 'null' ]; then output="${output}"']'; fi
  echo " done" &> /dev/stderr
else
  echo "No devices" &> /dev/stderr
fi

echo "${output:-null}"
