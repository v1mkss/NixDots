{
  pkgs,
  ...
}:
let
  # --- KDE specific packages ---
  kdePackages = with pkgs; [
    whitesur-icon-theme # Icon theme
    pkgs.kdePackages.sddm-kcm # KDE SDDM configuration module
    # pkgs.kdePackages.kdialog # File dialogs for non-KDE apps
  ];

  # --- Packages to exclude globally ---
  globalExcludePackages = with pkgs; [
    nixos-render-docs
  ];

  # --- Packages to exclude from KDE ---
  kdeExcludePackages = with pkgs.kdePackages; [
    baloo # Disable file indexing if not needed
    elisa # KDE music player
    kate # KDE text editor
    khelpcenter # KDE help center
    konsole # KDE terminal emulator
    xwaylandvideobridge # Component for screen recording in XWayland
    discover # Software center
    drkonqi # Crash handler
    oxygen # Old theme
    breeze-gtk # GTK theme
    kdeconnect-kde # KDE Connectz
  ];

in
{
  # --- Basic X-server/Wayland settings ---
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [ xterm ];
  };

  # --- Configuration for KDE Plasma ---
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true; # Enable KDE Plasma 6

  environment.systemPackages = kdePackages; # Add KDE specific packages
  # Exclude unwanted packages from the default Plasma 6 installation and global excludes
  environment.plasma6.excludePackages = kdeExcludePackages ++ globalExcludePackages;

  # Power management for KDE
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      TLP_ENABLE = 1;
      TLP_DEFAULT_MODE = "BAT"; # Prioritize battery savings

      # Battery charge thresholds
      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 91;

      # CPU scaling governors (optimized for Zen kernel)
      CPU_SCALING_GOVERNOR_ON_AC = "performance"; # Max performance on AC
      CPU_SCALING_GOVERNOR_ON_BAT = "schedutil"; # Better for Zen kernel on battery

      # CPU energy performance policy
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power"; # Aggressive power saving

      # CPU boost control
      CPU_BOOST_ON_AC = 1; # Enable boost on AC
      CPU_BOOST_ON_BAT = 0; # Disable boost on battery

      # Platform profile for AMD APU
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # Power management for amdgpu iGPU
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";

      # Enable power-saving features for iGPU
      RUNTIME_PM_DRIVER_BLACKLIST = ""; # Ensure amdgpu is not blacklisted
    };
  };
  powerManagement.enable = true;
}
