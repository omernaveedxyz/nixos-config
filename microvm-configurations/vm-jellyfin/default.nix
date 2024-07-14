{ relativeToRoot, ... }:
{
  imports = [
    (relativeToRoot "microvm-modules")

    ./hardware/mounts
    ./hardware/wireguard

    ./services/jellyfin
    ./services/prowlarr
    ./services/qbittorrent
    ./services/radarr
    ./services/sabnzbd
    ./services/sonarr
  ];
}
