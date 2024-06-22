#!/usr/bin/env bash

if [ $# -eq 0 ] || [ "$1" = "" ]; then
	echo "No arguments specified."
	exit 1
else
	UUID=$(nmcli c | grep "$1" | awk '{print $2}')
	if [ -n "$UUID" ]; then
		nmcli c modify "$UUID" 802-11-wireless.cloned-mac-address permanent
		nmcli c down "$UUID"
		nmcli c up "$UUID"
	else
		echo "Unable to find specified SSID."
		exit 1
	fi
fi
