#!/bin/bash

d=($(find motion/ -name *.gif -print | while read; do echo "${REPLY##* }"; done | sort | uniq | sed "s/.gif//")) 

for c in ${d[@]}; do 
  echo -n "Processing ${c}: "
  rm -fr "${c}"
  mkdir -p "${c}" 
  pushd "${c}" &> /dev/null
  for i in ../motion/*; do 
    for j in $i/*; do 
      rm -fr "${i##*/}"
      mkdir -p "${i##*/}/${j##*/}"
      pushd "${i##*/}/${j##*/}" &> /dev/null
      find ../../"${j}" -name '*'"${c}"'.gif' -print | while read; do 
        t="${REPLY##*/}" 
	rm -f "${t}"
	ln -s "${REPLY}" "${t}"
        echo -n "."
      done
      popd &> /dev/null
    done
  done
  popd &> /dev/null
  echo
done
