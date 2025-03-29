{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Development Tools
    zed-editor-fhs # Alternative editor
    godot_4 # Game development engine
    lazygit # Terminal UI for git
    blender # 3D creation suite
    jetbrains.idea-ultimate # IntelliJ IDEA

    # Runtime and SDK
    bun # Fast JavaScript runtime/toolkit
    rustup # Rust toolchain manager

    # Java Development Kit (only default version)
    jdk21 # Default Java version

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
    # Java version management
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";

    # Rust configuration
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";

    # Bun configuration
    BUN_INSTALL = "$HOME/.bun";
  };
}
