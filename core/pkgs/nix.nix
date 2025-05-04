{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nil # Nix LSP
    nixd # Alternative Nix LSP
    nixfmt-rfc-style # Nix formatter
  ];
}
