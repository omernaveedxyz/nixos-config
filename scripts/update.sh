#!/usr/bin/env bash

if [ $# -eq 0 ] || [ "$1" = "" ]; then
	echo "No arguments specified. Updating all inputs..."
	nix flake update --commit-lock-file
else
	for input in "$@"; do
		params=" $params --update-input $input"
	done
	nix flake lock --commit-lock-file $params
fi
