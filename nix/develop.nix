{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  # Nix Language Server
  # Provides language server and formatting tools for Nix development
  buildInputs = [
    pkgs.nil            # Nix LSP
    pkgs.nixd           # Alternative Nix LSP
    pkgs.nixfmt-rfc-style # Nix formatter
  ];
}