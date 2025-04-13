{ pkgs, ... }:
{
  services = {
    # Enable printing services
    printing.enable = true;

    # Support for video driver
    xserver.videoDrivers = [ "amdgpu" ];
  };

  # Enable gamemode for performance optimizations during gaming
  programs.gamemode.enable = true;
}
