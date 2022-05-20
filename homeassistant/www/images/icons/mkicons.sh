#!/bin/bash

CLASS=( battery connectivity current door energy gas humidity illuminance light moisture motion occupancy opening plug power presence problem safety smoke tamper temperature update vibration voltage )
NOTIFICATION=( activity cleared detected found good bad high low missing unavailable )

for i in ${CLASS[@]}; do 
  for j in ${NOTIFICATION[@]}; do
    e="notification-${i}-${j}.png"
    if [ -e "${i}-${j}-icon.png" ]; then
      f="${i}-${j}-icon.png"
    else
      f="${j}-icon.png"
    fi
    if [ ! -e "${e}" ] || [ -h "${e}" ]; then
      echo "Using ${f} for ${e}"
      rm -f "${e}"
      ln -s "${f}" "${e}"
    else
      echo "Existing: ${e}"
    fi
  done
done
