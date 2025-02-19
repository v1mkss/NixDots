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
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  # System Version
  system.stateVersion = "24.11";
}
