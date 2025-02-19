{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # Development Tools
    jetbrains-toolbox  # For IDEs
    vscode             # For quick edits
    zed-editor         # Alternative editor

    # Runtime and SDK
    bun                # Fast JavaScript runtime/toolkit
    rustup             # Rust toolchain manager

    # Java Development Kit (only default version)
    jdk21              # Default Java version

    # Build tools
    cmake
    gnumake
    pkg-config
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
