{ lib, pkgs, ... }:
let
  davinci-resolve-studio =
    let
      davinci-patched = pkgs.davinci-resolve-studio.davinci.overrideAttrs (old: {
        postInstall = ''
          ${old.postInstall or ""}
          ${lib.getExe pkgs.perl} -pi -e 's/\x74\x11\xe8\x21\x23\x00\x00/\xeb\x11\xe8\x21\x23\x00\x00/g' $out/bin/resolve
        '';
      });
    in
    pkgs.buildFHSEnv {
      inherit (davinci-patched) pname version;

      targetPkgs =
        pkgs:
        with pkgs;
        [
          alsa-lib
          aprutil
          bzip2
          dbus
          expat
          fontconfig
          freetype
          glib
          libGL
          libGLU
          libarchive
          libcap
          librsvg
          libtool
          libuuid
          libxcrypt # provides libcrypt.so.1
          libxkbcommon
          nspr
          ocl-icd
          opencl-headers
          python3
          python3.pkgs.numpy
          udev
          xdg-utils # xdg-open needed to open URLs
          xorg.libICE
          xorg.libSM
          xorg.libX11
          xorg.libXcomposite
          xorg.libXcursor
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXi
          xorg.libXinerama
          xorg.libXrandr
          xorg.libXrender
          xorg.libXt
          xorg.libXtst
          xorg.libXxf86vm
          xorg.libxcb
          xorg.xcbutil
          xorg.xcbutilimage
          xorg.xcbutilkeysyms
          xorg.xcbutilrenderutil
          xorg.xcbutilwm
          xorg.xkeyboardconfig
          zlib
        ]
        ++ [ davinci-patched ];

      extraPreBwrapCmds = ''
        mkdir -p ~/.local/share/DaVinciResolve/license || exit 1
      '';

      extraBwrapArgs = [
        "--bind \"$HOME\"/.local/share/DaVinciResolve/license ${davinci-patched}/.license"
      ];

      runScript = "${pkgs.bash}/bin/bash ${pkgs.writeText "davinci-wrapper" ''
        export QT_XKB_CONFIG_ROOT="${pkgs.xkeyboard_config}/share/X11/xkb"
        export QT_PLUGIN_PATH="${davinci-patched}/libs/plugins:$QT_PLUGIN_PATH"
        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/lib32:${davinci-patched}/libs
        ${davinci-patched}/bin/resolve
      ''}";

      extraInstallCommands = ''
        mkdir -p $out/share/applications $out/share/icons/hicolor/128x128/apps
        ln -s ${davinci-patched}/share/applications/*.desktop $out/share/applications/
        ln -s ${davinci-patched}/graphics/DV_Resolve.png $out/share/icons/hicolor/128x128/apps/davinci-resolve-studio.png
      '';
    };
in
{
  home.packages = [ davinci-resolve-studio ];
}
