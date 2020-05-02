#!/usr/bin/env bash
  
## DOITTOIT <command> <output-json> <timeout> <total>

doittoit()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo  "${FUNCNAME[0]} ${*}"; fi

  local force=
  local wait=
  if [ "${1:-}" = '-f' ]; then force='${1}'; shift; fi
  if [ "${1:-}" = '-w' ]; then shift; wait="-w ${1}"; shift; fi
  local cmd=${1:-}
  local out=${2:-}
  local timeout=${3:-3.0}
  # reset argument list
  shift 3
  # remaining arguments are machines
  local machines=${*}
  local machine_array=(${machines})
  local total=${#machine_array[@]}
  local action="Running ${cmd}; output: ${out}; timeout: ${timeout}"

  if [ "${DEBUG:-false}" = 'true' ]; then echo "ACTION: ${action}; force: ${force}; wait: ${wait}"; fi

  if [ ! -z "${cmd:-}" ] && [ ! -s "${out}" ]; then
    # loop over all nodes
    for machine in ${machines}; do 
      ${cmd} ${force} ${wait} ${machine} ${out} ${timeout} &
    done
  elif [ ! -z "${cmd:-}" ] && [ -s "${out}" ]; then
    action="Processing ${cmd}; output: ${out}"
    touch ${out}
  else
    if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]}: invalid arguments"
    exit 1
  fi

  # announce
  echo -n "${action}; nodes: ${total}:" &> /dev/stderr

  # count results
  local count=$(wc -l ${out} 2> /dev/null | awk '{ print $1 }')
  # wait for all to complete
  while [ ${count:-0} -lt ${total} ]; do
    sleep 5
    count=$(wc -l ${out} | awk '{ print $1 }')
    pct=$(echo "${count:-0} / ${total} * 100" | bc -l | awk '{ printf("%02.2f",$1) }')
    pct=${pct%.*}
    if [ "${pct}" = "${old:-}" ]; then
      echo -n '.' &> /dev/stderr
    else
      echo -n " ${pct}%" &> /dev/stderr
      old=${pct}
    fi
  done
  echo " completed" &> /dev/stderr
  echo "${count:-0}"
}
