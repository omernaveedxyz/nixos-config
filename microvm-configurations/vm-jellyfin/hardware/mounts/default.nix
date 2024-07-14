{
  # Shared directory trees
  microvm.shares = [
    {
      # Protocol for this share
      proto = "virtiofs";

      # Unique virtiofs daemon tag
      tag = "media";

      # Path to shared directory tree
      source = "/mnt/media";

      # Where to mount the share inside the container
      mountPoint = "/mnt/media";
    }
  ];
}
