{
  imports = [ ./programs/colmena.nix ];

  # Modify and extend existing Nixpkgs collection
  nixpkgs.overlays = with (import ./overlays); [
    additions
    modifications
  ];
}
