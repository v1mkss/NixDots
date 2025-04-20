{
  pkgs,
  username,
  hostname,
  nixstateVersion,
  ...
}:

let
  userConfig = {
    isNormalUser = true;
    description = "LiveISO";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    initialPassword = "";
    shell = pkgs.fish;
  };
in
{
  imports = [
    ../../modules/core
    ../../profiles/installer
  ];

  # Networking configuration
  networking.hostName = hostname;

  # User configuration
  users = {
    mutableUsers = false;
    users.${username} = userConfig;
  };

  # Program configurations
  programs.fish.enable = true;

  # Security settings
  security.sudo.wheelNeedsPassword = false;

  # System settings
  services.chrony.enable = true; # For time synchronization
  time.timeZone = "UTC";

  system.stateVersion = nixstateVersion;
}
