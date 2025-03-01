{ pkgs, ... }:
{
  # Kernel and boot configuration
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ ];

  # Hardware configuration
  hardware = {
    cpu.amd.updateMicrocode = true;
    amdgpu.opencl.enable = true;

    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        vulkan-tools
        rocmPackages.rocminfo
        rocmPackages.rocm-runtime
      ];
    };
  };

  # Some programs hard-code the path to HIP:
  systemd.tmpfiles.rules = [
    "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];
}
