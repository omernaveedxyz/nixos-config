# HACK: https://github.com/NixOS/nixpkgs/pull/287923
{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.qbittorrent;
  inherit (builtins) concatStringsSep isAttrs isString;
  inherit (lib)
    literalExpression
    getExe
    mkEnableOption
    mkOption
    mkPackageOption
    mkIf
    maintainers
    escape
    collect
    mapAttrsRecursive
    ;
  inherit (lib.types)
    str
    port
    path
    nullOr
    unspecified
    ;
  inherit (lib.generators) toINI mkKeyValueDefault mkValueStringDefault;
  gendeepINI = toINI {
    mkKeyValue =
      let
        sep = "=";
      in
      k: v:
      if isAttrs v then
        concatStringsSep "\n" (
          collect isString (
            mapAttrsRecursive (
              path: value:
              "${escape [ sep ] (concatStringsSep "\\" ([ k ] ++ path))}${sep}${mkValueStringDefault { } value}"
            ) v
          )
        )
      else
        mkKeyValueDefault { } sep k v;
  };
in
{
  options.services.qbittorrent = {
    enable = mkEnableOption "qbittorrent, BitTorrent client";

    package = mkPackageOption pkgs "qbittorrent-nox" { };

    user = mkOption {
      type = str;
      default = "qbittorrent";
      description = "User account under which qbittorrent runs.";
    };

    group = mkOption {
      type = str;
      default = "qbittorrent";
      description = "Group under which qbittorrent runs.";
    };

    profileDir = mkOption {
      type = path;
      default = "/var/lib/qBittorrent/";
      description = "the path passed to qbittorrent via --profile.";
    };

    openFirewall = mkEnableOption "opening both the webuiPort and torrentPort over TCP in the firewall";

    webuiPort = mkOption {
      default = 8080;
      type = port;
      description = "the port passed to qbittorrent via `--webui-port`";
    };

    torrentingPort = mkOption {
      default = null;
      type = nullOr port;
      description = "the port passed to qbittorrent via `--torrenting-port`";
    };

    serverConfig = mkOption {
      default = { };
      type = unspecified;
      description = ''
        Free-form settings mapped to the `qBittorrent.conf` file in the profile.
        Refer to [Explanation-of-Options-in-qBittorrent](https://github.com/qbittorrent/qBittorrent/wiki/Explanation-of-Options-in-qBittorrent)
        the Password_PBKDF2 format is oddly unique, you will likely want to use [this tool](https://codeberg.org/feathecutie/qbittorrent_password) to generate the format.
        alternatively you can run qBittorrent independently first and use its webUI to generate the format.
      '';
      example = literalExpression ''
        {
          LegalNotice.Accepted = true;
          Preferences = {
            WebUI = {
              Username = "user";
              Password_PBKDF2 = "generated ByteArray.";
            };
            General.Locale = "en";
          };
        }
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd = {
      tmpfiles.settings = {
        qbittorrent = {
          "${cfg.profileDir}/qBittorrent/"."d" = {
            mode = "700";
            inherit (cfg) user group;
          };
          "${cfg.profileDir}/qBittorrent/config/"."d" = {
            mode = "700";
            inherit (cfg) user group;
          };
          "${cfg.profileDir}/qBittorrent/config/qBittorrent.conf"."L+" = {
            mode = "1500";
            inherit (cfg) user group;
            argument = "${pkgs.writeText "qBittorrent.conf" (gendeepINI cfg.serverConfig)}";
          };
        };
      };
      services.qbittorrent = {
        description = "qbittorrent BitTorrent client";
        wants = [ "network-online.target" ];
        after = [
          "local-fs.target"
          "network-online.target"
          "nss-lookup.target"
        ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          ExecStart = utils.escapeSystemdExecArgs (
            [
              (getExe cfg.package)
              "--profile=${cfg.profileDir}"
              "--webui-port=${toString cfg.webuiPort}"
            ]
            ++ lib.optional (cfg.torrentingPort != null) "--torrenting-port=${toString cfg.torrentingPort}"
          );
          TimeoutStopSec = 1800;

          # https://github.com/qbittorrent/qBittorrent/pull/6806#discussion_r121478661
          PrivateTmp = false;

          PrivateNetwork = false;
          RemoveIPC = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProtectHome = "yes";
          ProtectProc = "invisible";
          ProcSubset = "pid";
          ProtectSystem = "full";
          ProtectClock = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          SystemCallArchitectures = "native";
          CapabilityBoundingSet = "";
          SystemCallFilter = [ "@system-service" ];
        };
      };
    };

    users = {
      users = mkIf (cfg.user == "qbittorrent") {
        qbittorrent = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };
      groups = mkIf (cfg.group == "qbittorrent") { qbittorrent = { }; };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall (
      [ cfg.webuiPort ] ++ lib.optional (cfg.torrentingPort != null) cfg.torrentingPort
    );
  };
  meta.maintainers = with maintainers; [ fsnkty ];
}
