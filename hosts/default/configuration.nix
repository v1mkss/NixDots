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
    description = "Volodia Kraplich";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "adbusers"
      "corectrl"
    ];
    shell = pkgs.fish;
  };
in
{
  imports = [
    ../../modules/core
    ../../profiles/desktop
    ../hardware-configuration.nix
  ];

  # Networking configuration
  networking.hostName = hostname;

  # User configuration
  users = {
    mutableUsers = true;
    users.${username} = userConfig;
  };

  # Program configurations
  programs = {
    adb.enable = true;
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # Security settings
  security.sudo.wheelNeedsPassword = true;
  nix.settings.trusted-users = [ "@wheel" ];

  # System settings
  services.chrony.enable = true; # For time synchronization
  time.timeZone = "Europe/Kyiv";

  system.stateVersion = nixstateVersion;
}
