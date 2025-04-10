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
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      # Function to generate a NixOS configuration for a given host
      mkNixosSystem = { hostname, username ? hostname, system ? "x86_64-linux", desktopEnv ? "kde" }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs hostname username desktopEnv;
          };
          modules = [
            # Import host-specific configuration
            ./hosts/${hostname}/configuration.nix

            # Import home-manager module
            home-manager.nixosModules.home-manager
            {
              # Global Nixpkgs settings
              nixpkgs.config = {
                allowUnfree = true;
                android_sdk.accept_license = true;
              };

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
                   inherit inputs hostname username desktopEnv;
                };
                # Configure the user specified for this host
                users.${username} = import ./hosts/${hostname}/home.nix;
              };
            }
          ];
        };

      # Define hosts and their configurations
      hostConfigurations = {
        # Default user for v1mkss host
        v1mkss = mkNixosSystem { hostname = "v1mkss"; username = "v1mkss"; desktopEnv = "kde"; };
      };
    in
  {
      nixosConfigurations = hostConfigurations;
  };
}
