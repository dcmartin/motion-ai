#!/bin/bash

# source
source ${0%/*}/doittoit.sh

###
### MAIN
###

## arguments
if [ "${1:-}" = '-f' ]; then
  force="-f"
  shift
fi
if [ ! -z "${1:-}" ] && [ -s "${1}" ]; then
  out="${1}"
  shift
else
  out=${0##*/} && out=test.${out%.*}.$$.json
  touch ${out}
fi
timeout=${1:-10}

# test for existing output
if [ ! -z "${out:-}" ] && [ -s "${out}" ]; then
  MACHINES=$(jq -r '.machine' ${out})
elif [ -s ./NODES ]; then
  MACHINES=$(egrep -v '^#' NODES)
else
  hzn.log.error "$0 $$ -- no NODES file; create it or download CSV from cloud and save as ./devices.csv"
  exit 1
fi
MACHINE_ARRAY=(${MACHINES})
MACHINE_COUNT=${#MACHINE_ARRAY[@]}

echo "$0 $$ -- ${MACHINE_COUNT} machines specified" &> /dev/stderr

start=$(date -u +%FT%TZ)
when=$(date +%s)

TOTAL=$(doittoit ${force:-} ${0%/*}/rtsp-test.sh ${out} ${timeout} ${MACHINES})

echo "received ${TOTAL} responses" &> /dev/stderr

# investigate results
ALIVE=$(jq -r '.|select(.alive==true).machine' ${out}) && AA=(${ALIVE})
echo "total: ${MACHINE_COUNT}; total: ${TOTAL}; alive: ${#AA[@]}" &> /dev/stderr

# collect bad
BAD_NODE_NAMES=$(jq -j '.|select(.bad|length>0).machine," "' ${out} | sed 's/^[ ]*//' | sed 's/ \([^ ]\)/","\1/g' | sed 's/ //g' | sed 's/\(.*\)/"\1"/')
if [ "${BAD_NODE_NAMES}" = '""' ]; then BAD_NODE_NAMES=null; else BAD_NODE_NAMES='['"${BAD_NODE_NAMES}"']'; fi
BAD_NODE_COUNT=$(echo "${BAD_NODE_NAMES}" | jq '.|length')

# generate JSON
OUTPUT=$(echo '{"output":"'${out}'","total":'${TOTAL}',"purged":'$((TOTAL-BAD_NODE_COUNT))',"offline":'"${BAD_NODE_NAMES}"'}' | jq -c '.')

# output
echo "${OUTPUT}" | jq -c '.start="'${start:-}'"|.finish="'$(date -u +%FT%TZ)'"|.elapsed='$(($(date +%s)-when))

# all done
exit
