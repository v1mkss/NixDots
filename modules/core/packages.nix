{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Basic utilities
    git
    wget
    gnupg
    rar
    unrar
    zip
    unzip

    # Other useful system tools
    pciutils # lspci
    usbutils # lsusb

    # Nix Language Server
    nil
    nixd
    nixfmt-rfc-style
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      alsa-lib
      ncurses
      stdenv.cc.cc.lib
      zlib

      openssl_3
    ];
  };
}
