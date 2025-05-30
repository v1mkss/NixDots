{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    # Shell initialization script executed for interactive shells
    interactiveShellInit = ''
      # Remove the default fish greeting message
      set -g fish_greeting

      # Disable fish greeting message
      function fish_greeting
      end

      # Format man pages
      set -x MANROFFOPT "-c"
      set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

      # Prevent history sharing between host and containers
      if test "$container" = "podman" -o "$container" = "docker" -o -n "$DISTROBOX_ENTER_PATH"
          set -g fish_history ""
      end

      # Configure fish color scheme
      set -g fish_color_normal normal
      set -g fish_color_command blue
      set -g fish_color_param cyan
      set -g fish_color_error red
      set -g fish_color_quote green
      set -g fish_color_operator yellow
    '';

    # Define convenient shell aliases
    shellAliases = {
      # Directory Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";

      # Modern Unix Command Replacements
      # First check if these packages are installed
      ls = "eza -al --color=always --group-directories-first --icons"; # preferred listing
      l = "eza -l --color=always --group-directories-first --icons";   # long format
      la = "eza -a --color=always --group-directories-first --icons";  # all files and dirs
      lt = "eza -aT --color=always --group-directories-first --icons"; # tree listing
      "l." = "eza -a | grep -e '^\.'";                                   # show only dotfiles
      tree = "eza --tree";
      cat = "bat";
      untar = "tar -xvf";     # Extract tar archives
      tarnow = "tar -acf";    # Create a tar archive
      grep = "grep --color=auto";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";
      wget = "wget -c";       # Resume wget by default

      # Git shortcuts
      g = "git";
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gd = "git diff";
      gs = "git status";
      gl = "git log --oneline --graph --decorate";
      gp = "git push";
      gpull = "git pull";
      gb = "git branch";
      cleanup = "nix-collect-garbage -d; sudo nix-collect-garbage -d; echo 'Nix-Garbage work finished'";
      optimize = "echo Nix-Store Optimization... Please wait; sudo nix-store --optimize";
    };

    # Define custom fish functions
    functions = {
      # Custom Fish Prompt
      fish_prompt = {
        body = ''
          ## Simple prompt: PWD (git branch) >
          set -l last_status $status

          ## Current Directory
          set_color blue
          echo -n (prompt_pwd)

          ## Git Branch (if in a git repository)
          if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
            set_color yellow
            ## Use __fish_git_prompt for more features later if needed
            echo -n " ("(command git branch --show-current)")"
          end

          ## Status Indicator (> green, > red on error)
          if test $last_status -eq 0
            set_color normal
          else
            set_color red
          end
          echo -n " > "

          ## Reset color for user input
          set_color normal
        '';
      };

      # Create a directory and change into it
      mkcd = {
        description = "Create directory and cd into it";
        body = "mkdir -p $argv[1] && cd $argv[1]";
      };

      gf = {
        description = "Git flow helper function";
        body = ''
          set -l cmd $argv[1]
          set -l args $argv[2..-1]

          if test -z "$cmd"
            echo "Git Flow Helper"
            echo "Usage: gf [command] [arguments]"
            echo ""
            echo "Commands:"
            echo "  s, status       Show git status"
            echo "  a, add          Add files: gf a . or gf a file.txt"
            echo "  c, commit       Commit with message: gf c \"commit message\""
            echo "  ca              Commit all changed files: gf ca \"commit message\""
            echo "  p, push         Push to remote"
            echo "  pl, pull        Pull from remote"
            echo "  co, checkout    Checkout branch: gf co branch-name"
            echo "  cb              Create and checkout new branch: gf cb new-branch"
            echo "  b, branch       List branches"
            echo "  m, merge        Merge branch: gf m branch-name"
            echo "  d, diff         Show changes"
            echo "  l, log          Show commit logs"
            echo "  r, reset        Reset files: gf r file.txt or gf r --hard"
            echo "  cl, clean       Clean repository: gf cl"
            echo "  t, tag          Create tag: gf t v1.0.0 or list tags: gf t"
            return 0
          end

          switch $cmd
            case s status
              git status
            case a add
              if test (count $args) -eq 0
                git add .
              else
                git add $args
              end
            case c commit
              if test (count $args) -eq 0
                echo "Error: Commit message required"
                return 1
              end
              git commit -m "$args"
            case ca
              if test (count $args) -eq 0
                echo "Error: Commit message required"
                return 1
              end
              git add .
              git commit -m "$args"
            case p push
              git push $args
            case pl pull
              git pull $args
            case co checkout
              git checkout $args
            case cb
              if test (count $args) -eq 0
                echo "Error: Branch name required"
                return 1
              end
              git checkout -b $args
            case b branch
              git branch $args
            case m merge
              if test (count $args) -eq 0
                echo "Error: Branch name required"
                return 1
              end
              git merge $args
            case d diff
              git diff $args
            case l log
              git log --oneline --graph --decorate $args
            case r reset
              git reset $args
            case cl clean
              git clean -fd $args
            case t tag
              if test (count $args) -eq 0
                git tag
              else
                git tag $args
              end
            case '*'
              echo "Unknown command: $cmd"
              return 1
          end
        '';
      };
      __history_previous_command = {
        body = ''
          switch (commandline -t)
            case "!"
              commandline -t $history[1]; commandline -f repaint
            case "*"
              commandline -i !
          end
        '';
      };
      __history_previous_command_arguments = {
        body = ''
          switch (commandline -t)
              case "!"
                  commandline -t ""
                  commandline -f history-token-search-backward
              case "*"
                  commandline -i '$'
          end
        '';
      };
      history = {
        body = ''
          builtin history --show-time='%F %T '
        '';
      };
      backup = {
        description = "Simple backup function";
        body = ''
          cp $filename $filename.bak
        '';
      };
      copy = {
        body = ''
          set count (count $argv | tr -d \n)
          if test "$count" = 2; and test -d "$argv[1]"
              set from (echo $argv[1] | string trim -r -c/)
              set to (echo $argv[2])
              command cp -r $from $to
          else
              command cp $argv
          end
        '';
      };
    };

    shellInit = ''
      function __fish_command_not_found_handler
          set_color blue
          echo -n "❄ "
          set_color red
          echo -n "$argv[1]"
          set_color normal
          echo " not found"
      end
      function fish_command_not_found
          __fish_command_not_found_handler $argv
      end
    '';
  };

  # Install essential command-line utilities managed
  home.packages = with pkgs; [
    # File system navigation & display
    eza # Modern 'ls' replacement
    bat # Modern 'cat' replacement with syntax highlighting
    fd # Simple, fast and user-friendly 'find' alternative

    # Search & Filtering
    fzf # Command-line fuzzy finder
  ];
}
