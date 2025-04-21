{ lib, pkgs, ... }:

let
  # --- modprobe.d Configuration ---
  modprobeDir = ./modprobe.d;
  modprobeDirExists = builtins.pathExists modprobeDir;

  # Read .conf files only if the directory exists
  modprobeConfigContent = lib.mkIf modprobeDirExists (
    let
      modprobeFiles = builtins.attrNames (builtins.readDir modprobeDir);
      confFiles = lib.filter (name: lib.hasSuffix ".conf" name) modprobeFiles;
      # Sort files for deterministic order
      sortedConfFiles = lib.sort lib.lessThan confFiles;
    in
    lib.concatMapStringsSep "\n" (name: builtins.readFile (modprobeDir + "/${name}")) sortedConfFiles # Use sorted files
  );

in
{
  # Include configurations from ./modprobe.d/ if the directory exists and has content
  boot.extraModprobeConfig = lib.mkIf (
    modprobeDirExists && modprobeConfigContent != ""
  ) modprobeConfigContent;

  # --- Hardware Configuration ---
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault true;
    enableRedistributableFirmware = lib.mkDefault true;

    # Graphics configuration
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vulkan-validation-layers
        # OpenCL support
        mesa.opencl
        # VA-API (Video Acceleration) support
        libva
        libva-utils # For vainfo tool
        # VDPAU backend using VA-API
        libvdpau-va-gl
      ];
      # Add 32-bit Mesa drivers
      extraPackages32 = with pkgs; [
        driversi686Linux.mesa
      ];
    };

    # Bluetooth
    bluetooth.enable = true;
  };

  # --- Environment Variables for Graphics ---
  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
    LIBVA_DRIVER_NAME = "radeonsi";

    # Explicitly tell the Vulkan loader where to find ICD files.
    VK_ICD_FILENAMES = lib.concatStringsSep ":" [
      "${pkgs.mesa}/share/vulkan/icd.d/radeon_icd.x86_64.json" # Mesa RADV 64-bit
      "${pkgs.driversi686Linux.mesa}/share/vulkan/icd.d/radeon_icd.i686.json" # Mesa RADV 32-bit
    ];

    # Explicitly tell GLVND where to find EGL vendor libraries.
    __EGL_VENDOR_LIBRARY_FILENAMES = lib.concatStringsSep ":" [
      "${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json" # Mesa EGL 64-bit
      "${pkgs.driversi686Linux.mesa}/share/glvnd/egl_vendor.d/50_mesa.json" # Mesa EGL 32-bit
    ];
  };

  # --- Ananicy Service ---
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-rules-cachyos;
  };
}
