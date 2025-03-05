{ pkgs, ... }:
{
  # Steam packages for Home Manager
  home.packages = with pkgs; [
    # Steam core
    steam
    steam-run
    steamcmd

    # Wine and compatibility tools
    protontricks
    winetricks
    wine-staging
    wine64
  ];
  
  # Optional: Additional configuration for Steam
  home.sessionVariables = {
    # Disable Steam's update notifications
    STEAM_DISABLE_UPDATES = "1";
  };
}
