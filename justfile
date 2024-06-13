# List all available commands using Just
default:
	just --list

# Install a specific NixOS configuration to a device
install config device:
	nix run github:nix-community/nixos-anywhere -- \
		--flake '.#{{config}}' \
		--disk-encryption-keys /tmp/disk.key <(echo -n password) \
		'{{device}}'

# Update all Nix Flake inputs and commit changes
update-all:
	nix flake update --commit-lock-file

# Update a single Nix Flake input and commit changes
update input:
	nix flake lock --commit-lock-file --update-input {{input}}
