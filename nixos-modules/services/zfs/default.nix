{
  # Whether to enable periodic scrubbing of ZFS pools
  services.zfs.autoScrub.enable = true;

  # Whether to enable period TRIM on all ZFS pools
  services.zfs.trim.enable = true;
}
