{
  pkgs,
  username,
  ...
}:
{
  # Install container management tools
  home.packages = with pkgs; [
    distrobox
  ];

  # Configure container settings
  home.file.".config/containers/containers.conf".text = ''
    [containers]
    netns = "bridge"
    userns = "host"

    [engine]
    runtime = "runc"
    cgroup_manager = "systemd"
    events_logger = "file"
  '';

  home.file.".config/containers/storage.conf".text = ''
    [storage]
    driver = "overlay"
    graphroot = "/home/${username}/.local/share/containers/storage"
    runroot = "/home/${username}/.local/share/containers/storage/run"

    [storage.options.overlay]
    mount_program = "${pkgs.fuse-overlayfs}/bin/fuse-overlayfs"
    mountopt = "nodev"
  '';
}
