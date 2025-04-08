{ pkgs, ... }:
{
  services = {
    # Enable printing services
    printing.enable = true;

    # Support for video driver
    xserver.videoDrivers = [ "amdgpu" ];

    # udev rules for Android devices
    udev.packages = [ pkgs.android-udev-rules ];
  };
}
