#!/bin/bash

if [ -z "${1}" ]; then SCRIPT="script.txt"; else SCRIPT="${1}"; fi
if [ ! -s "${SCRIPT}" ]; then echo "No ${SCRIPT} to read" &> /dev/stderr; exit 1; fi

echo -n "Counting down " &> /dev/stderr
for ((i=0; i<10; i++)); do echo -n '.' &> /dev/stderr; sleep 0.1; done
echo ' done' &> /dev/stderr

clear

NC='\033[0m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN_ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT_GRAY='\033[0;37m'

DARK_GRAY='\033[1;30m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_PURPLE='\033[1;35m'
LIGHT_CYAN='\033[1;36m'
WHITE='\033[1;37m'

cat "${SCRIPT}" | while read; do 
  echo -e -n "${LIGHT_CYAN}$(hostname) $(date +%T)"' $ '"${YELLOW}"
  for ((i=0; i<${#REPLY}; i++)); do echo "after 200" | tclsh; printf "${REPLY:$i:1}"; done
  echo -e "${NC}"
  eval "${REPLY}"
done
