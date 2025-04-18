{ ... }:

let
  # Catppuccin Mocha Blue
  ctp = {
  # Акценти
  rosewater = "#e6cbc7"; # Трохи менш насичений рожевий
  mauve     = "#c9aee8"; # Трохи менш насичений бузковий
  red       = "#e28ca5"; # Трохи менш насичений червоний
  yellow    = "#e8d1ad"; # Трохи менш насичений жовтий
  green     = "#a1cca0"; # Трохи менш насичений зелений
  teal      = "#92ccc3"; # Трохи менш насичений бірюзовий
  blue      = "#7796d0"; # Менш яскравий синій (на основі вашого #6a95d7)

  # Текст
  text      = "#bcc4e4"; # Оригінальний текст
  subtext1  = "#aab4d4"; # Оригінальний підтекст 1

  # Фонові кольори
  surface2  = "#3d3f52"; # Оригінальна поверхня 2
  surface1  = "#2a2b3c"; # Оригінальна поверхня 1
  base      = "#1a1a2a"; # Оригінальна база
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
        padding = { x = 5; y = 5; };
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
