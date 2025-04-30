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
    enable = false;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
    dockerSocket.enable = true;
    extraPackages = with pkgs; [ fuse-overlayfs ];
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Better Gamnig Support
  programs.gamemode.enable = true;
}
