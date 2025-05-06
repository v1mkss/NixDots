{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  # Nix Language Server
  # Provides language server and formatting tools for Nix development
  buildInputs =  with pkgs;[
    nil            # Nix LSP
    nixd           # Alternative Nix LSP
    nixfmt-rfc-style # Nix formatter
  ];
}