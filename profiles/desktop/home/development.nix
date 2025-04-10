{ pkgs, ... }:

let
  # Group development tools for clarity
  developmentTools = with pkgs; [
    zed-editor-fhs # Alternative editor
    godot_4        # Game development engine
    lazygit        # Terminal UI for git
  ];

  # Runtimes and SDKs managed via home-manager
  runtimesAndSDKs = with pkgs; [
    bun            # Fast JavaScript runtime/toolkit
    rustc          # Rust compiler
    cargo          # Rust package manager/build tool
  ];

  # Common build tools needed globally
  buildTools = with pkgs; [
    # C/C++ Toolchain (LLVM/Clang)
    clang # C/C++ Compiler
    lld   # Linker

    # C/C++ Toolchain (GCC related)
    gdb                # Debugger

    # Build Systems & Helpers
    cmake
    meson
    ninja
    gnumake
    pkg-config
  ];

in
{
  imports = [
    ./development
  ];

  # Install packages into the user profile
  home.packages = developmentTools ++ runtimesAndSDKs ++ buildTools;

  # Configure environment variables for tools managed outside the Nix store
  home.sessionVariables = {
    # Bun configuration
    BUN_INSTALL = "$HOME/.bun";
  };
}
