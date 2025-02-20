{ pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./development.nix
    ./git.nix
  ];

  home.packages = with pkgs; [
    # Media
    mpv
    obs-studio
    spotify

    # Internet
    floorp
    telegram-desktop
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })

    # Office
    libreoffice-qt6-fresh

    # Additional tools
    nil
    nixd
    nixfmt-rfc-style
  ];
}
