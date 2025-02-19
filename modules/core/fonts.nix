{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [ cascadia-code ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "Cascadia Mono" ];
        sansSerif = [ "Cascadia Code" ];
        serif = [ "Cascadia Code" ];
      };
    };

    # Enable font support
    enableDefaultPackages = true;
    fontDir.enable = true;
  };
}
