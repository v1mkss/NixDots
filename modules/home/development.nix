{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # Development Tools
    vscode # Alternative editor
    godot_4-mono # Game development engine
    lazygit # Terminal UI for git
    blender # 3D creation suite

    # Runtime and SDK
    bun # Fast JavaScript runtime/toolkit
    rustup # Rust toolchain manager
    dotnet-sdk_8 # .NET SDK (latest LTS version)

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

    # .NET configuration
    DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";

    # Rust configuration
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";

    # Bun configuration
    BUN_INSTALL = "$HOME/.bun";
  };

  # .NET CLI tools PATH
  home.sessionPath = [
    "${pkgs.dotnet-sdk_8}/bin"
  ];
}
