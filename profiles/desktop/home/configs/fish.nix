{ pkgs, lib, ... }:
let
  # Define JDK versions for clarity and easy updates
  jdks = {
    "8" = pkgs.jdk8;
    "11" = pkgs.jdk11;
    "17" = pkgs.jdk17;
    "21" = pkgs.jdk21;
  };
  defaultJdkVersion = "21";
in
{
  # Enable command-not-found, which uses nix-index database when available
  programs.command-not-found.enable = true;
  # Enable nix-index installation and database generation
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
  };

  programs.fish = {
    enable = true;

    # Shell initialization script executed for interactive shells
    interactiveShellInit = ''
      # Remove the default fish greeting message
      set -g fish_greeting

      # Configure fish color scheme (example)
      set -g fish_color_normal normal
      set -g fish_color_command blue
      set -g fish_color_param cyan
      set -g fish_color_error red
      set -g fish_color_quote green
      set -g fish_color_operator yellow

      # --- Environment Setup ---

      # Java Environment Variables (managed by 'use-java' function below)
      # Store paths to different JDKs provided by Nix
      ${lib.strings.concatStringsSep "\n" (
        lib.mapAttrsToList (name: pkg: ''set -gx JAVA_${name}_HOME "${pkg}"'') jdks
      )}
      # Set the default JAVA_HOME on shell startup
      set -gx JAVA_HOME "$JAVA_${defaultJdkVersion}_HOME"
      # Add the default Java's bin directory to the PATH
      # 'fish_add_path' prepends and avoids duplicates
      fish_add_path "$JAVA_HOME/bin"

      # Bun Environment (assumes Bun managed via official installer outside Nix)
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

      # Switch the active Java Development Kit version
      use-java = {
        description = "Switch active Java version (8|11|17|21)";
        body = ''
          # Check if a valid version argument was provided
          if test -z "$argv[1]"
             echo "Usage: use-java [${lib.strings.concatStringsSep "|" (lib.attrNames jdks)}]"
             echo "Current JAVA_HOME: $JAVA_HOME"
             # List available versions
             echo "Available versions (defined in Nix config):"
             for v in ${lib.strings.concatStringsSep " " (lib.attrNames jdks)}
               set -l jdk_path "JAVA_''${v}_HOME"
               # Check if the variable exists and is non-empty
               if set -q $jdk_path; and test -n "$$jdk_path"
                 echo "  $v: $$jdk_path"
               else
                 echo "  $v: (path not set or empty)"
               end
             end
             return 1
          end

          # Construct the variable name for the desired JDK home
          set -l target_jdk_var "JAVA_$argv[1]_HOME"

          # Check if the corresponding environment variable exists and is set
          if not set -q $target_jdk_var; or test -z "$$target_jdk_var"
              echo "Error: Java version '$argv[1]' is not configured or its path is empty."
              echo "Check your Nix configuration and the $target_jdk_var variable."
              return 1
          end

          # --- Path Management ---
          # Remove current JAVA_HOME/bin from fish_user_paths if it's there
          if set -q JAVA_HOME; and test -n "$JAVA_HOME"
            set -l current_java_bin "$JAVA_HOME/bin"
            # Check if the path exists in the user paths list
            if contains -- "$current_java_bin" $fish_user_paths
               # Use 'string match' to filter out the path (works across fish versions)
               set -g fish_user_paths (string match --invert --regex "^$(string escape --style=regex "$current_java_bin")\$" $fish_user_paths)
               # For newer fish versions, 'fish_path remove "$current_java_bin"' might be preferred
            end
          end

          # --- Update Environment ---
          # Get the path from the target environment variable
          set -l new_java_home $$target_jdk_var
          # Update the global JAVA_HOME
          set -gx JAVA_HOME $new_java_home
          # Prepend the new Java's bin directory to the PATH
          fish_add_path "$JAVA_HOME/bin"

          # --- Confirmation ---
          # Verify the change (optional but good practice)
          set -l current_java_version (java -version 2>&1 | string match -r 'version "([^"]+)"')
          if test $status -eq 0; and test -n "$current_java_version"
             echo "Java version set to: $argv[1] ( $current_java_version )"
             echo "JAVA_HOME: $JAVA_HOME"
          else
             echo "Java version set to: $argv[1]"
             echo "JAVA_HOME: $JAVA_HOME"
             echo "(Could not verify 'java -version')"
          end
        '';
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
