{
  username,
  ...
}:
{
  imports = [
    ../../modules/home/packages.nix
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  programs = {
    home-manager.enable = true;

    git = {
      # Basic configuration
      userName = "Volodia Kraplich";
      userEmail = "v1mkss.m+git@gmail.com";

      signing = {
        key = "78AFBBDECD279E2E";
        signByDefault = true;
      };
    };
  };
}
