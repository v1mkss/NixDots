{ pkgs, username, ... }: {
  users.mutableUsers = true;

  users = {
    users.${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
      shell = pkgs.fish;
    };
  };

  security.sudo.wheelNeedsPassword = true;
  programs.fish.enable = true;
}
