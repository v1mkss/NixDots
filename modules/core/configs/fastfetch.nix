{ ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
        padding = {
          top = 1;
        };
      };
      display = {
        separator = "  ";
      };
      modules = [
        {
          type = "break";
        }
        {
          type = "title";
        }
        {
          type = "os";
          key = "OS    ";
          keyColor = "33";
        }
        {
          type = "kernel";
          key = "KERNEL";
          keyColor = "33";
        }
        {
          type = "host";
          format = "{5} {1}";
          key = "HOST  ";
          keyColor = "33";
        }
        {
          type = "packages";
          format = "{}";
          key = "PKGS  ";
          keyColor = "33";
        }
        {
          type = "uptime";
          format = "{2}h {3}m";
          key = "UPTIME";
          keyColor = "33";
        }
        {
          type = "memory";
          key = "RAM";
          keyColor = "33";
        }
        {
          type = "break";
        }
      ];
    };
  };
}
