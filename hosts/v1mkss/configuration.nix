{ pkgs, username, hostname, ... }:

{
  imports = [
    ../../modules/core
    ../../modules/desktop
    ../hardware-configuration.nix
  ];

  # Networking configuration
  networking.hostName = hostname;

  # User configuration
  users = {
    mutableUsers = true;
    users.${username} = {
      isNormalUser = true;
      description = "Volodia Kraplich";
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "audio"
        "adbusers"
      ];
      shell = pkgs.fish;
    };
  };

  # Program configurations
  programs = {
    adb.enable = true;
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nix-ld.enable = true;
  };

  # Security settings
  security.sudo.wheelNeedsPassword = true;

  # System settings
  time.timeZone = "Europe/Kyiv";
  system.stateVersion = "25.05";
}
