#!/bin/sh

# Get current script directory
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Ensure Home Manager is installed
if ! command -v home-manager >/dev/null 2>&1; then
    echo "✗ Home Manager is not installed. Please install it first."
    exit 1
fi

# Apply the Home Manager configuration
cd "$SCRIPT_DIR"
echo "Applying Home Manager configuration..."
if home-manager switch --flake .#default --extra-experimental-features nix-command --extra-experimental-features flakes -b backup; then
    echo "✓ Configuration applied successfully!"
else
    echo "✗ Failed to apply configuration. Please check the error messages above."
    exit 1
fi
