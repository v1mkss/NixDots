{pkgs, ...}: {
  home.packages = with pkgs; [
    nil
    nixd
    nixfmt-rfc-style
  ];
}