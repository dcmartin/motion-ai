#!/bin/bash

CCDIR=$(pwd -P "${0%/*}/../")

CCDIR=${CCDIR:-}/homeassistant/custom_components

if [ ! -d "${CCDIR:-}" ]; then
  echo "Cannot locate Home-Assistant custom_components/ directory; expected: ${CCDIR}" 2> /dev/stderr
  exit 1
else
  HACSDIR="${CCDIR}/hacs"
fi

if [ -d ${HACSDIR:-} ]; then
  echo "Existing directory; removing ${HACSDIR}/"
  rm -fr ${HACSDIR}
fi

mkdir -p ${HACSDIR} \
  && \
  echo -n "Installing HACS in ${HACSDIR}/ directory ..." &> /dev/stderr \
  && \
  curl -sSL -o /tmp/hacs.zip "https://github.com/hacs/integration/releases/latest/download/hacs.zip" &> /dev/null \
  && \
  unzip "/tmp/hacs.zip" -d "${HACSDIR}" &> /dev/null \
  && \
  rm -f "/tmp/hacs.zip" \
  && \
  echo " success" &> /dev/stderr \
  || \
  echo " failed" &> /dev/stderr
