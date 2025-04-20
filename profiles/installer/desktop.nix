{
  pkgs,
  modulesPath,
  username,
  ...
}:
let
  # --- KDE specific packages ---
  kdePackages = [
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
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares.nix"
  ];

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
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };

    autoLogin = {
      enable = true; # Enable auto-login
      user = username; # Auto-login for the Live ISO user
    };
  };

  services.desktopManager.plasma6.enable = true; # Enable KDE Plasma 6

  environment.systemPackages = kdePackages; # Add KDE specific packages
  # Exclude unwanted packages from the default Plasma 6 installation and global excludes
  environment.plasma6.excludePackages = kdeExcludePackages ++ globalExcludePackages;

  # Power management for KDE
  services.power-profiles-daemon.enable = true;

  # INSTALLER
  system.activationScripts.installerDesktop =
    let

      # Comes from documentation.nix when xserver and nixos.enable are true.
      manualDesktopFile = "/run/current-system/sw/share/applications/nixos-manual.desktop";

      homeDir = "/home/${username}/";
      desktopDir = homeDir + "Desktop/";

    in
    ''
      mkdir -p ${desktopDir}
      chown nixos ${homeDir} ${desktopDir}

      ln -sfT ${manualDesktopFile} ${desktopDir + "nixos-manual.desktop"}
      ln -sfT ${pkgs.gparted}/share/applications/gparted.desktop ${desktopDir + "gparted.desktop"}
      ln -sfT ${pkgs.calamares-nixos}/share/applications/io.calamares.calamares.desktop ${
        desktopDir + "io.calamares.calamares.desktop"
      }
    '';

}
