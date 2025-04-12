{ lib, pkgs, desktopEnv, ... }:
let
  # --- Variable for selecting the DE ---
  desktopEnvironment = desktopEnv;

  # --- GNOME specific packages ---
  gnomePackages = with pkgs; [
    papirus-icon-theme # Icon theme


    gnome-tweaks # GNOME tweaking tool
    gnome-extension-manager # Extension manager
  ];

  # --- KDE specific packages ---
  kdePackages = with pkgs; [
    ghostty # New GPU-accelerated terminal
    papirus-icon-theme # Icon theme

    # KDE Integration and Utilities
    pkgs.kdePackages.sddm-kcm # SDDM configuration
    pkgs.kdePackages.powerdevil # KDE power management
  ];

  # --- Packages to exclude from GNOME ---
  gnomeExcludePackages = with pkgs; [
    atomix
    epiphany
    geary
    gedit
    gnome-characters
    gnome-connections
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-photos
    gnome-terminal
    gnome-text-editor
    gnome-tour
    gnome-weather
    hitori
    iagno
    nixos-render-docs
    seahorse
    totem
    yelp
  ];# ++ (with pkgs.gnome; []);

  # --- Packages to exclude from KDE ---
  kdeExcludePackages = with pkgs; [] ++ (with pkgs.kdePackages; [
    baloo
    elisa
    kate
    khelpcenter
    konsole
  ]);

in
{
  config = lib.mkMerge [
    # --- Basic X-server/Wayland settings ---
    {
      # Base Xorg server still needed even for Wayland compositors sometimes
      services.xserver.enable = true;
      # Exclude basic xterm if not needed
      services.xserver.excludePackages = with pkgs; [ xterm ];
      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    }

    # --- Configuration for GNOME ---
    (lib.mkIf (desktopEnvironment == "gnome") {
      # GNOME still uses services.xserver for its GDM/Desktop settings
      services.xserver = {
        displayManager.gdm.enable = true;
        displayManager.gdm.wayland = true; # Wayland is enabled by default
        desktopManager.gnome.enable = true;
      };
      environment.systemPackages = gnomePackages;
      environment.gnome.excludePackages = gnomeExcludePackages;
      # services.gnome.core-utilities.enable = true; # Enables basic utilities, might be useful

      # Power management for GNOME
      services.power-profiles-daemon.enable = true;
      # Disable alternatives to avoid conflicts
      # services.tlp.enable = false;
      # services.upower.enable = false; # power-profiles-daemon provides a similar service
    })

    # --- Configuration for KDE Plasma ---
    (lib.mkIf (desktopEnvironment == "kde") {
      # KDE options moved out of services.xserver
      services.displayManager.sddm = {
         enable = true;
         wayland.enable = true; # Enable Wayland session for SDDM
      };
      services.desktopManager.plasma6.enable = true;

      environment.systemPackages = kdePackages;
      environment.plasma6.excludePackages = kdeExcludePackages;

      # Power management for KDE (uses upower)
      # services.upower.enable = true;
      # Disable alternatives
      services.power-profiles-daemon.enable = true;
      # services.tlp.enable = false;
    })
  ];
}
