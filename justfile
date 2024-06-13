# List all available commands using Just
default:
	just --list

# Update all Nix Flake inputs and commit changes
update-all:
	nix flake update --commit-lock-file

# Update a single Nix Flake input and commit changes
update input:
	nix flake lock --commit-lock-file --update-input {{input}}

# Install a specific NixOS configuration to a device
install config device:
	#!/usr/bin/env sh
	
	# Create a temporary directory
	temp=$(mktemp -d)

	# Copy files to the temporary directory
	just install-lanzaboote "$temp"

	# Install NixOS to the host system
	nix run github:nix-community/nixos-anywhere -- \
		--disk-encryption-keys /tmp/disk.key <(echo -n password) \
		--extra-files "$temp" \
		--flake '.#{{config}}' \
		'{{device}}'
	
	# Delete temporary directory
	rm -rf "$temp"

[private]
install-lanzaboote tempdir:
	# Create the directories to copy to host machine
	install -d -m755 "{{tempdir}}/etc/secureboot"
	install -d -m755 "{{tempdir}}/persistent/etc/secureboot"

	# Create lanzaboote secure boot keys and copy to persistent directory
	sbctl create-keys -d "{{tempdir}}/etc/secureboot" -e "{{tempdir}}/etc/secureboot/keys"
	cp -r "{{tempdir}}/etc/secureboot" "{{tempdir}}/persistent/etc"

# Commands to run post-installation
post-install:
	just post-install-lanzaboote

[private]
post-install-lanzaboote:
	# Enroll Secure Boot keys
	sudo sbctl enroll-keys --microsoft
