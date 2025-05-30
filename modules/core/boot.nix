{ pkgs, ... }:
{
  # Kernel and boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_zen;
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
