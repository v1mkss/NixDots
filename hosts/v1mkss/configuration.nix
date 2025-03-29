{ pkgs, username, hostname, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
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
      ];
      shell = pkgs.fish;
    };
  };

  # Program configurations
  programs = {
    fish.enable = true;
    gpu-screen-recorder.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # Security settings
  security.sudo.wheelNeedsPassword = true;

  # System settings
  time.timeZone = "Europe/Kyiv";
  system.stateVersion = "25.05";
}
