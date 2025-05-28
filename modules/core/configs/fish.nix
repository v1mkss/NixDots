{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    # Shell initialization script executed for interactive shells
    interactiveShellInit = ''
      # Remove the default fish greeting message (redundant with empty function definition, but harmless)
      set -g fish_greeting

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

      # Setup key bindings for history (!! and !$)
      if [ "$fish_key_bindings" = "fish_vi_key_bindings" ]
          bind -Minsert ! __history_previous_command
          bind -Minsert '$' __history_previous_command_arguments
      else
          bind ! __history_previous_command
          bind '$' __history_previous_command_arguments
      end

      # Configure "done" plugin settings (command completion notifications)
      # The "done" plugin (in conf.d/done.fish) sends desktop notifications when long-running commands complete
      set -g __done_min_cmd_duration 10000       # Show notification after 10 seconds
      set -g __done_exclude '^git (?!push|pull|fetch)'  # Don't notify for most git commands except push/pull/fetch
      set -g __done_notify_sound 0               # Don't play sound with notifications
      set -g __done_notification_duration 3000   # How long notifications stay on screen (ms)
      set -U __done_notification_urgency_level low # Set urgency level to low

      # MIT License

      # Copyright (c) 2016 Francisco Lourenço & Daniel Wehner

      # Permission is hereby granted, free of charge, to any person obtaining a copy
      # of this software and associated documentation files (the "Software"), to deal
      # in the Software without restriction, including without limitation the rights
      # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
      # copies of the Software, and to permit persons to whom the Software is
      # furnished to do so, subject to the following conditions:

      # The above copyright notice and this permission notice shall be included in all
      # copies or substantial portions of the Software.

      # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
      # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
      # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
      # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
      # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
      # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
      # SOFTWARE.

      if not status is-interactive
          exit
      end

      set -g __done_version 1.19.1

      function __done_run_powershell_script
          set -l powershell_exe (command --search "powershell.exe")

          if test $status -ne 0
              and command --search wslvar

              set -l powershell_exe (wslpath (wslvar windir)/System32/WindowsPowerShell/v1.0/powershell.exe)
          end

          if string length --quiet "$powershell_exe"
              and test -x "$powershell_exe"

              set cmd (string escape $argv)

              eval "$powershell_exe -Command $cmd"
          end
      end

      function __done_windows_notification -a title -a message
          if test "$__done_notify_sound" -eq 1
              set soundopt "<audio silent=\"false\" src=\"ms-winsoundevent:Notification.Default\" />"
          else
              set soundopt "<audio silent=\"true\" />"
          end

          __done_run_powershell_script "
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null

\$toast_xml_source = @\"
      <toast>
          $soundopt
          <visual>
              <binding template=\"ToastText02\">
                  <text id=\"1\">$title</text>
                  <text id=\"2\">$message</text>
              </binding>
          </visual>
      </toast>
\"@

\$toast_xml = New-Object Windows.Data.Xml.Dom.XmlDocument
\$toast_xml.loadXml(\$toast_xml_source)

\$toast = New-Object Windows.UI.Notifications.ToastNotification \$toast_xml

[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier(\"fish\").Show(\$toast)
"
      end

      function __done_get_focused_window_id
          if type -q lsappinfo
              lsappinfo info -only bundleID (lsappinfo front | string replace 'ASN:0x0-' '0x') | cut -d '"' -f4
          else if test -n "$SWAYSOCK"
              and type -q jq
              swaymsg --type get_tree | jq '.. | objects | select(.focused == true) | .id'
          else if test -n "$HYPRLAND_INSTANCE_SIGNATURE"
              hyprctl activewindow | awk '/^\tpid: / {print $2}'
          else if begin
                  test "$XDG_SESSION_DESKTOP"$'' = gnome$'' and type -q gdbus
              end
              gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval 'global.display.focus_window.get_id()'
          else if type -q xprop
              and test -n "$DISPLAY"
              # Test that the X server at $DISPLAY is running
              and xprop -grammar >/dev/null 2>&1
              xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2
          else if uname -a | string match --quiet --ignore-case --regex microsoft
              __done_run_powershell_script '
Add-Type @"
      using System;
      using System.Runtime.InteropServices;
      public class WindowsCompat {
          [DllImport("user32.dll")]
          public static extern IntPtr GetForegroundWindow();
      }
"@
[WindowsCompat]::GetForegroundWindow()
'
          else if set -q __done_allow_nongraphical
              echo 12345 # dummy value
          end
      end

      function __done_is_tmux_window_active
          set -q fish_pid; or set -l fish_pid %self

          # find the outermost process within tmux
          # ppid != "tmux" -> pid = ppid
          # ppid == "tmux" -> break
          set tmux_fish_pid $fish_pid
          while set tmux_fish_ppid (ps -o ppid= -p $tmux_fish_pid | string trim)
              # remove leading hyphen so that basename does not treat it as an argument (e.g. -fish), and return only
              # the actual command and not its arguments so that basename finds the correct command name.
              # (e.g. '/usr/bin/tmux' from command '/usr/bin/tmux new-session -c /some/start/dir')
              and ! string match -q "tmux*" (basename (ps -o command= -p $tmux_fish_ppid | string replace -r '^-' '' | string split ' ')[1])
              set tmux_fish_pid $tmux_fish_ppid
          end

          # tmux session attached and window is active -> no notification
          # all other combinations -> send notification
          tmux list-panes -a -F "#{session_attached} #{window_active} #{pane_pid}" | string match -q "1 1 $tmux_fish_pid"
      end

      function __done_is_screen_window_active
          string match --quiet --regex "$STY\s+\(Attached" (screen -ls)
      end

      function __done_is_process_window_focused
          # Return false if the window is not focused

          if set -q __done_allow_nongraphical
              return 1
          end

          if set -q __done_kitty_remote_control
              kitty @ --password="$__done_kitty_remote_control_password" ls | jq -e ".[].tabs[] | select(any(.windows[]; .is_self)) | .is_focused" >/dev/null
              return $status
          end

          set __done_focused_window_id (__done_get_focused_window_id)
          if test "$__done_sway_ignore_visible" -eq 1
              and test -n "$SWAYSOCK"
              string match --quiet --regex "^true" (swaymsg -t get_tree | jq ".. | objects | select(.id == "$__done_initial_window_id") | .visible")
              return $status
          else if test -n "$HYPRLAND_INSTANCE_SIGNATURE"
              set window_pid (hyprctl activewindow | awk '/^\tpid: / {print $2}' )
              if test -n "$window_pid"
                  and test $__done_initial_window_id -eq $window_pid
                  return $status
              else
                  return 1
              end
          else if test "$__done_initial_window_id" != "$__done_focused_window_id"
              return 1
          end
          # If inside a tmux session, check if the tmux window is focused
          if type -q tmux
              and test -n "$TMUX"
              __done_is_tmux_window_active
              return $status
          end

          # If inside a screen session, check if the screen window is focused
          if type -q screen
              and test -n "$STY"
              __done_is_screen_window_active
              return $status
          end

          return 0
      end

      function __done_humanize_duration -a milliseconds
          set -l seconds (math --scale=0 "$milliseconds/1000" % 60)
          set -l minutes (math --scale=0 "$milliseconds/60000" % 60)
          set -l hours (math --scale=0 "$milliseconds/3600000")

          if test $hours -gt 0
              printf '%s' $hours'h '
          end
          if test $minutes -gt 0
              printf '%s' $minutes'm '
          end
          if test $seconds -gt 0
              printf '%s' $seconds's'
          end
      end

      # verify that the system has graphical capabilities before initializing
      if test -z "$SSH_CLIENT" # not over ssh
          and count (__done_get_focused_window_id) >/dev/null # is able to get window id
          set __done_enabled
      end

      if set -q __done_allow_nongraphical
          and set -q __done_notification_command
          set __done_enabled
      end

      if set -q __done_enabled
          set -g __done_initial_window_id ''
          set -q __done_min_cmd_duration; or set -g __done_min_cmd_duration 5000
          set -q __done_exclude; or set -g __done_exclude '^git (?!push|pull|fetch)'
          set -q __done_notify_sound; or set -g __done_notify_sound 0
          set -q __done_sway_ignore_visible; or set -g __done_sway_ignore_visible 0
          set -q __done_tmux_pane_format; or set -g __done_tmux_pane_format '[#{window_index}]'
          set -q __done_notification_duration; or set -g __done_notification_duration 3000

          function __done_started --on-event fish_preexec
              set __done_initial_window_id (__done_get_focused_window_id)
          end

          function __done_ended --on-event fish_postexec
              set -l exit_status $status

              # backwards compatibility for fish < v3.0
              set -q cmd_duration; or set -l cmd_duration $CMD_DURATION

              if test $cmd_duration
                  and test $cmd_duration -gt $__done_min_cmd_duration # longer than notify_duration
                  and not __done_is_process_window_focused # process pane or window not focused

                  # don't notify if command matches exclude list
                  for pattern in $__done_exclude
                      if string match -qr $pattern $argv[1]
                          return
                      end
                  end

                  # Store duration of last command
                  set -l humanized_duration (__done_humanize_duration "$cmd_duration")

                  set -l title "Done in $humanized_duration"
                  set -l wd (string replace --regex "^$HOME" "~" (pwd))
                  set -l message "$wd/ $argv[1]"
                  set -l sender $__done_initial_window_id

                  if test $exit_status -ne 0
                      set title "Failed ($exit_status) after $humanized_duration"
                  end

                  if test -n "$TMUX_PANE"
                      set message (tmux lsw  -F"$__done_tmux_pane_format" -f '#{==:#{pane_id},'$TMUX_PANE'}')" $message"
                  end

                  if set -q __done_notification_command
                      eval $__done_notification_command
                      if test "$__done_notify_sound" -eq 1
                          echo -e "\a" # bell sound
                      end
                  else if set -q KITTY_WINDOW_ID
                      printf "\x1b]99;i=done:d=0;$title\x1b\\"
                      printf "\x1b]99;i=done:d=1:p=body;$message\x1b\\"
                  else if type -q terminal-notifier # https://github.com/julienXX/terminal-notifier
                      if test "$__done_notify_sound" -eq 1
                          # pipe message into terminal-notifier to avoid escaping issues (https://github.com/julienXX/terminal-notifier/issues/134). fixes #140
                          echo "$message" | terminal-notifier -title "$title" -sender "$__done_initial_window_id" -sound default
                      else
                          echo "$message" | terminal-notifier -title "$title" -sender "$__done_initial_window_id"
                      end

                  else if type -q osascript # AppleScript
                      # escape double quotes that might exist in the message and break osascript. fixes #133
                      set -l message (string replace --all '"' '\"' "$message")
                      set -l title (string replace --all '"' '\"' "$title")

                      osascript -e "display notification \"$message\" with title \"$title\""
                      if test "$__done_notify_sound" -eq 1
                          osascript -e "display notification \"$message\" with title \"$title\" sound name \"Glass\""
                      else
                          osascript -e "display notification \"$message\" with title \"$title\""
                      end

                  else if type -q notify-send # Linux notify-send
                      # set urgency to normal
                      set -l urgency normal

                      # use user-defined urgency if set
                      if set -q __done_notification_urgency_level
                          set urgency "$__done_notification_urgency_level"
                      end
                      # override user-defined urgency level if non-zero exitstatus
                      if test $exit_status -ne 0
                          set urgency critical
                          if set -q __done_notification_urgency_level_failure
                              set urgency "$__done_notification_urgency_level_failure"
                          end
                      end

                      notify-send --hint=int:transient:1 --urgency=$urgency --icon=utilities-terminal --app-name=fish --expire-time=$__done_notification_duration "$title" "$message"

                      if test "$__done_notify_sound" -eq 1
                          echo -e "\a" # bell sound
                      end

                  else if type -q notify-desktop # Linux notify-desktop
                      set -l urgency
                      if test $exit_status -ne 0
                          set urgency "--urgency=critical"
                      end
                      notify-desktop $urgency --icon=utilities-terminal --app-name=fish "$title" "$message"
                      if test "$__done_notify_sound" -eq 1
                          echo -e "\a" # bell sound
                      end

                  else if uname -a | string match --quiet --ignore-case --regex microsoft
                      __done_windows_notification "$title" "$message"

                  else # anything else
                      echo -e "\a" # bell sound
                  end

              end
          end

          function __done_uninstall -e done_uninstall
              # Erase all __done_* functions
              functions -e __done_ended
              functions -e __done_started
              functions -e __done_get_focused_window_id
              functions -e __done_is_tmux_window_active
              functions -e __done_is_screen_window_active
              functions -e __done_is_process_window_focused
              functions -e __done_windows_notification
              functions -e __done_run_powershell_script
              functions -e __done_humanize_duration

              # Erase __done variables
              set -e __done_version
          end
    ''; # End of interactiveShellInit

    # Define convenient shell aliases
    shellAliases = {
      # System Maintenance (Keep original Nix-specific ones)
      cleanup = "nix-collect-garbage -d; sudo nix-collect-garbage -d; echo 'Nix-Garbage work finished'";
      optimize = "echo Nix-Store Optimization... Please wait; sudo nix-store --optimize";

      # Directory Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";

      # Modern Unix Command Replacements (Use Nix paths)
      ls = "${pkgs.eza}/bin/eza -al --color=always --group-directories-first --icons";
      l = "${pkgs.eza}/bin/eza -l --color=always --group-directories-first --icons";
      la = "${pkgs.eza}/bin/eza -a --color=always --group-directories-first --icons";
      lt = "${pkgs.eza}/bin/eza -aT --color=always --group-directories-first --icons";
      # Note: l. alias uses grep, ensure grep is in home.packages if not already
      # It is usually in essential packages, but explicitly adding it might be safer.
      # The original home.packages doesn't have it, let's stick to the prompt and original list.
      "l." = "${pkgs.eza}/bin/eza -a | grep -e '^\.'";
      tree = "${pkgs.eza}/bin/eza --tree";
      cat = "${pkgs.bat}/bin/bat";

      # General Utilities
      untar = "tar -xvf"; # Extract tar archives
      tarnow = "tar -acf";    # Create a tar archive
      # Note: grep aliases assume coreutils grep is available or in path
      grep = "grep --color=auto";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";
      wget = "wget -c";       # Resume wget by default

      # Git shortcuts (Assume git is available)
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
    };

    # Define custom fish functions
    functions = {
      # Disable default fish greeting message
      fish_greeting = {
        body = "";
      };

      # Minimalistic NixOS-themed command not found handler (Updated spacing)
      __fish_command_not_found_handler = {
        body = ''
          set_color blue
          echo -n "❄  " # Added a space
          set_color red
          echo -n "$argv[1]"
          set_color normal
          echo " not found"
        '';
      };

      # Custom Fish Prompt (Identical body, updated description)
      fish_prompt = {
        description = "Simple prompt: PWD (git branch) >";
        body = ''
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

      ## Functions for command history
      # Functions needed for !! and !$
      __history_previous_command = {
        description = "Recalls the previous command line or starts history token search";
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
        description = "Recalls arguments of the previous command or starts history token search";
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

      # Enhanced history display with timestamps
      history = {
        description = "Display command history with timestamps";
        body = "builtin history --show-time='%F %T '";
      };

      # Simple backup function
      backup = {
        description = "Create a backup of a file";
        body = "cp $argv[1] $argv[1].bak";
      };

      # Improved copy function
      copy = {
        description = "Copy files or directories";
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

      update = {
        description = "Update system packages based on available package manager";
        body = ''
          set update_cmd ""
          set pkg_manager ""

          if type -q apt
            set pkg_manager "apt"
            set update_cmd "sudo apt update && sudo apt upgrade -y"
          else if type -q paru
            set pkg_manager "paru"
            set update_cmd "paru -Syu"
          else if type -q yay
            set pkg_manager "yay"
            set update_cmd "yay -Syu"
          else if type -q pacman
            set pkg_manager "pacman"
            set update_cmd "sudo pacman -Syu"
          else if type -q dnf
            set pkg_manager "dnf"
            set update_cmd "sudo dnf up -y"
          else if type -q nobara-sync
            set pkg_manager "nobara-sync"
            set update_cmd "nobara-sync cli"
          end

          # Execute the update command if one was found, otherwise notify the user
          if test -n "$update_cmd"
            eval $update_cmd
          else
            echo "No supported package manager found."
          end
        '';
      };

      cleanup = {
        description = "Clean system packages cache and remove orphaned packages";
        body = ''
          echo "Starting system cleanup..."

          # For Debian-based systems: use apt
          if type -q apt
            sudo apt autoremove -y
            sudo apt clean
          # For Arch-based systems: use paru, yay, or pacman
          else if type -q paru
            paru -Scc
            # paru -Qtdq lists orphaned AUR packages, pacman -Qtdq lists orphaned repo packages
            # paru -Rns can remove both types
            set -l orphaned_packages (paru -Qtdq)
            if test -n "$orphaned_packages"
              paru -Rns $orphaned_packages
            else
              echo "No orphaned packages found."
            end
          else if type -q yay
            echo "Detected yay package manager."
            echo "Running yay -Scc (clean cache)..."
            yay -Scc
            # yay -Qtdq lists orphaned AUR packages, pacman -Qtdq lists orphaned repo packages
            # yay -Rns can remove both types
            set -l orphaned_packages (yay -Qtdq)
            if test -n "$orphaned_packages"
              yay -Rns $orphaned_packages
            else
              echo "No orphaned packages found."
            end
          else if type -q pacman
            sudo pacman -Scc
            # pacman -Qtdq lists orphaned repo packages
            set -l orphaned_packages (pacman -Qtdq)
            if test -n "$orphaned_packages"
              sudo pacman -Rns $orphaned_packages
            else
              echo "No orphaned repo packages found."
            end
          # For Nobara: use nobara-sync for cache clean and dnf for autoremove
          else if type -q nobara-sync
            nobara-sync clean-dnf
            # Assuming Nobara still uses dnf for autoremove of explicitly installed packages
            sudo dnf autoremove -y
          # For Fedora-based systems: use dnf
          else if type -q dnf
            sudo dnf autoremove -y
            sudo dnf clean all
          else
            echo "No supported package manager found for cleanup."
          end

          echo "Cleanup finished."
        '';
      };


      # Create a directory and change into it (Identical body, updated description)
      mkcd = {
        description = "Create directory and cd into it";
        body = "mkdir -p $argv[1] && cd $argv[1]";
      };
    };

    # Add configuration for the fish 'done' plugin if needed.
    # The prompt includes the raw script for the 'done' plugin which
    # is placed directly into interactiveShellInit. This is less idiomatic
    # than using the fish plugin mechanism, but follows the prompt's structure.
    # A better approach would be to add:
    # plugins = [ { name = "done"; src = pkgs.fetchFromGitHub { ... }; } ];
    # and remove the script block from interactiveShellInit.
    # However, sticking strictly to the prompt, the script goes in interactiveShellInit.

  }; # End of programs.fish

  # Set session environment variables
  home.sessionVariables = {
    MANROFFOPT = "-c";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };


  # Install essential command-line utilities managed
  home.packages = with pkgs; [
    # File system navigation & display
    eza # Modern 'ls' replacement
    bat # Modern 'cat' replacement with syntax highlighting
    fd # Simple, fast and user-friendly 'find' alternative

    # Search & Filtering
    fzf # Command-line fuzzy finder
    # Add packages required by aliases/functions if not standard, e.g., git, tar, grep, wget, jq, tmux, screen, terminal-notifier, notify-send
    # Keeping the original minimal list as per the original structure.
    # Users should add necessary packages here based on their function/alias usage.
  ];
}
