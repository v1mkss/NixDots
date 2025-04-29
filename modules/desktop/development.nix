{ pkgs, ... }:

let
# --- General Purpose Development Tools ---
developmentTools = with pkgs; [
  vscode-fhs # Visual Studio Code
  zed-editor-fhs # Zed Editor
  lazygit # Terminal UI for git
];
in
{
# Install packages into the user profile
home.packages = developmentTools;
}
