{
  username,
  nixstateVersion,
  ...
}:
{

  imports = [
    ../../modules/core/configs
    ../../modules/installer
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = nixstateVersion;

    # nix-shell configuration
    file.".config/nixpkgs/config.nix".text = ''{ allowUnfree = true; }'';
  };

  programs.home-manager.enable = true;
}
