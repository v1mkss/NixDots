{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Settings GnuPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  # System Version
  system.stateVersion = "25.05";
}
