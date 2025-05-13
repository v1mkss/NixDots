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
        vulkan-loader
        amdvlk
        # OpenCL support
        mesa.opencl
        # VA-API (Video Acceleration) support
        libva
        libva-utils
        libvdpau-va-gl
      ];
    };

    # Bluetooth
    bluetooth.enable = true;
  };

  # --- Environment Variables for Graphics ---
  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "va_gl";
    AMD_VULKAN_ICD = "RADV";
  };
}
