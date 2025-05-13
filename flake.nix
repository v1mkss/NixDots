{
  description = "NixOS configuration by Volodia Kraplich(v1mkss)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xmcl-nix = {
      url = "github:v1mkss/XMCL-Nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;

      # Define parameters for each host configuration
      hostDefinitions = {
        default = {
          hostname = "v1mkss";
          username = "v1mkss";
          system = "x86_64-linux";
        };
      };

      mkNixosSystem =
        configName:
        {
          hostname,
          username ? hostname,
          system ? "x86_64-linux",
          nixstateVersion ? "25.05",
          ...
        }:
        lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              hostname
              username
              nixstateVersion
              configName
              ;
          };
          modules = [
            # Import host-specific system configuration
            ./hosts/${configName}/configuration.nix

            # Import the home-manager module
            home-manager.nixosModules.home-manager
            {
              # Global Nixpkgs settings
              nixpkgs.config.allowUnfree = true;

              # Nix settings
              nix.settings.experimental-features = [
                "nix-command"
                "flakes"
              ];

              # Home Manager configuration
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit
                    inputs
                    hostname
                    username
                    nixstateVersion
                    configName
                    ;
                };
                # Configure the user for this host
                users.${username} = import ./hosts/${configName}/home.nix;
              };
            }
          ];
        };

    in
    {
      # Generate nixosConfigurations by applying mkNixosSystem to each entry in hostDefinitions
      nixosConfigurations = lib.mapAttrs mkNixosSystem hostDefinitions;

      devShells = lib.genAttrs ["x86_64-linux"] (system: {
        default = import ./nix/develop.nix { pkgs = import nixpkgs { inherit system; }; };
      });
    };
}
