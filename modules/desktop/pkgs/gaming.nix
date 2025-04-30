{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Gaming Core
    steam
    lutris

    # Wine and compatibility tools
    protontricks
    protonplus
    winetricks
    wine-staging
    wine64
  ];

  home.sessionVariables = {
    # Disable Steam's update notifications
    STEAM_DISABLE_UPDATES = "1";
  };

}
