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
      "amd_pstate=passive" # AMD CPU power management
      "amdgpu.ppfeaturemask=0xffffffff" # AMD GPU power management
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
