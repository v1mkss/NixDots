{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    # Shell initialization script executed for interactive shells
    interactiveShellInit = ''
      # Remove the default fish greeting message
      set -g fish_greeting

      # Prevent history sharing between host and containers
      if test "$container" = "podman" -o "$container" = "docker" -o -n "$DISTROBOX_ENTER_PATH"
        set -g fish_history ""
      end

      # Minimalistic NixOS-themed command not found handler
      function __fish_command_not_found_handler --on-event fish_command_not_found
        set_color blue
        echo -n "❄ "
        set_color red
        echo -n "$argv[1]"
        set_color normal
        echo " not found"
      end

      # Configure fish color scheme
      set -g fish_color_normal normal
      set -g fish_color_command blue
      set -g fish_color_param cyan
      set -g fish_color_error red
      set -g fish_color_quote green
      set -g fish_color_operator yellow

      # --- Environment Setup ---
      # Bun Environment
      set -gx BUN_INSTALL "$HOME/.bun"
      fish_add_path "$BUN_INSTALL/bin" # Add bun to PATH

      # Additional User-Specific Paths
      fish_add_path "$HOME/.local/bin" # Standard location for user scripts/binaries
    '';

    # Define convenient shell aliases
    shellAliases = {
      # System Maintenance (Note: 'sudo' requires root privileges)
      # Consider NixOS auto garbage collection instead for system cleanup
      cleanup = "nix-collect-garbage --delete-old; sudo nix-collect-garbage -d; echo 'Nix-Garbage work finished'";
      optimize = "echo Nix-Store Optimization... Please wait; sudo nix-store --optimize";

      # Directory Navigation
      ".." = "cd ..";
      "..." = "cd ../..";

      # Modern Unix Command Replacements
      # Use direct paths from pkgs for robustness
      ls = "${pkgs.eza}/bin/eza";
      l = "${pkgs.eza}/bin/eza -l";
      la = "${pkgs.eza}/bin/eza -la";
      tree = "${pkgs.eza}/bin/eza --tree";
      cat = "${pkgs.bat}/bin/bat";
    };

    # Define custom fish functions
    functions = {
      # Custom Fish Prompt
      fish_prompt = {
        body = ''
          # Simple prompt: PWD (git branch) >
          set -l last_status $status

          # Current Directory
          set_color blue
          echo -n (prompt_pwd)

          # Git Branch (if in a git repository)
          if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
            set_color yellow
            # Use __fish_git_prompt for more features later if needed
            echo -n " ("(command git branch --show-current)")"
          end

          # Status Indicator (> green, > red on error)
          if test $last_status -eq 0
            set_color normal
          else
            set_color red
          end
          echo -n " > "

          # Reset color for user input
          set_color normal
        '';
      };

      # Create a directory and change into it
      mkcd = {
        description = "Create directory and cd into it";
        body = "mkdir -p $argv[1] && cd $argv[1]";
      };
    };
  };

  # Install essential command-line utilities managed by Home Manager
  home.packages = with pkgs; [
    # File system navigation & display
    eza # Modern 'ls' replacement
    bat # Modern 'cat' replacement with syntax highlighting
    fd # Simple, fast and user-friendly 'find' alternative

    # Search & Filtering
    fzf # Command-line fuzzy finder
  ];
}
