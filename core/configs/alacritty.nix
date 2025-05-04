{ ... }:
{
  home.file.".config/alacritty/alacritty.toml".text = ''
    [env]
    TERM = "xterm-256color"

    [window]
    padding = { x = 5, y = 5 }
    decorations = "full"
    startup_mode = "Windowed"
    opacity = 0.8
    blur = true

    [scrolling]
    history = 10000
    multiplier = 3

    [font]
    size = 12.0
    [font.normal]
    family = "Cascadia Code"
    style = "Regular"
    [font.bold]
    family = "Cascadia Code"
    style = "Bold"
    [font.italic]
    family = "Cascadia Code"
    style = "Italic"
    [font.bold_italic]
    family = "Cascadia Code"
    style = "Bold Italic"

    [colors.primary]
    background = "#1a1a2a"
    foreground = "#bcc4e4"
    [colors.cursor]
    text = "#1a1a2a"
    cursor = "#e6cbc7"
    [colors.selection]
    text = "#bcc4e4"
    background = "#3d3f52"
    [colors.normal]
    black =   "#2a2b3c"
    red =     "#e28ca5"
    green =   "#a1cca0"
    yellow =  "#e8d1ad"
    blue =    "#7796d0"
    magenta = "#c9aee8"
    cyan =    "#92ccc3"
    white =   "#aab4d4"
    [colors.bright]
    black =   "#3d3f52"
    red =     "#e28ca5"
    green =   "#a1cca0"
    yellow =  "#e8d1ad"
    blue =    "#7796d0"
    magenta = "#c9aee8"
    cyan =    "#92ccc3"
    white =   "#bcc4e4"

    [mouse]
    hide_when_typing = true
  '';
}
