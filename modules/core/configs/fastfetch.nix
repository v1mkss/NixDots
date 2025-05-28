{ ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
        height = 18;
        padding = {
          top = 1;
        };
      };
      display = {
        separator = " ";
      };
      modules = [
        "break"
        {
          type = "title";
          keyWidth = 10;
        }
        {
          type = "os";
          key = "OS:";
          keyColor = "33";
        }
        {
          type = "kernel";
          key = "KERNEL:";
          keyColor = "33";
        }
        {
          type = "host";
          format = "{5} {1}";
          key = "HOST:";
          keyColor = "33";
        }
        {
          type = "packages";
          format = "{}";
          key = "PKGS:";
          keyColor = "33";
        }
        {
          type = "uptime";
          format = "{2}h {3}m";
          key = "UPTIME:";
          keyColor = "33";
        }
        {
          type = "memory";
          key = "RAM:";
          keyColor = "33";
        }
        {
          type = "custom";
          format = "\u001b[90m  \u001b[31m  \u001b[32m  \u001b[33m  \u001b[34m  \u001b[35m  \u001b[36m  \u001b[37m";
        }
        "break"
      ];
    };
  };
}
