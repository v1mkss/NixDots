{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      cascadia-code
      noto-fonts
      noto-fonts-cjk-sans
      roboto

      nerd-fonts.symbols-only
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "Cascadia Mono" ];
        sansSerif = [ "Cascadia Code" ];
        serif = [ "Cascadia Code" ];
        emoji = [ "Noto Color Emoji" "Symbols Nerd Font"];
      };

      antialias = true;
      hinting.enable = true; # Enable hinting
      hinting.style = "slight"; # Set hint style
      subpixel.rgba = "rgb"; # Set subpixel rendering order (common for LCDs)
    };

    # Enable font support
    enableDefaultPackages = true;
    fontDir.enable = true;
  };
}
