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
    nil
    nixd
    nixfmt-rfc-style
  ];
}
