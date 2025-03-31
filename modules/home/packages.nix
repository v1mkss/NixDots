{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./development.nix
    ./fish.nix
    ./git.nix
    ./steam.nix
    # ./pkgs/davinci-resolve.nix # Davinci Resolve Studio
  ];

  home.packages = with pkgs; [
    # Media
    easyeffects
    mpv
    gpu-screen-recorder-gtk
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
