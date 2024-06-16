# List all available commands using Just
default:
	just --list --unsorted

# Update all Nix Flake inputs and commit changes
update-all:
	nix flake update --commit-lock-file

# Update a single Nix Flake input and commit changes
update input:
	nix flake lock --commit-lock-file --update-input "{{input}}"

# Install a specific NixOS configuration to a device
install config device:
	#!/usr/bin/env sh
	
	# Create a temporary directory
	temp=$(mktemp -d)

	# Copy files to the temporary directory
	just install-lanzaboote "$temp"
	just install-openssh "$temp" "{{config}}"
	if [ "{{config}}" = "omer-desktop" ]; then
		just install-keyfile "$temp"
	fi

	# Install NixOS to the host system
	if [ "{{config}}" = "omer-desktop" ]; then
		nix run github:nix-community/nixos-anywhere -- \
			--disk-encryption-keys /tmp/disk.key <(sops --extract '["luks_passphrase"]' -d "nixos-configurations/{{config}}/secrets.yaml") \
			--disk-encryption-keys /etc/keyfile <(sops --extract '["keyfile"]' -d "nixos-configurations/{{config}}/secrets.yaml") \
			--extra-files "$temp" \
			--flake ".#{{config}}" \
			"{{device}}"
	else
		nix run github:nix-community/nixos-anywhere -- \
			--disk-encryption-keys /tmp/disk.key <(sops --extract '["luks_passphrase"]' -d "nixos-configurations/{{config}}/secrets.yaml") \
			--extra-files "$temp" \
			--flake ".#{{config}}" \
			"{{device}}"
	fi
	
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

[private]
install-openssh tempdir config:
	# Create the directories to copy to host machine
	install -d -m755 "{{tempdir}}/etc/ssh"
	install -d -m755 "{{tempdir}}/persistent/etc/ssh"

	# Decrypt SSH keys using sops and store in temporary directory
	sops --extract '["ssh_host_ed25519_key"]' -d "nixos-configurations/{{config}}/secrets.yaml" > "{{tempdir}}/etc/ssh/ssh_host_ed25519_key"
	sops --extract '["ssh_host_ed25519_key.pub"]' -d "nixos-configurations/{{config}}/secrets.yaml" > "{{tempdir}}/etc/ssh/ssh_host_ed25519_key.pub"
	sops --extract '["ssh_host_rsa_key"]' -d "nixos-configurations/{{config}}/secrets.yaml" > "{{tempdir}}/etc/ssh/ssh_host_rsa_key"
	sops --extract '["ssh_host_rsa_key.pub"]' -d "nixos-configurations/{{config}}/secrets.yaml" > "{{tempdir}}/etc/ssh/ssh_host_rsa_key.pub"

	chmod 0600 "{{tempdir}}/etc/ssh/ssh_host_ed25519_key"
	chmod 0644 "{{tempdir}}/etc/ssh/ssh_host_ed25519_key.pub"
	chmod 0600 "{{tempdir}}/etc/ssh/ssh_host_rsa_key"
	chmod 0644 "{{tempdir}}/etc/ssh/ssh_host_rsa_key.pub"

	cp -r "{{tempdir}}/etc/ssh" "{{tempdir}}/persistent/etc"

[private]
install-keyfile tempdir:
	# Create the directories to copy to host machine
	install -d -m755 "{{tempdir}}/etc"
	install -d -m755 "{{tempdir}}/persistent/etc"

	# Decrypt SSH keys using sops and store in temporary directory
	sops --extract '["keyfile"]' -d "nixos-configurations/omer-desktop/secrets.yaml" > "{{tempdir}}/etc/keyfile"

	chmod 0600 "{{tempdir}}/etc/keyfile"

	cp "{{tempdir}}/etc/keyfile" "{{tempdir}}/persistent/etc"

# Enroll Secure Boot keys
enroll-secureboot:
	sudo sbctl enroll-keys --microsoft

# Set a permanent device MAC address for a specific network
trust-network ssid:
	#!/usr/bin/env sh
	
	UUID=$(nmcli c | grep "{{ssid}}" | awk '{print $2}')
	if [ ! -z "$UUID" ]; then
		nmcli c modify $UUID 802-11-wireless.cloned-mac-address permanent
		nmcli c down $UUID
		nmcli c up $UUID
	else
		echo "Unable to find specified SSID." && exit 1
	fi

# Enroll FIDO2 YubiKey to decrypt specified LUKS partition
enroll-fido2 partition:
	sudo systemd-cryptenroll --fido2-device=auto "{{partition}}"

# Load GnuPG private key stubs
enroll-gnupg:
	gpg --card-status
