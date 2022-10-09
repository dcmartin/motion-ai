#!/bin/bash

device_class=( $(jq -r '.[]|.class' device_class.json) )

output=$(mktemp)

# intiate output
echo '[' > ${output}

# loop over all device_class
for i in ${device_class[@]}; do
  icon=$(jq -r '.[]|select(.class=="'${i}'")|.icon'  device_class.json)
  sed -e "s/<deviceclass>/${i}/g" primary.json.tmpl \
    | jq -c '.path="'${i}'"|.icon="'${icon}'"' \
    >> ${output}
  n=${#device_class[@]}
  n=$((n - 1))
  if [ "${i}" != "${device_class[${n}]}" ]; then
   echo ',' >> ${output}
  fi
done

# complete output
echo ']' >> ${output}

# test output
jq '.' ${output} &> /dev/null
if [ $? ]; then
  jq '.' ${output} > primary.json
  echo "UPDATED: primary.json"
else
  echo "ERROR: bad JSON: ${output}"
fi
