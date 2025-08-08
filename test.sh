#!/bin/sh

Z=625

X() {
	od -An -tx1 | tr -d ' \n'
}

Y=0

while [ "$Y" -lt "$Z" ]
do
	./getprand | tr -d '\n\r' | X || exit 1
	Y=$((Y + 1))
done | xxd -r -p | rngtest -c $(( (Z * 32) / 2500 ))
