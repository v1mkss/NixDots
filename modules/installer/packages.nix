{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    # Media
    easyeffects
    mpv

    # Internet
    inputs.zen-browser.packages."${system}".default

    # Office
    libreoffice-qt6-fresh
  ];
}
