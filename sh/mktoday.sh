#!/bin/bash 

if [ "${USER:-null}" != 'root' ]; then
  echo "Please run as root; sudo ${0} ${*}" &> /dev/stderr
  exit 1
fi

# specify media directory
if [ ! -z "${1:-}" ]; then
  rootdir="${1}/Motion-Ã👁/"
else
  rootdir='./media/Motion-Ã👁/'
fi
if [ ! -d "${rootdir}" ]; then
  echo "Directory not found: ${rootdir}; usage: ${0} [<directory>]" 2>&1 > /dev/stderr
  exit 1
fi
pushd ${rootdir} &> /dev/null
rootdir=$(pwd -P)

# find today's directory
date=$(date +'%Y-%b-%d')
datedir=${rootdir}/${date}
if [ ! -d "${datedir}" ]; then
  echo "Today's directory not found: ${datedir}" 2>&1 > /dev/stderr
  exit 1
fi
pushd "${datedir}" &> /dev/null
datedir=$(pwd -P)

# find cameras
cameras=($(find '.' -name '*\.gif' -print | awk -F' at ' '{ print $2 }' | sort | uniq | while read; do echo "${REPLY%*.gif}"; done))
if [ ${#cameras[@]} -le 0 ]; then
  echo "No cameras found in directory ${rootdir}:${camdir}" 2>&1 > /dev/stderr
  popd &> /dev/null
  exit 1
fi

# reset today directory
todaydir=${rootdir}/TODAY
rm -fr ${todaydir}
mkdir -p ${todaydir}
if [ ! -d "${todaydir}" ]; then
  echo "Unable to create directory: ${todaydir}" 2>&1 > /dev/stderr
  exit 1
fi

# link to entity(s)
pushd ${todaydir} &> /dev/null
ln -s ../${date}/person .
ln -s ../${date}/vehicle .
ln -s ../${date}/animal .
popd &> /dev/null

# start script
script="/tmp/mktoday.$$.sh"
rm -f ${script}
echo '#!/bin/bash' > ${script}

for d in ${cameras[@]}; do 
  fp="${todaydir}/CAMERAS/${d}"
  echo "rm -fr "${fp}"; mkdir -p \"${fp}\" && pushd \"${fp}\"" >> ${script}
  e=$(find . -name "*${d}\.*" -print | sort -t/ -k3 | tee /tmp/${d}.$$.day | while read; do i="${REPLY%at *}"; echo "${d}/${i#./*}"; done)
  for j in ${e[@]}; do 
    camera=${j%%/*}
    time=${j##*/}
    k=${j%/*}
    entity=${k#*/}
    echo "ln -s \"../../../${date}/${entity}/${time} at ${camera}.gif\" \"${entity} at ${time}.gif\"" >> ${script}
  done
  echo "popd" >> ${script}
done
bash ${script} &> ${script%.*}.log && rm -f ${script%.*}.log || echo "Failed: log: ${script%.*}.log" &> /dev/stderr
rm -f ${script}
