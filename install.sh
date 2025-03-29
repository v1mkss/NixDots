#!/bin/sh

# Get current script directory
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PARENT_DIR=$(dirname "$SCRIPT_DIR")

# Check if running on NixOS
if ! command -v nixos-version >/dev/null 2>&1; then
    echo "✗ This script requires NixOS. Current system is not NixOS."
    exit 1
fi

# Determine target host configuration
CURRENT_HOSTNAME=$(hostname)
DEFAULT_HOSTNAME="v1mkss"
TARGET_HOSTNAME=""

if [ -d "./hosts/$CURRENT_HOSTNAME" ]; then
    TARGET_HOSTNAME=$CURRENT_HOSTNAME
    echo "✓ Using configuration for current host: $TARGET_HOSTNAME"
else
    TARGET_HOSTNAME=$DEFAULT_HOSTNAME
    echo "ℹ Configuration for current host '$CURRENT_HOSTNAME' not found. Using default: $TARGET_HOSTNAME"
fi

HOST_DIR="./hosts/$TARGET_HOSTNAME"

# Copy hardware configuration to the target host directory
echo "✓ Copying hardware configuration to $HOST_DIR/"
cp /etc/nixos/hardware-configuration.nix "$HOST_DIR/"

# Ensure we're in the directory with flake.nix
cd "$SCRIPT_DIR"

# Build and switch to the new configuration for the target host
echo " rebuilding system for host '$TARGET_HOSTNAME'..."
if sudo nixos-rebuild switch --flake .#"$TARGET_HOSTNAME"; then
    echo "✓ Hardware configuration copied and system rebuilt successfully!"

    read -p "Do you want to reboot now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo reboot
    fi
else
    echo "✗ Failed to rebuild system. Please check the error messages above."
    exit 1
fi
