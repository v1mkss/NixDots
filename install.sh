#!/bin/sh

# Get current script directory
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PARENT_DIR=$(dirname "$SCRIPT_DIR")

# Check if running on NixOS
if ! command -v nixos-version >/dev/null 2>&1; then
    echo "✗ This script requires NixOS. Current system is not NixOS."
    exit 1
fi

# Define target host configuration
HOST_DIR="./hosts"

# Copy hardware configuration to the target host directory
echo "✓ Copying hardware configuration to $HOST_DIR/"
cp /etc/nixos/hardware-configuration.nix "$HOST_DIR/"

# Ensure we're in the directory with flake.nix
cd "$SCRIPT_DIR"

# Build and switch to the new configuration for the target host
echo " rebuilding system for host 'default'..."
if sudo nixos-rebuild switch --flake .#default; then
    echo "✓ Hardware configuration copied and system rebuilt successfully!"

    # Execute all scripts in profiles/desktop/scripts if host is 'default'
    SCRIPTS_DIR="$SCRIPT_DIR/profiles/desktop/scripts"
    if [ -d "$SCRIPTS_DIR" ]; then
        echo "✓ Executing scripts in $SCRIPTS_DIR..."
        for script in "$SCRIPTS_DIR"/*.sh; do
            [ -f "$script" ] && [ -x "$script" ] && sh "$script"
        done
    else
        echo "✗ Directory $SCRIPTS_DIR does not exist. Skipping script execution."
    fi
else
    echo "✗ Failed to rebuild system. Please check the error messages above."
    exit 1
fi
