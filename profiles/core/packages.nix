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

    # Additional tools
    nixd
    nixfmt-rfc-style

    openssl_3

    preload
    rng-tools
  ];
}
