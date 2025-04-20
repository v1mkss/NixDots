{ pkgs, ... }:
{
  imports = [
    ./audio.nix
    ./desktop.nix
    ./fonts.nix
    ./services.nix
  ];

  # Diagnostic tools for graphics and compute APIs
  environment.systemPackages = with pkgs; [
    vulkan-tools # vkinfo, vkcube
    clinfo # Check OpenCL
    glxinfo # Check OpenGL
    libva-utils # vainfo
    corectrl # GPU control utility
  ];

  programs.corectrl = {
    enable = true;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xffffffff";
    };
  };
}
