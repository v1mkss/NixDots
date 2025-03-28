{ lib, pkgs, ... }:
let
  # Path to the directory with modprobe configurations
  modprobeDir = ./modprobe.d;

  # Get the list of file names in the directory
  modprobeFiles = builtins.attrNames (builtins.readDir modprobeDir);

  # Filter only files ending with .conf
  confFiles = lib.filter (name: lib.hasSuffix ".conf" name) modprobeFiles;

  # Read the content of each .conf file and concatenate them
  modprobeConfigContent = lib.concatMapStringsSep "\n"
    (name: builtins.readFile (modprobeDir + "/${name}"))
    confFiles;
in
{
  # Include configurations from ./modprobe.d/
  boot.extraModprobeConfig = modprobeConfigContent;

  # Hardware configuration
  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;

    # Graphics configuration
    graphics = {
      enable = true;
      enable32Bit = true; # For Steam/Wine
      extraPackages = with pkgs; [
        # Main drivers
        mesa
        # Vulkan tools
        vulkan-loader
        vulkan-validation-layers
        # OpenCL
        mesa.opencl
        # rocm-opencl-icd # If ROCm OpenCL is needed (for computations)
        # VA-API (Video Acceleration API)
        libva
        libva-utils # For vainfo tool
        libvdpau-va-gl # VDPAU backend using VA-API
      ];

      extraPackages32 = with pkgs; [
        driversi686Linux.mesa
      ];
    };

    # Bluetooth
    bluetooth.enable = true;
  };

  # Environment variables for graphics
  environment.variables = {
    RUSTICL_ENABLE = "radeonsi"; # Use Mesa OpenCL implementation (Rusticl)
    VDPAU_DRIVER = "radeonsi";
    LIBVA_DRIVER_NAME = "radeonsi";

    # Explicitly tell the Vulkan loader to only use the RADV driver (64-bit and 32-bit).
    VK_ICD_FILENAMES = lib.concatStringsSep ":" [
      "${pkgs.mesa}/share/vulkan/icd.d/radeon_icd.x86_64.json"
      "${pkgs.driversi686Linux.mesa}/share/vulkan/icd.d/radeon_icd.i686.json"
    ];

    # Explicitly tell GLVND where to find EGL vendor libraries (64-bit and 32-bit).
    __EGL_VENDOR_LIBRARY_FILENAMES = lib.concatStringsSep ":" [
      "${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json"
      "${pkgs.driversi686Linux.mesa}/share/glvnd/egl_vendor.d/50_mesa.json"
    ];
  };
}
