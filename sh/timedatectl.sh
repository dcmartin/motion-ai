#!/bin/bash
timedatectl -a | awk '{ sub(/^[ \t]+/, ""); print }' | awk -F: '{ if (x++ > 0) { printf(",") } else { printf("{"); }; printf("\"%s\":\"%s\"\n", gensub(" ","_","g",$1), gensub("^[ ]*","","g",$2)) } END { if ( x > 0 ) printf("}") }' | jq
