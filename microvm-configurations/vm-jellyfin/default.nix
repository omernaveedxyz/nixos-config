{ relativeToRoot, ... }:
{
  imports = [
    (relativeToRoot "microvm-modules")

    ./common/hardware/mounts
    ./common/hardware/wireguard

    ./common/services/jellyfin
    ./common/services/prowlarr
    ./common/services/qbittorrent
    ./common/services/radarr
    ./common/services/sabnzbd
    ./common/services/sonarr
  ];
}
