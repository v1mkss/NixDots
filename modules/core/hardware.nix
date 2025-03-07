{ pkgs, ... }:
{
  # Kernel and boot configuration
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "amdgpu" ];

  # Hardware configuration
  hardware = {
    cpu.amd.updateMicrocode = true;

    # Graphics configuration
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        mesa.opencl
        vulkan-loader
        vulkan-validation-layers

        libva
        libvdpau-va-gl
      ];
    };

    bluetooth.enable = true;
  };

  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
    vulkan-tools
    clinfo
    glxinfo
  ];

  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
    RUSTICL_ENABLE = "radeonsi";
  };

}
