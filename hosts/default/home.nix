{
  username,
  nixstateVersion,
  ...
}:
{
  imports = [
    ../../modules/core/configs
    ../../modules/desktop
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = nixstateVersion;


    # nix-shell configuration
    file.".config/nixpkgs/config.nix".text = ''{ allowUnfree = true; }'';
  };

  programs = {
    home-manager.enable = true;

    git = {
      # Basic configuration
      userName = "Kraplich Volodia";
      userEmail = "v1mkss.m+git@gmail.com";

      signing = {
        key = "7C3F49C8042B171E";
        signByDefault = true;
      };
    };
  };
}
