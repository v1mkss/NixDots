{
  pkgs,
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
    (vivaldi.overrideAttrs (oldAttrs: {
      dontWrapQtApps = false;
      dontPatchELF = true;
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.kdePackages.wrapQtAppsHook ];
    }))

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