{ relativeToRoot, ... }:
{
  imports = [
    (relativeToRoot "microvm-modules")

    ./common/hardware/wireguard

    ./common/services/xmrig
  ];
}
