{ pkgs, ... }:

let
  # --- General Purpose Development Tools ---
  developmentTools = with pkgs; [
    vscode-fhs     # Visual Studio Code (FHS compatible)
    zed-editor-fhs
    godot_4        # Game development engine
    lazygit        # Terminal UI for git
  ];

  # --- Runtimes and SDKs ---
  runtimesAndSDKs = with pkgs; [
    bun            # Fast JavaScript runtime/toolkit
    dart           # Dart SDK (includes LSP)
  ];

  # --- C/C++ Toolchain ---
  llvm = pkgs.llvmPackages_latest;

  # C/C++ Build and Development Tools
  buildTools = with pkgs; [
    # Core Clang Toolset
    llvm.clang       # Clang C/C++ Compiler
    llvm.lld         # LLVM's Linker
    llvm.clang-tools
    llvm.lldb        # LLVM's Debugger

    # GCC Toolchain (still useful, especially GDB)
    gdb              # GNU Debugger (can debug Clang-compiled code)

    # Build Systems & Helpers
    cmake            # Cross-platform build system generator
    meson            # Modern, fast build system (works well with Ninja)
    ninja            # Very fast build system backend
    gnumake          # Standard Make utility
    pkg-config       # Utility to retrieve metadata about installed libraries
  ];

in
{
  imports = [
    ./development
  ];

  # Install packages into the user profile
  # Combine all package lists
  home.packages = developmentTools ++ runtimesAndSDKs ++ buildTools;

  # Configure environment variables
  home.sessionVariables = {
    # Bun configuration
    BUN_INSTALL = "$HOME/.bun";
  };
}
