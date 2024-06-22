#!/usr/bin/env bash

if [ $# -eq 0 ] || [ "$1" = "" ]; then
	echo "No arguments specified."
	exit 1
elif [ $# -eq 2 ]; then
	sudo systemd-cryptenroll --fido2-device="$2" "$1"
else
	echo "Too many arguments specified. Expected 2 but received $#."
	exit 1
fi
