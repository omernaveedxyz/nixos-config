{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ./pkgs final.pkgs;

  # This one contains whatever you want to overlay. You can change versions, add patches, set compilation flags, etc.
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    # TODO: https://github.com/NixOS/nixpkgs/issues/292700
    flameshot = prev.flameshot.overrideAttrs (oldAttrs: {
      src = final.fetchFromGitHub {
        owner = "flameshot-org";
        repo = "flameshot";
        rev = "3d21e4967b68e9ce80fb2238857aa1bf12c7b905";
        sha256 = "sha256-OLRtF/yjHDN+sIbgilBZ6sBZ3FO6K533kFC1L2peugc=";
      };
      cmakeFlags = [
        "-DUSE_WAYLAND_CLIPBOARD=1"
        "-DUSE_WAYLAND_GRIM=1"
      ];
      buildInputs = oldAttrs.buildInputs ++ [ final.libsForQt5.kguiaddons ];
    });

    # TODO: https://github.com/NixOS/nixpkgs/pull/296421
    standardnotes = prev.standardnotes.overrideAttrs (oldAttrs: {
      version = "3.191.0";
      src = final.fetchurl {
        url = "https://github.com/standardnotes/app/releases/download/%40standardnotes/desktop%403.191.4/standard-notes-3.191.4-linux-amd64.deb";
        hash = "sha512-+DbnnHkwRcSUuJWlCd3xr6kTE/ecDHQeKS7yPbmyyLv80+YNvmU0AdA89hkR8Jjokep0k4MQUpvLZEDtJljYBA==";
      };
      updateAutotoolsGnuConfigScriptsPhase = ":";
      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin $out/share/standardnotes
        cp -R usr/share/{applications,icons} $out/share
        cp -R opt/Standard\ Notes/resources/app.asar $out/share/standardnotes/

        makeWrapper ${final.pkgs.electron_27}/bin/electron $out/bin/standardnotes \
          --add-flags $out/share/standardnotes/app.asar \
          --prefix LD_LIBRARY_PATH : ${
            final.lib.makeLibraryPath [
              final.pkgs.libsecret
              final.pkgs.stdenv.cc.cc.lib
            ]
          }

        ${final.pkgs.desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
          --set-key Exec --set-value standardnotes usr/share/applications/standard-notes.desktop

        runHook postInstall
      '';
    });
  };
}
