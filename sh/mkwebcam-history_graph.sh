#!/bin/bash

###
### webcams history_graph
###

WEBCAMS=$(jq -r '.[].name' ${1:-webcams.json})

WEBCAM_EVENTS='detected_entity detected annotated'
WEBCAM_ATTRIBUTES='ago percent delay'
WEBCAM_MEASURES='actual mean stdev'

echo "###"
echo "## history_grsph/webcams.yaml"
echo "###"
echo ""

for E in ${WEBCAM_EVENTS}; do
  for A in ${WEBCAM_ATTRIBUTES}; do
    for M in ${WEBCAM_MEASURES}; do
      if [ "${M}" == 'actual' ]; then MM=; else MM="_${M}"; fi
      echo "#"
      echo "motion_${E}_${A}${MM}_webcams:"
      echo "  name: motion_${E}_${A}${MM}_webcams"
      echo "  hours_to_show: 24"
      echo "  refresh: 30"
      echo "  entities:"
      for C in ${WEBCAMS}; do
        echo "    - sensor.motion_${E}_${A}_${C}${MM}"
      done
      echo ""
    done
  done
done
