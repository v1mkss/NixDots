{
  pkgs,
  ...
}: {
  # Install container management tools
  home.packages = with pkgs; [
    distrobox
    podman-compose
    fuse-overlayfs
  ];

  # Configure container settings
  home.file.".config/containers/containers.conf".text = ''
    [containers]
    pids_limit = 0
    netns = "bridge"
    userns = "host"
    cgroups = "enabled"
    log_driver = "k8s-file"
    
    [engine]
    cgroup_manager = "systemd"
    events_logger = "file"
    runtime = "crun"
  '';

  home.file.".config/containers/storage.conf".text = ''
    [storage]
    driver = "overlay"
    
    [storage.options]
    mount_program = "${pkgs.fuse-overlayfs}/bin/fuse-overlayfs"
    
    [storage.options.overlay]
    mount_program = "${pkgs.fuse-overlayfs}/bin/fuse-overlayfs"
  '';
}