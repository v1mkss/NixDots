{ pkgs, ... }:
{
  nix.package = pkgs.nix;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
}
