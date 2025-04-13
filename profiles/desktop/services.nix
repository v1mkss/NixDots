{ ... }:
{
  services = {
    # Enable printing services
    printing.enable = true;

    # Support for video driver
    xserver.videoDrivers = [ "amdgpu" ];
  };

  # Enable Podman
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
      dockerSocket.enable = true;
      extraPackages = [ ];
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  # Enable gamemode for performance optimizations during gaming
  programs.gamemode.enable = true;

  # Configure systemd for container support
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  # Allow unprivileged ports binding for containers
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 0;
    "kernel.cgroup_enable_nesting" = 1;
  };
}
