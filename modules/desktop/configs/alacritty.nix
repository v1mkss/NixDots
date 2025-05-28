{ ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "catpuccin-mocha"; # Set theme as requested

      font = {
        family = "Cascadia Code"; # Set font family as requested
        size = 12.0; # Keep original font size from Alacritty config
      };

      window = {
        opacity = 0.8; # Keep opacity from Alacritty config
        blur = true; # Keep blur from Alacritty config
      };

      scrollback = {
        lines = 10000; # Translate history from Alacritty config
      };
    };
  };
}
