{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # Gaming Core
    steam
    lutris
    inputs.xmcl-nix.packages.${system}.default # Minecraft Launcher

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
