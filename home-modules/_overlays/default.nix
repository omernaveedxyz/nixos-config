{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ./pkgs final.pkgs;

  # This one contains whatever you want to overlay. You can change versions, add patches, set compilation flags, etc.
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    flameshot = prev.flameshot.override { enableWlrSupport = true; };
  };
}
