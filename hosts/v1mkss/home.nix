{
  username,
  nixstateVersion,
  ...
}:
{
  imports = [
    ../../profiles/desktop/home
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = nixstateVersion;
  };

  programs = {
    home-manager.enable = true;

    git = {
      # Basic configuration
      userName = "Volodia Kraplich";
      userEmail = "v1mkss.m+git@gmail.com";

      signing = {
        key = "D4B9586507C7C61B";
        signByDefault = true;
      };
    };
  };
}
