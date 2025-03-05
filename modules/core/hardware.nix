{ pkgs, ... }:
{
  # Kernel and boot configuration
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "" ];

  # Hardware configuration
  hardware = {
    cpu.amd.updateMicrocode = true;

    # Graphics configuration
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        # Enhanced graphics stack
        mesa
        vulkan-tools

        # Specific AMD support
        rocmPackages.rocminfo
        rocmPackages.rocm-runtime

        # Additional OpenGL and Vulkan support
        libGL
        vulkan-loader
        amdvlk
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libGL
        vulkan-loader
        amdvlk
      ];
    };

    bluetooth.enable = true;
  };

  # Some programs hard-code the path to HIP:
  systemd.tmpfiles.rules = [
    "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];
}