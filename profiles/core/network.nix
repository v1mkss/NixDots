{ ... }:
{
  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable Firewall
  networking.firewall.enable = false;
}
