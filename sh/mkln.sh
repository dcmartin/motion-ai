#!/bin/bash

d=($(find motion/ -name *.gif -print | while read; do echo "${REPLY##* }"; done | sort | uniq | sed "s/.gif//")) 

echo "Found ${#d[@]} cameras" &> /dev/stderr

for c in ${d[@]}; do 
  echo -n "Processing camera ${c}: "
  rm -fr "${c}"
  mkdir -p "${c}" 
  pushd "${c}" &> /dev/null
  for i in ../motion/*; do 
    rm -fr "${i##*/}"
    mkdir "${i##*/}"
    pushd "${i##*/}" &> /dev/null
    for j in ../$i/*; do 
      rm -fr "${j##*/}"
      mkdir -p "${j##*/}"
      pushd "${j##*/}" &> /dev/null
      find "../${j}" -name "*${c}.gif" -print | while read; do 
        t="${REPLY##*/}" 
	rm -f "${t}"
	ln -s "${REPLY}" "${t}"
        echo -n "."
      done
      popd &> /dev/null
    done
    popd &> /dev/null
  done
  popd &> /dev/null
  echo
done
