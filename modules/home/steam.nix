{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Steam core
    steam
    steam-run

    # Wine and compatibility tools
    protontricks
    winetricks
    wine-staging
    wine64
  ];

  home.sessionVariables = {
    # Disable Steam's update notifications
    STEAM_DISABLE_UPDATES = "1";
  };
}
