#!/bin/bash

exec 0>&- # close stdin
exec 1>&- # close stdout
exec 2>&- # close stderr

while true; do
	iperf3 -s -D
	pid=$!
	wait $pid
done
