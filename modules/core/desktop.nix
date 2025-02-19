{ lib, pkgs, ... }:
let
  desktopEnvironment = "gnome"; # "gnome" or "kde"

  # Common packages
  commonPackages = with pkgs; [
    git
    wget
    gnupg
    pinentry
    pinentry-gnome3
  ];

  # GNOME packages
  gnomePackages = with pkgs; [
    gnome-tweaks
    gnome-extension-manager
  ];

  # KDE packages
  kdePackages = with pkgs; [
    ghostty
    # libsForQt5.yakuake
    # libsForQt5.qtstyleplugin-kvantum
  ];

  # Packages to exclude
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
  ]; #++ (with pkgs.gnome; []);

  kdeExcludePackages = with pkgs; [] ++ (with pkgs.kdePackages; [
    elisa
    kate
    khelpcenter
    konsole
    kwallet
    kwalletmanager
  ]);
in
{
  config = lib.mkMerge [
    {
      # Display manager and desktop environment settings
      services = {
        xserver = {
          enable = true;
          excludePackages = with pkgs; [ xterm ];

          displayManager.gdm = {
            enable = desktopEnvironment == "gnome";
            wayland = true;
          };

          desktopManager.gnome = {
            enable = desktopEnvironment == "gnome";
          };
        };

        displayManager.sddm = {
          enable = desktopEnvironment == "kde";
          wayland.enable = true;
        };

        desktopManager.plasma6 = {
          enable = desktopEnvironment == "kde";
        };

      };

      # Installing packages depending on DE
      environment.systemPackages = commonPackages ++
        (if desktopEnvironment == "gnome"
         then gnomePackages
         else if desktopEnvironment == "kde"
         then kdePackages
         else []);
    }

    (lib.mkIf (desktopEnvironment == "gnome") {
      environment.gnome.excludePackages = gnomeExcludePackages;
      services.gnome.core-utilities.enable = true;

      # GNOME Power Management
      services.power-profiles-daemon.enable = true;
      services.tlp.enable = false;
    })

    (lib.mkIf (desktopEnvironment == "kde") {
      environment.plasma6.excludePackages = kdeExcludePackages;

      # KDE Power Management
      services.power-profiles-daemon.enable = true;
      services.tlp.enable = false;
    })
  ];
}
