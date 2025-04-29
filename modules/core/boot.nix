{ pkgs, ... }:
{
  # Kernel and boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "zswap.enabled=1" # Enable zswap
    ];
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ "amdgpu" ];
  };

  # Swap configuration using zram
  zramSwap = {
    enable = true;
    algorithm = "zstd lz4";
    memoryPercent = 50;
  };
}
