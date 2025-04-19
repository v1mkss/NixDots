{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zulu21
    gradle
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.zulu21}";
  };
}
