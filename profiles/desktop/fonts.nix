{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      cascadia-code
      noto-fonts
      noto-fonts-cjk-sans
      roboto
      unifont

      nerd-fonts.symbols-only
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "Cascadia Mono" ];
        sansSerif = [ "Cascadia Code" ];
        serif = [ "Cascadia Code" ];
        emoji = [
          "Noto Color Emoji"
          "Symbols Nerd Font"
          "Unifont"
        ];
      };

      antialias = true;
      hinting.enable = true; # Enable hinting
      hinting.style = "slight"; # Set hint style
      subpixel.rgba = "rgb"; # Set subpixel rendering order
    };

    # Enable font support
    enableDefaultPackages = true;
    fontDir.enable = true;
  };

  environment.variables.TERM = "xterm-256color";
}
