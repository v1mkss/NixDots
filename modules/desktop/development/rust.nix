{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustc # Rust compiler
    cargo # Rust package manager/build tool
  ];
}
