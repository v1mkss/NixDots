{ ... }:

let
  # Catppuccin Mocha Blue
  ctp = {
    # Accents
    rosewater = "#e6cbc7"; # Mocha Rosewater
    mauve = "#c9aee8"; # Mocha Mauve
    red = "#e28ca5"; # Mocha Red
    yellow = "#e8d1ad"; # Mocha Yellow
    green = "#a1cca0"; # Mocha Green
    teal = "#92ccc3"; # Mocha Teal
    blue = "#7796d0"; # Mocha Blue

    # Text
    text = "#bcc4e4"; # Mocha Text
    subtext1 = "#aab4d4"; # Mocha Subtext1

    # Background colors
    surface2 = "#3d3f52"; # Mocha Subtext2
    surface1 = "#2a2b3c"; # Mocha Subtext1
    base = "#1a1a2a"; # Mocha Base
  };
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };

      window = {
        padding = {
          x = 5;
          y = 5;
        };
        decorations = "full";
        startup_mode = "Windowed";
        opacity = 0.8;
        blur = true;
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      # ---------------------------------
      font = {
        normal = {
          family = "Cascadia Code";
          style = "Regular";
        };
        bold = {
          family = "Cascadia Code";
          style = "Bold";
        };
        italic = {
          family = "Cascadia Code";
          style = "Italic";
        };
        bold_italic = {
          family = "Cascadia Code";
          style = "Bold Italic";
        };
        size = 12.0;
      };
      # ---------------------------------

      colors = {
        primary = {
          background = ctp.base;
          foreground = ctp.text;
        };
        cursor = {
          text = ctp.base;
          cursor = ctp.rosewater;
        };
        selection = {
          text = ctp.text;
          background = ctp.surface2;
        };
        normal = {
          black = ctp.surface1;
          red = ctp.red;
          green = ctp.green;
          yellow = ctp.yellow;
          blue = ctp.blue;
          magenta = ctp.mauve;
          cyan = ctp.teal;
          white = ctp.subtext1;
        };
        bright = {
          black = ctp.surface2;
          red = ctp.red;
          green = ctp.green;
          yellow = ctp.yellow;
          blue = ctp.blue;
          magenta = ctp.mauve;
          cyan = ctp.teal;
          white = ctp.text;
        };
      };

      # scrollbar.mode = "Never";

      mouse = {
        hide_when_typing = true;
      };
    };
  };
}