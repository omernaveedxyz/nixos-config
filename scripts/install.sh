#!/usr/bin/env bash

if [ $# -eq 3 ]; then
	# Assign inputs to variables
	config="$1"
	device="$2"
	keyfile="$3"

	# Create a temporary directory
	temp=$(mktemp -d)

	# Function to cleanup temporary directory on exit
	cleanup() {
	  rm -rf "$temp"
	}
	trap cleanup EXIT

	# Function to create directories for Lanzaboote
	lanzaboote() {
		# Create the directories to copy to host machine
		install -d -m755 "$temp/etc/secureboot"
		install -d -m755 "$temp/persistent/etc/secureboot"

		# Create lanzaboote secure boot keys and copy to persistent directory
		sbctl create-keys -d "$temp/etc/secureboot" -e "$temp/etc/secureboot/keys"
		cp -r "$temp/etc/secureboot" "$temp/persistent/etc"
	}

	# Function to create directories for OpenSSH
	openssh() {
		# Create the directories to copy to host machine
		install -d -m755 "$temp/etc/ssh"
		install -d -m755 "$temp/persistent/etc/ssh"

		# Decrypt SSH keys using sops and store in temporary directory
		sops --extract '["ssh_host_ed25519_key"]' -d "nixos-configurations/$config/secrets.yaml" > "$temp/etc/ssh/ssh_host_ed25519_key"
		sops --extract '["ssh_host_ed25519_key.pub"]' -d "nixos-configurations/$config/secrets.yaml" > "$temp/etc/ssh/ssh_host_ed25519_key.pub"
		sops --extract '["ssh_host_rsa_key"]' -d "nixos-configurations/$config/secrets.yaml" > "$temp/etc/ssh/ssh_host_rsa_key"
		sops --extract '["ssh_host_rsa_key.pub"]' -d "nixos-configurations/$config/secrets.yaml" > "$temp/etc/ssh/ssh_host_rsa_key.pub"

		chmod 0600 "$temp/etc/ssh/ssh_host_ed25519_key"
		chmod 0644 "$temp/etc/ssh/ssh_host_ed25519_key.pub"
		chmod 0600 "$temp/etc/ssh/ssh_host_rsa_key"
		chmod 0644 "$temp/etc/ssh/ssh_host_rsa_key.pub"

		cp -r "$temp/etc/ssh" "$temp/persistent/etc"
	}

	# Function to create directories for decrypting additional disks using a keyfile
	keyfile() {
		# Create the directories to copy to host machine
		install -d -m755 "$temp/etc"
		install -d -m755 "$temp/persistent/etc"

		# Decrypt SSH keys using sops and store in temporary directory
		sops --extract '["keyfile"]' -d "nixos-configurations/$device/secrets.yaml" > "$temp/etc/keyfile"

		chmod 0600 "$temp/etc/keyfile"

		cp "$temp/etc/keyfile" "$temp/persistent/etc"
	}

	# Copy files to the temporary directory
	lanzaboote
	openssh
	if [ "$keyfile" = "true" ]; then keyfile; fi

	# Install NixOS to the host system
	if [ "$keyfile" = "true" ]; then
		nix run github:nix-community/nixos-anywhere -- \
			--disk-encryption-keys /tmp/disk.key <(sops --extract '["luks_passphrase"]' -d "nixos-configurations/$config/secrets.yaml") \
			--disk-encryption-keys /etc/keyfile <(sops --extract '["keyfile"]' -d "nixos-configurations/$config/secrets.yaml") \
			--extra-files "$temp" \
			--flake ".#$config" \
			"$device"
	else
		nix run github:nix-community/nixos-anywhere -- \
			--disk-encryption-keys /tmp/disk.key <(sops --extract '["luks_passphrase"]' -d "nixos-configurations/$config/secrets.yaml") \
			--extra-files "$temp" \
			--flake ".#$config" \
			"$device"
	fi
else
	echo "Incorrect number of arguments specified. Expected 3 but received $#."
	exit 1
fi
