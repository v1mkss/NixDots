{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      cascadia-code
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      roboto
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "Cascadia Mono" ];
        sansSerif = [ "Cascadia Code" ];
        serif = [ "Cascadia Code" ];
      };

      antialias = true;

    };

    # Enable font support
    enableDefaultPackages = true;
    fontDir.enable = true;
  };
}
