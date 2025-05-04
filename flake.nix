{
  description = "Linux configuration by Volodia Kraplich (v1mkss)";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
    };
  };

  outputs =
    { home-manager, ... }:
    {
      homeConfigurations = {
        default = home-manager.lib.homeManagerConfiguration {
          pkgs = import home-manager.inputs.nixpkgs {
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
            };
          };
          
          modules = [
            {
              # Home Manager global options
              home = {
                username = "v1mkss";
                homeDirectory = "/home/v1mkss";
                stateVersion = "25.05";
                enableNixpkgsReleaseCheck = false;
              };
            }
            ./core/home.nix
          ];
        };
      };
    };
}
