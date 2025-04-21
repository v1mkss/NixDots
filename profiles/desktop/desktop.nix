{
  pkgs,
  ...
}:
let
  # --- KDE specific packages ---
  kdePackages = with pkgs; [
    whitesur-icon-theme # Icon theme

    # KDE Integration and Utilities
    pkgs.kdePackages.sddm-kcm # SDDM configuration
    pkgs.kdePackages.powerdevil # KDE power management
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
    xwaylandvideobridge # Component for screen recording in XWayland, might be unnecessary
  ];

in
{
  # --- Basic X-server/Wayland settings ---
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [ xterm ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
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
  services.power-profiles-daemon.enable = true;

  # TLP settings (if you decide to use it instead of/in addition to power-profiles-daemon)
  # Note: power-profiles-daemon and TLP can conflict.
  # It's usually recommended to use ONLY ONE of them.
  # If power-profiles-daemon.enable = true, it's better to disable TLP (enable = false).
  # If you want to use TLP, set power-profiles-daemon.enable = false;
  services.tlp = {
    enable = false;
    settings = {
      # --- General ---
      TLP_ENABLE = 1;
      TLP_DEFAULT_MODE = "AC";

      # --- Battery Charge Thresholds (check compatibility with your laptop!) ---
      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 91;

      # --- CPU Performance Scaling ---
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power"; # or "balance_power" or "power"

      # --- CPU Boosting ---
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0; # Disable boost on battery to save power
      # SCHED_POWERSAVE_ON_BAT = 1; # More aggressive scheduling for power saving

      # --- Graphics (example for Radeon, adapt for Intel/Nvidia) ---
      RADEON_POWER_PROFILE_ON_AC = "high";
      RADEON_POWER_PROFILE_ON_BAT = "low";
      RADEON_DPM_PERF_LEVEL_ON_AC = "high";
      RADEON_DPM_PERF_LEVEL_ON_BAT = "low";

      # --- WiFi Power Saving ---
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # --- Audio Power Saving ---
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      SOUND_POWER_SAVE_CONTROLLER = "Y";

      # --- USB Autosuspend ---
      USB_AUTOSUSPEND = 1;
      USB_AUTOSUSPEND_ON_AC = 0; # Disable on AC for better compatibility
      USB_AUTOSUSPEND_ON_BAT = 1; # Enable on battery for power saving
      # USB_BLACKLIST="1234:5678"; # Add IDs of devices that don't work with autosuspend

      # --- PCIe Runtime Power Management ---
      # RUNTIME_PM_ON_AC = "auto";
      # RUNTIME_PM_ON_BAT = "auto";
      # RUNTIME_PM_BLACKLIST="01:00.0"; # Example PCI ID
    };
  };
}
