{ pkgs, ... }:
{
  imports = [
    ./development
  ];

  home.packages = with pkgs; [
    # Development Tools
    zed-editor-fhs # Alternative editor
    godot_4 # Game development engine
    lazygit # Terminal UI for git

    # Runtime and SDK
    bun # Fast JavaScript runtime/toolkit
    rustup # Rust toolchain manager

    # Build tools
    cmake
    gnumake
    pkg-config

    # GCC and related tools for Rust
    gcc
    binutils
    gdb
  ];

  # Environment setup
  home.sessionVariables = {
    # Rust configuration
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";

    # Bun configuration
    BUN_INSTALL = "$HOME/.bun";
  };
}
