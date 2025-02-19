{ pkgs, ... }:
{
  # Kernel and boot configuration
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "amdgpu" ];

  # Hardware configuration
  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        amdvlk
        vulkan-tools
        rocmPackages.clr.icd
        rocmPackages.clr
        rocmPackages.rocminfo
        rocmPackages.rocm-runtime
      ];
    };
  };

  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };

  # Some programs hard-code the path to HIP:
  systemd.tmpfiles.rules = [
    "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];
}
