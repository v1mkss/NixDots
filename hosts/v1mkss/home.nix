{
  username,
  ...
}:
{
  imports = [
    ../../profiles/desktop/home
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
        key = "3325BAABB555B6DF";
        signByDefault = true;
      };
    };
  };
}
