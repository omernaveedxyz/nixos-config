#!/usr/bin/env bash

update_sabnzbd_config() {
  sudo sed -i 's/host = .*/host = 0.0.0.0/' /var/lib/microvms/vm-jellyfin/persistent/var/lib/sabnzbd/sabnzbd.ini
  sudo sed -i 's/host_whitelist = .*/host_whitelist = sabnzbd.omernaveed.dev/' /var/lib/microvms/vm-jellyfin/persistent/var/lib/sabnzbd/sabnzbd.ini
  sudo systemctl restart microvm@vm-jellyfin
}

set_download_folder_permissions() {
  sudo mkdir -p "/var/lib/microvms/vm-jellyfin/persistent/var/lib/$1"
  sudo chown -R "$2:$2" "/var/lib/microvms/vm-jellyfin/persistent/var/lib/$1"
  sudo chmod -R 0775 "/var/lib/microvms/vm-jellyfin/persistent/var/lib/$1"
  sudo setfacl -R -d -m u::rwx,g::rwx,o::rx "/var/lib/microvms/vm-jellyfin/persistent/var/lib/$1"
  sudo chmod -R g+s "/var/lib/microvms/vm-jellyfin/persistent/var/lib/$1"
}

create_folder() {
  sudo mkdir -p "/mnt/media/$1"
  sudo chown -R "$2:$2" "/mnt/media/$1"
  sudo chmod -R 0775 "/mnt/media/$1"
  sudo setfacl -R -d -m u::rwx,g::rwx,o::rx "/mnt/media/$1"
  sudo chmod -R g+s "/mnt/media/$1"
}

update_sabnzbd_config

set_download_folder_permissions "sabnzbd/Downloads" "sabnzbd"
set_download_folder_permissions "qBittorrent/qBittorrent/downloads" "qbittorrent"

create_folder "Shows" "274"
create_folder "Movies" "275"
