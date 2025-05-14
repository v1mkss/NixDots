{ pkgs, ... }:

let
  # --- General Purpose Development Tools ---
  developmentTools = with pkgs; [
    zed-editor-fhs # Code editor
    lazygit # Terminal UI for git
  ];
in
{
  # Install packages into the user profile
  home.packages = developmentTools;
}
