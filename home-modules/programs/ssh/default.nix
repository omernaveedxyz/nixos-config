{ lib, relativeToRoot, ... }:
let
  inherit (builtins) readDir;
  inherit (lib) listToAttrs attrNames;
in
{
  programs.ssh = {
    # Whether to enable SSH client configuration
    enable = true;

    # Specify per-host settings
    matchBlocks = listToAttrs (
      map (host: {
        name = host;
        value = {
          # Whether the connection to the authentication agent (if any) will be forwarded to the remote machine
          forwardAgent = true;

          # Specify remote port forwardings
          remoteForwards = [
            {
              bind.address = "/run/user/1000/gnupg/S.gpg-agent";
              host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
            }
          ];
        };
      }) (attrNames (readDir (relativeToRoot "nixos-configurations")))
    );
  };
}
