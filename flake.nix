{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      defaultUser = "v1mkss";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Function to get the list of users from /home directory
      getUsers =
        let
          readDir = dir: builtins.readDir dir;
          isDirectory = type: type == "directory";
          filterDirectories =
            dir:
            let
              contents = readDir dir;
            in
            builtins.filter (name: isDirectory contents.${name}) (builtins.attrNames contents);
        in
        if builtins.pathExists /home then filterDirectories /home else [ defaultUser ];
    in
    {
      nixosConfigurations.v1mkss = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          username = defaultUser;
        };
        modules = [
          ./hosts/v1mkss/configuration.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.permittedInsecurePackages = [
              "dotnet-sdk-6.0.428"
            ];

            nix.settings.experimental-features = [
              "nix-command"
              "flakes"
            ];

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                username = defaultUser;
                # Pass the list of users to home.nix
                users = getUsers;
              };

              users =
                let
                  homeDirUsers = getUsers;
                  # Create configuration for each user from /home
                  mkUserConfig = user: {
                    ${user} = import ./hosts/v1mkss/home.nix;
                  };
                in
                # Merge all user configurations
                builtins.foldl' (acc: user: acc // mkUserConfig user) { } homeDirUsers;
            };
          }
        ];
      };
    };
}
