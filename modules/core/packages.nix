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

    # GPU/Graphics tools
    vulkan-tools # vkinfo, vkcube
    clinfo # Check OpenCL
    glxinfo # Check OpenGL
    libva-utils # vainfo

    # Other useful system tools
    pciutils # lspci
    usbutils # lsusb


    # Additional tools
    nil
    nixd
    nixfmt-rfc-style
  ];
}
