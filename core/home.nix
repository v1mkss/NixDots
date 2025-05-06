{ ... }:
{
  imports = [
    ./configs
    ./pkgs
    ./optimization.nix
  ];

  home = {
    # nix-shell configuration
    file.".config/nixpkgs/config.nix".text = ''{ allowUnfree = true; }'';
  };

  programs = {
    home-manager.enable = true;

    git = {
      # Basic configuration
      userName = "Volodia Kraplich";
      userEmail = "v1mkss.m+git@gmail.com";
      signing = {
        key = "3F26710B564F4235";
        signByDefault = true;
      };
    };
  };
}