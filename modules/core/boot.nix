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
    kernelParams = [
        "zswap.enabled=1" # enables zswap
        "zswap.compressor=zstd" # compression algorithm
      ];

  };

  # Swap configuration using zram
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
