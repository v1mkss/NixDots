{ ... }:
{
  programs.zed-editor = {
    enable = true;
    installRemoteServer = false;
    extensions = ["catppuccin" "catppuccin-icons" "nix" "toml" "make" "neocmake" "java"];

    userSettings = {
      theme = "Catppuccin Mocha";
      icon_theme = "Catppuccin Mocha";
      ui_font_size = 16;
      buffer_font_size = 16;
      tab_size = 2;

      shell = "system";
      ui_font_family = "Cascadia Code";
      buffer_font_family = "Cascadiad Code";

      assistant.enabled = true;

      assistant.default_model = {
        provider = "google";
        model = "gemini-2.0-flash";
      };

      assistant.version = "2";

      project_panel.dock = "right";
      assistant.dock = "left";

      lsp = {
        rust-analyzer = {
          binary = {
            path_lookup = true;
          };
        };
        Nix = {
          language_servers = [
            "nil"
            "!nixd"
          ];
          formatter = {
            external = {
              command = "nixfmt";
            };
          };
          nil = {
            formatting.command = "nixfmt";
          };
        };
      };
      load_direnv = "shell_hook";
    };
  };
}
