{
  lib,
  pkgs,
  desktopEnv,
  ...
}:
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
    papirus-icon-theme # Icon theme

    # KDE Integration and Utilities
    pkgs.kdePackages.sddm-kcm # SDDM configuration
    pkgs.kdePackages.powerdevil # KDE power management
    # pkgs.kdePackages.kdialog # File dialogs for non-KDE apps

    # Add tlpui for a graphical interface to TLP if desired
    # tlpui
  ];

  # --- Packages to exclude globally ---
  globalExcludePackages = with pkgs; [
    nixos-render-docs
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
    seahorse
    totem
    yelp
  ]; # ++ (with pkgs.gnome; []);

  # --- Packages to exclude from KDE ---
  kdeExcludePackages = with pkgs.kdePackages; [
    baloo
    elisa
    kate
    khelpcenter
    konsole
    xwaylandvideobridge
  ];

in
{
  config = lib.mkMerge [
    # --- Basic X-server/Wayland settings ---
    {
      services.xserver.enable = true;
      services.xserver.excludePackages = with pkgs; [ xterm ];
      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };
    }

    # --- Configuration for GNOME ---
    (lib.mkIf (desktopEnvironment == "gnome") {
      services.xserver = {
        displayManager.gdm.enable = true;
        displayManager.gdm.wayland = true;
        desktopManager.gnome.enable = true;
      };
      environment.systemPackages = gnomePackages;
      environment.gnome.excludePackages = gnomeExcludePackages ++ globalExcludePackages;
      # services.gnome.core-utilities.enable = true; # Enables basic utilities, might be useful

      # Power management for GNOME
      services.power-profiles-daemon.enable = true;
      services.tlp.enable = false;
      services.upower.enable = false;
    })

    # --- Configuration for KDE Plasma ---
    (lib.mkIf (desktopEnvironment == "kde") {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
      services.desktopManager.plasma6.enable = true;

      environment.systemPackages = kdePackages;
      environment.plasma6.excludePackages = kdeExcludePackages ++ globalExcludePackages;

      # Power management for KDE
      services.power-profiles-daemon.enable = true;
      services.tlp = {
        enable = false;
        settings = {
          # --- General ---
          TLP_ENABLE = 1;
          # Set to 0 to disable TLP temporarily
          TLP_DEFAULT_MODE = "AC";

          # --- Battery Charge Thresholds ---
          START_CHARGE_THRESH_BAT0 = 85;
          STOP_CHARGE_THRESH_BAT0 = 91;


          # --- CPU Performance Scaling ---
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          # --- CPU Boosting ---
          # Disable boost on battery to save power
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;
          # SCHED_POWERSAVE_ON_AC = 0; # Less aggressive scheduling on AC (default for performance governor)
          # SCHED_POWERSAVE_ON_BAT = 1; # More aggressive scheduling on BAT (default for powersave governor)


          # --- Graphics ---
          RADEON_POWER_PROFILE_ON_AC = "high"; # Prioritize performance on AC
          RADEON_POWER_PROFILE_ON_BAT = "low";  # Prioritize battery saving on BAT

          # Controls the dynamic power management performance level hint.
          RADEON_DPM_PERF_LEVEL_ON_AC = "high"; # Use high performance state on AC ('auto' is safer)
          RADEON_DPM_PERF_LEVEL_ON_BAT = "low"; # Use low power state on BAT ('auto' is safer)

          # --- WiFi Power Saving ---
          WIFI_PWR_ON_AC = "off"; # Disable power saving on AC
          WIFI_PWR_ON_BAT = "on"; # Enable power saving on BAT

          # --- Audio Power Saving ---
          SOUND_POWER_SAVE_ON_AC = 0; # Disable on AC
          SOUND_POWER_SAVE_ON_BAT = 1; # Enable on BAT
          SOUND_POWER_SAVE_CONTROLLER = "Y"; # Automatically enable controller power save

          # --- USB ---
          # Disable USB autosuspend on AC for device compatibility/performance
          USB_AUTOSUSPEND = 1; # Master switch for USB autosuspend feature
          USB_AUTOSUSPEND_ON_AC = 0; # Disable autosuspend when on AC power
          USB_AUTOSUSPEND_ON_BAT = 1; # Enable autosuspend when on battery power
          # You might need to blacklist specific devices if they misbehave with autosuspend:
          # USB_BLACKLIST="1234:5678 ..."

          # --- PCIe Runtime Power Management ---
          # RUNTIME_PM_ON_AC = "auto"; # Allow PCIe devices to sleep on AC if idle
          # RUNTIME_PM_ON_BAT = "auto"; # Allow PCIe devices to sleep on battery
          # Runtime PM Blacklist if needed for specific devices:
          # RUNTIME_PM_BLACKLIST="01:00.0 02:00.0" # Example PCI IDs (find with lspci)
        };
      };
    })
  ];
}
