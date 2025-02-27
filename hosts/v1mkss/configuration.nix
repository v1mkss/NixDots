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
    pinentryPackage = pkgs.pinentry-qt;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # System Version
  system.stateVersion = "24.11";
}
