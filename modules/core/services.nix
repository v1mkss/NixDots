{ ... }:
{
  # General system services
  services = {
    # Printing
    printing.enable = true;

    # Periodic SSD trim
    fstrim.enable = true;

    # Smart card service
    pcscd.enable = true;

    # Journald limit settings
    journald.extraConfig = "SystemMaxUse=50M";
  };

  # Allow deletion of old Nix generations
  nix.gc = {
    automatic = true; # Automatically run GC
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Nix settings
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true; # Automatically optimize Nix store
}
