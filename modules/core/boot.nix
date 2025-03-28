{ pkgs, ... }:
{
  # Kernel and boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = ["zswap.enabled=1"];
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ "amdgpu" ];

    # extraModprobeConfig = builtins.readFile ./modprobe.d/amdgpu.conf;
  };

  #Swap
  zramSwap = {
     enable = true;
     algorithm = "zstd lz4";
     memoryPercent = 30;
  };
}
