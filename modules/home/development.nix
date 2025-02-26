{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # Development Tools
    jetbrains.rust-rover    # Rust IDE
    jetbrains.idea-ultimate # IntelliJ IDEA Ultimate
    jetbrains.webstorm      # WebStorm IDE
    vscodium                # Alternative editor
    godot_4                 # Game development engine
    lazygit                 # Terminal UI for git

    # Runtime and SDK
    bun                # Fast JavaScript runtime/toolkit
    rustup             # Rust toolchain manager

    # Java Development Kit (only default version)
    jdk21              # Default Java version

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
    # Java
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";

    # Rust
    RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";
    CARGO_HOME = "${config.home.homeDirectory}/.cargo";

    # Bun
    BUN_INSTALL = "${config.home.homeDirectory}/.bun";
  };
}
