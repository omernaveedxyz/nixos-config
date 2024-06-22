# List all available commands using Just
default:
	just --list --unsorted

# Update Nix Flake inputs and commit changes
update *INPUTS:
	sh ./scripts/update.sh "{{INPUTS}}"

# Install a specific NixOS configuration to a device
install CONFIG DEVICE KEYFILE="false":
	sh ./scripts/install.sh "{{CONFIG}}" "{{DEVICE}}" "{{KEYFILE}}"

# Enroll Secure Boot keys
enroll-secureboot:
	sh ./scripts/enroll-secureboot.sh

# Set a permanent device MAC address for a specific network
trust-network SSID:
	sh ./scripts/trust-network.sh "{{SSID}}"

# Enroll FIDO2 YubiKey to decrypt specified LUKS partition
enroll-fido2 PARTITION DEVICE="auto":
	sh ./scripts/enroll-fido2.sh "{{PARTITION}}" "{{DEVICE}}"

# Load GnuPG private key stubs
enroll-gnupg:
	sh ./scripts/enroll-gnupg.sh
