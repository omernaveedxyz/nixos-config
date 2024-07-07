{ relativeToRoot, ... }:
{
  imports = [
    (relativeToRoot "microvm-modules")

    ./hardware/wireguard

    ./services/xmrig
  ];
}
