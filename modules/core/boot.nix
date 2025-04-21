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
      "zswap.enabled=1"
      "amd_pstate=passive"
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
