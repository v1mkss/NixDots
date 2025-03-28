{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
  ];

  # Settings GnuPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # System Version
  system.stateVersion = "25.05";
}
