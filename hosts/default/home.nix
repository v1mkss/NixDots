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
      userName = "Volodia Kraplich";
      userEmail = "v1mkss.m+git@gmail.com";

      signing = {
        key = "040CB8687767955A";
        signByDefault = true;
      };
    };
  };
}
