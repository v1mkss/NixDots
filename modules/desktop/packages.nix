{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ./pkgs ];

  home.packages = with pkgs; [
    # Media
    audacious
    easyeffects
    youtube-music
    yt-dlp
    vlc

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
