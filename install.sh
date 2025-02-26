#!/bin/sh

# Get current script directory
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PARENT_DIR=$(dirname "$SCRIPT_DIR")

# Check if running on NixOS
if ! command -v nixos-version >/dev/null 2>&1; then
    echo "✗ This script requires NixOS. Current system is not NixOS."
    exit 1
fi

# Copy hardware configuration
cp /etc/nixos/hardware-configuration.nix "./hosts/v1mkss/"

# Ensure we're in the directory with flake.nix
cd "$SCRIPT_DIR"

# Build and switch to new configuration
if sudo nixos-rebuild switch --flake .#v1mkss; then
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
