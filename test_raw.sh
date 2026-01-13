#!/bin/sh
#TODO: get rid of the evil bashisms to ensure POSIX compatibility...

Z="625"
X="0"

while [ "${X}" -lt "${Z}" ]; do
	./raw || exit 1
	count=$((X+1))
done | rngtest -c $(( (Z * 32) / 2500 ))
