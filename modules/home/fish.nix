{ pkgs, ... }:
let
  # Define Java packages without installing them directly
  jdk8 = pkgs.jdk8;
  jdk11 = pkgs.jdk11;
  jdk17 = pkgs.jdk17;
  jdk21 = pkgs.jdk21;
in
{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # Remove greeting
      set -g fish_greeting

      # Basic colors
      set -g fish_color_normal normal
      set -g fish_color_command blue
      set -g fish_color_param cyan
      set -g fish_color_error red
      set -g fish_color_quote green
      set -g fish_color_operator yellow

      # Java version management (using variables only)
      set -gx JAVA_8_HOME "${jdk8}/lib/openjdk"
      set -gx JAVA_11_HOME "${jdk11}/lib/openjdk"
      set -gx JAVA_17_HOME "${jdk17}/lib/openjdk"
      set -gx JAVA_21_HOME "${jdk21}/lib/openjdk"
      set -gx JAVA_HOME $JAVA_21_HOME  # Default to Java 21

      # Rust
      set -gx RUSTUP_HOME $HOME/.rustup
      set -gx CARGO_HOME $HOME/.cargo
      fish_add_path $CARGO_HOME/bin

      # Bun
      set -gx BUN_INSTALL $HOME/.bun
      fish_add_path $BUN_INSTALL/bin

      # Additional PATHs
      fish_add_path $HOME/.local/bin
    '';

    shellAliases = {
      # System
      cleanup = "sudo nix-collect-garbage -d";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";

      # Modern Unix
      ls = "eza";
      l = "eza -l";
      la = "eza -la";
      tree = "eza --tree";
      cat = "bat";
    };

    functions = {
      fish_prompt = {
        body = ''
          # Simple minimalistic prompt
          set -l last_status $status

          # Path
          set_color blue
          echo -n (prompt_pwd)

          # Git status (if in git repository)
          if git rev-parse --is-inside-work-tree >/dev/null 2>&1
            set_color yellow
            echo -n " ("(git branch --show-current)")"
          end

          # Status symbol (red if error)
          if test $last_status -eq 0
            set_color normal
          else
            set_color red
          end

          echo -n " > "
          set_color normal
        '';
      };

      # Function for quick directory creation and navigation
      mkcd = {
        body = "mkdir -p $argv[1] && cd $argv[1]";
      };

      # Function for switching Java version
      use-java = {
        body = ''
          switch $argv[1]
            case "8"
              set -gx JAVA_HOME $JAVA_8_HOME
            case "11"
              set -gx JAVA_HOME $JAVA_11_HOME
            case "17"
              set -gx JAVA_HOME $JAVA_17_HOME
            case "21"
              set -gx JAVA_HOME $JAVA_21_HOME
            case '*'
              echo "Usage: use-java [8|11|17|21]"
          end
          echo "JAVA_HOME is now $JAVA_HOME"
        '';
      };
    };
  };

  # Install required utilities
  home.packages = with pkgs; [
    eza # Modern replacement for ls
    bat # Modern replacement for cat
    fd # Modern replacement for find
    fzf # Fuzzy finder
  ];
}
