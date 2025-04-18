{ pkgs, ... }:
{
  services = {
    # Enable printing services
    printing.enable = true;

    # Support for video driver
    xserver.videoDrivers = [ "amdgpu" ];
  };

  # Enable Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
    dockerSocket.enable = true;
    extraPackages = with pkgs; [ fuse-overlayfs ];
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
}
