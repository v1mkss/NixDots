{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./fish.nix
    ./development.nix
    ./git.nix
    ./steam.nix
  ];

  home.packages = with pkgs; [
    # Media
    easyeffects
    mpv
    obs-studio
    spotify
    yt-dlp

    # Internet
    inputs.zen-browser.packages."${system}".default
    telegram-desktop
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })

    # Office
    libreoffice-qt6-fresh
  ];
}
